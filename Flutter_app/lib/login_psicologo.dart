import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_psicologo.dart';
import 'type_user.dart';

class LoginPsicologoScreen extends StatefulWidget {
  @override
  _LoginPsicologoScreenState createState() => _LoginPsicologoScreenState();
}

class _LoginPsicologoScreenState extends State<LoginPsicologoScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _login() async {
    setState(() => isLoading = true);
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot psicologoDoc =
            await _firestore.collection("psicologos").doc(user.uid).get();

        if (psicologoDoc.exists) {
          String? token = await user.getIdToken();
          _showPopup("Login realizado com sucesso!", true, token);
        } else {
          await _auth.signOut();
          _showPopup("Conta não cadastrada como psicólogo.", false);
        }
      }
    } catch (e) {
      _showPopup("Erro ao fazer login: ${e.toString()}", false);
    }
    setState(() => isLoading = false);
  }

  void _showPopup(String message, bool success, [String? token]) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(success ? "Sucesso" : "Erro"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (success && token != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPsicologoScreen(token: token),
                  ),
                );
              }
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6B9471), // Cor verde da imagem
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Row(
                children: [
                  Spacer(),
                  Text(
                    'LOGIN PSICÓLOGO',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: 40),
              Image.asset('../assets/images/logo.png', height: 200),
              SizedBox(height: 30),
              _buildInputField("E-mail", emailController),
              _buildInputField("Senha", passwordController, isPassword: true),
              SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      ),
                      onPressed: _login,
                      child: Text("Entrar", style: TextStyle(color: Colors.black)),
                    ),
              SizedBox(height: 15),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelecaoUsuarioScreen()),
                ),
                child: Text("CADASTRE-SE", style: TextStyle(color: Colors.white)),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset('../assets/images/Parceria_Prefeitura.png', height: 60),
                  Image.asset('../assets/images/Parceria_enlace.png', height: 60),
                  Image.asset('../assets/images/Parceria_cvv.png', height: 60),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFF5B4736), // Verde escuro
            hintText: label,
            hintStyle: TextStyle(color: Colors.white70),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
