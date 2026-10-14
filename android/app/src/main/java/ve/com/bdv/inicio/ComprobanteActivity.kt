package ve.com.bdv.inicio

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * Comprobante de operación: se abre al pulsar "Pagar" en PagomovilBDV, con los
 * datos que se escribieron en el formulario.
 *
 * Replica 1:1 del mockup design/referencia-comprobante.jpeg
 * (633x1280 px -> lienzo de diseno 360 x 727.9 dp).
 * Medidas en values/dimens_comprobante.xml.
 *
 * Nota: es una replica de interfaz. El comprobante no realiza ninguna
 * operacion real; el boton de compartir abre el selector del sistema.
 */
class ComprobanteActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_comprobante)

        // Datos del formulario (con los del mockup como valores por defecto).
        val documento = intent.getStringExtra(EXTRA_DOCUMENTO).orEmpty().ifEmpty { "24349893" }
        val telefono = intent.getStringExtra(EXTRA_TELEFONO).orEmpty().ifEmpty { "04147459612" }
        val concepto = intent.getStringExtra(EXTRA_CONCEPTO).orEmpty().ifEmpty { "pago" }
        val banco = intent.getStringExtra(EXTRA_BANCO).orEmpty().ifEmpty { "0105 - BANCO MERCANTIL" }
        val monto = intent.getStringExtra(EXTRA_MONTO).orEmpty().ifEmpty { "2.400,00 Bs" }

        // Número de operación: 12 dígitos que empiezan por 00 (como el mockup).
        val operacion = "00" + (1000000000L..9999999999L).random()
        val fecha = SimpleDateFormat("dd/MM/yyyy", Locale("es", "VE")).format(Date())

        findViewById<TextView>(R.id.cpVal1).text = fecha
        findViewById<TextView>(R.id.cpVal2).text = operacion
        findViewById<TextView>(R.id.cpVal3).text = documento
        findViewById<TextView>(R.id.cpVal4).setText(R.string.cp_origen)
        findViewById<TextView>(R.id.cpVal5).text = telefono
        findViewById<TextView>(R.id.cpVal6).text = banco
        findViewById<TextView>(R.id.cpVal7).text = concepto
        findViewById<TextView>(R.id.cpMonto).text = monto

        // Copiar el número de operación.
        findViewById<View>(R.id.cpCopiar).setOnClickListener {
            val portapapeles = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
            portapapeles.setPrimaryClip(ClipData.newPlainText("Operación", operacion))
            aviso(getString(R.string.cp_copiado))
        }

        // Compartir el comprobante (selector del sistema).
        findViewById<View>(R.id.cpCompartir).setOnClickListener {
            val texto = getString(R.string.cp_subtitulo) + "\n" +
                getString(R.string.cp_etiqueta_fecha) + " " + fecha + "\n" +
                getString(R.string.cp_etiqueta_operacion) + " " + operacion + "\n" +
                getString(R.string.cp_etiqueta_identificacion) + " " + documento + "\n" +
                getString(R.string.cp_etiqueta_destino) + " " + telefono + "\n" +
                getString(R.string.cp_etiqueta_banco) + " " + banco + "\n" +
                getString(R.string.cp_etiqueta_concepto) + " " + concepto + "\n" +
                monto
            val enviar = Intent(Intent.ACTION_SEND).apply {
                type = "text/plain"
                putExtra(Intent.EXTRA_TEXT, texto)
            }
            startActivity(Intent.createChooser(enviar, null))
        }

        // Cerrar el comprobante: la flecha de arriba y la del pie.
        findViewById<View>(R.id.cpFlecha).setOnClickListener { finish() }
        findViewById<View>(R.id.cpFlechaPie).setOnClickListener { finish() }

        // Los dos interruptores: mueven la bola (decorativos en la demo).
        moverInterruptor(R.id.cpKnob1, R.id.cpInt1)
        moverInterruptor(R.id.cpKnob2, R.id.cpInt2)
    }

    /** Al tocar el interruptor o su texto, la bola se mueve de lado a lado. */
    private fun moverInterruptor(knobId: Int, textoId: Int) {
        val bola = findViewById<View>(knobId)
        val etiqueta = findViewById<View>(textoId)
        val recorrido = resources.getDimension(R.dimen.cp_track_ancho) -
            resources.getDimension(R.dimen.cp_knob)
        var encendido = false
        val alternar = View.OnClickListener {
            encendido = !encendido
            bola.animate().translationX(if (encendido) recorrido else 0f).setDuration(120).start()
        }
        bola.setOnClickListener(alternar)
        etiqueta.setOnClickListener(alternar)
    }

    private fun aviso(texto: String) {
        Toast.makeText(this, texto, Toast.LENGTH_SHORT).show()
    }

    companion object {
        const val EXTRA_DOCUMENTO = "documento"
        const val EXTRA_TELEFONO = "telefono"
        const val EXTRA_MONTO = "monto"
        const val EXTRA_CONCEPTO = "concepto"
        const val EXTRA_BANCO = "banco"
    }
}
