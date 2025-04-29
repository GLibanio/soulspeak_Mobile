import 'package:flutter/material.dart';

class CultivarPlantasPage extends StatelessWidget {
  const CultivarPlantasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // Verde bem claro
      appBar: AppBar(
        title: const Text('Cultivar Plantas'),
        backgroundColor: const Color(0xFF4CAF50), // Verde do botão
        foregroundColor: Colors.white, // Cor do texto e ícone de voltar
        elevation: 1, // Sombra leve
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.eco,
                size: 80,
                color: Colors.green.shade800,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Benefícios de Cultivar Plantas',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade900,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Cuidar de plantas pode ser uma atividade terapêutica e recompensadora. Ajuda a reduzir o estresse, melhora a qualidade do ar, aumenta a sensação de bem-estar e ensina sobre paciência e responsabilidade.',
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            Text(
              'Dicas para Começar:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
            const SizedBox(height: 10),
            _buildTip('Escolha plantas fáceis de cuidar para iniciantes, como suculentas, jiboias ou zamioculcas.'),
            _buildTip('Pesquise sobre as necessidades de luz, água e solo de cada planta.'),
            _buildTip('Comece com poucos vasos e aumente gradualmente sua coleção.'),
            _buildTip('Reserve um tempo regularmente para regar, adubar e observar suas plantas.'),
             const SizedBox(height: 20),
             Center(
                child: Image.asset(
                    'assets/images/plant_illustration.png', // Substitua por uma imagem sua se tiver
                     height: 150,
                     errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(), // Não mostra erro se imagem não existir
                ),
             )
          ],
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: Colors.green.shade600, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}