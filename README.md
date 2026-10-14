# BDV · Pantalla de inicio (réplica 1:1 → APK)

Réplica **medida píxel a píxel** de la pantalla de inicio del mockup
`design/referencia-inicio.jpeg`, traducida a una app Android real y compilable
a APK **sin instalar nada en tu PC** (se compila en la nube con GitHub Actions).

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



```
bdv-app/
├─ design/
│  ├─ referencia-inicio.jpeg      mockup original
│  └─ ESPECIFICACIONES.md         todas las medidas, colores y geometría
├─ replica/
│  ├─ index.html                  réplica HTML 1:1 (720×1453 px)
│  ├─ arimo.ttf                   fuente calibrada (la misma que usa el APK)
│  ├─ logo-bdv.png                logotipo recortado a 2x (fondo limpiado)
│  ├─ ico-movil.png               icono tarjeta 1
│  ├─ ico-access.png              icono tarjeta 2
│  └─ ico-saldos.png              icono tarjeta 3
├─ tools/
│  ├─ comparar.ps1                comparador automático contra el mockup
│  ├─ probar-fuentes.ps1          identificador de tipografía (24 fuentes)
│  ├─ prueba-fuentes.html         página de la prueba de fuentes
│  └─ fuentes.png                 captura de la prueba de fuentes
├─ android/                       proyecto Android (Kotlin + ConstraintLayout)
│  ├─ settings.gradle.kts
│  ├─ build.gradle.kts
│  ├─ gradle.properties
│  └─ app/
│     ├─ build.gradle.kts
│     ├─ proguard-rules.pro
│     └─ src/main/
│        ├─ AndroidManifest.xml
│        ├─ java/ve/com/bdv/inicio/InicioActivity.kt
│        └─ res/
│           ├─ layout/activity_inicio.xml
│           ├─ values/{colors,dimens,strings,themes}.xml
│           ├─ drawable/fondo_franjas.xml      franjas diagonales (vector)
│           ├─ drawable/logo_bdv_marca.xml     marca BDV en vector
│           ├─ drawable/ic_campana.xml         campana (vector)
│           ├─ drawable/bg_boton.xml           botón (radio 10 dp)
│           ├─ drawable/bg_tarjeta.xml         tarjeta (radio 12 dp)
│           ├─ drawable/bg_badge.xml           badge circular
│           ├─ drawable-xhdpi/                 logo + 3 iconos a 2x
│           └─ mipmap-*/ic_launcher.png        icono de app (5 densidades)
└─ .github/workflows/build-apk.yml   compila el APK en la nube
```

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

# 1) renderizar la réplica a 720x1453 con Chrome headless
& "C:\Program Files\Google\Chrome\Application\chrome.exe" --headless=new `
  --disable-gpu --hide-scrollbars --force-device-scale-factor=1 `
  --window-size=720,1453 --screenshot="replica\render.png" `
  "file:///C:/Users/Alexis%20Ruiz/.cline/data/workspaces/chat/bdv-app/replica/index.html"

# 2) comparar contra el mockup (tabla de regiones + mapa de peores zonas)
powershell -ExecutionPolicy Bypass -File tools\comparar.ps1
```

`comparar.ps1` informa, por cada región: la caja medida en la referencia, la caja
medida en la réplica y la diferencia media de color. Con eso se corrige cualquier
desviación en un solo paso.

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

