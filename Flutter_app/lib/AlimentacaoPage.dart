import 'package:flutter/material.dart';

class AlimentacaoPage extends StatelessWidget {
  const AlimentacaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6CA180),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'ALIMENTAÇÃO',
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
                    Icons.restaurant,
                    size: 50,
                    color: Colors.white,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'A alimentação saudável é essencial para garantir energia, vitalidade e um bom funcionamento do organismo. Uma dieta equilibrada fortalece o sistema imunológico e mantém o corpo e a mente saudáveis.',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Dicas de alimentação saudável:',
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
                      leading: Icon(Icons.local_grocery_store, color: Colors.white),
                      title: Text(
                        'Priorize frutas e vegetais frescos e da estação.',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white.withOpacity(0.08), // Agora é permitido
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    child: const ListTile(
                      leading: Icon(Icons.no_food, color: Colors.white),
                      title: Text(
                        'Modere o consumo de alimentos processados, ultraprocessados e fast food.',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white.withOpacity(0.08), // Agora é permitido
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    child: const ListTile(
                      leading: Icon(Icons.water_drop, color: Colors.white),
                      title: Text(
                        'Mantenha-se hidratado bebendo água regularmente.',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white.withOpacity(0.08), // Agora é permitido
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    child: const ListTile(
                      leading: Icon(Icons.egg, color: Colors.white),
                      title: Text(
                        'Inclua fontes de proteína magra como ovos, peixe e leguminosas.',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white.withOpacity(0.08), // Agora é permitido
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    child: const ListTile(
                      leading: Icon(Icons.restaurant_menu, color: Colors.white),
                      title: Text(
                        'Faça refeições balanceadas e evite pular horários.',
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