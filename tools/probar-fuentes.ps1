<#
  probar-fuentes.ps1 — Identifica la tipografia del mockup.
  Renderiza el texto del subtitulo en N fuentes candidatas (tools\prueba-fuentes.html),
  alinea cada una con la referencia y mide la diferencia real de los trazos.
#>
param(
  [string]$Ref    = "C:\Users\Alexis Ruiz\.cline\data\workspaces\chat\bdv-app\design\referencia-inicio.jpeg",
  [string]$Prueba = "C:\Users\Alexis Ruiz\.cline\data\workspaces\chat\bdv-app\tools\fuentes.png"
)

Add-Type -AssemblyName System.Drawing

$fuentes = @(
  'Segoe UI','Segoe UI Variable Display','Arial','Helvetica','Tahoma','Verdana',
  'Trebuchet MS','Calibri','Candara','Corbel','Century Gothic','Franklin Gothic Medium',
  'Bahnschrift','Lucida Sans Unicode','Microsoft Sans Serif','Sylfaen','Ebrima',
  'Nirmala UI','Sitka Text','Constantia','Georgia','Palatino Linotype','Malgun Gothic','Yu Gothic UI'
)

function Get-Raw([string]$path) {
  $bmp  = New-Object System.Drawing.Bitmap($path)
  $rect = New-Object System.Drawing.Rectangle 0,0,$bmp.Width,$bmp.Height
  $data = $bmp.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::ReadOnly,
                        [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
  $stride = $data.Stride; $w = $bmp.Width; $h = $bmp.Height
  $buf = New-Object byte[] ($stride*$h)
  [System.Runtime.InteropServices.Marshal]::Copy($data.Scan0, $buf, 0, $buf.Length)
  $bmp.UnlockBits($data); $bmp.Dispose()
  return [pscustomobject]@{ W=$w; H=$h; Stride=$stride; Data=$buf }
}

$A = Get-Raw $Ref
$B = Get-Raw $Prueba
$pa = 300*$A.Stride + 360*3
$bgA = @($A.Data[$pa+2],$A.Data[$pa+1],$A.Data[$pa])
$pb = 5*$B.Stride + 5*3
$bgB = @($B.Data[$pb+2],$B.Data[$pb+1],$B.Data[$pb])

# caja del subtitulo "Banco de Venezuela" en la referencia
$rx0 = 142; $rx1 = 578; $ry0 = 528; $ry1 = 563
$anchoRef = $rx1 - $rx0 + 1

$alto = 90
$res = New-Object System.Collections.Generic.List[object]

for($i=0; $i -lt $fuentes.Count; $i++){
  $y0 = $i*$alto; $y1 = $y0+$alto-1
  if($y1 -ge $B.H){ break }
  $minx=999999;$miny=999999;$maxx=-1;$maxy=-1
  for($y=$y0; $y -le $y1; $y++){
    $ib = $y*$B.Stride
    for($x=0; $x -lt $B.W; $x++){
      $p = $ib+$x*3
      $d = [math]::Max([math]::Abs($B.Data[$p+2]-$bgB[0]),[math]::Max([math]::Abs($B.Data[$p+1]-$bgB[1]),[math]::Abs($B.Data[$p]-$bgB[2])))
      if($d -gt 40){
        if($x -lt $minx){$minx=$x}; if($x -gt $maxx){$maxx=$x}
        if($y -lt $miny){$miny=$y}; if($y -gt $maxy){$maxy=$y}
      }
    }
  }
  if($maxx -lt 0){ continue }

  $anchoB  = $maxx-$minx+1
  $centroB = ($minx+$maxx)/2
  $baseB   = $maxy

  # anclaje 1: esquina superior izquierda de la caja
  $ox1 = $minx
  $oy1 = $miny
  # anclaje 2 (mas riguroso): linea base + centro horizontal
  $ox2 = [int]($centroB - 360) + $rx0
  $oy2 = ($baseB - $ry1) + $ry0

  $s1=0;$c1=0; $s2=0;$c2=0
  for($y=$ry0; $y -le $ry1; $y++){
    $ya   = $y*$A.Stride
    $fila1 = $oy1 + ($y-$ry0)
    $fila2 = $oy2 + ($y-$ry0)
    for($x=$rx0; $x -le $rx1; $x++){
      $xa  = $ya+$x*3
      $cx1 = $ox1 + ($x-$rx0)
      $cx2 = $ox2 + ($x-$rx0)
      if($fila1 -ge 0 -and $fila1 -lt $B.H -and $cx1 -ge 0 -and $cx1 -lt $B.W){
        $xb = $fila1*$B.Stride + $cx1*3
        $dr=[math]::Abs($A.Data[$xa+2]-$B.Data[$xb+2])
        $dg=[math]::Abs($A.Data[$xa+1]-$B.Data[$xb+1])
        $db=[math]::Abs($A.Data[$xa]  -$B.Data[$xb])
        $d=$dr; if($dg -gt $d){$d=$dg}; if($db -gt $d){$d=$db}
        $s1+=$d; $c1++
      }
      if($fila2 -ge 0 -and $fila2 -lt $B.H -and $cx2 -ge 0 -and $cx2 -lt $B.W){
        $xb = $fila2*$B.Stride + $cx2*3
        $dr=[math]::Abs($A.Data[$xa+2]-$B.Data[$xb+2])
        $dg=[math]::Abs($A.Data[$xa+1]-$B.Data[$xb+1])
        $db=[math]::Abs($A.Data[$xa]  -$B.Data[$xb])
        $d=$dr; if($dg -gt $d){$d=$dg}; if($db -gt $d){$d=$db}
        $s2+=$d; $c2++
      }
    }
  }
  $d1 = if($c1 -gt 0){ [math]::Round($s1/$c1,2) } else { -1 }
  $d2 = if($c2 -gt 0){ [math]::Round($s2/$c2,2) } else { -1 }
  $res.Add([pscustomobject]@{
    Fuente   = $fuentes[$i]
    Ancho    = $anchoB
    Alto     = $maxy-$miny+1
    Diff     = $d1
    DiffBase = $d2
  })
}

Write-Output ("REFERENCIA: ancho $anchoRef px, alto 36 px")
Write-Output ""
Write-Output "RANKING por anclaje de LINEA BASE + CENTRO (el mas riguroso)"
Write-Output "---------------------------------------------------------------------------"
$res | Sort-Object DiffBase | ForEach-Object {
  Write-Output ("  {0,-28} ancho {1,4} px  alto {2,3} px   diff(base) {3,6}   diff(esquina) {4,6}" -f $_.Fuente,$_.Ancho,$_.Alto,$_.DiffBase,$_.Diff)
}
