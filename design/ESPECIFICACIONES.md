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

