import 'package:flutter/material.dart';

class RegisterSuporteScreen extends StatefulWidget {
  @override
  _RegisterSuporteScreenState createState() => _RegisterSuporteScreenState();
}

class _RegisterSuporteScreenState extends State<RegisterSuporteScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController sobrenomeController = TextEditingController();
  final TextEditingController diaController = TextEditingController();
  final TextEditingController mesController = TextEditingController();
  final TextEditingController anoController = TextEditingController();
  final TextEditingController funcaoController = TextEditingController();
  final TextEditingController dddController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmarSenhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6B9471),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Image.asset('../assets/images/logo.png', height: 100),
            SizedBox(height: 20),
            Text(
              "SUPORTE",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            _buildLabel("Nome:"),
            Row(
              children: [
                Expanded(child: _buildInputField("Primeiro Nome", nomeController)),
                SizedBox(width: 10),
                Expanded(child: _buildInputField("Sobrenome", sobrenomeController)),
              ],
            ),
            _buildLabel("Data de nascimento:"),
            Row(
              children: [
                Expanded(child: _buildInputField("DIA", diaController)),
                SizedBox(width: 5),
                Expanded(child: _buildInputField("MÊS", mesController)),
                SizedBox(width: 5),
                Expanded(child: _buildInputField("ANO", anoController)),
              ],
            ),
            _buildLabel("Função:"),
            _buildInputField("Exemplo: Infraestrutura", funcaoController),
            _buildLabel("WhatsApp:"),
            Row(
              children: [
                SizedBox(width: 50, child: _buildInputField("DDD", dddController)),
                SizedBox(width: 10),
                Expanded(child: _buildInputField("99170-7070", telefoneController)),
              ],
            ),
            _buildLabel("E-mail:"),
            _buildInputField("exemplo@email.com", emailController),
            _buildLabel("Senha:"),
            _buildInputField("************", senhaController, isPassword: true),
            _buildLabel("Confirme sua senha:"),
            _buildInputField("************", confirmarSenhaController, isPassword: true),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                // Lógica para cadastrar usuário
              },
              child: Text(
                "Cadastrar",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 5),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInputField(String hint, TextEditingController controller, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFF5B4736),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(color: Colors.white),
    );
  }
}
