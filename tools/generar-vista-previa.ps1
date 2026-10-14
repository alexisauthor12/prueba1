<#
  generar-vista-previa.ps1
  Crea un UNICO archivo autocontenido por pantalla (fuente e imagenes en
  base64). Sirve para:
    - ver la pantalla en el PC (se abre en el navegador)
    - pasarla al telefono (WhatsApp, Drive, USB) y abrirla en Chrome
      SIN instalar nada y SIN compilar el APK

  Uso:
    powershell -File generar-vista-previa.ps1                      (inicio)
    powershell -File generar-vista-previa.ps1 -Pantalla login
    powershell -File generar-vista-previa.ps1 -Pantalla clave
    powershell -File generar-vista-previa.ps1 -Pantalla todas

  Salidas:
    inicio -> replica\vista-previa.html
    login  -> replica\vista-previa-login.html
    clave  -> replica\vista-previa-clave.html   (dialogo sobre el login)
#>
param(
  [string]$Base = "",
  [ValidateSet('inicio','login','clave','dashboard','todas')][string]$Pantalla = 'inicio'
)

$ErrorActionPreference = 'Stop'
if([string]::IsNullOrEmpty($Base)){
  $Base = Join-Path (Split-Path -Parent $PSScriptRoot) 'replica'
}
if(-not (Test-Path $Base)){ Write-Output ("No existe: " + $Base); exit 1 }

function Incrustar([string]$html, [string]$archivo, [string]$patron){
  $p = Join-Path $Base $archivo
  if(-not (Test-Path $p)){ return $html }
  $b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($p))
  return $html.Replace($patron, "data:font/ttf;base64,$b64")
}

function IncrustarImagen([string]$html, [string]$archivo){
  $p = Join-Path $Base $archivo
  if(-not (Test-Path $p)){ return $html }
  $b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($p))
  return $html.Replace('"' + $archivo + '"', '"data:image/png;base64,' + $b64 + '"')
}

function Generar([string]$origen, [string]$destino, [string[]]$imagenes, [switch]$ConLogin){
  $html = Get-Content (Join-Path $Base $origen) -Raw
  $html = Incrustar $html 'arimo.ttf' "url('arimo.ttf')"
  foreach($img in $imagenes){ $html = IncrustarImagen $html $img }
  if($ConLogin){
    # El login va dentro del iframe: se incrusta como data URI ya autocontenido
    $login = Get-Content (Join-Path $Base 'login.html') -Raw
    $login = Incrustar $login 'arimo.ttf' "url('arimo.ttf')"
    foreach($img in @('logo-bdv.png','ico-huella.png','ico-salir.png')){ $login = IncrustarImagen $login $img }
    $b64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($login))
    $html = $html.Replace('src="login.html"', 'src="data:text/html;base64,' + $b64 + '"')
  }
  $salida = Join-Path $Base $destino
  [IO.File]::WriteAllText($salida, $html, [Text.Encoding]::UTF8)
  Write-Output ("generado: " + $destino + "  (" + [math]::Round((Get-Item $salida).Length/1KB) + " KB)")
}

$hacer = @()
if($Pantalla -eq 'todas'){ $hacer = @('inicio','login','clave','dashboard') } else { $hacer = @($Pantalla) }

foreach($p in $hacer){
  switch($p){
    'inicio' { Generar 'index.html' 'vista-previa.html' @('logo-bdv.png','ico-movil.png','ico-access.png','ico-saldos.png') }
    'login'  { Generar 'login.html' 'vista-previa-login.html' @('logo-bdv.png','ico-huella.png','ico-salir.png') }
    'clave'  { Generar 'clave.html' 'vista-previa-clave.html' @('ico-ojo.png') -ConLogin }
    'dashboard' { Generar 'dashboard.html' 'vista-previa-dashboard.html' @(
        'db_campana.png','db_access.png','db_nfc.png','db_menu.png',
        'db_ico1.png','db_ico2.png','db_ico3.png','db_ico4.png',
        'db_chart.png','db_flecha.png','db_telefono.png','db_chevron.png',
        'db_nav1.png','db_nav2.png','db_nav3.png','db_nav4.png','db_nav5.png','db_nav6.png') }
  }
}

Write-Output ""
Write-Output "Para verlo: abre el archivo en Chrome (o pasalo al telefono y abrelo alli)."

