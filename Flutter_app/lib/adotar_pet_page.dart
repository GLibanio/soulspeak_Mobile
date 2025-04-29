import 'package:flutter/material.dart';

class AdotarPetPage extends StatelessWidget {
  const AdotarPetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0), // Laranja bem claro / Bege
      appBar: AppBar(
        title: const Text('Adotar um Pet'),
        backgroundColor: const Color(0xFFFF9800), // Laranja do botão
         foregroundColor: Colors.white, // Cor do texto e ícone de voltar
         elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Center(
              child: Icon(
                Icons.pets,
                size: 80,
                color: Colors.brown.shade700,
              ),
            ),
            const SizedBox(height: 20),
             Text(
              'Benefícios de Adotar um Pet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.brown.shade900,
              ),
            ),
             const SizedBox(height: 10),
             const Text(
              'Ter um animal de estimação traz muita alegria e companheirismo. Eles podem reduzir a solidão, incentivar a prática de exercícios (no caso de cães), diminuir o estresse e ensinar sobre amor incondicional e responsabilidade.',
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.justify,
            ),
             const SizedBox(height: 20),
             Text(
              'Antes de Adotar:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                 color: Colors.brown.shade800,
              ),
            ),
            const SizedBox(height: 10),
            _buildConsideration('Pesquise sobre as necessidades da espécie e raça que você pretende adotar (espaço, alimentação, exercícios, cuidados veterinários).'),
            _buildConsideration('Considere seu estilo de vida, tempo disponível e orçamento para cuidar do animal.'),
            _buildConsideration('Pense na adoção como um compromisso de longo prazo (muitos animais vivem 10, 15 anos ou mais).'),
            _buildConsideration('Procure ONGs e abrigos de animais em sua cidade. Há muitos pets esperando por um lar!'),
            const SizedBox(height: 20),
            Center(
                child: Image.asset(
                  'assets/images/pet_illustration.png', // Substitua por uma imagem sua se tiver
                   height: 150,
                   errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(), // Não mostra erro se imagem não existir
                ),
            )
          ],
        ),
      ),
    );
  }

   Widget _buildConsideration(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: Colors.brown.shade600, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}