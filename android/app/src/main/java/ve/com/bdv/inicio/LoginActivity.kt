package ve.com.bdv.inicio

import android.os.Bundle
import android.view.View
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity

/**
 * Pantalla de autenticacion: se abre al pulsar "Iniciar sesion" en la
 * pantalla de inicio.
 *
 * Replica 1:1 del mockup design/referencia-login.jpeg
 * (720x1460 px @2x, con 14 px de mas arriba -> lienzo de diseno 360 x 723 dp).
 * Medidas en values/dimens_login.xml.
 *
 * Nota: es una replica de interfaz. NO captura credenciales ni envia datos:
 * los botones solo muestran un aviso.
 */
class LoginActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login)

        findViewById<View>(R.id.campana).setOnClickListener { aviso("Notificaciones (3)") }
        findViewById<View>(R.id.circulo).setOnClickListener { aviso("Autenticación con huella digital") }
        findViewById<View>(R.id.ingresa).setOnClickListener { aviso("Ingreso con contraseña") }
        findViewById<View>(R.id.desvincular).setOnClickListener {
            aviso("Dispositivo desvinculado")
            finish()
        }
        findViewById<View>(R.id.salir).setOnClickListener { finish() }
    }

    private fun aviso(texto: String) {
        Toast.makeText(this, texto, Toast.LENGTH_SHORT).show()
    }
}
