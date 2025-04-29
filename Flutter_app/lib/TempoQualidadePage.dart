import 'package:flutter/material.dart';

class TempoQualidadePage extends StatelessWidget {
  const TempoQualidadePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6CA180),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'TEMPO DE QUALIDADE',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.hourglass_full,
                    size: 50,
                    color: Colors.white,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Passar tempo de qualidade com pessoas queridas ou consigo mesmo é fundamental para o equilíbrio emocional e a felicidade. Fortalece os vínculos, promove o bem-estar e ajuda a relaxar.',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Dicas para um tempo de qualidade:',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [ // Removi o 'const' aqui
                  Card(
                    color: Colors.white.withOpacity(0.08), // Cor não constante agora
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    child: const ListTile(
                      leading: Icon(Icons.self_improvement, color: Colors.white),
                      title: Text(
                        'Reserve momentos para você, sem interrupções.',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white.withOpacity(0.08), // Cor não constante
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    child: const ListTile(
                      leading: Icon(Icons.people, color: Colors.white),
                      title: Text(
                        'Desfrute da companhia de amigos e familiares, sem distrações.',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white.withOpacity(0.08), // Cor não constante
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    child: const ListTile(
                      leading: Icon(Icons.nature, color: Colors.white),
                      title: Text(
                        'Conecte-se com a natureza através de atividades ao ar livre.',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white.withOpacity(0.08), // Cor não constante
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    child: const ListTile(
                      leading: Icon(Icons.videogame_asset, color: Colors.white),
                      title: Text(
                        'Divirtam-se juntos com jogos e atividades lúdicas.',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white.withOpacity(0.08), // Cor não constante
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    child: const ListTile(
                      leading: Icon(Icons.movie, color: Colors.white),
                      title: Text(
                        'Compartilhe momentos assistindo filmes ou séries.',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}