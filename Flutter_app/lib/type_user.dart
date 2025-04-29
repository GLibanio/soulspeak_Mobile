import 'package:flutter/material.dart';
import 'register_psicologo.dart';
import 'register.dart'; // Importação da tela de paciente
import 'register_suporte.dart';  // Importação da tela de suporte

class SelecaoUsuarioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8EAA89), Color(0xFF5E7855)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('../assets/images/logo.png', height: 100),
            SizedBox(height: 20),
            Text(
              "SOU",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),
            _buildButton(context, "Paciente", Colors.brown, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen()),
              );
            }),
            _buildButton(context, "Psicólogo", Colors.brown, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterPsicologoScreen()),
              );
            }),
            _buildButton(context, "Suporte", Colors.brown, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterSuporteScreen()),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, Color color, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
