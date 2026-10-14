package ve.com.bdv.inicio

import android.content.Intent
import android.util.TypedValue
import android.os.Bundle
import android.view.Gravity
import android.view.View
import android.widget.LinearLayout
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
 */
class BancosActivity : AppCompatActivity() {

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
