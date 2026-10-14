package ve.com.bdv.inicio

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.EditText
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import java.text.DecimalFormat
import java.text.DecimalFormatSymbols

/**
 * PagomovilBDV: se abre al pulsar la opcion "PagomovilBDV" del panel de Pagos.
 *
 * Replica 1:1 del mockup design/referencia-pagomovil.jpeg
 * (720x1451 px @2x -> lienzo de diseno 360 x 725.5 dp).
 * Medidas en values/dimens_pagomovil.xml.
 *
 * Los campos Documento, Teléfono, Monto y Concepto son editables. Al pulsar
 * "Pagar" se abre el Comprobante de operación con esos datos y el monto en
 * formato venezolano (ej.: 2400 -> "2.400,00 Bs").
 *
 * Nota: es una replica de interfaz; no se realiza ninguna operacion real.
 */
class PagomovilActivity : AppCompatActivity() {

    private lateinit var documento: EditText
    private lateinit var telefono: EditText
    private lateinit var monto: EditText
    private lateinit var concepto: EditText

    /** Banco elegido en el desplegable; lo devuelve BancosActivity. */
    private var banco: String = "0102 - BANCO DE VENEZUELA"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_pagomovil)

        documento = findViewById(R.id.pmTexto2)
        telefono = findViewById(R.id.pmTexto4)
        monto = findViewById(R.id.pmTexto5)
        concepto = findViewById(R.id.pmTexto6)

        // Barra superior.
        findViewById<View>(R.id.pmCampana).setOnClickListener { aviso("Notificaciones (3)") }
        findViewById<View>(R.id.pmMenu).setOnClickListener { aviso("Menú") }

        // Pegar datos / Leer datos (el icono y el texto hacen lo mismo).
        findViewById<View>(R.id.pmCirculoPegar).setOnClickListener { aviso("Pegar datos") }
        findViewById<View>(R.id.pmPegar).setOnClickListener { aviso("Pegar datos") }
        findViewById<View>(R.id.pmCirculoLeer).setOnClickListener { aviso("Leer datos") }
        findViewById<View>(R.id.pmLeer).setOnClickListener { aviso("Leer datos") }

        // Buscar por documento y los dos desplegables.
        findViewById<View>(R.id.pmBotonDoc).setOnClickListener { aviso("Buscar por documento") }
        findViewById<View>(R.id.pmCampo1).setOnClickListener { aviso("Operación: Personas") }
        // El campo Banco abre el selector con los 25 bancos.
        findViewById<View>(R.id.pmCampo3).setOnClickListener {
            startActivityForResult(
                Intent(this, BancosActivity::class.java)
                    .putExtra(BancosActivity.EXTRA_BANCO, banco),
                CODIGO_BANCO
            )
        }

        // Pagar: lleva los datos al comprobante. Limpiar: vacia los campos.
        findViewById<View>(R.id.pmPagar).setOnClickListener { pagar() }
        findViewById<View>(R.id.pmLimpiar).setOnClickListener { limpiar() }

        // Barra inferior: "Inicio" vuelve al dashboard, el resto avisa.
        findViewById<View>(R.id.nav1).setOnClickListener { finish() }
        findViewById<View>(R.id.navTexto1).setOnClickListener { finish() }
        findViewById<View>(R.id.nav2).setOnClickListener { aviso("Transferencias") }
        findViewById<View>(R.id.navTexto2).setOnClickListener { aviso("Transferencias") }
        findViewById<View>(R.id.nav3).setOnClickListener { aviso("Pagos") }
        findViewById<View>(R.id.navTexto3).setOnClickListener { aviso("Pagos") }
        findViewById<View>(R.id.nav4).setOnClickListener { aviso("Servicios") }
        findViewById<View>(R.id.navTexto4).setOnClickListener { aviso("Servicios") }
        findViewById<View>(R.id.nav5).setOnClickListener { aviso("Divisas") }
        findViewById<View>(R.id.navTexto5).setOnClickListener { aviso("Divisas") }
        findViewById<View>(R.id.nav6).setOnClickListener { aviso("Tarjeta") }
        findViewById<View>(R.id.navTexto6).setOnClickListener { aviso("Tarjeta") }
    }

    /** Recoge el banco elegido en el selector y lo escribe en el campo. */
    @Deprecated("Deprecated in Java")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == CODIGO_BANCO && resultCode == RESULT_OK) {
            data?.getStringExtra(BancosActivity.EXTRA_BANCO)?.let {
                banco = it
                findViewById<TextView>(R.id.pmTexto3).text = it
            }
        }
    }

    /** Abre el comprobante con los datos escritos (Documento, Teléfono, Monto y Concepto). */
    private fun pagar() {
        val doc = documento.text.toString().trim()
        val tel = telefono.text.toString().trim()
        val mon = monto.text.toString().trim()
        if (doc.isEmpty() || tel.isEmpty() || mon.isEmpty()) {
            aviso("Complete Documento, Teléfono y Monto")
            return
        }
        startActivity(
            Intent(this, ComprobanteActivity::class.java)
                .putExtra(ComprobanteActivity.EXTRA_DOCUMENTO, doc)
                .putExtra(ComprobanteActivity.EXTRA_TELEFONO, tel)
                .putExtra(ComprobanteActivity.EXTRA_MONTO, formatearMonto(mon))
                .putExtra(ComprobanteActivity.EXTRA_CONCEPTO, concepto.text.toString().trim())
                .putExtra(ComprobanteActivity.EXTRA_BANCO, banco)
        )
    }

    /** Vacia los cuatro campos y deja el cursor en el primero. */
    private fun limpiar() {
        documento.setText("")
        telefono.setText("")
        monto.setText("")
        concepto.setText("")
        documento.requestFocus()
        aviso("Campos limpiados")
    }

    /**
     * Monto en formato venezolano: los miles con punto y los decimales con coma.
     * 2400 -> "2.400,00 Bs"   |   2400,5 -> "2.400,50 Bs"   |   2.400,00 -> "2.400,00 Bs"
     */
    private fun formatearMonto(entrada: String): String {
        val limpio = entrada.replace(".", "").replace(',', '.')
        val valor = limpio.toDoubleOrNull() ?: 0.0
        val simbolos = DecimalFormatSymbols().apply {
            groupingSeparator = '.'
            decimalSeparator = ','
        }
        return DecimalFormat("#,##0.00", simbolos).format(valor) + " Bs"
    }

    private fun aviso(texto: String) {
        Toast.makeText(this, texto, Toast.LENGTH_SHORT).show()
    }

    private companion object {
        /** Codigo con el que se le pide el banco al selector. */
        const val CODIGO_BANCO = 1
    }
}
