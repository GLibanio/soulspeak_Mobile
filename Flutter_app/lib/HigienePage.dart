import 'package:flutter/material.dart';

class HigienePage extends StatelessWidget {
  const HigienePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6CA180),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'HIGIENE',
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
                    Icons.clean_hands,
                    size: 50,
                    color: Colors.white,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'A higiene pessoal é fundamental para a saúde física e mental. Manter-se limpo e cuidar do corpo de forma adequada melhora o bem-estar geral e reduz o risco de doenças.',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Dicas de práticas de higiene:',
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
                      leading: Icon(Icons.shower, color: Colors.white),
                      title: Text(
                        'Tomar banho diariamente para remover impurezas.',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white.withOpacity(0.08), // Agora é permitido
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    child: const ListTile(
                      leading: Icon(Icons.wash, color: Colors.white),
                      title: Text(
                        'Lavar as mãos frequentemente com água e sabão, especialmente antes das refeições e após usar o banheiro.',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white.withOpacity(0.08), // Agora é permitido
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    child: const ListTile(
                      leading: Icon(Icons.brush, color: Colors.white),
                      title: Text(
                        'Escovar os dentes pelo menos duas vezes ao dia para manter a saúde bucal.',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white.withOpacity(0.08), // Agora é permitido
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    child: const ListTile(
                      leading: Icon(Icons.content_cut, color: Colors.white),
                      title: Text(
                        'Manter as unhas limpas e cortadas, e o cabelo limpo e bem cuidado.',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white.withOpacity(0.08), // Agora é permitido
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    child: const ListTile(
                      title: Text(
                        'Higienizar os pés diariamente, especialmente após usar calçados fechados.',
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