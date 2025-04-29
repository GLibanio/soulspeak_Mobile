import 'package:flutter/material.dart';
import 'cultivar_plantas_page.dart';
import 'adotar_pet_page.dart';


class StrokeText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final double strokeWidth;

  const StrokeText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    this.strokeWidth = 3,
  });

  @override
  Widget build(BuildContext context) {
    const String defaultFontFamily = 'Comic Sans MS';

    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontFamily: defaultFontFamily, // Aplicar fonte
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontFamily: defaultFontFamily, 
            color: Colors.white, 
            shadows: [Shadow(color: Colors.black, blurRadius: 2)], 
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class IndicacoesScreen extends StatelessWidget {
  const IndicacoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7DA181), 
      body: SafeArea(
        child: SingleChildScrollView( 
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight( 
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Center(
                            child: StrokeText(
                              text: "INDICAÇÕES",
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              strokeWidth: 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10), // Ajuste margem
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 5,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8FB996), 
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                         BoxShadow(
                           color: Colors.black.withOpacity(0.1),
                           blurRadius: 4,
                           offset: Offset(0, 2)
                         )
                      ]
                    ),
                    child: const Center(
                      child: Text(
                        "O QUE FAZER PARA SE SENTIR MELHOR?",
                        style: TextStyle(
                          color: Colors.black87, 
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Stack(
                    clipBehavior: Clip.none, 
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15, 
                        ),
                        padding: const EdgeInsets.only( 
                            top: 20, bottom: 20, left: 14, right: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD3BC9C), 
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black.withOpacity(0.7), width: 2),
                        ),
                        child: const Text(
                          "Assumir responsabilidades, mesmo as menores, pode ser um passo significativo para aumentar nossa sensação de propósito e bem-estar. Ao nos envolvermos em atividades que requerem comprometimento, tendemos a nos tornar mais engajados, ativos e cultivamos uma perspectiva mais positiva sobre nós mesmos e sobre o mundo ao nosso redor.",
                          style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.4), // Melhorar leitura
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Positioned(
                        top: 5,
                        left: -10, 
                        child: Transform.rotate(
                          angle: -0.5,
                          child: Image.asset(
                            "../assets/images/bandage.png", 
                            width: 60,
                            height: 32,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 5, 
                        right: -10, 
                        child: Transform.rotate(
                          angle: 0.5, 
                          child: Image.asset(
                            "../assets/images/bandage.png", 
                            width: 60,
                            height: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10), 
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC3975F), 
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF8B4513),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: const Offset(2, 6), 
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none, 
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: 10,
                          top: -12, 
                          child: Icon(
                            Icons.push_pin, 
                            size: 28,
                            color: const Color(0xFF8B4513).withOpacity(0.8),
                            shadows: [BoxShadow(color: Colors.black26, blurRadius: 2)],
                          ),
                        ),
                        Positioned(
                          right: 10,
                          top: -12,
                          child: Icon(
                            Icons.push_pin,
                            size: 28,
                            color: const Color(0xFF8B4513).withOpacity(0.8),
                             shadows: [BoxShadow(color: Colors.black26, blurRadius: 2)],
                          ),
                        ),
                        const Text(
                          "ABAIXO TERÁ DOIS\nEXEMPLOS PARA ASSUMIR\nRESPONSABILIDADES\nESCOLHA O QUE PREFERIR E\nAPENAS COMECE!",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 14, 
                            letterSpacing: 0.5, 
                            height: 1.5, 
                            shadows: [
                              Shadow(color: Colors.black54, blurRadius: 3, offset: Offset(1,1)),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15, 
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start, 
                      children: [
                        Expanded(
                          child: _buildResponsibilityCard(
                            context: context,
                            title: "Cultivar Plantas",
                            icon: Icons.eco,
                            iconColor: const Color(0xFF214D23), 
                            buttonColor: const Color(0xFF4CAF50),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const CultivarPlantasPage()),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12), 
                        Expanded(
                           child: _buildResponsibilityCard(
                            context: context,
                            title: "Adotar Pet",
                            icon: Icons.pets,
                            iconColor: Colors.brown.shade700, 
                            buttonColor: const Color(0xFFFF9800), 
                            onPressed: () {
                               Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AdotarPetPage()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20), 
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsibilityCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color buttonColor,
    required VoidCallback onPressed,
  }) {
    return Container(
       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8), 
       decoration: BoxDecoration(
         color: Colors.grey[200], 
         borderRadius: BorderRadius.circular(18),
         border: Border.all(
           color: Colors.grey.shade400,
           width: 2,
         ),
         boxShadow: [
           const BoxShadow(
             color: Colors.black12,
             blurRadius: 4,
             offset: Offset(0, 2),
           ),
         ],
       ),
       child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
             Icon(
               icon,
               size: 50,
               color: iconColor,
             ),
             const SizedBox(height: 10),
             ElevatedButton(
               onPressed: onPressed,
               style: ElevatedButton.styleFrom(
                 backgroundColor: buttonColor,
                 shape: const StadiumBorder(), 
                 elevation: 2,
                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), 
               ),
               child: Text(
                 title,
                 style: const TextStyle(
                   color: Colors.white,
                   fontWeight: FontWeight.bold,
                   fontSize: 14,
                 ),
                 textAlign: TextAlign.center, 
               ),
             ),
          ],
       ),
    );
  }
}