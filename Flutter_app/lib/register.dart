import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController birthDayController = TextEditingController();
  final TextEditingController birthMonthController = TextEditingController();
  final TextEditingController birthYearController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isLoading = false;

  Future<void> _register() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty) {
      _showPopup("Preencha todos os campos!", false);
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showPopup("As senhas não coincidem!", false);
      return;
    }

    setState(() => isLoading = true);

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        await _firestore.collection('usuarios').doc(userCredential.user!.uid).set({
          'firstName': firstNameController.text.trim(),
          'lastName': lastNameController.text.trim(),
          'nickname': nicknameController.text.trim(),
          'birthDate': "${birthDayController.text}/${birthMonthController.text}/${birthYearController.text}",
          'email': emailController.text.trim(),
          'userType': 'paciente',
          'createdAt': Timestamp.now(),
        });

        _showPopup("Cadastro realizado com sucesso!", true);
      }
    } catch (e) {
      _showPopup("Erro ao criar conta: \${e.toString()}", false);
    }

    setState(() => isLoading = false);
  }

  void _showPopup(String message, bool success) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(success ? "Sucesso" : "Erro"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (success) {
                Navigator.pop(context);
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Image.asset('../assets/images/logo.png', height: 100),
            SizedBox(height: 20),
            Text("PACIENTE", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 20),
            _buildInputRow("Nome:", firstNameController, "Primeiro Nome", lastNameController, "Sobrenome"),
            _buildInputField("Como você gostaria de ser chamado?", nicknameController, "Escreva aqui seu Apelido"),
            _buildBirthDateInput(),
            _buildInputField("E-mail:", emailController, "exemple@email.com"),
            _buildInputField("Senha:", passwordController, "***********", isPassword: true),
            _buildInputField("Confirme sua senha:", confirmPasswordController, "***********", isPassword: true),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: _register,
                    child: Text("Cadastrar", style: TextStyle(color: Colors.black)),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, String hint, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Color(0xFF5B4736),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          ),
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget _buildInputRow(String label, TextEditingController controller1, String hint1, TextEditingController controller2, String hint2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Row(
          children: [
            Expanded(child: _buildSmallInputField(controller1, hint1)),
            SizedBox(width: 10),
            Expanded(child: _buildSmallInputField(controller2, hint2)),
          ],
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget _buildSmallInputField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Color(0xFF5B4736),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
      style: TextStyle(color: Colors.white),
    );
  }

  Widget _buildBirthDateInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Data de nascimento", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildSmallInputField(birthDayController, "DIA")),
            SizedBox(width: 5),
            Expanded(child: _buildSmallInputField(birthMonthController, "MÊS")),
            SizedBox(width: 5),
            Expanded(child: _buildSmallInputField(birthYearController, "ANO")),
          ],
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
