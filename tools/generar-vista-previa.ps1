<#
  generar-vista-previa.ps1
  Crea replica\vista-previa.html: un UNICO archivo autocontenido con la fuente
  y las imagenes incrustadas en base64. Sirve para:
    - ver la pantalla en el PC (se abre en el navegador)
    - pasarla al telefono (WhatsApp, Drive, USB) y abrirla en Chrome
      SIN instalar nada y SIN compilar el APK
#>
param(
  [string]$Base = "C:\Users\Alexis Ruiz\.cline\data\workspaces\chat\bdv-app\replica"
)

$index = Join-Path $Base "index.html"
$salida = Join-Path $Base "vista-previa.html"

if(-not (Test-Path $index)){ Write-Output "No existe $index"; exit 1 }

$html = Get-Content $index -Raw

# fuente en base64
$ttf = Join-Path $Base "arimo.ttf"
if(Test-Path $ttf){
  $b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($ttf))
  $html = $html.Replace("url('arimo.ttf')", "url(data:font/ttf;base64,$b64)")
  Write-Output "fuente incrustada: arimo.ttf"
}

# imagenes en base64
foreach($img in @('logo-bdv.png','ico-movil.png','ico-access.png','ico-saldos.png')){
  $p = Join-Path $Base $img
  if(Test-Path $p){
    $b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($p))
    $html = $html.Replace('"' + $img + '"', '"data:image/png;base64,' + $b64 + '"')
    Write-Output "incrustada: $img"
  }
}

[IO.File]::WriteAllText($salida, $html, [Text.Encoding]::UTF8)
Write-Output ("generado: $salida  ({0} KB)" -f [math]::Round((Get-Item $salida).Length/1KB))
Write-Output ""
Write-Output "Para verlo: abre vista-previa.html en Chrome (o pasalo al telefono y abrelo alli)."
