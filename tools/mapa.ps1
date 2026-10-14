# ---------------------------------------------------------------------------
# mapa.ps1
#   Mapa estructural de un mockup: para cada fila calcula el color dominante
#   (el "fondo" de esa fila) y localiza el primer y ultimo pixel que se
#   desvia de el. Imprime solo las filas donde la geometria cambia, lo que
#   da la estructura de bandas de la pantalla en pocas lineas.
#
#   Uso:
#     powershell -File mapa.ps1 -Imagen ..\design\referencia-dashboard.jpeg
#     powershell -File mapa.ps1 -Imagen ..\design\referencia-dashboard.jpeg -Salto 1 -Umbral 20
# ---------------------------------------------------------------------------
param(
  [Parameter(Mandatory=$true)][string]$Imagen,
  [string]$Salida = "",
  [int]$Umbral = 26,
  [int]$Salto  = 1,
  [int]$Tolerancia = 3
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

if(-not (Test-Path $Imagen)){ Write-Output ("No existe: " + $Imagen); exit 1 }
if([string]::IsNullOrEmpty($Salida)){ $Salida = [IO.Path]::ChangeExtension($Imagen, '.mapa.txt') }

$bmp = New-Object System.Drawing.Bitmap($Imagen)
$W = $bmp.Width; $H = $bmp.Height
$rect = New-Object System.Drawing.Rectangle 0,0,$W,$H
$datos = $bmp.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::ReadOnly, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
$stride = $datos.Stride
$bytes = New-Object byte[] ($stride * $H)
[System.Runtime.InteropServices.Marshal]::Copy($datos.Scan0, $bytes, 0, $bytes.Length)
$bmp.UnlockBits($datos)

$o = @()
$o += ("MAPA DE " + (Split-Path $Imagen -Leaf) + "   " + $W + " x " + $H + "   umbral " + $Umbral)
$o += "   fila   x0..x1        ancho   fondo     observacion"

$antX0 = -999; $antX1 = -999
for($y=0; $y -lt $H; $y += $Salto){
  $ia = $y * $stride
  # color dominante de la fila (cuantizado a 8 niveles)
  $cubos = New-Object int[] 4096
  for($x=0; $x -lt $W; $x++){
    $p = $ia + $x*3
    $b = $bytes[$p]; $g = $bytes[$p+1]; $r = $bytes[$p+2]
    $k = (($r -band 0xF0) -shr 4) * 256 + (($g -band 0xF0) -shr 4) * 16 + (($b -band 0xF0) -shr 4)
    $cubos[$k]++
  }
  $mejor = 0; $mejorK = 0
  for($k=0; $k -lt 4096; $k++){ if($cubos[$k] -gt $mejor){ $mejor = $cubos[$k]; $mejorK = $k } }
  $fR = (((($mejorK -shr 8) -band 0xF) * 16) + 8)
  $fG = (((($mejorK -shr 4) -band 0xF) * 16) + 8)
  $fB = ((($mejorK -band 0xF) * 16) + 8)

  $x0 = -1; $x1 = -1
  for($x=0; $x -lt $W; $x++){
    $p = $ia + $x*3
    $d = [math]::Abs($bytes[$p] - $fB)
    $d2 = [math]::Abs($bytes[$p+1] - $fG); if($d2 -gt $d){ $d = $d2 }
    $d2 = [math]::Abs($bytes[$p+2] - $fR); if($d2 -gt $d){ $d = $d2 }
    if($d -gt $Umbral){ if($x0 -lt 0){ $x0 = $x }; $x1 = $x }
  }
  $cambio = ($x0 -eq -1 -and $antX0 -ne -1) -or ($x0 -ne -1 -and $antX0 -eq -1) -or ([math]::Abs($x0-$antX0) -gt $Tolerancia) -or ([math]::Abs($x1-$antX1) -gt $Tolerancia)
  if($cambio){
    $fondo = ('#{0:X2}{1:X2}{2:X2}' -f $fR,$fG,$fB)
    if($x0 -lt 0){ $o += ("   {0,5}   (vacio)                {1}" -f $y,$fondo) }
    else { $o += ("   {0,5}   {1,4}..{2,4}   {3,5}   {4}   ({5} px)" -f $y,$x0,$x1,($x1-$x0+1),$fondo,($x1-$x0+1)) }
    $antX0 = $x0; $antX1 = $x1
  }
}

[IO.File]::WriteAllLines($Salida, $o, [Text.Encoding]::UTF8)
Write-Output ("mapa escrito en: " + $Salida + "   (" + $o.Count + " lineas)")
