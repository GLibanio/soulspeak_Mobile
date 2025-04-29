import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soulspeak/login_psicologo.dart';
import 'home.dart';
import 'register.dart';
import 'type_user.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
        DocumentSnapshot userDoc = await _firestore.collection("usuarios").doc(user.uid).get();
        if (userDoc.exists) {
          String? token = await user.getIdToken();
          _showPopup("Login realizado com sucesso!", true, token);
        } else {
          await _auth.signOut();
          _showPopup("Conta não cadastrada como usuário.", false);
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
                    builder: (context) => HomeScreen(token: token),
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
      backgroundColor: Color(0xFF6B9471),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('../assets/images/logo.png', height: 200),
            SizedBox(height: 20),
            Text(
              "LOGIN",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            _buildInputField("E-MAIL:", emailController),
            _buildInputField("SENHA:", passwordController, isPassword: true),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: _login,
                    child: Text("Entrar", style: TextStyle(color: Colors.black)),
                  ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SelecaoUsuarioScreen()),
              ),
              child: Text("CADASTRE-SE", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPsicologoScreen(),
                ),
              ),
              child: Text("Entrar como Psicólogo", style: TextStyle(color: Colors.white)),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset('../assets/images/Parceria_Prefeitura.png', height: 80),
                Image.asset('../assets/images/Parceria_enlace.png', height: 80),
                Image.asset('../assets/images/Parceria_cvv.png', height: 80),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFF5B4736),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
