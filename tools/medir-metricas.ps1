<#
  medir-metricas.ps1 — Lee las metricas verticales de una fuente (ascenso de la
  celda y altura de mayuscula real) y calcula el HUECO entre el borde de la caja
  y la tinta: el valor que hay que descontar del margen superior de cada texto.

  Sirve para dos cosas:
    - comprobar que una fuente nueva no descuadra las posiciones verticales
    - justificar los margenes de res/<valores>/dimens_*.xml

  Uso:
    powershell -ExecutionPolicy Bypass -File tools\medir-metricas.ps1 `
      -Ruta android\app\src\main\res\font\nunito_variable.ttf

  Medido (10/2026):
    Arimo  ascenso 0.9053 em  capHeight 0.690 em  ->  hueco 0.2153 em
    Nunito ascenso 1.0110 em  capHeight 0.715 em  ->  hueco 0.2960 em
  Por eso, al pasar el comprobante de Arimo a Nunito, todos sus margenes
  superiores bajan 0.081 em (el hueco nuevo menos el viejo).
#>
param([Parameter(Mandatory=$true)][string]$Ruta)
Add-Type -AssemblyName System.Drawing
$inv = [System.Globalization.CultureInfo]::InvariantCulture
$col = New-Object System.Drawing.Text.PrivateFontCollection
$col.AddFontFile($Ruta)
$fam  = $col.Families[0]
$em   = $fam.GetEmHeight([System.Drawing.FontStyle]::Regular)
$asc  = $fam.GetCellAscent([System.Drawing.FontStyle]::Regular)
$desc = $fam.GetCellDescent([System.Drawing.FontStyle]::Regular)
# Altura de mayuscula: se dibuja una "H" y se mide su tinta.
$tam  = 200
$fnt  = New-Object System.Drawing.Font -ArgumentList $fam, $tam, ([System.Drawing.FontStyle]::Regular), ([System.Drawing.GraphicsUnit]::Pixel)
$bmp  = New-Object System.Drawing.Bitmap -ArgumentList 600, 500
$g    = [System.Drawing.Graphics]::FromImage($bmp)
$g.Clear([System.Drawing.Color]::Black)
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$g.DrawString('H', $fnt, [System.Drawing.Brushes]::White, (New-Object System.Drawing.PointF 50, 100))
$minY = 9999; $maxY = -1
for($y=0; $y -lt $bmp.Height; $y++){
  for($x=0; $x -lt $bmp.Width; $x++){
    if($bmp.GetPixel($x,$y).R -gt 128){ if($y -lt $minY){$minY=$y}; if($y -gt $maxY){$maxY=$y}; break }
  }
}
$g.Dispose(); $bmp.Dispose(); $fnt.Dispose()
$cap = ($maxY-$minY+1)/$tam
Write-Output ("{0}" -f (Split-Path $Ruta -Leaf))
Write-Output ("  em {0}  ascenso {1} ({2} em)  descendente {3} ({4} em)" -f $em, $asc, [math]::Round($asc/$em,4).ToString($inv), $desc, [math]::Round($desc/$em,4).ToString($inv))
Write-Output ("  capHeight medida {0} px a {1} px  ->  {2} em" -f ($maxY-$minY+1), $tam, [math]::Round($cap,4).ToString($inv))
Write-Output ("  HUECO ascenso - cap = {0} em" -f [math]::Round(($asc/$em) - $cap, 4).ToString($inv))
