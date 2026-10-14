<#
  comparar.ps1 — Compara la réplica renderizada contra la imagen de referencia,
  región por región, y localiza dónde está la desviación.

  Uso:
    powershell -ExecutionPolicy Bypass -File tools\comparar.ps1
    powershell -ExecutionPolicy Bypass -File tools\comparar.ps1 -Ref <img> -Render <img>
#>
param(
  [string]$Ref    = "C:\Users\Alexis Ruiz\.cline\data\workspaces\chat\bdv-app\design\referencia-inicio.jpeg",
  [string]$Render = "C:\Users\Alexis Ruiz\.cline\data\workspaces\chat\bdv-app\replica\render.png",
  [int]$Paso = 1
)

Add-Type -AssemblyName System.Drawing

function Get-Raw([string]$path) {
  $bmp    = New-Object System.Drawing.Bitmap($path)
  $rect   = New-Object System.Drawing.Rectangle 0,0,$bmp.Width,$bmp.Height
  $data   = $bmp.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::ReadOnly,
                          [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
  $stride = $data.Stride
  $w = $bmp.Width; $h = $bmp.Height
  $len = $stride * $h
  $buf = New-Object byte[] $len
  [System.Runtime.InteropServices.Marshal]::Copy($data.Scan0, $buf, 0, $len)
  $bmp.UnlockBits($data)
  $bmp.Dispose()
  return [pscustomobject]@{ W=$w; H=$h; Stride=$stride; Data=$buf }
}

function BBox($img,$x0,$y0,$x1,$y1,$bgR,$bgG,$bgB,$th) {
  if($x1 -ge $img.W){ $x1 = $img.W-1 }
  if($y1 -ge $img.H){ $y1 = $img.H-1 }
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
  return ("x {0,4}..{1,4}   y {2,4}..{3,4}   {4,3}x{5,3}" -f $minx,$maxx,$miny,$maxy,($maxx-$minx+1),($maxy-$miny+1))
}

function DiffRegion($A,$B,$x0,$y0,$x1,$y1) {
  if($x1 -ge $A.W){ $x1 = $A.W-1 }
  if($y1 -ge $A.H){ $y1 = $A.H-1 }
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

$A = Get-Raw $Ref
$B = Get-Raw $Render
$W = [math]::Min($A.W,$B.W)
$H = [math]::Min($A.H,$B.H)

Write-Output ("REFERENCIA : {0} x {1}" -f $A.W,$A.H)
Write-Output ("RENDER     : {0} x {1}" -f $B.W,$B.H)
Write-Output ""

# --- fondo de cada imagen (muestra en zona vacia) ---
$pa = 300*$A.Stride + 360*3; $pb = 300*$B.Stride + 360*3
$bgA = @($A.Data[$pa+2],$A.Data[$pa+1],$A.Data[$pa])
$bgB = @($B.Data[$pb+2],$B.Data[$pb+1],$B.Data[$pb])
Write-Output ("FONDO ref = #{0:X2}{1:X2}{2:X2}    render = #{3:X2}{4:X2}{5:X2}" -f $bgA[0],$bgA[1],$bgA[2],$bgB[0],$bgB[1],$bgB[2])
Write-Output ""

# --- recorrido por bloques: estadistica global + mapa de calor ---
$bs = 40
$nbx = [math]::Ceiling($W/$bs); $nby = [math]::Ceiling($H/$bs)
$gSum = 0; $gBad = 0; $gTot = 0
$lista = New-Object System.Collections.Generic.List[object]
for($by=0; $by -lt $nby; $by++){
  $y0 = $by*$bs; $y1 = [math]::Min($y0+$bs-1, $H-1)
  for($bx=0; $bx -lt $nbx; $bx++){
    $x0 = $bx*$bs; $x1 = [math]::Min($x0+$bs-1, $W-1)
    $s=0; $c=0; $bad=0
    for($y=$y0; $y -le $y1; $y += $Paso){
      $ia = $y*$A.Stride; $ib = $y*$B.Stride
      for($x=$x0; $x -le $x1; $x += $Paso){
        $p1 = $ia + $x*3; $p2 = $ib + $x*3
        $dr = [math]::Abs($A.Data[$p1+2]-$B.Data[$p2+2])
        $dg = [math]::Abs($A.Data[$p1+1]-$B.Data[$p2+1])
        $db = [math]::Abs($A.Data[$p1]  -$B.Data[$p2])
        $d  = $dr; if($dg -gt $d){$d=$dg}; if($db -gt $d){$d=$db}
        $s += $d; $c++
        if($d -gt 32){ $bad++ }
      }
    }
    $gSum += $s; $gTot += $c; $gBad += $bad
    $lista.Add([pscustomobject]@{ X=$x0; Y=$y0; Media=[math]::Round($s/$c,1); Malos=[math]::Round(100*$bad/$c,1) })
  }
}
Write-Output ("GLOBAL  : diff medio = {0:N2}/255      pixeles con diff>32 = {1:N2}%" -f ($gSum/$gTot), (100*$gBad/$gTot))
Write-Output ""
Write-Output "PEORES ZONAS (bloques de 40x40 px, ordenados por diff medio):"
$lista | Sort-Object -Property Media -Descending | Select-Object -First 14 | ForEach-Object {
  Write-Output ("   x {0,4}  y {1,4}   diff medio {2,6}   malos {3,5}%" -f $_.X,$_.Y,$_.Media,$_.Malos)
}
Write-Output ""

# --- comparacion por region ---
$regiones = @(
  @('CAMPANA',    30,  10, 100,  85),
  @('BADGE',      50,  12,  95,  56),
  @('LOGO',       95, 320, 625, 515),
  @('SUBTITULO', 100, 515, 620, 580),
  @('BOTON',      60, 615, 660, 725),
  @('TEXTO_BOTON',200, 645, 520, 700),
  @('ENLACE',    150, 780, 570, 830),
  @('TARJETA_1',  60, 870, 220, 1000),
  @('TARJETA_2', 290, 870, 430, 1000),
  @('TARJETA_3', 515, 870, 660, 1000),
  @('ETIQ_1',     55,1005, 215, 1045),
  @('ETIQ_2_l1', 300,1005, 420, 1045),
  @('ETIQ_2_l2', 300,1042, 420, 1078),
  @('ETIQ_3_l1', 540,1005, 635, 1045),
  @('ETIQ_3_l2', 540,1042, 635, 1078)
)
Write-Output "REGION                  REFERENCIA                              RENDER                                             DIFF"
foreach($r in $regiones){
  $n=$r[0]; $x0=$r[1]; $y0=$r[2]; $x1=$r[3]; $y1=$r[4]
  $ba = BBox $A $x0 $y0 $x1 $y1 $bgA[0] $bgA[1] $bgA[2] 40
  $bb = BBox $B $x0 $y0 $x1 $y1 $bgB[0] $bgB[1] $bgB[2] 40
  $dd = DiffRegion $A $B $x0 $y0 $x1 $y1
  Write-Output ("{0,-16} {1,-38} {2,-43} medio {3,6}   malos {4,5}%" -f $n,$ba,$bb,$dd.Media,$dd.Malos)
}
Write-Output ""

# --- bordes de las franjas en filas concretas ---
Write-Output "FRANJAS (primer y ultimo px que no es fondo):"
foreach($y in @(1060,1100,1160,1220,1260,1300,1340,1380,1420,1450)){
  $ia = $y*$A.Stride; $ib = $y*$B.Stride
  $fa=-1;$la=-1;$fb=-1;$lb=-1
  for($x=0; $x -lt $W; $x++){
    $p1=$ia+$x*3; $p2=$ib+$x*3
    $d1=[math]::Max([math]::Abs($A.Data[$p1+2]-$bgA[0]),[math]::Max([math]::Abs($A.Data[$p1+1]-$bgA[1]),[math]::Abs($A.Data[$p1]-$bgA[2])))
    $d2=[math]::Max([math]::Abs($B.Data[$p2+2]-$bgB[0]),[math]::Max([math]::Abs($B.Data[$p2+1]-$bgB[1]),[math]::Abs($B.Data[$p2]-$bgB[2])))
    if($d1 -gt 40){ if($fa -lt 0){$fa=$x}; $la=$x }
    if($d2 -gt 40){ if($fb -lt 0){$fb=$x}; $lb=$x }
  }
  Write-Output ("   y={0,4}   ref {1,4}..{2,4}      render {3,4}..{4,4}" -f $y,$fa,$la,$fb,$lb)
}
