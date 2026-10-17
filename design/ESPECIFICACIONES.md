# BDV · Pantalla de inicio — Especificación medida (pixel-perfect)

> Todos los valores fueron **medidos píxel a píxel** sobre `design/referencia-inicio.jpeg`
> con `System.Drawing` (lectura de color y barrido de bordes). No son estimaciones visuales.

## 1. Lienzo y densidad

| Dato | Valor |
|---|---|
| Imagen de referencia | 720 × 1453 px |
| Densidad deducida | **xhdpi (factor 2.0)** |
| Pantalla de diseño | **360 × 726.5 dp** |
| Conversión | `dp = px ÷ 2` · `sp = px ÷ 2` (a densidad de fuente 1.0) |

**Prueba de la densidad (matemática exacta):**

```
margen 40dp + tarjeta 56 + hueco 56 + tarjeta 56 + hueco 56 + tarjeta 56 + margen 40 = 360 dp
en px:  79      + 112        + 113     + 112        + 113     + 112        + 79      = 720 px
```

Los 7 valores salen enteros y limpios solo con factor 2. Confirmado.

## 2. Paleta exacta

| Token | Hex | RGB | Uso |
|---|---|---|---|
| `fondo` | `#303030` | 48,48,48 | Fondo de pantalla |
| `rojo_marca` | `#BB1B47` | 187,27,71 | Botón, tarjetas, franja inferior derecha |
| `amarillo` | `#FDC800` | 253,200,0 | Franja diagonal izquierda + shard del logo |
| `azul` | `#0068B1` | 0,104,177 | Franja diagonal central + shard del logo |
| `badge_rojo` | `#A32C24` | 163,44,36 | Círculo de notificaciones |
| `enlace` | `#A42749` | 164,39,73 | Enlace «Quiero abrir una cuenta en el BDV» |
| `blanco` | `#FFFFFF` | 255,255,255 | Textos, iconos, logotipo |

## 3. Jerarquía y medidas (px / dp)

| # | Elemento | x (px) | y (px) | w × h (px) | dp | Notas |
|---|---|---|---|---|---|---|
| 1 | Campana (glifo) | 40..75 | 28..70 | 36 × 43 | 18 × 21.5 | icono blanco, contorno |
| 2 | Badge notificación | 56..87 | 19..50 | 32 × 32 | 16 × 16 | círculo, `#A32C24` |
| 2b | Dígito «3» | 68..75 | 28..40 | 8 × 13 | cap 6.5 | blanco, ~18 px |
| 3 | Logotipo BDV (marca) | 105..258 | 330..501.5 | 153 × 171.5 | 76.5 × 85.75 | 3 shards vectoriales |
| 3b | Logotipo «BDV» (letras) | 284..611 | 362..474 | 327 × 113 | 163.5 × 56.5 | logotipo, no fuente estándar |
| 4 | Subtítulo | 142..578 | 528..563 | 437 × 36 | cap 18 | «Banco de Venezuela», 24 sp |
| 5 | Botón | 90..629 | 632..711 | 540 × 80 | 270 × 40 | radio **20 px (10 dp)** |
| 5b | Texto botón | 290..429 | 662..679 | 140 × 18 | cap 7.5 | «Iniciar sesión», ~11 sp, bold |
| 6 | Enlace | 179..541 | 796..818 | 363 × 23 | cap 9 | «Quiero abrir una cuenta en el BDV», ~13 sp |
| 7 | Tarjeta 1 | 79..190 | 882..993 | 112 × 112 | 56 × 56 | radio **24 px (12 dp)** |
| 8 | Tarjeta 2 | 304..415 | 882..993 | 112 × 112 | 56 × 56 | |
| 9 | Tarjeta 3 | 529..640 | 882..993 | 112 × 112 | 56 × 56 | |
| 10 | Etiqueta 1 | 67..203 | 1019..1037 | 137 × 19 | cap 7 | «PagomóvilBDV», 1 línea |
| 11 | Etiqueta 2 | 312..407 | 1020..1065 | 96 × 46 | cap 7 | «Pagos» / «AccessPay», 2 líneas |
| 12 | Etiqueta 3 | 551..617 | 1020..1061 | 67 × 42 | cap 7 | «Ver mis» / «saldos», 2 líneas |

### Iconos dentro de las tarjetas

| Tarjeta | x (px) | y (px) | w × h (px) | Centrado |
|---|---|---|---|---|
| 1 · móvil | 118..151 | 911..964 | 34 × 54 | sí (134.5 , 937.5) |
| 2 · AccessPay | 332..386 | 910..964 | 55 × 55 | sí (359 , 937) |
| 3 · saldos | 563..609 | 916..959 | 47 × 44 | sí (586 , 937.5) |

## 4. Tipografía medida (alturas de mayúscula reales)

| Texto | Cap-height | Tamaño deducido | Ancho real | Ratio ancho/cap |
|---|---|---|---|---|
| Banco de Venezuela | 34 px | ~48 px = **24 sp** | 437 px | 12.85 |
| Quiero abrir una cuenta en el BDV | 18 px | ~26 px = **13 sp** | 363 px | 20.17 |
| Iniciar sesión (bold) | 15 px | ~22 px = **11 sp** | 140 px | 9.33 |
| PagomóvilBDV | 14 px | ~20 px = **10 sp** | 137 px | 9.79 |

Interlineado de las etiquetas de 2 líneas: **28 px (14 dp)** (baseline 1033 → 1061).

> El ratio ancho/cap es independiente del tamaño: sirve para identificar la fuente exacta.
> Pendiente: confirmar familia tipográfica (ver §7).

## 5. Geometría de las franjas diagonales (polígonos exactos, px)

Las tres franjas están recortadas por el borde inferior de la imagen (el diseño continúa).

**Amarilla** — cuadrilátero:
```
(0 , 1043.7)  (357 , 1220)  (161 , 1317)  (0 , 1249)
```

**Azul** — banda (borde superior-izq. y borde inferior-der. paralelos):
```
(719 , 1044)  (0 , 1396)  (0 , 1453)  (293 , 1453)  (719 , 1250)
```
Rectas: `x = 2880 − 2.07y` (arriba) y `x = 3304 − 2.07y` (abajo) → ancho horizontal 424 px.

**Roja** — triángulo:
```
(719 , 1250)  (719 , 1453)  (293 , 1453)
```

## 6. Geometría del logotipo (shards del «V», px)

**Amarillo:** `(169.7,338) (185,364.3) (165.8,493.7) (105,371.5)`
**Azul:**     `(189,372) (233,462) (171,501.5) (179,420.5)`
**Rojo:**     `(258,330) (237.3,460.6) (193,372)`

Separación entre shards: **4–5 px (2 dp)** de fondo visible.

## 7. Pendiente / decisiones abiertas

1. **Fuente**: la del mockup no es una fuente de sistema estándar. Sin el archivo
   `.ttf`/`.otf` del banco, los textos se replican con la familia más cercana y el
   ancho puede variar 1–4 %. Los **espaciados, colores y tamaños sí son exactos**.
2. **Barra de estado**: el mockup no la incluye (el contenido empieza en y=0).
   En el APK real hay que decidir si se dibuja bajo la barra de estado.
3. **Borde inferior**: los últimos ~8 px de la imagen son negros (recorte del mockup,
   no diseño). Se excluye del diseño.
4. **Logotipo**: se reproduce como asset de marca recortado a 2x + versión vectorial
   de los 3 shards. Para producción conviene el SVG oficial del banco.

---

## 8. Diálogo «Ingresa con tu contraseña» (referencia-clave.jpeg)

Mockup: **720 × 1456 px** @2x. Comparte lienzo con la pantalla de autenticación
(360 × 723 dp), con 4 px menos arriba, así que `dp = (y − 10) / 2`.

El fondo **no es un color plano**: es la propia pantalla de autenticación
oscurecida con un **velo negro al 53 %** (`#000000` con alfa `#87` = 135/255 =
0,529). Verificado con tres colores independientes:

| Zona | Color original | × 0,47 | Medido en el mockup |
|---|---|---|---|
| fondo | #303030 | #161616 | **#161616** |
| franja amarilla | #FDC800 | #775E00 | **#755C00** |
| franja roja | #BB1B47 | #580D21 | **#560D21** |

### Medidas (px del mockup → dp)

| Elemento | px | dp | Nota |
|---|---|---|---|
| Tarjeta | 560 × 414 en (80, 524) | 280 × 207 | radio 20 px = 10 dp |
| Relleno de la tarjeta | #424242 | — | opaco |
| «Usuario: A\*\*\*\*\*4» | 199 × 20 · cap-top 580 | 14 sp | blanco, centrado |
| Campo | 480 × 96 en (120, 674) | 240 × 48 | radio 20 px = 10 dp |
| Relleno del campo | #555555 | — | |
| Borde del campo | 4 px #9E9E9E | 2 dp | |
| «Contraseña:» | 141 × 20 · x 142..282 | 13,5 sp | #757575, padding izq 11 dp |
| Ojo (mostrar/ocultar) | 43 × 30 en (530, 707) | 21,5 × 15 | blanco, dentro del campo |
| Botones | 176 × 80 en y 818 | 88 × 40 | radio 20 px = 10 dp, #BB1B47 |
| «Aceptar» / «Cancelar» | 83 / 93 px de ancho | 12,5 sp | peso 400, tracking −0,025 em |

### Radio verificado con la fórmula del arco

`inset(d) = r − √(r² − (r−d)²)`, con `d` = distancia al borde recto:

| d (px) | Predicho (r = 20) | Tarjeta | Campo | Botón |
|---|---|---|---|---|
| 1 | 13,8 | 13 | 14 | 15 |
| 4 | 8,0 | 8 | 8 | 7 |
| 8 | 4,0 | 4 | 3 (d=10) | 4 (d=7) |

Los tres elementos usan **el mismo radio de 20 px = 10 dp**.

### Posicionamiento en Android

No es una pantalla nueva: es una **capa superpuesta** (`@+id/panelClave`,
`visibility="gone"`) dentro de `activity_login.xml`, de modo que el fondo
oscurecido es la pantalla real.

```
FrameLayout  panelClave     (match_parent · clickable · focusable)
├── View           velo     #87000000          (match_parent)
└── ConstraintLayout        280 × 207 dp       layout_gravity="center"
    ├── TextView   claveUsuario   14 sp          marginTop 25 dp
    ├── EditText   claveCampo     240 × 48 dp    en (20, 75)   borde 2 dp
    ├── ImageView  claveOjo       28 × 21 dp     en (222, 88,5)
    ├── TextView   claveAceptar   88 × 40 dp     en (47, 147)
    └── TextView   claveCancelar  88 × 40 dp     en (145, 147)
```

`LoginActivity` lo abre al pulsar «Ingresa con tu contraseña» y lo cierra con
«Aceptar», «Cancelar», el botón atrás o un toque en el velo. El ojo alterna entre
contraseña visible y oculta.

### Validación

Diff global **2,23 / 255** (1,33 % de píxeles con desviación > 32). Cajas
comprobadas contra el mockup: tarjeta, campo, botones y ojo **exactos**;
«Contraseña:» 141 px **exacto**; «Usuario» 197 px (Δ 2); textos de botón
83 / 95 px.

---

## 9. Panel de Pagos (referencia-pagos.jpeg)

Al pulsar **Pagos** en la barra inferior del dashboard no se cambia de pantalla:
se abre una **hoja inferior** (bottom sheet) sobre el propio dashboard.

Mockup: **720 × 1446 px** @2x → `dp = px ÷ 2`.

El fondo es el dashboard real con un **velo negro al 53 %** (el mismo `#87000000`
del diálogo). Verificado con tres colores independientes:

| Zona | Color original | × 0,47 | Medido en el mockup |
|---|---|---|---|
| barra superior | #303030 | #161616 | **#161616** |
| tarjeta de saldo | #BB1B47 | #580D21 | **#560D21** |
| hoja del histórico | #212121 | #0F0F0F | **#0F0F0F** |

### Medidas (px del mockup → dp)

| Elemento | px | dp | Nota |
|---|---|---|---|
| Panel | ancho completo, desde y 803 | 322 de alto, anclado abajo | radio superior 40 px = **20 dp** |
| Cabecera | 720 × 84 desde y 803 | 360 × 42 | `#BB1B47`, radio 40 arriba |
| «Pagos» | 81 × 27 · cap-top 833 · centro x 360 | 14,5 sp bold | blanco |
| Opciones | paso **112** px · cap-top 927 + 112·i | paso **56 dp** | 15,25 sp, blanco |
| «PagomóvilBDV» | 206 px · x 34 | margen izq 15,5 dp | |
| «PagomóvilBDV QR» | 257 px · x 34 | | |
| «Tarjeta de crédito» | 236 px · x 32 | | |
| «Financiamiento especial» | 325 px · x 34 | | |
| «Pagos compartidos» | 260 px · x 34 | | |

El alto del panel sale exacto de su contenido: **42 + 5 × 56 = 322 dp**, y en el
mockup (723 dp de alto) arranca justo en y = 401,5 dp → 723 − 401,5 = 321,5 dp.
Por eso se ancla abajo con `wrap_content`.

### Radio verificado con la fórmula del arco

`inset(d) = r − √(r² − (r−d)²)` sobre la esquina superior izquierda de la cabecera:

| d (px) | Predicho (r = 40) | Medido |
|---|---|---|
| 1 | 31,1 | 31 |
| 5 | 20,6 | 22 |
| 12 | 11,4 | 13 |
| 20 | 5,4 | 6 |
| 30 | 1,3 | 2 |

### Posicionamiento en Android

Capa superpuesta dentro de `activity_dashboard.xml` (el fondo oscurecido es el
dashboard real):

```
View          pgVelo    #87000000            (match_parent, visibility=gone)
LinearLayout  pgPanel   wrap_content · abajo (match_parent de ancho)
├── FrameLayout          42 dp   → bg_panel_cabecera (#BB1B47, radio 20 arriba)
│   └── TextView pgTitulo   14,5 sp bold, centrado
├── TextView pgItem1     56 dp   15,25 sp, paddingStart 15,5 dp
├── TextView pgItem2     56 dp
├── TextView pgItem3     56 dp
├── TextView pgItem4     56 dp
└── TextView pgItem5     56 dp
```

`DashboardActivity` lo abre con el icono **y** el texto «Pagos» (`nav3`,
`navTexto3`), y lo cierra al tocar el velo, al elegir una opción o con el botón
atrás (solo mientras está visible).

### Validación

| Región | Diff medio | Comprobación |
|---|---|---|
| **Fondo (velo)** | **0** | `#161616` idéntico |
| **Panel completo** (y 803..1445) | **5,59 / 255 (2,2 %)** | |
| Cabecera roja | **1,80** | color y geometría exactos |
| Márgenes laterales y pie | **0,00** | `#303030` idéntico |
| Título «Pagos» | 6,25 | 80 × 26 px vs 81 × 27 del mockup |
| Opciones 1..5 | 9,1 – 12,1 | anchos 202 / 258 / 234 / 324 / 259 px vs 206 / 257 / 236 / 325 / 260 |

El resto del diff es la **forma de las letras** (la tipografía de marca sigue
siendo la limitación conocida): posiciones, colores, radios y márgenes son
exactos.

---

## 10. PagomóvilBDV (referencia-pagomovil.jpeg)

Se abre al pulsar **PagomóvilBDV** en el panel de Pagos.

Mockup: **720 × 1451 px** @2x → `dp = px ÷ 2`.

### Paleta medida

| Token | Hex | Uso |
|---|---|---|
| `fondo` | `#303030` | Fondo (igual que el resto de la app) |
| `campo_pm_fondo` | `#454545` | Relleno de los 6 campos |
| `campo_borde` | `#9E9E9E` | Borde de **4 px = 2 dp** de los campos |
| `texto_gris` | `#9F9F9F` | Etiquetas («Operación:», «Banco:») y placeholders |
| `chevron_pm` | `#C9C9C9` | Triángulo del desplegable (medido) |
| `rojo_marca` | `#BB1B47` | Círculos, botón de Documento, Pagar/Limpiar, barra |

### Medidas (px del mockup → dp)

| Elemento | px | dp |
|---|---|---|
| Campana + badge | 48 × 52 en (40, 22) | 24 × 26 en (20, 11) |
| Título «PagomóvilBDV» | 225 × 32 · cap-top 41 · x 146 | 16 sp bold, x 73 |
| Menú | 30 × 22 en (657, 42) | 15 × 11 en (328.5, 21) |
| Círculo «Pegar datos» | 72 × 72 en (40, 110) | 36 × 36 en (20, 55) |
| «Pegar datos» / «Leer datos» | cap-top 136 | 13 sp, x 67 / der 67 |
| Campos | 640 × 96 · borde 4 · radio 20 | 320 × 48 · 2 · 10 |
| **Paso entre campos** | **156** | **78** |
| Etiquetas sobre el borde | cap-top 204 / 517 · x 45 | 12 sp, x 21.5 |
| Notch (borde interrumpido) | x 40..165 = 126 px | 63 dp × 2 dp |
| Triángulo del desplegable | 18 × 9 en x 623 | 9 × 4.5 en x 311.5 |
| Campo Documento | 534 × 96 | 267 × 48 |
| Botón de Documento | 96 × 96 en (584, 368) · radio 20 | 48 × 48 en (292, 184) · 10 |
| Pagar / Limpiar | 176 × 80 en y 1126 · radio 20 | 88 × 40 en y 563 · 10 |
| Icono del pie | 66 × 81 en (325, 1258) | 33 × 40.5 en (162.5, 629) |
| Barra inferior | desde y 1338 · 113 px | 669 · 56.5 |

### Radio del botón de Documento (fórmula del arco)

`inset(d) = r − √(r² − (r−d)²)`

| d (px) | Predicho (r = 20) | Medido |
|---|---|---|
| 1 | 13,8 | 14 |
| 5 | 6,8 | 7 |
| 10 | 2,7 | 3 |
| 17 | 0,2 | 1 |

### Las etiquetas sobre el borde («notch»)

Los dos desplegables llevan la etiqueta **encima del borde**, que se interrumpe
justo debajo de ella. Medido: el borde desaparece desde el borde izquierdo del
campo hasta x 165 px (63 dp) y solo en el grosor del borde (4 px = 2 dp); detrás
de la etiqueta se ve el fondo de la página arriba y el relleno del campo abajo.
Se reproduce con una `View` de 63 × 2 dp con el mismo relleno del campo
(`bg_notch_pm.xml`) en la esquina superior izquierda.

### Posicionamiento en Android

`activity_pagomovil.xml` (ConstraintLayout) + `PagomovilActivity`, con los iconos
recortados del mockup en `res/drawable-xhdpi` (`pm_campana`, `pm_menu`,
`pm_circulo_pegar`, `pm_circulo_leer`, `pm_boton_doc`, `pm_icono_inferior`) y el
triángulo como vector (`pm_triangulo.xml`). La barra inferior reutiliza los
mismos `db_nav1..6` del dashboard, 4 px más arriba.

`DashboardActivity` abre esta pantalla al pulsar **PagomóvilBDV** (la primera
opción) en el panel de Pagos.

### Validación

| Región | Diff medio | Comprobación |
|---|---|---|
| **Global** | **2,56 / 255 (2,03 %)** | la mejor de las seis pantallas |
| Campana + badge · Menú · Círculos · Botón · Icono del pie | 0,03 · 0,00 · 0,95 · 1,01 · 0,35 | recortes exactos |
| Campos vacíos 2, 4, 5 y 6 | 0,52 – 1,33 | bordes, radio y relleno exactos |
| Barra inferior (iconos) | 2,98 | |
| Botones Pagar / Limpiar | 4,82 / 6,54 | caja 176 × 80 **exacta** |
| Textos | 10 – 42 | solo forma de letra |

El resto del diff es la **forma de las letras**: posiciones, colores, radios,
bordes y márgenes son exactos.





---

## 11. Comprobante de operación (referencia-comprobante.jpeg)

Se abre al pulsar **Pagar** en PagomóvilBDV, con los datos del formulario.

**Lienzo**: 633 × 1280 px. A diferencia de los otros mockups (720 px = 360 dp
a 2×), este viene a **escala 1,75833** → lienzo **360 × 727,9 dp**. Todas las
medidas de abajo salen de `px / 1,75833`.

**Fondo**: `#212121` (el mismo `@color/hoja` del dashboard, no `#303030`).

### 11.1 Medidas (px del mockup)

| Elemento | Medida | Posición | dp / sp |
|---|---|---|---|
| Flecha atrás | 32 × 32 | (33, 36) | 18,2 dp en (18,8 · 20,5) |
| Título «Comprobante de operación» | mayúscula 40 → 68 (29 px) | centrado | **16sp** negrita · margen 19,3 |
| Icono compartir | 38 × 40 | (572, 31) | 21,6 × 22,7 en (325,3 · 17,6) |
| Logotipo (shards) | 85 × 90 | (272, 150) | 51,2 × 54,6 en (153 · 83,6) |
| «PagomóvilBDV Personas» | banda 258 → 282 (25 px) | centrado | **14sp** · margen 143,6 |
| Círculo blanco con check | 45 × 44 | (294, 299) | 28,4 × 27,9 en (165,5 · 168,3) |
| Caja del monto | 543 × 69 · radio 17 | (45, **365**) | 308,8 × 39,2 · radio 9,7 · margen 207,6 |
| «2.400,00 Bs» | mayúscula 389 → 410 (22 px) · 132 px de ancho | centrado · color **#F5F5F5** | **14,2sp** · margen 218,1 |
| Etiquetas (negrita) | cap 466 → 483 | x 57 | **12,5sp** · margen izq 32,4 |
| Valores | igual banda | derecha en 575 (**el de Operación, en 540**) | **12,5sp** · margen der 33 (**Operación, 52,9**) |
| Paso entre filas | **49,5** | caps 466, 515, 565, 615, 664, 713, 763 | **28,1 dp** |
| Icono copiar | **28 × 34** | (**555, 508**) · al lado del número | **15,9 × 19,3** en (**315,6 · 288,9**) |
| Flecha del pie | 40 × 39 | (296, 1021) | 22,7 × 22,2 en (168,3 · 580,7) |
| Separador | 6 px de alto | y 1096 · color `#272727` | 3,4 dp · margen 623,3 |
| Riel del interruptor | 63 × 35 · radio 17,5 · `#636363` | (186, 1136) y (186, 1220) | 35,8 × 19,9 · radio 10 · margen 105,8 |
| Bola | 32 × 32 · `#BDBDBD` | (187, 1137,5) y (187, 1221,5) | 18,2 dp · margen 106,3 |
| «Agregar Beneficiario» / «Crear Acceso directo» | banda 1144/1229 | x 273 | **12sp** · margen 155,3 |

### 11.2 Trampas de medición (apuntadas para no repetirlas)

1. **La caja del monto empieza en y 365, no en 339.** Un barrido por color
   (`≈#757575`) da un bbox que empieza en 340 porque **el borde antialiasado del
   círculo blanco del check** tiene ese gris. La forma correcta de medirla es
   buscar, columna a columna, la primera fila con brillo > 60: da 365 en todas
   las columnas centrales. Ese error hacía la caja 26 px más alta (diff 21,1 en
   vez de 2,57).
2. **El check va encima de la caja**: el círculo (299 → 342) solapa el borde
   superior de la caja (365)… no llega a solapar, pero en el mockup está pegado
   y con el fondo del círculo recortado. En el layout la caja se declara antes
   que el `ImageView` del check para que este quede por encima.
3. **Etiquetas y valores miden igual**: al proyectar por filas, las dos bandas
   ocupan exactamente las mismas filas (466 → 483), así que van al mismo tamaño
   (12,5sp); la diferencia es solo el peso (negrita / redonda).
4. **El interruptor no es un `Switch`**: el riel mide 63 × 35 px con radio 17,5
   y la bola 32 px, con `#636363` y `#BDBDBD`. Se dibuja con dos `View`
   redondeadas para clavar los colores medidos.
5. **La escala del mockup no es 2×**: se deduce del paso entre filas (49,5 px)
   y del ancho del título (362 px = 11,58 em en negrita): con 1,75833 todo cae
   en valores redondos (28,1 dp de paso, 12,5sp de texto).
6. **El icono de copiar va AL LADO del número, no encima**: medido, el valor de
   «Operación:» termina en **x 540** (los demás valores llegan a 575) y el icono
   ocupa **555..582 × 508..541**. Estaba puesto en 562..587 y con 25 px de ancho,
   o sea montado sobre el número (diff 12,05); con su caja real baja a **0,32**.
   La trampa es dar por hecho que todos los valores comparten el margen derecho
   de 33 dp: el de Operación no, porque le deja sitio al icono.
7. **El monto es blanco suave, no blanco puro**: el núcleo del texto del mockup
   es `#FFFFFF`, pero al ser JPEG el 88 % de sus píxeles claros son grises
   (media `#D7D7D7`). Probados seis valores midiendo el diff real de la zona
   del monto (`#FFFFFF` 13,97 · `#F2F2F2` 13,40 · `#E8E8E8` 13,26 · `#DCDCDC`
   13,47 · `#D7D7D7` 13,57 · `#CCCCCC` 13,92), con **`#F5F5F5`** y capa de
   composición se queda en **10,22**.
7b. **La fuente del mockup es Nunito, la tipografía de marca del banco, y sí se
   puede usar**: al principio se dio por hecho que era una tipografía propia no
   disponible y se probaron 13 fuentes del sistema (Arimo 400/500/600/700, Arial
   Rounded MT Bold, Century Gothic y Bold, Corbel, Candara, Segoe UI y Semibold,
   Leelawadee UI, Nirmala UI) sin bajar el monto de 10,22. La respuesta estaba en
   la web oficial: **bancodevenezuela.com declara `font-family: Nunito,
   sans-serif`**. Nunito es SIL OFL 1.1 (se puede incrustar en la app y en el
   APK) y con ella el monto baja de 13,41 a **5,77** y el título de 31,0 a
   **22,33**. Los trazos medidos cuadran: monto 3,93 px en el mockup frente a
   4,03 con Nunito 500, y título 4,66 frente a 4,57 con Nunito 650. Los pesos e
   interletras de cada texto están en la sección 14.
8. **Chrome en Windows pinta el texto con antialiasing subpíxel** (flecos
   naranjas y azules) y el mockup es una captura de teléfono, que usa escala de
   grises. Forzando capa de composición en los textos (`transform:translateZ(0)`)
   el render se vuelve gris y el diff global baja de 5,56 a **4,75** (monto
   13,97 → 10,22, título 34,5 → 30,5, subtítulo 38,4 → 33,0, interruptores
   35,8 → 30,6). Poner la capa en el `body` **no sirve**: con fondo opaco Chrome
   sigue usando subpíxel; hay que ponérsela a cada texto. En Android no hace
   falta, ya usa escala de grises.


---

## 12. Selección de banco (referencia-bancos.jpeg)

Se abre al pulsar el campo **Banco:** de PagomóvilBDV.

**Lienzo**: 720 × 1441 px @2x → **360 × 720.5 dp**. Ojo: el mockup viene
**recortado por abajo** (la barra inferior se ve solo hasta y 1441, con 87 px),
y la réplica reproduce ese recorte para poder comparar 1:1.

### 12.1 Medidas (px del mockup)

| Elemento | Medida | Posición | dp / sp |
|---|---|---|---|
| Primera fila (la elegida) | 96 de alto | y **28** | 14 dp · 48 dp de alto |
| Paso entre filas | **96 exactos** | — | **48 dp** |
| Texto de fila | 27 px · mayúscula 20 px | x **33** | **13.5sp** · 16.5 dp del borde |
| Fondo de la fila elegida | `#494949` | y 29 → 125 | — |
| Fondo del resto / lienzo | `#303030` | — | `@color/fondo` |
| Barra de desplazamiento | 8 × 738 | (712, 13) · `#CCCCCC` | 4 dp · alto 369 dp |
| Pista de la barra | 8 × 1341 (transparente) | (712, 13) → y 1354 | 4 dp · 670.5 dp |
| Barra inferior | 87 px visibles | desde y **1354** | `@color/rojo_marca` |
| Degradado de la barra | `#7A1233` (1354) → `#BB1B47` (1400) | — | — |
| Iconos de la barra | 34 – 46 px de ancho | y 1356 – 1392 | **diff 0,2 – 0,5** |
| Etiquetas de la barra | mayúscula 13 px · «Pagos» 16 px | y 1412 (1408 la activa) | 9sp · 11sp negrita |

### 12.2 Trampas de medición

1. **El mockup está recortado**: el lienzo real de la app es 1451 px (725.5 dp)
   y aquí solo hay 1441, con la barra inferior cortada a 87 px. Se replica el
   recorte tal cual; en Android la barra va anclada abajo, completa.
2. **La barra inferior tiene degradado**, a diferencia de la de PagomóvilBDV
   (que es `#BB1B47` plano): aquí arriba es `#7A1233` y se aclara hasta y 1400.
3. **El texto va centrado en la fila**, no con un margen fijo: al ser 96 px de
   fila y 27 px de fuente, la mayúscula queda a 38 px del borde superior. Con
   `align-items:center` y `line-height:38px` salen las dos líneas del 0175, el
   0601 y el 0178 dentro de la misma fila de 96 px.
4. **La barra de desplazamiento es propia** (8 px `#CCCCCC` pegada al borde
   derecho), no la del navegador; se dibuja aparte y se mueve al desplazar.
5. Los **25 bancos** están en el orden del mockup (el alfabético real del
   sistema financiero venezolano), con los códigos de 4 dígitos delante.
6. **El mockup `-2` no es otra pantalla**: es esta misma lista **desplazada
   hasta abajo**. Sus 14 filas visibles son las filas 12 a 25 de la lista (0191,
   0138, 0137 BANCO SOFITASA y las 11 de debajo, hasta 0169 R4 BANCO
   MICROFINANCIERO C.A.). No hay bancos que añadir: lo que hacía falta es que la
   barra funcione para poder bajar hasta ellos.
7. **La barra no lleva flechas ni adornos**: es un rectángulo plano `#CCCCCC` de
   8 px (medido: `diff 0,07`). Si alguien la llama «la flecha para bajar y
   subir», se refiere a esta barra; la pista (13 → 1354) no se ve.

### 12.3 La barra de desplazamiento (bajar y subir)

La barra del borde derecho es propia, no la del navegador, y se comporta como la
de una app real:

| Gesto | Qué hace |
|---|---|
| Agarrar la barra y arrastrar (ratón o dedo) | Baja y sube la lista, 1:1 con el dedo |
| Tocar la pista (la franja del borde, fuera de la barra) | La barra salta a esa altura y sigue al dedo |
| Rueda del ratón encima de la barra o de la pista | Desplaza (antes no hacía nada: la barra no está dentro de la lista) |
| Lista enfocada (tabulador) + flechas / AvPág / RePág / Inicio / Fin | Baja y sube de fila, de pantalla o hasta el final |

Medidas: pista de **13 a 1354 px** (6.5 → 677 dp; 670.5 dp de alto) y barra de
4 dp de ancho pegada al borde (x 712). El alto de la barra no es fijo:
`pista × lo que se ve / lo que hay`; con 25 filas de 48 dp sale 741 px (los 738
del mockup, ±3). En Android el alto mínimo es 20 dp y la franja táctil 8 dp.

Validación: `tools/probar-interaccion.ps1` arrastra la barra de verdad (eventos
de ratón sobre la réplica) y comprueba el resultado: bajar 400 px → `scrollTop
716`; subir 300 → `179`; rueda 300 → `300`; tocar la pista abajo → `1074` (el
tope); flecha arriba → `978`. Antes de arreglarlo, arrastrar dejaba `scrollTop`
en `0`.

---

## 13. Textos centrados: `android:gravity="center"`

El mockup centra **todos** los textos que ocupan el ancho de la pantalla. En la
réplica HTML eso es una línea (`.txt{left:0;width:720px;text-align:center}`), pero
en Android un `TextView` con `layout_width="0dp"` y anclas a los dos bordes **no**
centra nada: por defecto alinea a la izquierda, así que el texto queda pegado al
borde y se ve cortado.

Le pasó a **siete** textos y no se vio en la validación pixel-perfect porque la
validación se hace sobre la réplica HTML, que sí estaba bien:

| Pantalla | Textos que salían pegados a la izquierda |
|---|---|
| Inicio | `subtitulo` («Banco de Venezuela»), `enlace` («Quiero abrir una cuenta…») |
| Autenticación | `subtitulo`, `sesionComo`, `usuario`, `pulsa`, `ingresa` |

Arreglo: `android:gravity="center"` en los siete (el diálogo de contraseña ya lo
llevaba, y en el panel de Pagos el título va centrado por
`layout_gravity="top|center_horizontal"`).

`tools/validar-android.ps1` lo comprueba ahora de forma automática (apartado
**2c**): recorre los layouts y avisa de cualquier `TextView`/`EditText`/`Button`
con ancho `0dp` y anclas a los dos bordes que no lleve `gravity` con `center`.
Estado actual: **OK (todos centrados)**.

---

## 14. La tipografía del mockup es Nunito (y se puede incrustar)

La primera pasada dio por hecho que el mockup usaba una tipografía propia del
banco que no estaba en el equipo, y se probaron 13 fuentes del sistema sin bajar
la diferencia. La respuesta estaba en la web oficial: **bancodevenezuela.com
declara `font-family: Nunito, sans-serif`**.

Nunito es de Google Fonts con licencia **SIL OFL 1.1**: se puede incrustar en la
app y dentro del APK sin problema. Se descargó la instancia variable
(`replica/nunito.ttf` y `android/app/src/main/res/font/nunito_variable.ttf`) y se
ajustó cada texto midiendo su tinta contra el mockup.

### 14.1 Lo que se midió (comprobante)

| Texto | Tamaño | Peso | Interletra | Tinta en el mockup | Tinta en la réplica | Trazo |
|---|---|---|---|---|---|---|
| «Comprobante de operación» | 28 px | 800 | +0,21 px | x 128..487 · y 41..67 | x 128..487 · y 41..67 | 4,66 / 4,57 |
| «PagomóvilBDV Personas» | 24,5 px | 650 | -0,35 px | x 182..451 · y 258..305 | x 180..453 · y 258..305 | 3,45 / 3,25 |
| «2.400,00 Bs» | 25,5 px | 650 | −0,7 px | x 251..382 · y 389..409 | x 251..382 · y 389..409 | 3,93 / 4,52 |
| Etiquetas («Fecha:»…) | 22 px | 700 | −1 px | 56×15 px | 57×16 px | 2,81 / 4,40 |
| Valores («13/10/2026»…) | 22 px | 500 | −0,9 px | 107×15 px | 109×17 px | 1,58 / 2,77 |
| Interruptores del pie | 21 px | 550 | −0,1 px | 190×20 px | 189×19 px | 2,69 / 2,53 |

Diferencias por zona al pasar de Arimo a Nunito (sobre 255, menos es mejor):

| Zona | Arimo | Nunito |
|---|---|---|
| Monto | 13,41 | **7,99** |
| Título | 30,99 | **23,91** |
| Subtítulo | 40,90 | **9,57** |
| Texto del interruptor 1 | 21,02 | **15,97** |
| Texto del interruptor 2 | 30,57 | **19,08** |
| **Media de los 12 textos** | 18,92 | **11,81** |
| **Diff global de la pantalla** | 4,78 | **3,36** (2,71 % de píxeles) |

### 14.2 Trampa nueva: el título del mockup NO está centrado

La tinta del título va de **x 126 a x 490** en un lienzo de 633 px: márgenes
**126 y 143 px**, o sea **8,5 px a la izquierda del centro**. El subtítulo y el
monto sí van centrados (su tinta va de 182 a 451 y de 251 a 382, con el centro
justo en 316,5). Es como si el texto del mockup llevase espacios de más al final.
Se reproduce con `left:-8.5px` en el HTML y con `android:translationX="-4.8dp"`
en Android (dimen `cp_titulo_desplazamiento`); es lo que baja el diff del título
de 32,8 a **22,33**.

### 14.3 Cómo se pasa a Android

| En el HTML | En Android |
|---|---|
| `font-family:'Nunito'` con peso 400 | `android:fontFamily="@font/nunito"` |
| peso 500 (monto) | `@font/nunito_medium` (`fontVariationSettings="'wght' 500"`) |
| peso 650 (título) | `@font/nunito_semibold` (`'wght' 650`) |
| peso 700 (etiquetas) | `@font/nunito` + `android:textStyle="bold"` |
| `letter-spacing: Npx` | `android:letterSpacing="N / tamaño"` (en em) |

Los márgenes verticales también cambian: el hueco entre el borde de la caja y la
altura de mayúscula pasa de **0,2153 em** (Arimo) a **0,2960 em** (Nunito), así
que todos los `margin_top` del comprobante bajan **0,081 em**. Se mide con
`tools/medir-metricas.ps1`; sin corregirlo, todos los textos quedan 1 px arriba.

### 14.4 Cómo se vuelve a medir (y las trampas de Chrome)

El bucle de ajuste es: renderizar, medir la tinta de cada texto, cambiar el valor
y repetir. Al renderizar con Chrome headless hay dos trampas que cuestan un rato
largo:

1. **`--user-data-dir` y `--screenshot` con espacios** (por ejemplo
   `C:\Users\Alexis Ruiz\...`) se parten en dos argumentos y Chrome falla con
   `Multiple targets are not supported in headless mode` (código 13), **sin
   escribir el PNG y sin decir nada por consola**. Solución: rutas cortas 8.3
   (`GetFolder($env:TEMP).ShortPath`) y todos los argumentos en un único string.
2. **Reutilizar el mismo perfil**: si queda una instancia de Chrome viva, la
   nueva responde «Se está abriendo en una sesión de navegador existente» y **no
   vuelve a capturar**: se miden números del render viejo y uno se los cree.
   Solución: un `--user-data-dir` nuevo (GUID) por captura y comprobar que el PNG
   se ha escrito de verdad.

3. **Una capa de composicion cerca del borde inferior no se pinta**: los textos
   del comprobante llevan `transform:translateZ(0)` (seccion 11.2, trampa 8) y
   Chrome headless **no pinta esa capa si cae pegada al borde inferior de la
   ventana**: en la captura a 633x1280 el texto del segundo interruptor
   ("Crear Acceso directo") desaparecia, con la misma diferencia que si no
   existiera (26,78 en esa zona en vez de 12,69). Con la ventana a 1400 px de
   alto si salia, asi que no era el HTML. La solucion son dos banderas de Chrome:
   `--run-all-compositor-stages-before-draw` y
   `--disable-new-content-rendering-timeout` (ya van en
   `tools/render-pantalla.ps1`). Comprobado: con la bandera la tinta sale en
   x 274..463 Â· y 1230..1244, igual que el mockup; sin ella, no sale.

Y una tercera del lado de PowerShell: al leer y reescribir un HTML sin
`-Encoding UTF8` los acentos se corrompen («operación» → «operación») y las
medidas del texto que se está ajustando salen mal. `tools/generar-vista-previa.ps1`
ya usa `-Raw -Encoding UTF8`.

---

## 15. Nunito en las siete pantallas restantes

La sección 14 pasó el comprobante a Nunito. Las otras siete pantallas seguían con
Arimo (elegido por descarte entre las fuentes del sistema), así que la app tenía
dos tipografías a la vez. Ya están todas con Nunito, que es la de marca.

### 15.1 Al cambiar de fuente la tinta se mueve, y depende de cómo esté colocado el texto

Nunito reparte distinto el ascenso y el descendente que Arimo (1,011 y 0,353 em
frente a 0,9053 y 0,2119) y tiene otra altura de mayúscula, así que la letra no
cae a la misma altura. Cómo se corrige depende de la colocación, y averiguarlo
costó varios renders:

| Colocación del texto | Qué mueve la tinta | Arreglo |
|---|---|---|
| Absoluto con `top` y `line-height:1` | el `line-height` | cambiar el `line-height` |
| Centrado en flex (`display:flex;align-items:center`) | **no** el `line-height`: manda el centrado | `padding-top` |

Medido pantalla a pantalla:

| Pantalla | Cómo van los textos | Desfase con Nunito | Arreglo aplicado |
|---|---|---|---|
| Bancos | filas de 96 px con `display:flex` | la letra sube 2 px | `padding-top:4px` en `.bkFila` (con `box-sizing:border-box` la fila sigue midiendo 96 px) |
| Pagos | ítems absolutos de 30,5 px | la letra sube 2 px | `line-height:1.2166` en `.item` |
| Dashboard | textos absolutos | ya cuadraban | solo el ancho del título (`letter-spacing:0.042em`) |

La fórmula del `line-height` es la que deja la tinta donde estaba con Arimo:
`(line-height − 1,364)/2 + 0,296 = (1 − 1,1172)/2 + 0,2153`, y se le suma el
desfase medido cuando hace falta (en Pagos, 2 px = 0,0656 em a 30,5 px, de ahí el
1,2166).

### 15.2 Resultado

| Pantalla | Con Arimo | Con Nunito | Cambio |
|---|---|---|---|
| Bancos | 9,49 | **4,78** | −41 % |
| Comprobante | 4,78 | **3,51** | −27 % |
| Inicio | 2,49 | **2,17** | −10 % |
| Clave | 2,24 | **2,06** | −7 % |
| Login | 3,49 | **3,40** | −1 % |
| PagomóvilBDV | 2,56 | 2,68 | +5 % |
| Dashboard | 4,87 | 5,17 | +6 % |
| Pagos | 5,59 | 5,72 | +2 % |

En las tres pantallas donde el número sube, la diferencia está en los **textos
pequeños**: la referencia es un JPEG y en letra pequeña el desenfoque le quita
contraste, así que el mockup parece más fino que cualquier fuente real. Medido con
`tools/medir-monto.ps1` (grosor de trazo), en la descripción de una fila del
dashboard el mockup da **1,49 px** y la réplica **3,25 px**; en el monto del
comprobante, que es letra grande, mockup y réplica coinciden (3,93 y 4,03). Aun
así la tipografía es la correcta en todas, y en las pantallas con texto grande
(Bancos, Comprobante) el cambio se nota mucho.

### 15.3 El título del dashboard: el ancho cuadraba, pero el diff empeoraba

En el dashboard el título («Inicio») medía 73 px de ancho en la réplica y 81 en el
mockup, con el mismo grosor de trazo (4,71 y 4,77 px), así que en principio solo
faltaba interletra. Se probó `letter-spacing:0.042em`: el ancho pasó a cuadrar
(80 px frente a 81), pero la diferencia de esa zona **subió** de 24,9 a 28,1 y la
global de 5,17 a 5,20. Al repartir el hueco entre las letras, cada trazo cae en una
fase distinta y el antialiasing se desvía más que antes, así que se dejó sin
interletra.

La lección (la misma que con el título del comprobante, sección 14.1): lo que hay
que bajar es la diferencia, no cuadrar el ancho. Un texto un poco más ancho o más
estrecho puede dar menos diferencia que el que mide exacto, porque sus trazos caen
en mejor sitio.
### 15.4 El peso del texto: 500, no 400

Nunito tiene los trazos mas finos que Arimo (que es como Arial), asi que al
cambiar de fuente **toda la app se veia mas fina** que antes y que el mockup: es
la misma sensacion que con el monto, que hubo que subir de 400 a 500 y luego a
600. Medido con renders de verdad, subir el texto normal de 400 a 500 **mejora**
casi todas las pantallas:

| Pantalla | 400 | 500 |
|---|---|---|
| Bancos | 5,46 | **4,78** |
| Pagos | 6,21 | **5,72** |
| Inicio | 2,25 | **2,17** |
| Login | 3,46 | **3,40** |
| Clave | 2,08 | **2,06** |
| Dashboard | 5,35 | 6,23 |
| PagomovilBDV | 2,68 | 2,73 |

En bancos, ademas, el 500 cuadra el ancho exacto de las filas (581 px frente a
581 del mockup) y baja la diferencia de esa zona de 29,3 a 19,3. El unico que
sube de verdad es el dashboard (+0,9): su mockup tiene la letra mas fina que los
demas. Se dejo en 500 igualmente, por coherencia con el resto de la app; si se
quiere el minimo ahi, es quitar el `font-weight:500` de su body.

El comprobante es aparte: alli cada texto lleva su peso medido uno a uno (400 en
valores, subtitulo e interruptores, 600 en el monto, 650 en el titulo y 700 en
las etiquetas), y subir sus textos a 500 empeora (subtitulo 11,9 -> 18,5,
interruptores 9,4 -> 16,5), asi que se queda como estaba.

En Android el peso va en la familia: `@font/nunito` (400 y 700) para el
comprobante y `@font/nunito_500` (500 y 700) para las otras siete pantallas,
incluido el `themes.xml`, que es de donde lo hereda la pantalla de inicio.