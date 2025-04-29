import 'package:flutter/material.dart';
import 'ExerciciosPage.dart';
import 'HigienePage.dart';
import 'AlimentacaoPage.dart';
import 'TempoQualidadePage.dart';

class PraticasSaudaveisPage extends StatelessWidget {
  const PraticasSaudaveisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6CA180),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'PRÁTICAS SAUDÁVEIS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Image.asset('../assets/images/brain.png', height: 50),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Cuidar da saúde mental é uma jornada que envolve atenção ao corpo, à mente e às emoções. Com práticas regulares de exercícios físicos, hábitos de higiene e uma alimentação equilibrada, é possível construir uma base sólida para o bem-estar integral e viver de forma mais plena.',
                      style: TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'CLIQUE E SAIBA MAIS!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 7,
                mainAxisSpacing: 7,
                childAspectRatio: 0.85, // Ainda mais "achatado"
                children: [
                  _buildOption(
                    context,
                    title: 'Exercícios',
                    color: const Color(0xFFD32F2F),
                    iconPath: '../assets/images/Exercicio.png',
                    page: const ExerciciosPage(),
                  ),
                  _buildOption(
                    context,
                    title: 'Higiene',
                    color: const Color(0xFF1976D2),
                    iconPath: '../assets/images/Higiene.png',
                    page: const HigienePage(),
                  ),
                  _buildOption(
                    context,
                    title: 'Alimentação',
                    color: const Color(0xFF388E3C),
                    iconPath: '../assets/images/alimentacao.png',
                    page: const AlimentacaoPage(),
                  ),
                  _buildOption(
                    context,
                    title: 'Tempo de qualidade',
                    color: const Color(0xFFF57C00),
                    iconPath: '../assets/images/Tempo_Saudavel.png',
                    page: const TempoQualidadePage(),
                    
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context,
      {required String title, required Color color, required String iconPath, required Widget page}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              height: 70, // Diminuindo ainda mais o ícone
              color: Colors.white,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20, // Diminuindo ainda mais o texto
              ),
            ),
          ],
        ),
      ),
    );
  }
}