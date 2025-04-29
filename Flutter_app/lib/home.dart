import 'package:flutter/material.dart';
import 'chat.dart';
import 'chat_usuario.dart';
import 'diario.dart';
import 'login.dart';
import 'indicacoes.dart'; 
import 'conteudo_emocional.dart';
import 'praticas_saudaveis.dart';
import 'cvv_page.dart';

class HomeScreen extends StatefulWidget {
  final String token;

  const HomeScreen({super.key, required this.token});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildMainContent(),
      IndicacoesScreen(),
      ConteudoEmocionalScreen(),
      PraticasSaudaveisPage(),
      UsuarioChatScreen(token: widget.token),
      ChatScreen(),
      CvvPage(),
      DiarioScreen(),
    ];
  }

  void _onSelectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  Widget _buildMainContent() {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('../assets/images/logo.png', height: 300),
              SizedBox(height: 16),
              Text(
                "Soul Speak",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('../assets/images/Parceria_Prefeitura.png', height: 70),
              Image.asset('../assets/images/Parceria_enlace.png', height: 70),
              Image.asset('../assets/images/Parceria_cvv.png', height: 70),
            ],
          ),
        ),
      ],
    );
  }

  void _showEmergencyPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Color(0xFFF5E9DA), // Fundo bege
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.add_ic_call, color: Colors.redAccent, size: 40),
                        SizedBox(width: 10),
                        Text(
                          "EMERGÊNCIA!!",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                            shadows: [Shadow(blurRadius: 2, color: Colors.white)],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Você acionou o botão de emergência. Se concordar, será redirecionado para o teclado para ligar ao CVV (188).\n\n"
                      "Você concorda com o procedimento acima?",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            // Aqui você pode adicionar lógica para iniciar chamada, se quiser
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: Icon(Icons.check, color: Colors.white),
                          label: Text("Sim", style: TextStyle(color: Colors.white)),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: Icon(Icons.close, color: Colors.white),
                          label: Text("Não", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, size: 28, color: Colors.black),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7DA181),
      appBar: AppBar(
        backgroundColor: Color(0xFF7DA181),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
            onPressed: _showEmergencyPopup,
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Color(0xFF5E8962),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Center(
                  child: Text(
                    'NAVEGUE AQUI',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 2, color: Colors.white)],
                    ),
                  ),
                ),
              ),
              _drawerItem("Indicações", Icons.psychology, 1),
              _drawerItem("Conteúdos Emocionais", Icons.video_library, 2),
              _drawerItem("Práticas Saudáveis", Icons.fitness_center, 3),
              _drawerItem("Falar com Psicólogo", Icons.people, 4),
              _drawerItem("Falar com Lótus (Chatbot)", Icons.chat, 5),
              _drawerItem("CVV (Centro de Valorização da Vida)", Icons.support, 6),
              _drawerItem("Meu Diário", Icons.book, 7),
              Divider(color: Colors.white),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.white),
                title: Text("Sair", style: TextStyle(color: Colors.white)),
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
    );
  }

  Widget _drawerItem(String title, IconData icon, int index) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white)),
      onTap: () => _onSelectPage(index),
    );
  }
}

