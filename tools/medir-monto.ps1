# ---------------------------------------------------------------------------
# medir-monto.ps1
#   Mide la zona del monto del comprobante (la caja gris con el importe) en el
#   render y la compara con el mockup:
#     - caja de los trazos en cada imagen (posicion y tamano)
#     - diferencia media de color del texto y de la caja entera
#     - grosor de trazo: anchura media de las rachas de tinta en las filas
#       centrales de los digitos (es lo que hace que el monto se vea "marcado")
#
#   Uso:
#     powershell -ExecutionPolicy Bypass -File tools\medir-monto.ps1
#     powershell -ExecutionPolicy Bypass -File tools\medir-monto.ps1 -Render <img>
#
#   Referencia del mockup: 633x1280 px, caja gris en x 45..588 y 365..434,
#   fondo #212121, caja #757575 y texto #F5F5F5.
# ---------------------------------------------------------------------------
param(
  [string]$Ref    = "C:\Users\Alexis Ruiz\.cline\data\workspaces\chat\bdv-app\design\referencia-comprobante.jpeg",
  [string]$Render = "C:\Users\Alexis Ruiz\.cline\data\workspaces\chat\bdv-app\replica\render-comprobante.png"
)

Add-Type -AssemblyName System.Drawing

function Get-Raw([string]$path) {
  $bmp    = New-Object System.Drawing.Bitmap($path)
  $rect   = New-Object System.Drawing.Rectangle 0,0,$bmp.Width,$bmp.Height
  $data   = $bmp.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::ReadOnly,
                          [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
  $stride = $data.Stride
  $len = $stride * $bmp.Height
  $buf = New-Object byte[] $len
  [System.Runtime.InteropServices.Marshal]::Copy($data.Scan0, $buf, 0, $len)
  $bmp.UnlockBits($data); $bmp.Dispose()
  return [pscustomobject]@{ W=$bmp.Width; H=$bmp.Height; Stride=$stride; Data=$buf }
}

function BBox($img,$x0,$y0,$x1,$y1,$bgR,$bgG,$bgB,$th) {
  $minx=999999;$miny=999999;$maxx=-1;$maxy=-1
  for($y=$y0; $y -le $y1; $y++){
    $i0 = $y * $img.Stride
    for($x=$x0; $x -le $x1; $x++){
      $p  = $i0 + $x*3
      $dr = [math]::Abs($img.Data[$p+2]-$bgR)
      $dg = [math]::Abs($img.Data[$p+1]-$bgG)
      $db = [math]::Abs($img.Data[$p]  -$bgB)
      $d  = $dr; if($dg -gt $d){$d=$dg}; if($db -gt $d){$d=$db}
      if($d -gt $th){
        if($x -lt $minx){$minx=$x}; if($x -gt $maxx){$maxx=$x}
        if($y -lt $miny){$miny=$y}; if($y -gt $maxy){$maxy=$y}
      }
    }
  }
  if($maxx -lt 0){ return "(vacio)" }
  return ("x {0,4}..{1,4}  y {2,4}..{3,4}  {4,3}x{5,3}" -f $minx,$maxx,$miny,$maxy,($maxx-$minx+1),($maxy-$miny+1))
}

function DiffRegion($A,$B,$x0,$y0,$x1,$y1) {
  $s=0;$c=0;$bad=0
  for($y=$y0; $y -le $y1; $y++){
    $ia=$y*$A.Stride; $ib=$y*$B.Stride
    for($x=$x0; $x -le $x1; $x++){
      $p1=$ia+$x*3; $p2=$ib+$x*3
      $dr=[math]::Abs($A.Data[$p1+2]-$B.Data[$p2+2])
      $dg=[math]::Abs($A.Data[$p1+1]-$B.Data[$p2+1])
      $db=[math]::Abs($A.Data[$p1]  -$B.Data[$p2])
      $d=$dr; if($dg -gt $d){$d=$dg}; if($db -gt $d){$d=$db}
      $s+=$d; $c++; if($d -gt 32){ $bad++ }
    }
  }
  return [pscustomobject]@{ Media=[math]::Round($s/$c,2); Malos=[math]::Round(100*$bad/$c,1) }
}

function Grosor($img) {
  # Rachas de tinta con umbral en el punto medio entre el gris de la caja (117)
  # y el texto (245): asi el desenfoque del JPEG no infla la medida.
  $anchos = @()
  for($y=392; $y -le 406; $y++){
    $i0 = $y*$img.Stride
    $enRacha = $false; $largo = 0
    for($x=240; $x -le 395; $x++){
      $p=$i0+$x*3
      $lum=[math]::Max($img.Data[$p+2],[math]::Max($img.Data[$p+1],$img.Data[$p]))
      if($lum -gt 181){
        if(-not $enRacha){ $enRacha=$true; $largo=1 } else { $largo++ }
      } else {
        if($enRacha){ $anchos += $largo; $enRacha=$false }
      }
    }
    if($enRacha){ $anchos += $largo }
  }
  $media = if($anchos.Count){ [math]::Round(($anchos | Measure-Object -Average).Average,2) } else { 0 }
  $mediana = if($anchos.Count){ ($anchos | Sort-Object)[[int]($anchos.Count/2)] } else { 0 }
  return [pscustomobject]@{ Rachas=$anchos.Count; Media=$media; Mediana=$mediana }
}

$A = Get-Raw $Ref
$B = Get-Raw $Render

Write-Output ("REFERENCIA : " + (BBox $A 240 380 395 418 117 117 117 40))
Write-Output ("RENDER     : " + (BBox $B 240 380 395 418 117 117 117 40))
Write-Output ""
Write-Output ("{0,-14} {1,8} {2,8}" -f 'ZONA','MEDIA','MALOS%')
foreach($z in @(@('TEXTO_MONTO',240,380,395,418), @('CAJA',45,366,588,433))){
  $d = DiffRegion $A $B $z[1] $z[2] $z[3] $z[4]
  Write-Output ("{0,-14} {1,8} {2,8}" -f $z[0], $d.Media, $d.Malos)
}
Write-Output ""
$ga = Grosor $A
$gb = Grosor $B
Write-Output ("GROSOR DE TRAZO  referencia: {0} px de media ({1} rachas)   render: {2} px de media ({3} rachas)" -f `
  $ga.Media, $ga.Rachas, $gb.Media, $gb.Rachas)
