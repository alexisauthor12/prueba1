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
#    5. Lista: 25 bancos | se ven 13.8 filas | recorrido 1074 px
#    7. Arrastro la barra hacia abajo -> scrollTop ...
#    8. Arrastro la barra hacia arriba -> scrollTop ...
#    9. Rueda del raton sobre la barra -> scrollTop 300
#   10. Toco la pista abajo del todo -> scrollTop 1074 (tope 1074)
#   11. Flecha arriba con la lista enfocada -> scrollTop 978
#   12. Bancos debajo de SOFITASA (fila 15): los 11 ESTAN
#   13. Ultimo banco de la lista: [0169 - R4 BANCO MICROFINANCIERO C.A.] (total 25)
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
    probarBarra(d);
  }, 60);
};

/* ---- La barra de desplazamiento del borde derecho ----
   Se agarra la barra (fracDesde = punto de agarre dentro de ella, de 0 a 1) y
   se arrastra salto px hacia abajo o hacia arriba, como haria el dedo. */
function arrastrarBarra(d, fracDesde, salto){
  var b = d.getElementById('bkScroll');
  var r = b.getBoundingClientRect();
  var x = r.left + 4, y = r.top + r.height * fracDesde;
  b.dispatchEvent(new MouseEvent('mousedown', {bubbles:true, clientX:x, clientY:y}));
  d.dispatchEvent(new MouseEvent('mousemove', {bubbles:true, clientX:x, clientY:y + salto}));
  d.dispatchEvent(new MouseEvent('mouseup',   {bubbles:true, clientX:x, clientY:y + salto}));
  return d.getElementById('bkLista').scrollTop;
}

function probarBarra(d){
  var l = d.getElementById('bkLista'), b = d.getElementById('bkScroll');
  var filas = d.querySelectorAll('.bkFila');
  p('5. Lista: ' + filas.length + ' bancos | se ven ' + (l.clientHeight/96).toFixed(1) +
    ' filas | recorrido ' + (l.scrollHeight - l.clientHeight) + ' px');
  p('6. Barra al empezar: top ' + b.style.top + ' | alto ' + b.style.height);
  p('7. Arrastro la barra hacia abajo -> scrollTop ' + arrastrarBarra(d, 0.1, 400) +
    ' | barra en top ' + b.style.top);
  p('8. Arrastro la barra hacia arriba -> scrollTop ' + arrastrarBarra(d, 0.9, -300) +
    ' | barra en top ' + b.style.top);
  l.scrollTop = 0;
  b.dispatchEvent(new WheelEvent('wheel', {bubbles:true, cancelable:true, deltaY:300}));
  p('9. Rueda del raton sobre la barra -> scrollTop ' + l.scrollTop);
  var r = d.getElementById('bkPista').getBoundingClientRect();
  d.getElementById('bkPista').dispatchEvent(new MouseEvent('mousedown',
      {bubbles:true, clientX:r.left + 4, clientY:r.top + 1200}));
  d.dispatchEvent(new MouseEvent('mouseup', {bubbles:true}));
  p('10. Toco la pista abajo del todo -> scrollTop ' + l.scrollTop +
    ' (tope ' + (l.scrollHeight - l.clientHeight) + ') | barra en top ' + b.style.top);
  l.dispatchEvent(new KeyboardEvent('keydown', {key:'ArrowUp', bubbles:true, cancelable:true}));
  p('11. Flecha arriba con la lista enfocada -> scrollTop ' + l.scrollTop);
  comprobarBancos(filas);
}

/* Los 11 bancos que el mockup referencia-bancos-2.jpeg muestra justo debajo de
   BANCO SOFITASA tienen que estar ahi mismo, en ese orden. */
function comprobarBancos(filas){
  var esperados = ['0104 - BANCO VENEZOLANO DE CREDITO','0168 - BANCRECER','0134 - BANESCO',
                   '0177 - BANFANB','0146 - BANGENTE','0174 - BANPLUS','0108 - BBVA PROVINCIAL',
                   '0157 - DELSUR BANCO UNIVERSAL','0601 - INSTITUTO MUNICIPAL DE CREDITO POPULAR',
                   '0178 - N58 BANCO DIGITAL BANCO MICROFINANCIERO S A',
                   '0169 - R4 BANCO MICROFINANCIERO C.A.'];
  var nombres = [];
  for(var i=0;i<filas.length;i++){ nombres.push(filas[i].textContent); }
  var desde = nombres.indexOf('0137 - BANCO SOFITASA') + 1;
  var reales = nombres.slice(desde, desde + esperados.length);
  p('12. Bancos debajo de SOFITASA (fila ' + (desde + 1) + '): ' +
    (reales.join('|') === esperados.join('|') ? 'los 11 ESTAN' : 'NO COINCIDEN: ' + reales.join(' / ')));
  p('13. Ultimo banco de la lista: [' + nombres[nombres.length-1] + '] (total ' + nombres.length + ')');
}
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
