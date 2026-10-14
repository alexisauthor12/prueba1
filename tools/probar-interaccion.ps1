# =============================================================================
#  Comprueba que las pantallas de la replica RESPONDEN de verdad a los clics.
#
#  Monta una pagina de prueba que carga las replicas en iframes, escribe en los
#  campos y hace clic de verdad, y captura los mensajes que se envian entre
#  pantallas (postMessage). Sirve para detectar fallos que no se ven mirando el
#  HTML, como un id que falta y rompe todo el script.
#
#  Uso:
#    powershell -File tools\probar-interaccion.ps1
#
#  Espera ver:
#    3. Clic en una fila -> 0114 - BANCARIBE
#    4. Fila resaltada tras el clic: [0114 - BANCARIBE]
#    1. Banco pulsado -> estado guardado (banco viejo: 0102 - BANCO DE VENEZUELA)
#    2. Campo Banco tras volver: [0114 - BANCARIBE]  ->  APLICADO OK
# =============================================================================

$ErrorActionPreference = 'Stop'
$Base  = Join-Path (Split-Path -Parent $PSScriptRoot) 'replica'
$Temp  = Join-Path $env:TEMP 'bdv-prueba'
$Chrome = 'C:\Program Files\Google\Chrome\Application\chrome.exe'

if(-not (Test-Path $Base)){ Write-Output ("No existe: " + $Base); exit 1 }
if(-not (Test-Path $Chrome)){ Write-Output ("No encuentro Chrome en " + $Chrome); exit 1 }

New-Item -ItemType Directory -Force -Path $Temp | Out-Null
foreach($f in @('pagomovil.html','bancos.html','comprobante.html','arimo.ttf')){
  Copy-Item (Join-Path $Base $f) $Temp -Force
}
foreach($pat in @('pm_*.png','bk_nav*.png','db_nav*.png')){
  Copy-Item (Join-Path $Base $pat) $Temp -Force -ErrorAction SilentlyContinue
}

$prueba = @'
<html><body>
<iframe id="a" src="pagomovil.html" width="720" height="1451"></iframe>
<iframe id="c" src="bancos.html" width="720" height="1441"></iframe>
<div id="log">INICIO</div>
<script>
var log = [];
function p(t){ log.push(t); document.getElementById('log').textContent = log.join(' || '); }
var a = document.getElementById('a'), c = document.getElementById('c'), estado = null;

window.addEventListener('message', function(ev){
  var d = ev.data;
  if(d.tipo === 'bdv-banco'){
    estado = d.estado;
    p('1. Banco pulsado -> estado guardado (banco viejo: ' + d.banco + ')');
    var w = a.contentWindow;
    w.postMessage({tipo:'bdv-banco', banco:'0114 - BANCARIBE'}, '*');
    w.postMessage({tipo:'bdv-estado', estado:estado}, '*');
    setTimeout(function(){
      var t = a.contentDocument.getElementById('pmTextoBanco').textContent;
      p('2. Campo Banco tras volver: [' + t + ']  ->  ' + (t === '0114 - BANCARIBE' ? 'APLICADO OK' : 'NO SE APLICO'));
    }, 120);
  }
  if(d.tipo === 'bdv-banco-elegido'){ p('3. Clic en una fila -> ' + d.banco); }
});

a.onload = function(){
  var d = a.contentDocument;
  d.getElementById('inDocumento').value = '24349893';
  d.getElementById('pmCampo3').click();
};
c.onload = function(){
  var d = c.contentDocument;
  d.querySelectorAll('.bkFila')[3].click();
  setTimeout(function(){
    p('4. Fila resaltada tras el clic: [' + d.querySelector('.bkFila.bkSel').textContent + ']');
  }, 60);
};
</script></body></html>
'@
[IO.File]::WriteAllText((Join-Path $Temp 'prueba.html'), $prueba, (New-Object Text.UTF8Encoding($false)))

$args = '--headless --disable-gpu --no-first-run --allow-file-access-from-files ' +
        '--virtual-time-budget=9000 --user-data-dir=' + (Join-Path $Temp 'perfil') +
        ' --dump-dom "file:///' + ($Temp -replace '\\','/') + '/prueba.html"'
$salida = Join-Path $Temp 'salida.txt'
Start-Process -FilePath $Chrome -ArgumentList $args -NoNewWindow -Wait `
  -RedirectStandardOutput $salida -RedirectStandardError (Join-Path $Temp 'error.txt')

$m = [regex]::Match((Get-Content $salida -Raw), '<div id="log">(.*?)</div>')
$lineas = ($m.Groups[1].Value -replace ' \|\| ', "`n") -replace '&gt;','>'
Write-Output "PRUEBA DE INTERACCION:"
Write-Output ""
Write-Output $lineas
