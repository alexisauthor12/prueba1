package ve.com.bdv.inicio

import android.os.Bundle
import android.view.View
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity

/**
 * Dashboard del BDV: se abre cuando en el dialogo de la pantalla de
 * autenticacion se ingresa la contrasena correcta.
 *
 * Replica 1:1 del mockup design/referencia-dashboard.jpeg
 * (720x1450 px @2x -> lienzo de diseno 360 x 725 dp).
 * Medidas en values/dimens_dashboard.xml.
 *
 * Nota: es una replica de interfaz. Los datos del historico son de ejemplo y
 * ningun boton realiza operaciones reales: solo muestran un aviso.
 */
class DashboardActivity : AppCompatActivity() {

    /** Historico de operaciones: descripcion, monto y hora. */
    private val movimientos = listOf(
        Triple(R.string.db_f1_desc, R.string.db_f1_monto, R.string.db_f1_hora),
        Triple(R.string.db_f2_desc, R.string.db_f2_monto, R.string.db_f2_hora),
        Triple(R.string.db_f3_desc, R.string.db_f3_monto, R.string.db_f3_hora),
        Triple(R.string.db_f4_desc, R.string.db_f4_monto, R.string.db_f4_hora),
        Triple(R.string.db_f5_desc, R.string.db_f5_monto, R.string.db_f5_hora),
        Triple(R.string.db_f6_desc, R.string.db_f6_monto, R.string.db_f6_hora)
    )

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_dashboard)

        // Rellenar las seis primeras filas del historico.
        val filas = findViewById<LinearLayout>(R.id.filas)
        for (i in 0 until minOf(filas.childCount, movimientos.size)) {
            val fila: View = filas.getChildAt(i)
            fila.findViewById<TextView>(R.id.filaDesc).setText(movimientos[i].first)
            fila.findViewById<TextView>(R.id.filaMonto).setText(movimientos[i].second)
            fila.findViewById<TextView>(R.id.filaHora).setText(movimientos[i].third)
        }

        // Acciones de la tarjeta de saldo.
        findViewById<View>(R.id.dbIco1).setOnClickListener { aviso("Saldo actualizado") }
        findViewById<View>(R.id.dbIco2).setOnClickListener { aviso("Saldo oculto") }
        findViewById<View>(R.id.dbIco3).setOnClickListener { aviso("Pago con código QR") }
        findViewById<View>(R.id.dbIco4).setOnClickListener { aviso("Compartir cuenta") }
        findViewById<View>(R.id.dbMovimientos).setOnClickListener { aviso("Movimientos en línea") }
        findViewById<View>(R.id.dbChart).setOnClickListener { aviso("Movimientos en línea") }
        findViewById<View>(R.id.dbFlecha).setOnClickListener { aviso("Movimientos en línea") }
        findViewById<View>(R.id.dbActualizar).setOnClickListener { aviso("Histórico actualizado") }

        // Acciones de la barra inferior.
        findViewById<View>(R.id.nav1).setOnClickListener { aviso("Inicio") }
        findViewById<View>(R.id.nav2).setOnClickListener { aviso("Transferencias") }
        findViewById<View>(R.id.nav3).setOnClickListener { aviso("Pagos") }
        findViewById<View>(R.id.nav4).setOnClickListener { aviso("Servicios") }
        findViewById<View>(R.id.nav5).setOnClickListener { aviso("Divisas") }
        findViewById<View>(R.id.nav6).setOnClickListener { aviso("Tarjeta") }
        findViewById<View>(R.id.dbCampana).setOnClickListener { aviso("Notificaciones (3)") }
        findViewById<View>(R.id.dbMenu).setOnClickListener { aviso("Menú") }
        findViewById<View>(R.id.dbAccess).setOnClickListener { aviso("Access") }
        findViewById<View>(R.id.dbNfc).setOnClickListener { aviso("NFC S7B") }
    }

    private fun aviso(texto: String) {
        Toast.makeText(this, texto, Toast.LENGTH_SHORT).show()
    }
}
