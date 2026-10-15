<#
  render-pantalla.ps1 — Renderiza una replica HTML al tamano EXACTO de su mockup
  (lee el ancho y el alto de design\referencia-<pantalla>.jpeg) y deja el PNG en
  replica\render-<pantalla>.png.

  Uso:
    powershell -ExecutionPolicy Bypass -File tools\render-pantalla.ps1 -Pantalla inicio
    powershell -ExecutionPolicy Bypass -File tools\render-pantalla.ps1 -Pantalla todas

  Dos trampas de Chrome headless que este script ya evita (costaron un rato):
    - rutas con espacios: si --user-data-dir o --screenshot llevan espacios y se
      parten en dos argumentos, Chrome falla con "Multiple targets are not
      supported in headless mode" y NO escribe el PNG, sin mensaje visible. Aqui
      los argumentos van en un unico string y las rutas por el nombre corto 8.3.
    - perfil reutilizado: si queda una instancia viva, Chrome responde "Se esta
      abriendo en una sesion de navegador existente" y no vuelve a capturar (se
      mediria un render viejo). Aqui cada captura usa un perfil nuevo (GUID).
#>
param(
  [ValidateSet('inicio','login','clave','dashboard','pagos','pagomovil','bancos','comprobante','todas')]
  [string]$Pantalla = 'inicio'
)

$raiz   = Split-Path -Parent $PSScriptRoot
$chrome = 'C:\Program Files\Google\Chrome\Application\chrome.exe'
$tmp    = (New-Object -ComObject Scripting.FileSystemObject).GetFolder($env:TEMP).ShortPath
Add-Type -AssemblyName System.Drawing

# La pantalla de inicio se llama index.html
$archivos = @{ inicio='index.html' }

function Renderizar([string]$nombre){
  $archivo = if($archivos.ContainsKey($nombre)){ $archivos[$nombre] } else { $nombre + '.html' }
  $html   = Join-Path $raiz ('replica\' + $archivo)
  $mockup = Join-Path $raiz ("design\referencia-$nombre.jpeg")
  if(-not (Test-Path $html))  { throw "No existe la replica: $html" }
  if(-not (Test-Path $mockup)){ throw "No existe el mockup: $mockup" }
  $b = New-Object System.Drawing.Bitmap $mockup
  $ancho = $b.Width; $alto = $b.Height; $b.Dispose()

  $perfil = "$tmp\perfil-" + [guid]::NewGuid().ToString('N').Substring(0,8)
  $pngTmp = "$tmp\render-$nombre.png"
  Remove-Item $pngTmp -Force -ErrorAction SilentlyContinue
  $url = 'file:///' + ($html -replace '\\','/') -replace ' ','%20'
  $argumentos = '--headless=new --disable-gpu --no-first-run --no-default-browser-check ' +
    '--hide-scrollbars --force-device-scale-factor=1 --virtual-time-budget=5000 ' +
    ('--user-data-dir="{0}" --window-size={1},{2} --screenshot="{3}" "{4}"' -f $perfil, $ancho, $alto, $pngTmp, $url)
  Start-Process -FilePath $chrome -ArgumentList $argumentos -Wait -NoNewWindow `
    -RedirectStandardError "$tmp\render-err.txt" | Out-Null
  if(-not (Test-Path $pngTmp)){
    throw ("Chrome no capturo " + $nombre + ": " + (Get-Content "$tmp\render-err.txt" -Raw))
  }
  Copy-Item $pngTmp (Join-Path $raiz ("replica\render-$nombre.png")) -Force
  Remove-Item $perfil -Recurse -Force -ErrorAction SilentlyContinue
  Write-Output ("{0,-12} {1} x {2}  ->  replica\render-{0}.png" -f $nombre, $ancho, $alto)
}

if($Pantalla -eq 'todas'){
  foreach($p in @('inicio','login','clave','dashboard','pagos','pagomovil','bancos','comprobante')){ Renderizar $p }
} else {
  Renderizar $Pantalla
}
