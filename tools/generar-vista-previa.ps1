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
    powershell -File generar-vista-previa.ps1 -Pantalla pagos
    powershell -File generar-vista-previa.ps1 -Pantalla pagomovil
    powershell -File generar-vista-previa.ps1 -Pantalla todas

  Salidas:
    inicio    -> replica\vista-previa.html
    login     -> replica\vista-previa-login.html
    clave     -> replica\vista-previa-clave.html   (dialogo sobre el login)
    dashboard -> replica\vista-previa-dashboard.html
    pagos     -> replica\vista-previa-pagos.html   (panel sobre el dashboard)
    pagomovil -> replica\vista-previa-pagomovil.html
    flujo     -> replica\vista-previa-flujo.html   (las siete pantallas)
#>
param(
  [string]$Base = "",
  [ValidateSet('inicio','login','clave','dashboard','pagos','pagomovil','comprobante','flujo','todas')][string]$Pantalla = 'inicio'
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

function Construir([string]$origen, [string[]]$imagenes, [switch]$ConLogin){
  $html = Get-Content (Join-Path $Base $origen) -Raw -Encoding UTF8
  $html = Incrustar $html 'arimo.ttf' "url('arimo.ttf')"
  foreach($img in $imagenes){ $html = IncrustarImagen $html $img }
  if($ConLogin){
    # El login va dentro del iframe: se incrusta como data URI ya autocontenido
    $login = Get-Content (Join-Path $Base 'login.html') -Raw -Encoding UTF8
    $login = Incrustar $login 'arimo.ttf' "url('arimo.ttf')"
    foreach($img in @('logo-bdv.png','ico-huella.png','ico-salir.png')){ $login = IncrustarImagen $login $img }
    $b64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($login))
    $html = $html.Replace('src="login.html"', 'src="data:text/html;base64,' + $b64 + '"')
  }
  return $html
}

function Generar([string]$origen, [string]$destino, [string[]]$imagenes, [switch]$ConLogin){
  $html = Construir $origen $imagenes -ConLogin:$ConLogin
  $salida = Join-Path $Base $destino
  [IO.File]::WriteAllText($salida, $html, [Text.Encoding]::UTF8)
  Write-Output ("generado: " + $destino + "  (" + [math]::Round((Get-Item $salida).Length/1KB) + " KB)")
}

# El visor flujo.html con las SIETE pantallas incrustadas: sirve para pasar al
# movil y permite escribir la contrasena, entrar al dashboard y abrir el panel
# de Pagos sin mas archivos.
function GenerarFlujo(){
  $flujo = Get-Content (Join-Path $Base 'flujo.html') -Raw -Encoding UTF8
  $iconos = @('db_campana.png','db_access.png','db_nfc.png','db_menu.png',
              'db_ico1.png','db_ico2.png','db_ico3.png','db_ico4.png',
              'db_chart.png','db_flecha.png','db_telefono.png','db_chevron.png',
              'db_nav1.png','db_nav2.png','db_nav3.png','db_nav4.png','db_nav5.png','db_nav6.png')
  # Iconos propios de PagomovilBDV (los del nav son los mismos del dashboard)
  $pmIconos = @('pm_campana.png','pm_menu.png','pm_circulo_pegar.png','pm_circulo_leer.png',
                'pm_boton_doc.png','pm_icono_inferior.png') + $iconos
  # Iconos propios del comprobante
  $cpIconos = @('cp_flecha.png','cp_compartir.png','cp_logo.png','cp_check.png',
                'cp_copiar.png','cp_flecha_pie.png')
  $pares = @(
    @('index.html',     (Construir 'index.html' @('logo-bdv.png','ico-movil.png','ico-access.png','ico-saldos.png'))),
    @('login.html',     (Construir 'login.html' @('logo-bdv.png','ico-huella.png','ico-salir.png'))),
    @('clave.html',     (Construir 'clave.html' @('ico-ojo.png') -ConLogin)),
    @('dashboard.html', (Construir 'dashboard.html' $iconos)),
    @('pagos.html',     (Construir 'pagos.html' @('render-dashboard.png'))),
    @('pagomovil.html', (Construir 'pagomovil.html' $pmIconos)),
    @('comprobante.html', (Construir 'comprobante.html' $cpIconos))
  )
  foreach($p in $pares){
    $b64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($p[1]))
    $data = 'data:text/html;base64,' + $b64
    $flujo = $flujo.Replace("'" + $p[0] + "'", "'" + $data + "'")
    $flujo = $flujo.Replace('"' + $p[0] + '"', '"' + $data + '"')
  }
  $salida = Join-Path $Base 'vista-previa-flujo.html'
  [IO.File]::WriteAllText($salida, $flujo, [Text.Encoding]::UTF8)
  Write-Output ("generado: vista-previa-flujo.html  (" + [math]::Round((Get-Item $salida).Length/1KB) + " KB)")
}

$hacer = @()
if($Pantalla -eq 'todas'){ $hacer = @('inicio','login','clave','dashboard','pagos','pagomovil','comprobante','flujo') } else { $hacer = @($Pantalla) }

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
    'pagos'  { Generar 'pagos.html' 'vista-previa-pagos.html' @('render-dashboard.png') }
    'pagomovil' { Generar 'pagomovil.html' 'vista-previa-pagomovil.html' @(
        'pm_campana.png','pm_menu.png','pm_circulo_pegar.png','pm_circulo_leer.png',
        'pm_boton_doc.png','pm_icono_inferior.png',
        'db_nav1.png','db_nav2.png','db_nav3.png','db_nav4.png','db_nav5.png','db_nav6.png') }
    'comprobante' { Generar 'comprobante.html' 'vista-previa-comprobante.html' @(
        'cp_flecha.png','cp_compartir.png','cp_logo.png','cp_check.png',
        'cp_copiar.png','cp_flecha_pie.png') }
    'flujo'  { GenerarFlujo }
  }
}

Write-Output ""
Write-Output "Para verlo: abre el archivo en Chrome (o pasalo al telefono y abrelo alli)."

