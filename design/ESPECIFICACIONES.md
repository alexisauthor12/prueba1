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
| «2.400,00 Bs» | mayúscula 389 → 410 (22 px) | centrado | **14,2sp** · margen 218,1 |
| Etiquetas (negrita) | cap 466 → 483 | x 57 | **12,5sp** · margen izq 32,4 |
| Valores | igual banda | derecha en 575 | **12,5sp** · margen der 33 |
| Paso entre filas | **49,5** | caps 466, 515, 565, 615, 664, 713, 763 | **28,1 dp** |
| Icono copiar | 20 × 32 | (562, 506) | 14,2 × 21,6 en (319,6 · 287,8) |
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

