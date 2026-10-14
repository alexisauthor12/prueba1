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
| Diferencia media | **2,61 / 255** (1,02 %) |
| Píxeles con desviación > 32 | **1,97 %** |
| Desviación de posición de todos los bloques | **±1 px** |

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

## 2. Estructura del proyecto

```
bdv-app/
├─ design/
│  ├─ referencia-inicio.jpeg      mockup original
│  └─ ESPECIFICACIONES.md         todas las medidas, colores y geometría
├─ replica/
│  ├─ index.html                  réplica HTML 1:1 (720×1453 px)
│  ├─ logo-bdv.png                logotipo recortado a 2x (fondo limpiado)
│  ├─ ico-movil.png               icono tarjeta 1
│  ├─ ico-access.png              icono tarjeta 2
│  └─ ico-saldos.png              icono tarjeta 3
├─ tools/
│  └─ comparar.ps1                comparador automático contra el mockup
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

## 5. Ajustes finos ya aplicados

Los textos se compensaron con `letter-spacing` / `android:letterSpacing` para que
el **ancho total** coincida con el mockup a pesar de no tener la fuente original:

| Texto | Ancho mockup | Compensación |
|---|---|---|
| Banco de Venezuela | 437 px | `letterSpacing 0.0246 em` |
| Quiero abrir una cuenta en el BDV | 363 px | `letterSpacing −0.0323 em` |
| PagomóvilBDV / Pagos / AccessPay / saldos | ±0 px | `letterSpacing 0.0325 em` |

## 6. Lo único que falta para el 100 %

**La tipografía.** El mockup usa una fuente de marca (no es Roboto, Arial ni
Segoe UI). Si me pasas el archivo `.ttf`/`.otf`:

1. Se copia a `android/app/src/main/res/font/`.
2. Se añade `android:fontFamily="@font/tu_fuente"` a los 5 `TextView`.
3. Se recalcula el `letterSpacing` (probablemente a 0) y los márgenes superiores.
4. Se recompila → el diff bajaría del 1,97 % a prácticamente 0.

Mientras tanto, los anchos, posiciones y tamaños ya están calibrados, así que
la diferencia es solo la forma de los trazos de las letras.

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

