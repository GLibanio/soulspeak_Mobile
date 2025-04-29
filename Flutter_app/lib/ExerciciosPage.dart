import 'package:flutter/material.dart';

class ExerciciosPage extends StatelessWidget {
  const ExerciciosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6CA180),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'EXERCÍCIOS',
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
                    Icons.fitness_center,
                    size: 50,
                    color: Colors.white,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'A prática regular de exercícios físicos é essencial para a saúde mental e corporal. Exercícios ajudam a liberar hormônios do bem-estar, reduzem o estresse e melhoram a qualidade de vida.',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Sugestões de atividades:',
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
                    color: Colors.white.withOpacity(0.08), // Agora é permitido
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    child: const ListTile(
                      leading: Icon(Icons.accessibility_new, color: Colors.white),
                      title: Text(
                        'Exercícios de força e musculação para fortalecer o corpo.',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white.withOpacity(0.08), // Agora é permitido
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    child: const ListTile(
                      leading: Icon(Icons.directions_walk, color: Colors.white),
                      title: Text(
                        'Caminhadas e corridas para melhorar a resistência cardiovascular.',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white.withOpacity(0.08), // Agora é permitido
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    child: const ListTile(
                      leading: Icon(Icons.spa, color: Colors.white),
                      title: Text(
                        'Yoga e alongamentos para flexibilidade e relaxamento.',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white.withOpacity(0.08), // Agora é permitido
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    child: const ListTile(
                      leading: Icon(Icons.water, color: Colors.white),
                      title: Text(
                        'Natação e hidroginástica para um exercício de baixo impacto.',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white.withOpacity(0.08), // Agora é permitido
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    child: const ListTile(
                      leading: Icon(Icons.pedal_bike, color: Colors.white),
                      title: Text(
                        'Andar de bicicleta para fortalecer as pernas e o sistema cardiovascular.',
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