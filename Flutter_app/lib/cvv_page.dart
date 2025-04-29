import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CvvPage extends StatelessWidget {
  const CvvPage({Key? key}) : super(key: key);

  _ligarParaCVV() async {
    const url = 'tel:188';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Não foi possível ligar para o CVV';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6BA386), // tom verde suave
      appBar: AppBar(
        title: const Text(
          'CVV - Centro de Valorização da Vida',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.support_agent, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              'Se você está passando por um momento difícil, saiba que não está sozinho. '
              'O CVV – Centro de Valorização da Vida – oferece apoio emocional gratuito e sigiloso, '
              '24 horas por dia, todos os dias.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 30),
            const Text(
              'Ligue para o número:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              '📞 188',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _ligarParaCVV,
              icon: const Icon(Icons.phone),
              label: const Text('Ligar agora'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade900,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
