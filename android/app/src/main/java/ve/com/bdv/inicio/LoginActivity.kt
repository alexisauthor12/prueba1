package ve.com.bdv.inicio

import android.os.Bundle
import android.text.InputType
import android.view.View
import android.widget.EditText
import android.widget.FrameLayout
import android.widget.Toast
import androidx.activity.OnBackPressedCallback
import androidx.appcompat.app.AppCompatActivity

/**
 * Pantalla de autenticacion: se abre al pulsar "Iniciar sesion" en la
 * pantalla de inicio.
 *
 * Replica 1:1 del mockup design/referencia-login.jpeg
 * (720x1460 px @2x, con 14 px de mas arriba -> lienzo de diseno 360 x 723 dp).
 * Medidas en values/dimens_login.xml.
 *
 * Al pulsar "Ingresa con tu contrasena" se abre el dialogo modal del mockup
 * design/referencia-clave.jpeg (medidas en values/dimens_clave.xml).
 *
 * Nota: es una replica de interfaz. NO captura credenciales ni envia datos:
 * los botones solo muestran un aviso.
 */
class LoginActivity : AppCompatActivity() {

    private lateinit var panelClave: FrameLayout
    private lateinit var campo: EditText
    private var claveVisible = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login)

        panelClave = findViewById(R.id.panelClave)
        campo = findViewById(R.id.claveCampo)

        findViewById<View>(R.id.campana).setOnClickListener { aviso("Notificaciones (3)") }
        findViewById<View>(R.id.circulo).setOnClickListener { aviso("Autenticación con huella digital") }
        findViewById<View>(R.id.ingresa).setOnClickListener { abrirClave() }
        findViewById<View>(R.id.desvincular).setOnClickListener {
            aviso("Dispositivo desvinculado")
            finish()
        }
        findViewById<View>(R.id.salir).setOnClickListener { finish() }

        // --- Dialogo "Ingresa con tu contrasena" ---
        findViewById<View>(R.id.claveOjo).setOnClickListener { alternarClave() }
        findViewById<View>(R.id.claveCancelar).setOnClickListener { cerrarClave() }
        findViewById<View>(R.id.claveAceptar).setOnClickListener {
            // Replica de interfaz: no se valida ni se envia la contrasena.
            cerrarClave()
            aviso("Acceso con contraseña (demo)")
        }
        // Tocar el velo (fuera de la tarjeta) cierra el dialogo.
        panelClave.setOnClickListener { cerrarClave() }

        // El boton "atras" cierra el dialogo si esta abierto.
        onBackPressedDispatcher.addCallback(this, object : OnBackPressedCallback(true) {
            override fun handleOnBackPressed() {
                if (panelClave.visibility == View.VISIBLE) {
                    cerrarClave()
                } else {
                    isEnabled = false
                    onBackPressedDispatcher.onBackPressed()
                }
            }
        })
    }

    /** Muestra el dialogo con el velo del mockup. */
    private fun abrirClave() {
        claveVisible = false
        campo.inputType = InputType.TYPE_CLASS_TEXT or InputType.TYPE_TEXT_VARIATION_PASSWORD
        panelClave.visibility = View.VISIBLE
    }

    /** Oculta el dialogo y limpia el campo. */
    private fun cerrarClave() {
        campo.text = null
        campo.clearFocus()
        panelClave.visibility = View.GONE
    }

    /** Alterna entre contrasena oculta y visible (icono del ojo). */
    private fun alternarClave() {
        claveVisible = !claveVisible
        val pos = campo.selectionEnd.coerceAtLeast(0)
        campo.inputType = if (claveVisible) {
            InputType.TYPE_CLASS_TEXT or InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD
        } else {
            InputType.TYPE_CLASS_TEXT or InputType.TYPE_TEXT_VARIATION_PASSWORD
        }
        campo.setSelection(pos.coerceAtMost(campo.text.length))
    }

    private fun aviso(texto: String) {
        Toast.makeText(this, texto, Toast.LENGTH_SHORT).show()
    }
}
