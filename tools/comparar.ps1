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
  [int]$Paso = 1,
  [ValidateSet('inicio','login','clave','dashboard','pagos','pagomovil','comprobante','bancos')][string]$Pantalla = 'inicio'
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
$pa = 200*$A.Stride + 20*3; $pb = 200*$B.Stride + 20*3
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
if($Pantalla -eq 'dashboard'){
  $regiones = @(
    @('CAMPANA',        30,   20, 100, 100),
    @('TITULO_INICIO', 130,   35, 245,  90),
    @('ACCESS',        440,   22, 520, 100),
    @('NFC',           535,   22, 615, 100),
    @('MENU',          645,   40, 700,  80),
    @('TARJETA',        30,  140, 690, 335),
    @('TXT_SALDO',      60,  175, 350, 205),
    @('TXT_MONTO',      60,  220, 350, 255),
    @('TXT_CUENTA',     60,  270, 350, 300),
    @('ICONOS_TARJ',   380,  160, 640, 215),
    @('MOVIMIENTOS',   360,  265, 645, 310),
    @('PUNTOS',        310,  360, 410, 395),
    @('TITULO_HOJA',    15,  435, 300, 475),
    @('ACTUALIZAR',    575,  435, 700, 470),
    @('HOY',            15,  500,  75, 530),
    @('FILA1_ICONO',    20,  550,  65, 615),
    @('FILA1_TEXTO',    80,  565, 400, 600),
    @('FILA1_MONTO',   580,  555, 710, 590),
    @('FILA1_HORA',    600,  585, 710, 615),
    @('FILA7',          20, 1275, 260, 1330),
    @('NAV_ICONOS',      0, 1355, 719, 1412),
    @('NAV_TEXTO',       0, 1412, 719, 1445)
  )
} elseif($Pantalla -eq 'clave'){
  $regiones = @(
    @('VELO_FONDO',      0,  150,  80,  300),
    @('LOGO_OSCURO',    90,  240, 630,  430),
    @('DIALOGO',        60,  500, 660,  960),
    @('USUARIO',       200,  565, 520,  615),
    @('CAMPO',         100,  655, 620,  790),
    @('PLACEHOLDER',   125,  695, 400,  745),
    @('OJO',           510,  690, 595,  755),
    @('BTN_ACEPTAR',   160,  805, 360,  910),
    @('BTN_CANCELAR',  360,  805, 560,  910),
    @('TXT_ACEPTAR',   190,  830, 340,  890),
    @('TXT_CANCELAR',  380,  830, 540,  890)
  )
} elseif($Pantalla -eq 'pagos'){
  $regiones = @(
    @('VELO_FONDO',     0,  200,  80,  300),
    @('ESQ_IZQ_PANEL',  0,  795,  90,  860),
    @('CABECERA',       0,  808, 719,  880),
    @('TITULO_PAGOS', 240,  820, 480,  875),
    @('BORDE_CABECERA', 0,  880, 719,  894),
    @('ITEM1',          0,  915, 719,  972),
    @('ITEM2',          0, 1027, 719, 1084),
    @('ITEM3',          0, 1139, 719, 1196),
    @('ITEM4',          0, 1251, 719, 1308),
    @('ITEM5',          0, 1363, 719, 1420),
    @('MARGEN_IZQ',     0,  900,  28, 1400),
    @('MARGEN_DER',   400,  900, 719, 1400),
    @('PIE',            0, 1425, 719, 1445),
    @('PANEL_COMPLETO', 0,  803, 719, 1445)
  )
} elseif($Pantalla -eq 'pagomovil'){
  $regiones = @(
    @('FONDO',           0,  140,  60,  200),
    @('CAMPANA',        30,   10, 100,   90),
    @('TITULO',        130,   30, 400,   80),
    @('MENU',          640,   30, 700,   75),
    @('CIRCULO_IZQ',    35,  105, 118,  188),
    @('PEGAR_DATOS',   125,  125, 275,  170),
    @('LEER_DATOS',    460,  125, 600,  170),
    @('CIRCULO_DER',   602,  105, 686,  188),
    @('CAMPO1',         35,  205, 690,  315),
    @('ETIQ_OPERACION', 40,  195, 175,  232),
    @('TEXTO_PERSONAS', 55,  240, 200,  275),
    @('CHEVRON1',      615,  250, 650,  272),
    @('CAMPO2',         35,  360, 580,  470),
    @('PLACEH_DOC',     55,  395, 215,  430),
    @('BOTON_DOC',     578,  362, 686,  470),
    @('CAMPO3',         35,  517, 690,  627),
    @('ETIQ_BANCO',     40,  507, 175,  545),
    @('TEXTO_BANCO',    55,  552, 460,  588),
    @('CHEVRON3',      615,  562, 650,  584),
    @('CAMPO4',         35,  673, 690,  783),
    @('PLACEH_TEL',     55,  706, 180,  740),
    @('CAMPO5',         35,  829, 690,  939),
    @('PLACEH_MONTO',   55,  862, 150,  896),
    @('CAMPO6',         35,  985, 690, 1095),
    @('PLACEH_CONC',    55, 1018, 190, 1058),
    @('BTN_PAGAR',     160, 1118, 355, 1212),
    @('BTN_LIMPIAR',   366, 1118, 560, 1212),
    @('TXT_PAGAR',     220, 1150, 295, 1185),
    @('TXT_LIMPIAR',   415, 1150, 510, 1185),
    @('ICONO_INFERIOR',315, 1250, 400, 1345),
    @('NAV_ICONOS',      0, 1350, 719, 1392),
    @('NAV_TEXTO',       0, 1394, 719, 1445)
  )
} elseif($Pantalla -eq 'comprobante'){
  $regiones = @(
    @('FONDO',          0,  900,  60, 1000),
    @('FLECHA_ATRAS',  25,   28,  70,   75),
    @('TITULO',       110,   30, 510,   80),
    @('COMPARTIR',    565,   25, 615,   80),
    @('LOGO',         260,  140, 370,  250),
    @('SUBTITULO',    170,  258, 470,  300),
    @('CHECK',        285,  290, 350,  350),
    @('CAJA',          40,  332, 595,  440),
    @('MONTO',        240,  380, 395,  418),
    @('FILA1',         45,  455, 600,  495),
    @('FILA2',         45,  500, 600,  550),
    @('COPIAR',       555,  500, 595,  548),
    @('FILA3',         45,  555, 600,  595),
    @('FILA4',         45,  605, 600,  650),
    @('FILA5',         45,  655, 600,  695),
    @('FILA6',         45,  705, 600,  742),
    @('FILA7',         45,  752, 600,  795),
    @('FLECHA_PIE',   290, 1015, 345, 1065),
    @('SEPARADOR',      0, 1090, 632, 1110),
    @('TOGGLE1',      180, 1128, 255, 1180),
    @('TXT_TOG1',     265, 1138, 480, 1175),
    @('TOGGLE2',      180, 1212, 255, 1265),
    @('TXT_TOG2',     265, 1222, 480, 1260)
  )
} elseif($Pantalla -eq 'bancos'){
  $regiones = @(
    @('FONDO',        600,  140, 700,  180),
    @('FILA_SEL',       0,   28, 720,  124),
    @('TXT1',          33,   60, 460,   92),
    @('TXT2',          33,  156, 460,  188),
    @('TXT3',          33,  252, 670,  284),
    @('TXT8_2LINEAS',  33,  712, 700,  784),
    @('TXT14',         33, 1308, 460, 1340),
    @('SCROLL',       705,   10, 720,  760),
    @('NAV',            0, 1354, 720, 1441),
    @('ICONO1',        38, 1356,  78, 1395),
    @('ICONO3',       278, 1360, 325, 1396),
    @('ICONO6',       635, 1357, 687, 1396),
    @('TXTNAV1',       30, 1405,  90, 1430),
    @('TXTNAV3',      260, 1403, 340, 1433),
    @('TXTNAV5',      500, 1405, 580, 1430)
  )
} elseif($Pantalla -eq 'login'){
  $regiones = @(
    @('CAMPANA',      15,    5, 120,  95),
    @('LOGO',         90,  240, 630, 430),
    @('SUBTITULO',   100,  440, 620, 500),
    @('SESION_COMO', 200,  510, 520, 555),
    @('USUARIO',     280,  585, 440, 615),
    @('PULSA',       200,  665, 520, 700),
    @('CIRCULO',     290,  715, 430, 850),
    @('HUELLA',      320,  745, 400, 825),
    @('INGRESA',     170,  855, 550, 885),
    @('SUBRAYADO',   170,  886, 550, 902),
    @('PIE_ICONO',   195, 1385, 252, 1440),
    @('PIE_TEXTO',   240, 1390, 530, 1440)
  )
} else {
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
}
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
