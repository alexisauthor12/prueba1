# BDV · Réplica 1:1 de la app (Inicio → Login → Contraseña → Dashboard → Pagos) → APK

Réplica **medida píxel a píxel** de los mockups de `design/`, traducida a una app
Android real y compilable a APK **sin instalar nada en tu PC** (se compila en la
nube con GitHub Actions).

| # | Pantalla | Mockup | Réplica HTML | Diff (sobre 255) |
|---|---|---|---|---|
| 1 | Inicio | `referencia-inicio.jpeg` | `replica/index.html` | 2,49 |
| 2 | Autenticación | `referencia-login.jpeg` | `replica/login.html` | 3,49 |
| 3 | Diálogo «Ingresa con tu contraseña» | `referencia-clave.jpeg` | `replica/clave.html` | 2,24 |
| 4 | Dashboard | `referencia-dashboard.jpeg` | `replica/dashboard.html` | 4,87 |
| 5 | Panel de Pagos | `referencia-pagos.jpeg` | `replica/pagos.html` | 5,59 (panel) |

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
â”œâ”€â”€ design/
â”‚  â”œâ”€â”€ referencia-inicio.jpeg      mockups originales
â”‚  â”œâ”€â”€ referencia-login.jpeg
â”‚  â”œâ”€â”€ referencia-clave.jpeg
â”‚  â””â”€â”€ ESPECIFICACIONES.md         todas las medidas, colores y geometrÃ­a
â”œâ”€â”€ replica/
â”‚  â”œâ”€â”€ index.html                  rÃ©plica del inicio        (720Ã—1453 px)
â”‚  â”œâ”€â”€ login.html                  rÃ©plica de autenticaciÃ³n  (720Ã—1460 px)
â”‚  â”œâ”€â”€ clave.html                  rÃ©plica del diÃ¡logo       (720Ã—1456 px)
â”‚  â”œâ”€â”€ flujo.html                  visor navegable de las 3 pantallas
â”‚  â”œâ”€â”€ vista-previa*.html          versiones autocontenidas (para el mÃ³vil)
â”‚  â”œâ”€â”€ arimo.ttf                   fuente calibrada (la misma que usa el APK)
â”‚  â”œâ”€â”€ logo-bdv.png                logotipo recortado a 2x (fondo limpiado)
â”‚  â”œâ”€â”€ ico-movil.png ico-access.png ico-saldos.png   iconos de las tarjetas
â”‚  â”œâ”€â”€ ico-huella.png ico-salir.png ico-ojo.png      huella, salir, ojo
â”œâ”€â”€ tools/
â”‚  â”œâ”€â”€ comparar.ps1                comparador automÃ¡tico (inicio | login | clave)
â”‚  â”œâ”€â”€ validar-android.ps1         XML + referencias @recurso + usos en Kotlin
â”‚  â”œâ”€â”€ probar-fuentes.ps1          identificador de tipografÃ­a (24 fuentes)
â”‚  â”œâ”€â”€ generar-vista-previa.ps1    crea los HTML autocontenidos
â”‚  â”œâ”€â”€ medir-login.ps1  mapa-login.ps1
â”‚  â””â”€â”€ prueba-fuentes.html  fuentes.png
â”œâ”€â”€ android/                       proyecto Android (Kotlin + ConstraintLayout)
â”‚  â”œâ”€â”€ settings.gradle.kts  build.gradle.kts  gradle.properties
â”‚  â””â”€â”€ app/
â”‚     â”œâ”€â”€ build.gradle.kts  proguard-rules.pro
â”‚     â””â”€â”€ src/main/
â”‚        â”œâ”€â”€ AndroidManifest.xml
â”‚        â”œâ”€â”€ java/ve/com/bdv/inicio/
â”‚        â”‚  â”œâ”€â”€ InicioActivity.kt
â”‚        â”‚  â””â”€â”€ LoginActivity.kt   (incluye el diÃ¡logo de contraseÃ±a)
â”‚        â””â”€â”€ res/
â”‚           â”œâ”€â”€ layout/activity_inicio.xml  activity_login.xml
â”‚           â”œâ”€â”€ values/{colors,dimens,dimens_login,dimens_clave,
â”‚           â”‚          strings,strings_login,themes}.xml
â”‚           â”œâ”€â”€ drawable/fondo_franjas.xml      franjas diagonales (vector)
â”‚           â”œâ”€â”€ drawable/logo_bdv_marca.xml     marca BDV en vector
â”‚           â”œâ”€â”€ drawable/ic_campana.xml         campana (vector)
â”‚           â”œâ”€â”€ drawable/bg_boton.xml           botÃ³n (radio 10 dp)
â”‚           â”œâ”€â”€ drawable/bg_tarjeta.xml         tarjeta (radio 12 dp)
â”‚           â”œâ”€â”€ drawable/bg_badge.xml           badge circular
â”‚           â”œâ”€â”€ drawable/bg_circulo.xml         cÃ­rculo de la huella
â”‚           â”œâ”€â”€ drawable/bg_dialogo.xml         tarjeta del diÃ¡logo
â”‚           â”œâ”€â”€ drawable/bg_campo.xml           campo de contraseÃ±a
â”‚           â”œâ”€â”€ drawable-xhdpi/                 logo + iconos a 2x
â”‚           â”œâ”€â”€ font/arimo_variable.ttf  font/arimo.xml
â”‚           â””â”€â”€ mipmap-*/ic_launcher.png        icono de app (5 densidades)
â””â”€â”€ .github/workflows/build-apk.yml   compila el APK en la nube```

## 3. Cómo obtener el APK (sin instalar nada)

1. Crea un repositorio **vacío** en GitHub (por ejemplo `bdv-inicio`).
2. En esta carpeta ejecuta (Git ya está configurado en tu equipo):

   ```powershell
   cd "C:\Users\Alexis Ruiz\.cline\data\workspaces\chat\bdv-app"
   git init
   git add .
   git commit -m "Pantalla de inicio BDV: replica 1:1 + proyecto Android"
   git branch -M main
   git remote add origin https://github.com/TU-USUARIO/bdv-inicio.git
   git push -u origin main
   ```

   En el primer `push` se abrirá el navegador para que te identifiques
   (Credential Manager de Windows; no hay que escribir tokens a mano).

3. Abre en GitHub: **Actions → Compilar APK → el run más reciente**.
   Tarda unos 3-5 minutos.
4. En la sección **Artifacts** descarga:
   - `bdv-inicio-debug-apk` → `app-debug.apk` (instalable directamente)
   - `bdv-inicio-release-sin-firmar-apk` → para firmar y distribuir
5. Pasa el `.apk` al teléfono, ábrelo y activa "Instalar apps de origen desconocido".

**Repetir tras cualquier cambio:** `git add . ; git commit -m "cambio" ; git push`
y en 3-5 minutos tendrás un APK nuevo en Actions.

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
```

`comparar.ps1` informa, por cada región: la caja medida en la referencia, la caja
medida en la réplica y la diferencia media de color. Con eso se corrige cualquier
desviación en un solo paso. Admite
`-Pantalla inicio | login | clave | dashboard | pagos`.

`validar-android.ps1` comprueba de una pasada: **35 XML bien formados**,
**369 recursos** definidos, **77 ids** y **0 referencias sin resolver**
(incluidos los usos `R.id.*` / `R.layout.*` en Kotlin).

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

**Arial gana**: coincide en ancho (436 vs 437 = 0,2 % de error), en altura de
mayúscula y en forma. Al aplicarlo, el diff global bajó de 2,61 a **2,49** y el
texto del botón mejoró un **52 %**.

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

`replica/flujo.html` tiene ya **5 pasos**: Inicio → Autenticación → Diálogo
(contraseña 12345) → Dashboard → Panel de Pagos. Y
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


