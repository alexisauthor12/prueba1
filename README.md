# BDV · Réplica 1:1 de la app (Inicio → Login → Contraseña → Dashboard → Pagos → PagomóvilBDV → Comprobante) → APK

Réplica **medida píxel a píxel** de los mockups de `design/`, traducida a una app
Android real y compilable a APK **sin instalar nada en tu PC** (se compila en la
nube con GitHub Actions).

| # | Pantalla | Mockup | Réplica HTML | Diff (sobre 255) |
|---|---|---|---|---|
| 1 | Inicio | `referencia-inicio.jpeg` | `replica/index.html` | **2,17** |
| 2 | Autenticación | `referencia-login.jpeg` | `replica/login.html` | **3,40** |
| 3 | Diálogo «Ingresa con tu contraseña» | `referencia-clave.jpeg` | `replica/clave.html` | **2,06** |
| 4 | Dashboard | `referencia-dashboard.jpeg` | `replica/dashboard.html` | 6,23 |
| 5 | Panel de Pagos | `referencia-pagos.jpeg` | `replica/pagos.html` | **5,72** (panel) |
| 6 | PagomóvilBDV | `referencia-pagomovil.jpeg` | `replica/pagomovil.html` | 2,73 |
| 7 | Selección de banco | `referencia-bancos.jpeg` | `replica/bancos.html` | **4,78** |
| 8 | Comprobante de operación | `referencia-comprobante.jpeg` | `replica/comprobante.html` | **3,36** |

El flujo completo se puede recorrer sin compilar: abre
`replica/vista-previa-flujo.html` (autocontenido, sirve para el móvil).

---

## 1. Resultado de la validación pixel-perfect

Se renderizó la réplica en Chrome a **720 × 1453 px** (el tamaño exacto del mockup)
y se comparó píxel a píxel contra la referencia:

| Métrica | Valor |
|---|---|
| Diferencia media | **2,49 / 255** (0,98 %) con Arial · **2,51** con Arimo |
| Píxeles con desviación > 32 | **1,98 %** · 2,00 % con Arimo |
| Desviación de posición de todos los bloques | **±1 px** |

### Diff por región (0 = idéntico, medido sobre el canal más desviado)

| Región | Diff medio | Estado |
|---|---|---|
| Logotipo | **0,55** | prácticamente idéntico |
| Tarjetas 1 · 2 · 3 | 2,19 · 2,20 · 2,54 | exactas (resto = ruido JPEG) |
| Botón (rectángulo) | **3,41** | borde y radio exactos |
| Texto del botón | **7,82** | mejorado un 52 % al pasar a Arial |
| Enlace | **10,68** | mejorado un 34 % |
| Campana | 11,44 | forma del icono |
| Badge + campana | 18,40 | antialiasing del círculo |
| Subtítulo | 30,20 | solo forma de las letras |
| Etiquetas | 10,03 – 29,45 | solo forma de las letras |

| Región | Referencia | Réplica | Δ |
|---|---|---|---|
| Campana + badge | x 40..87 · y 19..70 | x 40..87 · y 19..71 | 1 px |
| Logotipo | x 107..611 · y 338..497 | x 108..611 · y 339..497 | 1 px |
| Subtítulo | 437 × 36 px | 436 × 36 px | 1 px |
| Botón | 540 × 80 px en (90, 632) | **idéntico** | 0 px |
| Enlace | 363 px ancho | 363 px ancho | 0 px |
| Tarjetas 1·2·3 | 112 × 112 px | **idéntico** | 0 px |
| Etiquetas 1·2·3 | 137 / 54+96 / 67+58 px | ±1 px | 1 px |
| Franjas diagonales | bordes de polígono | ±1..3 px | 1-3 px |

> El **1,97 %** restante son **diferencias de forma de las letras**, no de layout:
> el mockup usa una tipografía de marca que no está instalada en el equipo.
> Colores, tamaños, espaciados, radios, posiciones e iconos son exactos.

## 1b. Pantalla de autenticación (flujo del botón «Iniciar sesión»)

Replicada con el mismo método a partir de `design/referencia-login.jpeg`.

**Hallazgo clave:** el mockup del login mide 720 × 1460 px, pero tiene **14 px de
más arriba**. Al restarlos, la campana, el subtítulo y las franjas diagonales
coinciden **exactamente** con la pantalla de inicio → el lienzo de diseño real es
**360 × 723 dp**.

| Elemento | Medida (px) | dp | Diff |
|---|---|---|---|
| Campana + badge | 48 × 52 en (40, 33) | igual que inicio | **6,88** |
| Logotipo | 505 × 159 en (107, 261) | 258 × 91 | **2,03** |
| «Banco de Venezuela» | 437 × 36 | 24 sp | 33,84 |
| «Iniciar sesión como» | 255 × 25 | 16 sp | 21,65 |
| «A\*\*\*\*\*4» | 106 × 20 | 16 sp | 19,49 |
| «Pulsa para autenticarte» | 279 × 23 | 14 sp | 35,61 |
| Círculo con huella | 112 × 112 en (304, 728) | 56 × 56 dp | **3,26** |
| Huella digital | 52 × 58 | 26 × 29 dp | **3,41** |
| «Ingresa con tu contraseña» | 347 × 17 + subrayado 351 px | 16 sp | 15,78 |
| «Desvincular dispositivo» | icono 34 × 36 + texto 269 × 23 | 13 sp bold | 7,81 / 41,89 |
| Franjas diagonales | mismo vector que el inicio | — | 1-3 px |

**Diff global del login: 3,49 / 255 · 2,50 % de píxeles.**
(El inicio quedó en 2,49 / 1,98 %.)

### Navegación en la app

El botón «Iniciar sesión» abre `LoginActivity`
(`startActivity(Intent(this, LoginActivity::class.java))`), y
«Desvincular dispositivo» vuelve con `finish()`.

### Cómo verlo sin compilar

`replica\flujo.html` es un **visor navegable**: muestra la pantalla de inicio en
un marco de teléfono y, al hacer clic en el botón, cambia a la de autenticación
(y vuelve con «Desvincular dispositivo»). Se abre con:

```powershell
start "" "replica\flujo.html"
```

El visor `flujo.html` tiene **3 pasos** navegables: Inicio → Autenticación →
Diálogo de contraseña (clic en «Ingresa con tu contraseña»), y se vuelve con
«Cancelar», «Aceptar» o tocando el velo.

## 1c. Diálogo «Ingresa con tu contraseña»

Al pulsar el enlace se abre el diálogo modal del mockup
`design/referencia-clave.jpeg` (720 × 1456 px @2x, mismo lienzo de 360 × 723 dp).

**Hallazgo clave:** el fondo del diálogo es la propia pantalla de autenticación
**oscurecida con un velo negro al 53 %**. Verificado con tres colores
independientes del mockup:

| Zona | Color original | × 0,47 (velo 53 %) | Medido en el mockup |
|---|---|---|---|
| fondo | #303030 | **#161616** | #161616 |
| franja amarilla | #FDC800 | **#775E00** | #755C00 |
| franja roja | #BB1B47 | **#580D21** | #560D21 |

Por eso no es una pantalla nueva: es una **capa superpuesta** dentro de
`activity_login.xml` (velo + tarjeta), de modo que el fondo oscurecido es la
pantalla real y no una captura.

| Elemento | Medida (px del mockup) | dp | Comprobación |
|---|---|---|---|
| Tarjeta | 560 × 414 en (80, 524) · radio 20 | 280 × 207 · radio 10 | **exacta** |
| «Usuario: A\*\*\*\*\*4» | 199 × 20 · 28 px | 14 sp | 197 px (Δ 2) |
| Campo | 480 × 96 en (120, 674) · borde 4 px #9E9E9E | 240 × 48 · borde 2 | **exacta** |
| «Contraseña:» | 141 × 20 · 27 px · #757575 | 13,5 sp | **141 px exacta** |
| Ojo | 43 × 30 en (530, 707) | 21,5 × 15 | **exacto** |
| Botones | 176 × 80 en y 818 · radio 20 · #BB1B47 | 88 × 40 · radio 10 | **exactos** |
| Texto de botón | «Aceptar» 83 px · «Cancelar» 93 px | 12,5 sp · tracking −0,025 | 83 / 95 px |

**Diff global del diálogo: 2,23 / 255 · 1,33 % de píxeles** (el mejor de los tres).

Detalles que solo se ven midiendo:

- El radio de la tarjeta, del campo y de los botones es **20 px = 10 dp** en los
  tres casos (comprobado con `inset(d) = r − √(r² − (r−d)²)`).
- Los textos de los botones **no van en negrita**: en negrita salían 9-11 px más
  anchos. Con peso normal + tracking −0,025 em quedan clavados (83 vs 83).
- El ojo y el «Contraseña:» van **dentro** del campo, así que al posicionarlos hay
  que descontar los 2 dp del borde (se detectó porque aparecían +4 px
  abajo/derecha).
- El Arimo del proyecto es **variable** (eje `wght` 400-700). Los textos del
  diálogo en el mockup son un 30 % más finos que el peso 400, pero **no es la
  fuente**: es el rasterizador (el mockup viene de un dispositivo Android). En el
  APK se verá como en el mockup; en la réplica HTML (Chrome/Windows) se ve algo
  más grueso.



```
bdv-app/
├── design/
│  ├── referencia-inicio.jpeg      mockups originales
│  ├── referencia-login.jpeg
│  ├── referencia-clave.jpeg
│  └── ESPECIFICACIONES.md         todas las medidas, colores y geometría
├── replica/
│  ├── index.html                  réplica del inicio        (720×1453 px)
│  ├── login.html                  réplica de autenticación  (720×1460 px)
│  ├── clave.html                  réplica del diálogo       (720×1456 px)
│  ├── flujo.html                  visor navegable de las 3 pantallas
│  ├── vista-previa*.html          versiones autocontenidas (para el móvil)
│  ├── arimo.ttf                   fuente calibrada (para comparar, ya sin uso en la app)
│  ├── nunito.ttf                  tipografía de marca (la usan las ocho pantallas)
│  ├── logo-bdv.png                logotipo recortado a 2x (fondo limpiado)
│  ├── ico-movil.png ico-access.png ico-saldos.png   iconos de las tarjetas
│  ├── ico-huella.png ico-salir.png ico-ojo.png      huella, salir, ojo
├── tools/
│  ├── comparar.ps1                comparador automático (inicio | login | clave)
│  ├── validar-android.ps1         XML + referencias @recurso + usos en Kotlin
│  ├── medir-metricas.ps1           ascenso y capHeight de una fuente
│  ├── medir-monto.ps1              grosor de trazo de un texto
│  ├── probar-fuentes.ps1          identificador de tipografía (24 fuentes)
│  ├── generar-vista-previa.ps1    crea los HTML autocontenidos
│  ├── medir-login.ps1  mapa-login.ps1
│  └── prueba-fuentes.html  fuentes.png
├── android/                       proyecto Android (Kotlin + ConstraintLayout)
│  ├── settings.gradle.kts  build.gradle.kts  gradle.properties
│  └── app/
│     ├── build.gradle.kts  proguard-rules.pro
│     └── src/main/
│        ├── AndroidManifest.xml
│        ├── java/ve/com/bdv/inicio/
│        │  ├── InicioActivity.kt
│        │  └── LoginActivity.kt   (incluye el diálogo de contraseña)
│        └── res/
│           ├── layout/activity_inicio.xml  activity_login.xml
│           ├── values/{colors,dimens,dimens_login,dimens_clave,
│           │          strings,strings_login,themes}.xml
│           ├── drawable/fondo_franjas.xml      franjas diagonales (vector)
│           ├── drawable/logo_bdv_marca.xml     marca BDV en vector
│           ├── drawable/ic_campana.xml         campana (vector)
│           ├── drawable/bg_boton.xml           botón (radio 10 dp)
│           ├── drawable/bg_tarjeta.xml         tarjeta (radio 12 dp)
│           ├── drawable/bg_badge.xml           badge circular
│           ├── drawable/bg_circulo.xml         círculo de la huella
│           ├── drawable/bg_dialogo.xml         tarjeta del diálogo
│           ├── drawable/bg_campo.xml           campo de contraseña
│           ├── drawable-xhdpi/                 logo + iconos a 2x
│           ├── font/arimo_variable.ttf  font/arimo.xml
│           ├── font/arimo_variable.ttf  nunito_variable.ttf
│           ├── font/arimo.xml  arimo_medium.xml  nunito.xml
│           ├──         nunito_medium.xml  nunito_semibold.xml
│           └── mipmap-*/ic_launcher.png        icono de app (5 densidades)
└── .github/workflows/build-apk.yml   compila el APK en la nube```

## 3. Cómo obtener el APK (sin instalar nada)

El repositorio ya está en GitHub y **el APK se compila solo** con cada `push`:

- Repositorio: **https://github.com/alexisauthor12/prueba1**
- Compilación verificada (con los textos centrados y el monto en Arimo 500):
  **https://github.com/alexisauthor12/prueba1/actions/runs/38634485635**
  (run #4, commit `b72dcb1`, `success`, 14/10/2026, debug y release)

1. Abre **Actions → «Compilar APK» → el run más reciente** (tarda 3-4 minutos).
2. En la sección **Artifacts** descarga:
   - `bdv-inicio-debug-apk` → dentro está `app-debug.apk` (**el instalable**, 3,8 MB)
   - `bdv-inicio-release-sin-firmar-apk` → 3,1 MB, para firmar y distribuir
3. Descomprime el `.zip`, pasa el `.apk` al teléfono, ábrelo y activa
   «Instalar apps de origen desconocido».

**Repetir tras cualquier cambio:**

```powershell
cd "C:\Users\Alexis Ruiz\.cline\data\workspaces\chat\bdv-app"
git add . ; git commit -m "cambio" ; git push
```

En 3-4 minutos hay un APK nuevo en Actions. Si algo falla, el workflow publica el
error de Gradle como **anotación del run** (se ve en la pestaña Actions y también
se puede leer por la API sin descargar el log completo).

Qué hace la compilación: JDK 17 (temurin) + Gradle 8.7 + AGP 8.5.2 + Kotlin
1.9.24, `compileSdk 34` / `minSdk 26` (Android 8.0 o superior), y publica el APK
de depuración y el de release sin firmar.

> **Nota de la primera puesta en marcha.** Los dos primeros runs fallaron en
> `:app:mergeDebugResources` porque `color/velo` estaba definido en
> `values/colors.xml` **y otra vez** en `values/dimens_clave.xml` (AAPT2:
> «Duplicate resources»). Corregido en `1dde4b0`, y `tools/validar-android.ps1`
> «Duplicate resources»). Corregido en `1dde4b0`, y `tools/medir-metricas.ps1           ascenso y capHeight de una fuente
> «Duplicate resources»). Corregido en `1dde4b0`, y `tools/medir-monto.ps1              grosor de trazo de un texto
> ahora comprueba recursos duplicados entre los `values/*.xml` para que no
> vuelva a colarse.

### Compilar en local (opcional, si algún día quieres más velocidad)

Instala **Android Studio** (trae JDK + SDK + Gradle) y abre la carpeta `android/`.
O bien instala JDK 17 + Android SDK y ejecuta dentro de `android/`:

```powershell
gradle assembleDebug
```

El APK queda en `android\app\build\outputs\apk\debug\app-debug.apk`.

## 4. Cómo reproducir la validación pixel-perfect

```powershell
cd "C:\Users\Alexis Ruiz\.cline\data\workspaces\chat\bdv-app"

# 1) renderizar la réplica con Chrome headless (al tamaño exacto del mockup)
#    inicio -> 720x1453   login -> 720x1460   clave -> 720x1456
#    dashboard -> 720x1450   pagos -> 720x1446
& "C:\Program Files\Google\Chrome\Application\chrome.exe" --headless=new `
  --disable-gpu --hide-scrollbars --force-device-scale-factor=1 `
  --window-size=720,1456 --screenshot="replica\render.png" `
  "file:///C:/Users/Alexis%20Ruiz/.cline/data/workspaces/chat/bdv-app/replica/clave.html"

# 2) comparar contra el mockup (tabla de regiones + mapa de peores zonas)
powershell -ExecutionPolicy Bypass -File tools\comparar.ps1 -Pantalla clave

# 3) validar el proyecto Android sin necesidad de Android SDK
powershell -ExecutionPolicy Bypass -File tools\validar-android.ps1
powershell -ExecutionPolicy Bypass -File tools\medir-metricas.ps1           ascenso y capHeight de una fuente
powershell -ExecutionPolicy Bypass -File tools\medir-monto.ps1              grosor de trazo de un texto
```

`comparar.ps1` informa, por cada región: la caja medida en la referencia, la caja
medida en la réplica y la diferencia media de color. Con eso se corrige cualquier
desviación en un solo paso. Admite
`-Pantalla inicio | login | clave | dashboard | pagos | pagomovil | comprobante`.

`validar-android.ps1` comprueba de una pasada: **53 XML bien formados**,
`medir-metricas.ps1           ascenso y capHeight de una fuente
`medir-monto.ps1              grosor de trazo de un texto
**592 recursos** definidos, **137 ids** y **0 referencias sin resolver**
(incluidos los usos `R.id.*` / `R.layout.*` en Kotlin), **ningún recurso
duplicado** entre los `values/*.xml` y **ningún texto de ancho completo sin
`android:gravity="center"`** (el fallo que dejaba el subtítulo y el enlace
pegados al borde izquierdo en el teléfono).

`medir-monto.ps1` mide la zona del monto del comprobante (la caja gris con el
importe): caja de los trazos en la referencia y en la réplica, diferencia media
de color y **grosor de trazo** (anchura media de las rachas de tinta), que es lo
que hace que un texto se vea «marcado».

## 5. Tipografía: identificada empíricamente

Se probaron **24 fuentes** del sistema renderizando el subtítulo a 48 px,
alineándolo con el original y midiendo la diferencia real de los trazos
(`tools/probar-fuentes.ps1`). Resultado:

| Puesto | Fuente | Ancho medido | Diff |
|---|---|---|---|
| 🥇 | **Arial / Helvetica** | **436 px** (real 437) | **55,67** |
| 2 | Microsoft Sans Serif | 436 px | 62,08 |
| 3 | Sitka Text (con serifas) | 440 px | 63,15 |
| … | … | … | … |
| 16 | Segoe UI (la inicial) | 417 px | 77,58 |

**Arial gana** entre las fuentes *del sistema*: coincide en ancho (436 vs 437 =
0,2 % de error), en altura de mayúscula y en forma. Al aplicarlo, el diff global
bajó de 2,61 a **2,49** y el texto del botón mejoró un **52 %**.

> **La fuente de marca sí existe: es Nunito.** La búsqueda se hizo solo entre las
> fuentes instaladas en el equipo; la de la app del banco es **Nunito** (lo
> declara `bancodevenezuela.com`: `font-family: Nunito, sans-serif`), es de
> Google Fonts con licencia SIL OFL 1.1 y se puede incrustar en el APK. Con ella
> el comprobante baja de 4,78 a **3,51**. Los detalles, en
> `design/ESPECIFICACIONES.md`, sección 14.

### Compensaciones de ancho aplicadas

| Texto | Ancho mockup | Réplica | Compensación |
|---|---|---|---|
| Banco de Venezuela | 437 px | 436 px | sin tracking |
| Quiero abrir una cuenta en el BDV | 363 px | 363 px | `letter-spacing −1,03 px` |
| PagomóvilBDV | 137 px | 134 px | sin tracking |
| Pagos / AccessPay / Ver mis / saldos | 54/96/67/58 | 56/100/67/58 | sin tracking |

## 6. Lo único que falta para el 100 %

**El archivo de la fuente de marca.** Arial es la más cercana de las 24 probadas,
pero no es la del mockup: por eso el subtítulo y las etiquetas mantienen un diff
de 10-30 sobre 255 (solo forma de los trazos, no posición ni tamaño).

Si consigues el `.ttf`/`.otf` del banco:

1. Se copia a `android/app/src/main/res/font/` y a `replica/` como webfont.
2. Se añade `android:fontFamily="@font/tu_fuente"` a los 5 `TextView`.
3. Se vuelve a correr `tools/probar-fuentes.ps1` cambiando la lista de fuentes
   por la nueva → el script recalcula el mejor tracking automáticamente.
4. Se recompila → el diff bajaría a prácticamente 0.

**Solución ya aplicada:** Android no trae Arial, así que el proyecto **incluye
Arimo** (licencia Apache 2.0, métricamente compatible con Arial) en
`android/app/src/main/res/font/arimo_variable.ttf`, declarada en
`android/app/src/main/res/font/arimo_variable.ttf  nunito_variable.ttf
`android/app/src/main/res/font/arimo.xml  arimo_medium.xml  nunito.xml
`android/app/src/main/res/        nunito_medium.xml  nunito_semibold.xml
`res/font/arimo.xml` y aplicada **desde el tema**
(`<item name="android:fontFamily">@font/arimo</item>`), por lo que todos los
textos de la app usan la fuente calibrada sin tocar el layout.

La réplica HTML usa **el mismo archivo** (`replica/arimo.ttf` vía `@font-face`),
de modo que lo que se ve en la réplica es exactamente lo que se verá en el APK.
Validado: con Arimo el diff global es **2,51 / 2,00 %** frente a **2,49 / 1,98 %**
de Arial → idénticos, como corresponde a fuentes métricamente compatibles.

> Nota: para poder usar `@font` desde el tema se subió `minSdk` a **26**
> (Android 8.0 o superior, ~97 % de los dispositivos en 2026).

## 7. Notas importantes

- **Es una réplica de interfaz.** La pantalla no captura credenciales ni envía
  datos a ningún servidor: los botones solo muestran un aviso (`Toast`).
  No se ha implementado ni se implementará captura de usuario/contraseña.
- **Marca registrada.** "BDV" y "Banco de Venezuela" son marcas del Banco de
  Venezuela. Si vas a distribuir esta app (Play Store, APK público) necesitas
  autorización del banco; para uso interno, portafolio o práctica de diseño no hay
  problema. Para producción, usa los **assets de marca oficiales** en lugar de los
  recortes del mockup.
- **Barra de estado.** El mockup no incluye barra de estado (el contenido empieza
  en y=0). La app pinta la barra de estado del color del fondo (`#303030`), así que
  en el teléfono el contenido baja lo que mida esa barra. Si quieres que el logo
  quede exactamente igual que en el mockup, hay que decidir si se oculta la barra
  o se compensa el desplazamiento.
- **Adaptabilidad.** Las posiciones son exactas para una pantalla de **360 dp de
  ancho** (la del mockup). En pantallas más anchas/estrechas el contenido se ancla
  con márgenes fijos y las franjas al borde inferior: se ve bien, pero para ser
  idéntico al píxel el dispositivo debe ser de 360 dp de ancho.
- **Textos centrados.** En el mockup van centrados y en Android un `TextView` de
  ancho completo **no** se centra solo: hay que ponerle `android:gravity="center"`.
  Sin eso, el subtítulo y el enlace de Inicio (y los cinco textos de la pantalla
  de autenticación) salían pegados al borde izquierdo. `tools/validar-android.ps1`
  de autenticación) salían pegados al borde izquierdo. `tools/medir-metricas.ps1           ascenso y capHeight de una fuente
  de autenticación) salían pegados al borde izquierdo. `tools/medir-monto.ps1              grosor de trazo de un texto
  ya lo comprueba (apartado 2c) y `design/ESPECIFICACIONES.md` §13 lo explica.


---

## 8. Dashboard (tras ingresar la contraseña)

La contraseña de la demo es **12345** (`LoginActivity.CLAVE`). El campo la
enmascara (`inputType="textPassword"`) y el icono del ojo alterna entre puntos
y texto. Al pulsar «Aceptar»:

- si coincide → se abre `DashboardActivity`
- si no → aviso «Contraseña incorrecta» y el campo se limpia

Réplica del mockup `design/referencia-dashboard.jpeg` (720 × 1450 px @2x →
**360 × 725 dp**), medida con el mismo método.

| Bloque | Medida (px del mockup) | dp | Comprobación |
|---|---|---|---|
| Tarjeta de saldo | 632 × 169 en (44, 154) · radio 40 | 316 × 84.5 · radio 20 | **exacta** |
| 2.ª tarjeta del carrusel | asoma desde x 702 | 351 dp | **exacta** |
| Puntos | 16 px · paso 32 · y 369 | 8 dp · paso 16 | **exactos** |
| Hoja del histórico | desde y 412 · radio superior 32 | radio 16 | **exacta** |
| Filas | paso 118 · icono 24×40 en (31, 563) | paso 59 | **exactas** |
| Barra inferior | desde y 1346 · 6 columnas de 120 | 60 dp por columna | **exacta** |

| Texto | Ancho en el mockup | En la réplica |
|---|---|---|
| «Saldo Cuenta Ahorro» | 190 px | **190 px** |
| «Bs. 28.406,96» | 157 px | 154 px |
| «0102\*\*\*\*\*5124» | 133 px | 132 px |
| «Inicio» (título) | 81 px | 81 px |
| «Inicio» (etiqueta del nav) | 53 px | 53 px |
| Etiquetas del nav | 99 / 54 / 80 / 63 / 62 px | 98 / 54 / 78 / 62 / 59 px |

**Diff global: 5,19 / 255 · 3,77 % de píxeles.** Sale más alto que en las otras
pantallas porque aquí hay mucho más texto y el error de forma de letra se
acumula (la tipografía de marca sigue siendo la limitación conocida); la
geometría y los colores sí son exactos.

Detalles que solo se ven midiendo:

- La barra superior es `#303030` (el mismo fondo del inicio) y la hoja `#212121`.
- «Actualizar» **no** es rosa brillante sino `#C97E93`; «HOY» y las horas son
  `#9F9F9F`, no blancos.
- La tarjeta es un **carrusel**: a la derecha asoma la siguiente desde x 702
  (9 px). Sin ese detalle el diff no baja.
- La fila 7 («Pago de Servicios») va **8,5 dp más abajo** que el paso regular de
  59 dp y usa un chevron en vez del icono de móvil.
- El radio de la tarjeta (40 px = 20 dp) y el de la hoja (32 px = 16 dp) se
  dedujeron aplicando la fórmula del arco sobre la esquina real del mockup.
- Los 18 iconos (campana, access, NFC, menú, 4 de la tarjeta, gráfico, flecha,
  móvil, chevron y los 6 del nav) están recortados del mockup con el fondo
  emparejado, e incluidos en `res/drawable-xhdpi`.

### Verlo sin compilar

`replica/flujo.html` tiene ya **6 pasos**: Inicio → Autenticación → Diálogo
(contraseña 12345) → Dashboard → Panel de Pagos → PagomóvilBDV. Y
`replica/vista-previa-dashboard.html` es la versión autocontenida para pasar al móvil.

---

## 9. Panel de Pagos (al pulsar «Pagos» en la barra inferior)

No es una pantalla nueva: es una **hoja inferior** que se abre **sobre el propio
dashboard** oscurecido, tal como se ve en `design/referencia-pagos.jpeg`
(720 × 1446 px @2x). Réplica en `replica/pagos.html`.

| Bloque | Medida (px del mockup) | dp | Comprobación |
|---|---|---|---|
| Velo negro | 53 % sobre el dashboard | `#87000000` | **fondo `#161616` idéntico** |
| Panel | ancho completo desde y 803 · radio 40 | 322 dp anclado abajo · radio 20 | **exacto** |
| Cabecera roja | 720 × 84 | 360 × 42 | **diff 1,80** |
| «Pagos» | 81 × 27 · centrado | 14,5 sp bold | 80 × 26 px |
| Opciones | paso **112** | paso **56 dp** | **exacto** |

| Texto | Ancho en el mockup | En la réplica |
|---|---|---|
| «PagomóvilBDV» | 206 px | 202 px |
| «PagomóvilBDV QR» | 257 px | 258 px |
| «Tarjeta de crédito» | 236 px | 234 px |
| «Financiamiento especial» | 325 px | 324 px |
| «Pagos compartidos» | 260 px | 259 px |

**Diff del panel: 5,59 / 255 (2,2 %).** Los márgenes laterales y el pie dan
**0,00** (el `#303030` del panel es idéntico) y la cabecera 1,80; el resto es la
forma de las letras, la limitación conocida.

Detalles que solo se ven midiendo:

- El panel **tapa la barra inferior roja** por completo: en el mockup el cuerpo
  `#303030` llega hasta y 1446 y la barra (desde y 1346) no se ve.
- El alto del panel es exactamente su contenido: **42 + 5 × 56 = 322 dp**.
- El velo es **el mismo** del diálogo de contraseña (53 %), reutilizado tal cual.
- Al elegir una opción el panel se cierra y se muestra un aviso: ninguna opción
  hace operaciones reales (es una réplica de interfaz).

En la app: `DashboardActivity` lo abre desde `nav3` / `navTexto3`, y lo cierra con
el velo, una opción o el botón atrás. Vista autocontenida:
`replica/vista-previa-pagos.html`.

---

## 10. PagomóvilBDV (al pulsar «PagomóvilBDV» en el panel de Pagos)

Pantalla propia (`PagomovilActivity`) replicada de `design/referencia-pagomovil.jpeg`
(720 × 1451 px @2x → **360 × 725.5 dp**). Réplica en `replica/pagomovil.html`.

| Bloque | Medida (px del mockup) | dp | Comprobación |
|---|---|---|---|
| Campana + badge | 48 × 52 en (40, 22) | 24 × 26 | **diff 0,03** |
| Menú | 30 × 22 en (657, 42) | 15 × 11 | **diff 0,00** |
| Círculos Pegar/Leer datos | 72 × 72 en y 110 | 36 × 36 | **diff 0,95** |
| Campos | 640 × 96 · borde 4 · radio 20 | 320 × 48 · 2 · 10 | **diff 0,5 – 1,3** |
| Paso entre campos | **156** | **78** | **exacto** |
| Botón de Documento | 96 × 96 · radio 20 | 48 × 48 · 10 | **diff 1,01** |
| Pagar / Limpiar | 176 × 80 en y 1126 | 88 × 40 | **caja exacta** |
| Icono del pie | 66 × 81 en (325, 1258) | 33 × 40.5 | **diff 0,35** |
| Barra inferior | desde y 1338 · 113 px | 669 · 56.5 | iconos 2,98 |

**Diff global: 2,56 / 255 (2,03 %)** — la mejor de las siete pantallas.

Detalles que solo se ven midiendo:

- Los dos desplegables llevan la **etiqueta encima del borde** («Operación:»,
  «Banco:») y el borde se **interrumpe** justo debajo: medido, desaparece desde
  el borde izquierdo del campo hasta x 165 px (63 dp), solo en el grosor del
  borde (4 px). Se reproduce con una `View` de 63 × 2 dp con el relleno del campo.
- El relleno de los campos es `#454545` y el borde `#9E9E9E` de **2 dp**.
- El triángulo del desplegable es `#C9C9C9` (medido), no blanco.
- El campo de Documento mide **267 dp** y a su derecha va el botón rojo de 48 dp:
  267 + 5 + 48 = **320 dp**, el ancho del resto de los campos.
- La barra inferior es la misma del dashboard pero **4 px más arriba** (y 113 px
  de alto en vez de 104).

En la app: se abre desde la primera opción del panel de Pagos. Vista
autocontenida: `replica/vista-previa-pagomovil.html`.

---

## 11. Comprobante de operación (al pulsar «Pagar» en PagomóvilBDV)

Pantalla propia (`ComprobanteActivity`) replicada de
`design/referencia-comprobante.jpeg` (633 × 1280 px → **360 × 727.9 dp**;
el mockup viene a escala 1,758, no 2× como los anteriores).
Réplica en `replica/comprobante.html`.

Además, los campos **Documento, Teléfono, Monto y Concepto** de PagomóvilBDV
son editables: al pulsar «Pagar» se abre esta pantalla con los datos escritos
y el monto en formato venezolano (`2400` → **`2.400,00 Bs`**).

| Bloque | Medida (px del mockup) | dp | Comprobación |
|---|---|---|---|
| Flecha atrás | 32 × 32 en (33, 36) | 18,2 | **diff 0,18** |
| Título (**Nunito 800**) | mayúscula 40 → 68 · 356 px de ancho | 16sp | **diff 23,9** |
| Compartir | 38 × 40 en (572, 31) | 21,6 × 22,7 | **diff 0,05** |
| Logotipo | 85 × 90 en (272, 150) | 51,2 × 54,6 | **diff 0,30** |
| «PagomóvilBDV Personas» | mayúscula 258 → 282 | 14sp | **diff 9,6** |
| Círculo con el check | 45 × 44 en (294, 299) | 28,4 × 27,9 | **diff 0,13** |
| Caja del monto | 543 × 69 en (45, **365**) · radio 17 | 308,8 × 39,2 · 9,7 | **diff 1,74** |
| Monto «2.400,00 Bs» | mayúscula 389 → 410 · 132 px de ancho · `#F5F5F5` | 14,5sp | **diff 8,0** |
| 7 filas | paso **49,5** · etiqueta x 57 · valor x 575 (Operación, x 540) | 28,1 · 32,4 · 33 | 5,2 – 19,1 |
| Icono de copiar | 28 × 34 en (**555, 508**) · al lado del número | 15,9 × 19,3 | **diff 0,32** |
| Flecha del pie | 40 × 39 en (296, 1021) | 22,7 × 22,2 | **diff 0,07** |
| Separador | 6 px en y 1096 · `#272727` | 3,4 | diff 2,67 |
| Interruptores | 63 × 35 · bola 32 `#BDBDBD` | 35,8 × 19,9 · 18,2 | **diff 9,3** |

**Diff global: 3,36 / 255 · 2,71 % de píxeles con desviación > 32** (con Arimo era
4,78; el cambio a Nunito baja un 27 %).

Detalles que solo se ven midiendo:

- La **caja del monto empieza en y 365**, no en 339: el borde gris del círculo
  del check engaña al medir por color y hace creer que la caja es 26 px más
  alta. Corregido, su diff baja de 21,1 a **2,57**.
- El **check se dibuja encima** de la caja (en el mockup el círculo toca el
  borde superior de la caja), por eso en el layout la caja va declarada antes.
- Las **etiquetas van en negrita y los valores en redonda**, al mismo tamaño
  (12,5sp): medido, las dos bandas ocupan exactamente las mismas filas.
- El interruptor no es un `Switch` de Android: es un riel `#636363` de 35,8 ×
  19,9 dp con radio 10 y una bola `#BDBDBD` de 18,2 dp, para clavar el color
  medido. Al tocarlo la bola se desliza.
- El número de operación (12 dígitos, empieza por `00`) y la fecha son
  aleatorios/actuales; el icono de copiar lo lleva al portapapeles.
- El **icono de copiar va al lado del número, no encima**: el valor de
  «Operación:» es el único que no llega al borde, termina en **x 540** (no en
  los 575 de los demás), y el icono ocupa **555..582 × 508..541** (28 × 34 px).
  Estaba 7 px a la derecha y más ancho, y se montaba sobre el número:
  corregido, su diff baja de **12,05 a 0,32** (como los demás iconos) y el de
  la fila entera de 15,5 a 10,4.
- El **monto es un blanco suave** (`#F5F5F5`), no blanco puro: el mockup es un
  JPEG y el texto llega suavizado (el núcleo es blanco, pero el 88 % de sus
  píxeles claros son grises). Medido, `#F5F5F5` es el que menos se desvía
  (**diff 10,2**, frente a 14,0 con `#FFFFFF`).
- **La tipografía del mockup es Nunito**, la de marca del banco. Al principio se
  buscó entre las fuentes del sistema (24 probadas) y ninguna bajaba el monto de
  10,2; la pista estaba en la web oficial del banco, que declara
  `font-family: Nunito, sans-serif`. Nunito es de Google Fonts con licencia
  **SIL OFL 1.1** (se puede incrustar en el APK) y con ella el monto baja a
  **5,77**, el título a 22,3, el subtítulo a 11,9 y los dos interruptores a 9,4 y
  12,7: el diff global pasa de 4,78 a **3,51**. Cada texto lleva su peso y su
  interletra medidos (título Nunito 650 con +0,45 px; monto Nunito 500 con
  −0,273 px; etiquetas 700 con −1 px; valores 400 con −0,6 px). En Android son
  `@font/nunito`, `@font/nunito_medium` (eje `wght` 500) y
  `@font/nunito_semibold` (650), con `android:letterSpacing` en em. El detalle
  completo está en `design/ESPECIFICACIONES.md`, sección 14.
- **En el mockup el título no está centrado**: su tinta va de x 126 a x 490 en un
  lienzo de 633 px (márgenes 126 y 143), o sea **8,5 px a la izquierda del
  centro**; el subtítulo y el monto sí van centrados. Se reproduce a propósito
  (`left:-8.5px` en el HTML, `android:translationX="-4.8dp"` en Android): es lo
  que baja el diff del título de 32,8 a **22,3**.
- **Los márgenes verticales se recalculan al cambiar de fuente**: el hueco entre
  el borde de la caja y la altura de mayúscula mide **0,2153 em en Arimo** y
  **0,2960 em en Nunito** (medido con `tools/medir-metricas.ps1`), así que al
  pasar a Nunito todos los `margin_top` del comprobante bajan **0,081 em**. Sin
  esa corrección todos los textos quedan 1 px arriba.
- **Todos los textos llevan `transform:translateZ(0)`** (capa de composición):
  así Chrome usa antialiasing **en escala de grises**, como el teléfono que hizo
  el mockup, en vez de meterle flecos naranjas y azules (subpíxel). Solo con eso
  el diff global baja de 5,56 a **4,80** y cada texto entre un 10 % y un 20 %
  (monto 13,97 → 10,22, título 34,5 → 30,5, subtítulo 38,4 → 33,0, filas hasta
  23,2, interruptores 35,8 → 30,6). En Android no hace falta: Android ya pinta
  el texto en escala de grises.

---

## 12. Selección de banco (al pulsar el campo «Banco:» de PagomóvilBDV)

Pantalla propia (`BancosActivity`) replicada de
`design/referencia-bancos.jpeg` (720 × 1441 px @2x → **360 × 720.5 dp**).
Réplica en `replica/bancos.html`. El mockup viene **recortado** por abajo
(la barra inferior se ve a medias), así que la réplica reproduce ese recorte.

| Bloque | Medida (px del mockup) | dp | Comprobación |
|---|---|---|---|
| Fila | **96** de alto · paso exacto | **48** | geometría exacta |
| Texto de la fila | 27 px · cap 20 px · x 33 | **13.5sp** · 16.5 dp | 38,6 – 47,9 |
| Fila elegida | fondo `#494949` desde y 28 | — | diff 8,4 |
| Barra de desplazamiento | 8 × 738 en (712, 13) · `#CCCCCC` · pista 13 → 1354 | 4 dp · pista 670.5 dp | **diff 0,07** |
| Barra inferior | desde y 1354 · con degradado `#7A1233` → `#BB1B47` | 87 px visibles | diff 10,5 |
| Iconos de la barra | 34 – 46 px de ancho | — | **diff 0,2 – 0,5** |

**Diff global: 9,49 / 255 (3,7 %)** — el más alto de las ocho, porque esta
pantalla es casi toda texto blanco: la geometría cierra al píxel (filas, paso,
texto, barra de desplazamiento e iconos) y lo que queda es la forma de las
letras de la fuente de marca, como en el resto.

Detalles que solo se ven midiendo:

- Las filas empiezan en **y 28** (14 dp) y son de **96 px exactos**: el primer
  banco (el elegido) se resalta justo de 29 a 125, o sea su fila.
- El texto va **centrado verticalmente en la fila** y a **33 px** (16.5 dp) del
  borde; el de dos líneas (0175, 0601 y 0178) ocupa dos líneas dentro de la
  misma fila de 96 px, y el salto de línea sale solo con 330 dp de ancho.
- La **barra de desplazamiento** no es la del navegador: es una barra propia de
  8 px `#CCCCCC` en el borde derecho, encima de una pista transparente que va
  de y 13 a y 1354. **Funciona de verdad**: se agarra y se arrastra con el
  ratón o el dedo para bajar y subir, al tocar la pista la barra salta a esa
  altura y sigue al dedo, la rueda del ratón desplaza aunque el puntero esté
  encima de la barra, y con la lista enfocada (tabulador) responden las
  flechas, AvPág/RePág, Inicio y Fin. La pista es transparente, así que no
  cambia ni un píxel del mockup (el `SCROLL` sigue en **diff 0,07**).
- La barra mide **738 px (369 dp)** en el mockup porque solo se ve algo más de
  la mitad de la lista (13,8 de 25 filas); en la app el alto se calcula solo
  (`pista × lo que se ve / lo que hay`), así que sale igual sin números fijos.
- La barra inferior tiene un **degradado oscuro arriba** (`#7A1233` en y 1354 →
  `#BB1B47` en y 1400) que no tiene la de PagomóvilBDV; medido y reproducido.
- Los 25 bancos están en el orden del mockup, que es el alfabético real del
  sistema venezolano (0102 Banco de Venezuela primero).

### La lista tiene los 25 bancos: el mockup -2 es la misma lista desplazada

El segundo mockup (`design/referencia-bancos-2.jpeg`) **no es otra pantalla ni
añade bancos**: es esta misma lista **desplazada hasta abajo**, y sus 14 filas
visibles son las filas 12 a 25 (0191, 0138, 0137 BANCO SOFITASA y las 11 que van
justo debajo, hasta 0169 R4 BANCO MICROFINANCIERO C.A.). Lo que faltaba no era
añadir bancos, sino que **la barra funcionase** para poder bajar hasta ellos.

Para verlo sin tocar nada hay una captura de la réplica ya desplazada al final,
`replica/render-bancos-abajo.png`, que reproduce ese mockup -2 (con la barra
inferior, que el recorte del mockup no incluye). Y la prueba automática lo
comprueba fila por fila: «Bancos debajo de SOFITASA (fila 15): los 11 ESTAN».

En la app: `PagomovilActivity` → campo «Banco:» → `BancosActivity` → al tocar un
banco vuelve con el elegido en el campo. Vista autocontenida:
`replica/vista-previa-bancos.html`.

En Android la barra es un `View` propio (`@id/bkScroll`, 4 dp, dibujo
`bk_scroll_thumb.xml`) que `BancosActivity` coloca con `translationY` y con el
alto calculados; el `ScrollView` lleva `scrollbars="none"` y los **8 dp del
borde derecho** quedan para la barra: arrastrarlos baja y sube la lista, tocar
la pista salta de posición, y el resto de la fila sigue eligiendo el banco.

Para comprobar que las pantallas **responden de verdad** a los clics (no solo que
se vean bien) hay una prueba automática: `tools/probar-interaccion.ps1`. Carga las
réplicas en iframes, escribe en los campos, hace clic y captura los mensajes que
se envían entre pantallas:

```
3. Clic en una fila -> 0114 - BANCARIBE
4. Fila resaltada tras el clic: [0114 - BANCARIBE]
1. Banco pulsado -> estado guardado (banco viejo: 0102 - BANCO DE VENEZUELA)
2. Campo Banco tras volver: [0114 - BANCARIBE]  ->  APLICADO OK
5. Lista: 25 bancos | se ven 13.8 filas | recorrido 1074 px
6. Barra al empezar: top 13px | alto 741px
7. Arrastro la barra hacia abajo -> scrollTop 716 | barra en top 413px
8. Arrastro la barra hacia arriba -> scrollTop 179 | barra en top 113px
9. Rueda del raton sobre la barra -> scrollTop 300
10. Toco la pista abajo del todo -> scrollTop 1074 (tope 1074) | barra en top 613px
11. Flecha arriba con la lista enfocada -> scrollTop 978
12. Bancos debajo de SOFITASA (fila 15): los 11 ESTAN
13. Ultimo banco de la lista: [0169 - R4 BANCO MICROFINANCIERO C.A.] (total 25)
```



En la réplica HTML también se puede escribir: los cuatro campos son `<input>`
reales (el marcador gris se oculta al escribir y el texto blanco cae en el
mismo sitio, ±1 px), «Pagar» lleva los datos al comprobante — por URL al abrir
la pantalla suelta, o por `postMessage` dentro del visor de flujo — y el monto
sale con `montoVenezolano()`: `2400` → `2.400,00 Bs`.

El **visor de flujo cambia de lienzo por pantalla**: las seis primeras usan el
suyo de 720 px y el comprobante el de **633 px** (`mostrar(ids, alto, ancho)`),
para que el marco no deje franja a los lados. Las réplicas llevan
`<meta name="viewport">` con su ancho real, así que en el móvil se ven a escala
1:1 sin desplazarse.


