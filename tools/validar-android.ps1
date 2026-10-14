# ---------------------------------------------------------------------------
# validar-android.ps1
#   Comprueba, sin necesidad de Android SDK:
#     1) que todos los XML esten bien formados
#     2) que no haya recursos duplicados entre los values/*.xml (AAPT2 falla
#        con "Error: Duplicate resources")
#     3) que cada @recurso usado exista (dimen, color, string, style, id,
#        drawable, font, layout, mipmap)
#     4) que cada R.tipo.nombre usado en Kotlin exista
#
#   Uso:  powershell -ExecutionPolicy Bypass -File validar-android.ps1
# ---------------------------------------------------------------------------
param(
  [string]$Raiz = ''
)

$ErrorActionPreference = 'Stop'
if([string]::IsNullOrEmpty($Raiz)){
  $Raiz = (Join-Path (Split-Path -Parent $PSScriptRoot) 'android\app\src\main')
}
if(-not (Test-Path $Raiz)){ Write-Output ("No existe: " + $Raiz); exit 1 }

$xmls = Get-ChildItem -Path $Raiz -Recurse -File | Where-Object { $_.Extension -eq '.xml' }
$kts  = Get-ChildItem -Path $Raiz -Recurse -File | Where-Object { $_.Extension -eq '.kt' }

# --- 1) XML bien formado ---
$errores = 0
Write-Output "XML BIEN FORMADO:"
foreach($f in $xmls){
  try { [void][xml](Get-Content $f.FullName -Raw -Encoding UTF8) }
  catch { $errores++; Write-Output ("   FALLA  " + $f.FullName.Replace($Raiz,'') + "  ->  " + $_.Exception.Message) }
}
if($errores -eq 0){ Write-Output ("   OK  (" + $xmls.Count + " archivos)") }

# --- 2) recursos definidos ---
$defs = @{}
foreach($f in Get-ChildItem -Path (Join-Path $Raiz 'res\values') -File -Filter *.xml){
  $x = [xml](Get-Content $f.FullName -Raw -Encoding UTF8)
  foreach($n in $x.SelectNodes('//*[@name]')){
    $t = $n.LocalName
    if($t -match '-array$'){ $t = 'array' }   # string-array / integer-array -> array
    if(@('dimen','color','string','style','integer','bool','array','attr') -contains $t){
      $defs[$t + '/' + $n.name] = $f.Name
    }
  }
}
foreach($d in Get-ChildItem -Path (Join-Path $Raiz 'res') -Directory){
  if($d.Name -match '^(drawable|font|layout|mipmap|anim)'){
    $tipo = ($d.Name -split '-')[0]
    foreach($f in Get-ChildItem $d.FullName -File){
      $defs[$tipo + '/' + $f.BaseName] = $f.Name
    }
  }
}

# --- 2b) recursos duplicados: AAPT2 aborta con "Error: Duplicate resources"
#         si el mismo tipo/nombre se define en dos archivos de values/
$dups = @()
$vistos = @{}
foreach($f in Get-ChildItem -Path (Join-Path $Raiz 'res\values') -File -Filter *.xml){
  $x = [xml](Get-Content $f.FullName -Raw -Encoding UTF8)
  foreach($n in $x.SelectNodes('//*[@name]')){
    $t = $n.LocalName
    if($t -match '-array$'){ $t = 'array' }
    if(@('dimen','color','string','style','integer','bool','array','attr') -contains $t){
      $clave = $t + '/' + $n.name
      if($vistos.ContainsKey($clave)){ $dups += ($clave + '  en ' + $vistos[$clave] + ' y ' + $f.Name) }
      else { $vistos[$clave] = $f.Name }
    }
  }
}
Write-Output ""
Write-Output "RECURSOS DUPLICADOS:"
if($dups.Count -eq 0){ Write-Output "   OK  (ninguno)" }
else { foreach($x in ($dups | Sort-Object -Unique)){ Write-Output ('   FALLA  ' + $x) } }

# --- 3) referencias ---
$ids = @{}
foreach($f in $xmls){
  $txt = Get-Content $f.FullName -Raw -Encoding UTF8
  foreach($m in [regex]::Matches($txt,'@\+id/([A-Za-z0-9_]+)')){ $ids[$m.Groups[1].Value] = $true }
}

$fallos = @()
foreach($f in $xmls){
  $txt = Get-Content $f.FullName -Raw -Encoding UTF8
  foreach($m in [regex]::Matches($txt,'@(?![+a-z]*:)([a-z]+)/([A-Za-z0-9_.]+)')){
    $tipo = $m.Groups[1].Value
    $nom  = $m.Groups[2].Value
    if($tipo -eq 'id'){ if(-not $ids.ContainsKey($nom)){ $fallos += ($f.Name + ' -> @id/' + $nom) } }
    elseif($tipo -in @('dimen','color','string','style','drawable','font','layout','mipmap','anim')){
      if(-not $defs.ContainsKey($tipo + '/' + $nom)){ $fallos += ($f.Name + ' -> @' + $tipo + '/' + $nom) }
    }
  }
}
Write-Output ""
Write-Output "REFERENCIAS @recurso:"
if($fallos.Count -eq 0){ Write-Output ("   OK  (" + $defs.Count + " recursos definidos, " + $ids.Count + " ids)") }
else { foreach($x in ($fallos | Sort-Object -Unique)){ Write-Output ('   FALLA  ' + $x) } }

# --- 4) R.tipo.nombre en Kotlin ---
$fallosKt = @()
foreach($f in $kts){
  $txt = Get-Content $f.FullName -Raw -Encoding UTF8
  foreach($m in [regex]::Matches($txt,'R\.([a-z]+)\.([A-Za-z0-9_]+)')){
    $tipo = $m.Groups[1].Value
    $nom  = $m.Groups[2].Value
    if($tipo -eq 'id'){ if(-not $ids.ContainsKey($nom)){ $fallosKt += ($f.Name + ' -> R.id.' + $nom) } }
    else{
      if(-not $defs.ContainsKey($tipo + '/' + $nom)){ $fallosKt += ($f.Name + ' -> R.' + $tipo + '.' + $nom) }
    }
  }
}
Write-Output ""
Write-Output "USOS EN KOTLIN (R.tipo.nombre):"
if($fallosKt.Count -eq 0){ Write-Output ("   OK  (" + $kts.Count + " archivos)") }
else { foreach($x in ($fallosKt | Sort-Object -Unique)){ Write-Output ('   FALLA  ' + $x) } }

Write-Output ""
if($errores -eq 0 -and $fallos.Count -eq 0 -and $fallosKt.Count -eq 0 -and $dups.Count -eq 0){
  Write-Output "RESULTADO: todo correcto."
} else {
  Write-Output "RESULTADO: hay fallos (ver arriba)."
}
