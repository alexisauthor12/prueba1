<#
  medir-login.ps1 - Mide la pantalla de autenticacion (referencia-login.jpeg).
  Usa LockBits para leer la imagen una sola vez (rapido) y calcula:
    - fondo, cajas de cada bloque y bordes de las franjas diagonales.
#>
param(
  [string]$Img = "C:\Users\Alexis Ruiz\.cline\data\workspaces\chat\bdv-app\design\referencia-login.jpeg"
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

Write-Output ("IMAGEN: $W x $H")
$i0 = 200*$stride + 20*3
$b = @([int]$buf[$i0+2],[int]$buf[$i0+1],[int]$buf[$i0])
Write-Output ("FONDO : #{0:X2}{1:X2}{2:X2}" -f $b[0],$b[1],$b[2])
Write-Output ""

$regiones = @(
  @('CAMPANA+badge',   0,    0, 719, 115),
  @('LOGO',            0,  230, 719, 515),
  @('SUBTITULO',       0,  505, 719, 580),
  @('INI_SESION_COMO', 0,  580, 719, 645),
  @('USUARIO_A****4',  0,  645, 719, 705),
  @('PULSA_PARA_AUT',  0,  705, 719, 775),
  @('BOTON_HUELLA',    0,  765, 719, 900),
  @('INGRESA_CONTRAS', 0,  895, 719, 985),
  @('PIE_DESVINCULAR', 0, 1380, 719, 1460)
)

Write-Output "CAJAS DE LOS BLOQUES (px, fondo #303030):"
foreach($r in $regiones){
  $minx=99999;$miny=99999;$maxx=-1;$maxy=-1
  $ylim = [math]::Min($r[4],$H-1)
  for($y=$r[2]; $y -le $ylim; $y++){
    $j0 = $y*$stride
    for($x=$r[1]; $x -le $W-1; $x++){
      $j = $j0 + $x*3
      $dr=[math]::Abs($buf[$j+2]-$b[0]); $dg=[math]::Abs($buf[$j+1]-$b[1]); $db=[math]::Abs($buf[$j]-$b[2])
      $mx=$dr; if($dg -gt $mx){$mx=$dg}; if($db -gt $mx){$mx=$db}
      if($mx -gt 40){
        if($x -lt $minx){$minx=$x}; if($x -gt $maxx){$maxx=$x}
        if($y -lt $miny){$miny=$y}; if($y -gt $maxy){$maxy=$y}
      }
    }
  }
  if($maxx -lt 0){ Write-Output ("  {0,-16} (vacio)" -f $r[0]) }
  else {
    Write-Output ("  {0,-16} x {1,4}..{2,4}   y {3,4}..{4,4}    {5,4}x{6,4}" -f `
      $r[0],$minx,$maxx,$miny,$maxy,($maxx-$minx+1),($maxy-$miny+1))
  }
}

Write-Output ""
Write-Output "FRANJAS DIAGONALES (transiciones por fila):"
foreach($y in @(1020,1080,1140,1200,1260,1320,1380,1440,1458)){
  $t=@(); $lR=-999;$lG=-999;$lB=-999
  for($x=0;$x -lt $W;$x++){
    $j = $y*$stride + $x*3
    $dr=[math]::Abs($buf[$j+2]-$lR); $dg=[math]::Abs($buf[$j+1]-$lG); $db=[math]::Abs($buf[$j]-$lB)
    $mx=$dr; if($dg -gt $mx){$mx=$dg}; if($db -gt $mx){$mx=$db}
    if($mx -gt 30){
      $t += ('x=' + $x + ' #' + ('{0:X2}{1:X2}{2:X2}' -f $buf[$j+2],$buf[$j+1],$buf[$j]))
      $lR=$buf[$j+2];$lG=$buf[$j+1];$lB=$buf[$j]
    }
  }
  Write-Output ('  y=' + $y + ' : ' + ($t -join ' | '))
}
