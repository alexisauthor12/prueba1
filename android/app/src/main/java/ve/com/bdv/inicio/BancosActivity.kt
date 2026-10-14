package ve.com.bdv.inicio

import android.annotation.SuppressLint
import android.content.Intent
import android.util.TypedValue
import android.os.Bundle
import android.view.Gravity
import android.view.MotionEvent
import android.view.View
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import androidx.core.content.res.ResourcesCompat

/**
 * Selector de banco: se abre al pulsar el campo "Banco:" de PagomovilBDV.
 *
 * Replica 1:1 del mockup design/referencia-bancos.jpeg
 * (720x1441 px @2x -> lienzo de diseno 360 x 720.5 dp).
 * Filas de 48 dp (96 px), texto de 13.5 sp (27 px) a 16.5 dp del borde y
 * centrado verticalmente; el banco elegido lleva el fondo #494949.
 * Medidas en values/dimens_bancos.xml.
 *
 * Al tocar un banco se devuelve a PagomovilBDV en el resultado del Intent.
 *
 * La barra de desplazamiento del borde derecho (8 px @2x = 4 dp de ancho) va
 * aparte de la lista, en un View propio, para que mida y se coloque igual que
 * en el mockup: se puede agarrar y arrastrar con el dedo para bajar y subir,
 * tocar la pista para saltar de posicion, y se mueve sola al desplazar la lista.
 */
class BancosActivity : AppCompatActivity() {

    /** Lista de bancos y barra de desplazamiento del borde derecho. */
    private lateinit var lista: ScrollView
    private lateinit var barra: View

    /** Arrastre de la barra en curso. */
    private var arrastrando = false
    private var toqueY = 0f
    private var scrollInicial = 0

    @SuppressLint("ClickableViewAccessibility")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_bancos)

        val bancos = resources.getStringArray(R.array.bk_bancos)
        val elegido = intent.getStringExtra(EXTRA_BANCO)
            ?: getString(R.string.bk_banco_por_defecto)

        val filas = findViewById<LinearLayout>(R.id.bkFilas)
        val alto = resources.getDimensionPixelSize(R.dimen.bk_fila_alto)
        val paddingIzq = resources.getDimensionPixelSize(R.dimen.bk_fila_padding_izq)
        val paddingDer = resources.getDimensionPixelSize(R.dimen.bk_fila_padding_der)
        val tamanoTexto = resources.getDimension(R.dimen.bk_fila_texto)
        val fuente = ResourcesCompat.getFont(this, R.font.arimo)
        val color = ContextCompat.getColor(this, R.color.blanco)

        for (banco in bancos) {
            val fila = TextView(this)
            fila.text = banco
            fila.layoutParams = LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, alto)
            fila.gravity = Gravity.CENTER_VERTICAL
            fila.setPadding(paddingIzq, 0, paddingDer, 0)
            fila.setTextColor(color)
            fila.setTextSize(TypedValue.COMPLEX_UNIT_PX, tamanoTexto)
            fila.includeFontPadding = false
            fila.typeface = fuente
            if (banco == elegido) {
                fila.setBackgroundResource(R.drawable.bg_fila_banco)
            }
            fila.setOnClickListener { devolver(banco) }
            filas.addView(fila)
        }

        // --- Barra de desplazamiento del borde derecho (se puede arrastrar) ---
        lista = findViewById(R.id.bkLista)
        barra = findViewById(R.id.bkScroll)
        lista.setOnScrollChangeListener { _, _, _, _, _ -> pintarBarra() }
        lista.setOnTouchListener { _, ev -> manejarBarra(ev) }
        // La primera colocacion se hace cuando el ScrollView ya tiene su tamano.
        lista.post { pintarBarra() }

        // Barra inferior: "Inicio" y "Pagos" vuelven a PagomovilBDV.
        findViewById<View>(R.id.nav1).setOnClickListener { finish() }
        findViewById<View>(R.id.navTexto1).setOnClickListener { finish() }
        findViewById<View>(R.id.nav3).setOnClickListener { finish() }
        findViewById<View>(R.id.navTexto3).setOnClickListener { finish() }

        // El resto de la barra solo avisa, igual que en el resto de la app.
        findViewById<View>(R.id.nav2).setOnClickListener { aviso("Transferencias") }
        findViewById<View>(R.id.navTexto2).setOnClickListener { aviso("Transferencias") }
        findViewById<View>(R.id.nav4).setOnClickListener { aviso("Servicios") }
        findViewById<View>(R.id.navTexto4).setOnClickListener { aviso("Servicios") }
        findViewById<View>(R.id.nav5).setOnClickListener { aviso("Divisas") }
        findViewById<View>(R.id.navTexto5).setOnClickListener { aviso("Divisas") }
        findViewById<View>(R.id.nav6).setOnClickListener { aviso("Tarjeta") }
        findViewById<View>(R.id.navTexto6).setOnClickListener { aviso("Tarjeta") }
    }

    // ------------------------------------------------------------------
    //  Barra de desplazamiento (la del borde derecho)
    // ------------------------------------------------------------------

    /**
     * Devuelve true si el toque es para la barra (o si se esta arrastrando).
     *
     * Funciona como la de un navegador: se agarra la barra y se arrastra para
     * bajar y subir; si se toca la pista (la franja del borde, fuera de la
     * barra) la barra salta a esa altura y sigue al dedo. Fuera de la franja
     * devuelve false, para que la lista se desplace con el dedo como siempre.
     */
    private fun manejarBarra(ev: MotionEvent): Boolean {
        val zona = resources.getDimensionPixelSize(R.dimen.bk_scroll_zona_toque)
        if (!arrastrando && ev.x < lista.width - zona) {
            return false
        }
        val pistaTop = resources.getDimensionPixelSize(R.dimen.bk_scroll_pista_top)
        val pistaAlto = resources.getDimensionPixelSize(R.dimen.bk_scroll_pista_alto)
        when (ev.actionMasked) {
            MotionEvent.ACTION_DOWN -> {
                arrastrando = true
                toqueY = ev.y
                scrollInicial = lista.scrollY
                val alto = altoBarra()
                val yBarra = barra.top + barra.translationY
                val yPantalla = ev.y + lista.top
                if (yPantalla < yBarra || yPantalla > yBarra + alto) {
                    // Se ha tocado la pista: la barra salta a ese punto
                    val recorrido = pistaAlto - alto
                    if (recorrido > 0) {
                        irA((yPantalla - pistaTop - alto / 2f) / recorrido)
                        scrollInicial = lista.scrollY
                    }
                }
            }
            MotionEvent.ACTION_MOVE -> {
                val recorrido = pistaAlto - altoBarra()
                val tope = topeScroll()
                if (recorrido > 0 && tope > 0) {
                    irA((scrollInicial + (ev.y - toqueY) * tope / recorrido) / tope)
                }
            }
            MotionEvent.ACTION_UP, MotionEvent.ACTION_CANCEL -> arrastrando = false
        }
        return true
    }

    /** Coloca la barra: alto segun lo que se ve de la lista y posicion segun el desplazamiento. */
    private fun pintarBarra() {
        val alto = altoBarra()
        val tope = topeScroll()
        val avance = if (tope > 0) lista.scrollY.toFloat() / tope else 0f
        val pistaTop = resources.getDimensionPixelSize(R.dimen.bk_scroll_pista_top)
        val pistaAlto = resources.getDimensionPixelSize(R.dimen.bk_scroll_pista_alto)
        val lp = barra.layoutParams
        if (lp.height != alto) {
            lp.height = alto
            barra.layoutParams = lp
        }
        barra.translationY = (pistaTop + Math.round(avance * (pistaAlto - alto))).toFloat()
    }

    /** Lleva la lista a una fraccion de su recorrido (0 = arriba, 1 = abajo). */
    private fun irA(fraccion: Float) {
        val f = fraccion.coerceIn(0f, 1f)
        lista.scrollTo(0, Math.round(f * topeScroll()))
        pintarBarra()
    }

    /** Alto de la barra: proporcional a lo que se ve de la lista. */
    private fun altoBarra(): Int {
        val pistaAlto = resources.getDimensionPixelSize(R.dimen.bk_scroll_pista_alto)
        val minimo = resources.getDimensionPixelSize(R.dimen.bk_scroll_min_alto)
        val contenido = lista.getChildAt(0)?.height ?: 0
        if (contenido <= 0 || lista.height <= 0) {
            return pistaAlto
        }
        return Math.max(minimo, Math.round(pistaAlto.toFloat() * lista.height / contenido))
    }

    /** Lo que se puede desplazar: el contenido menos lo que se ve. */
    private fun topeScroll(): Int {
        val contenido = lista.getChildAt(0)?.height ?: 0
        return Math.max(0, contenido - lista.height)
    }

    /** Devuelve el banco elegido a PagomovilBDV. */
    private fun devolver(banco: String) {
        setResult(RESULT_OK, Intent().putExtra(EXTRA_BANCO, banco))
        finish()
    }

    private fun aviso(texto: String) {
        Toast.makeText(this, texto, Toast.LENGTH_SHORT).show()
    }

    companion object {
        const val EXTRA_BANCO = "banco"
    }
}
