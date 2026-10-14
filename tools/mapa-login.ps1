<#
  mapa-login.ps1 - Genera un mapa de bandas de la pantalla de login:
  agrupa filas consecutivas con contenido y reporta el rango X de cada banda.
  Sirve para reconstruir el layout exacto sin ambiguedad.
#>
param(
  [string]$Img = "C:\Users\Alexis Ruiz\.cline\data\workspaces\chat\bdv-app\design\referencia-login.jpeg",
  [int]$Umbral = 40
)

Add-Type -AssemblyName System.Drawing
$bmp = New-Object System.Drawing.Bitmap($Img)
$W = $bmp.Width; $H = $bmp.Height
$rect = New-Object System.Drawing.Rectangle 0,0,$W,$H
$d = $bmp.LockBits($rect,[System.Drawing.Imaging.ImageLockMode]::ReadOnly,[System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
$stride = $d.Stride
$buf = New-Object byte[] ($stride*$H)
[System.Runtime.InteropServices.Marshal]::Copy($d.Scan0,$buf,0,$buf.Length)
$bmp.UnlockBits($d); $bmp.Dispose()

$bg = @(48,48,48)
Write-Output ("IMAGEN: $W x $H   umbral=$Umbral sobre fondo #303030")
Write-Output ""

$minxs = New-Object 'int[]' $H
$maxxs = New-Object 'int[]' $H
$cnts  = New-Object 'int[]' $H

for($y=0; $y -lt $H; $y++){
  $j0 = $y*$stride
  $mn = -1; $mx = -1; $c = 0
  for($x=0; $x -lt $W; $x++){
    $j = $j0 + $x*3
    $dr=[math]::Abs($buf[$j+2]-$bg[0]); $dg=[math]::Abs($buf[$j+1]-$bg[1]); $db=[math]::Abs($buf[$j]-$bg[2])
    $v=$dr; if($dg -gt $v){$v=$dg}; if($db -gt $v){$v=$db}
    if($v -gt $Umbral){ if($mn -lt 0){$mn=$x}; $mx=$x; $c++ }
  }
  $minxs[$y]=$mn; $maxxs[$y]=$mx; $cnts[$y]=$c
}

# agrupar filas en bandas (se permite un hueco de hasta 4 filas)
$bandas = New-Object System.Collections.Generic.List[object]
$i = 0
while($i -lt $H){
  if($cnts[$i] -gt 0){
    $y0 = $i
    $y1 = $i
    $gap = 0
    $k = $i+1
    while($k -lt $H){
      if($cnts[$k] -gt 0){ $y1 = $k; $gap = 0 }
      else { $gap++; if($gap -gt 4){ break } }
      $k++
    }
    $bandas.Add([pscustomobject]@{ Y0=$y0; Y1=$y1 })
    $i = $y1 + 1
  } else { $i++ }
}

Write-Output "BANDAS DETECTADAS:"
foreach($b in $bandas){
  $x0=99999; $x1=-1; $maxc=0; $ymax=0
  for($y=$b.Y0; $y -le $b.Y1; $y++){
    if($cnts[$y] -gt 0){
      if($minxs[$y] -lt $x0){ $x0=$minxs[$y] }
      if($maxxs[$y] -gt $x1){ $x1=$maxxs[$y] }
      if($cnts[$y] -gt $maxc){ $maxc=$cnts[$y]; $ymax=$y }
    }
  }
  $jm = $ymax*$stride
  # color dominante de la banda (muestra en el centro)
  $xm = [int](($x0+$x1)/2)
  $jc = $ymax*$stride + $xm*3
  $col = ('#{0:X2}{1:X2}{2:X2}' -f $buf[$jc+2],$buf[$jc+1],$buf[$jc])
  Write-Output ("  y {0,4}..{1,4}  (alto {2,3})   x {3,4}..{4,4}  (ancho {5,4})   px_max {6,4}   color_centro {7}" -f `
    $b.Y0,$b.Y1,($b.Y1-$b.Y0+1),$x0,$x1,($x1-$x0+1),$maxc,$col)
}
