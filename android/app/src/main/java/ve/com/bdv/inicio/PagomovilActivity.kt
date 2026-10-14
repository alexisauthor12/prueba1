package ve.com.bdv.inicio

import android.os.Bundle
import android.view.View
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity

/**
 * PagomovilBDV: se abre al pulsar la opcion "PagomovilBDV" del panel de Pagos.
 *
 * Replica 1:1 del mockup design/referencia-pagomovil.jpeg
 * (720x1451 px @2x -> lienzo de diseno 360 x 725.5 dp).
 * Medidas en values/dimens_pagomovil.xml.
 *
 * Nota: es una replica de interfaz. Ningun boton realiza operaciones reales:
 * solo muestran un aviso, igual que en el resto de la app.
 */
class PagomovilActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_pagomovil)

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
        findViewById<View>(R.id.pmCampo3).setOnClickListener {
            aviso("Banco: 0102 - Banco de Venezuela")
        }

        // Pagar / Limpiar.
        findViewById<View>(R.id.pmPagar).setOnClickListener { aviso("Pagar (demo)") }
        findViewById<View>(R.id.pmLimpiar).setOnClickListener { aviso("Campos limpiados") }

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

    private fun aviso(texto: String) {
        Toast.makeText(this, texto, Toast.LENGTH_SHORT).show()
    }
}
