package ve.com.bdv.inicio

import android.os.Bundle
import android.view.View
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity

/**
 * Pantalla de inicio del BDV.
 *
 * Réplica 1:1 del mockup de referencia (design/referencia-inicio.jpeg).
 * Todas las medidas del layout están en dp y provienen de la medición
 * píxel a píxel documentada en design/ESPECIFICACIONES.md
 * (mockup 720x1453 px @2x  ->  lienzo de diseño 360 x 726.5 dp).
 *
 * Nota: esta pantalla es una réplica de interfaz. NO captura credenciales
 * ni envía datos a ningún servidor; los botones solo muestran un aviso.
 */
class InicioActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_inicio)

        conectarAcciones()
    }

    private fun conectarAcciones() {
        val campana: View = findViewById(R.id.campana)
        val boton: View = findViewById(R.id.boton)
        val enlace: View = findViewById(R.id.enlace)
        val tarjeta1: View = findViewById(R.id.tarjeta1)
        val tarjeta2: View = findViewById(R.id.tarjeta2)
        val tarjeta3: View = findViewById(R.id.tarjeta3)

        campana.setOnClickListener { aviso("Notificaciones (3)") }
        boton.setOnClickListener { aviso("Iniciar sesión") }
        enlace.setOnClickListener { aviso("Abrir una cuenta en el BDV") }
        tarjeta1.setOnClickListener { aviso("PagomóvilBDV") }
        tarjeta2.setOnClickListener { aviso("Pagos AccessPay") }
        tarjeta3.setOnClickListener { aviso("Ver mis saldos") }
    }

    private fun aviso(texto: String) {
        Toast.makeText(this, texto, Toast.LENGTH_SHORT).show()
    }
}
