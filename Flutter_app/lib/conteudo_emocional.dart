// conteudo_emocional.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ConteudoEmocionalScreen extends StatelessWidget {
  const ConteudoEmocionalScreen({super.key});

  void abrirLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7DA181),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              Row(
                children: [
                  const SizedBox(width: 8),
                  const Text(
                    "CONTEÚDOS EMOCIONAIS",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  const Icon(Icons.menu_book, color: Colors.white),
                ],
              ),
              const SizedBox(height: 20),

              // Introdução
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.brown[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Explore conteúdos sobre educação emocional através de podcasts, livros, artigos e vídeos. Escolha a opção que mais ressoa com você!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
              const SizedBox(height: 30),

              // LIVROS E ARTIGOS
              const Text(
                "LIVROS E ARTIGOS",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _conteudoHorizontal([
                _conteudoBox(
                  label: "O mínimo sobre saúde mental",
                  onTap: () => abrirLink("https://www.amazon.com.br/dp/6585033302"),
                ),
                _conteudoBox(
                  label: "A geração ansiosa",
                  onTap: () => abrirLink("https://www.amazon.com.br/dp/8535938532"),
                ),
                _conteudoBox(
                  label: "Ação psicológica em saúde mental",
                  onTap: () => abrirLink("https://www.scielo.br/j/pcp/a/YpCPnpqwGqmxVqNzTKZj36c/"),
                ),
                _conteudoBox(
                  label: "Saúde mental no trabalho",
                  onTap: () => abrirLink("https://www.amazon.com.br/dp/6555646578"),
                ),
              ]),

              const SizedBox(height: 30),

              // PODCASTS
              const Text(
                "PODCASTS",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _conteudoHorizontal([
                _conteudoBox(
                  label: "Saúde Mental no trabalho",
                  icon: Icons.play_circle_fill,
                  onTap: () => abrirLink("https://open.spotify.com/show/01rxbQSWtzUrvaZ2ZtNBv8"),
                ),
                _conteudoBox(
                  label: "Boas Práticas em Saúde Mental",
                  icon: Icons.play_circle_fill,
                  onTap: () => abrirLink("https://open.spotify.com/show/53w5nQmGZcGHCCMTvgnVv7"),
                ),
                _conteudoBox(
                  label: "Terapia no dia a dia",
                  icon: Icons.play_circle_fill,
                  onTap: () => abrirLink("https://open.spotify.com/show/60LN9oZJ4lVprp24g05arh"),
                ),
              ]),

              const SizedBox(height: 30),

              // VÍDEOS
              const Text(
                "VÍDEOS",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _conteudoHorizontal([
                _conteudoBox(
                  label: "Saúde Mental na Universidade",
                  icon: Icons.play_circle_outline,
                  onTap: () => abrirLink("https://www.youtube.com/watch?v=a70PlS6oR88"),
                ),
                _conteudoBox(
                  label: "Adolescentes: riscos e ajuda",
                  icon: Icons.play_circle_outline,
                  onTap: () => abrirLink("https://www.youtube.com/watch?v=JxTqpELP0PU"),
                ),
                _conteudoBox(
                  label: "4 princípios da saúde emocional",
                  icon: Icons.play_circle_outline,
                  onTap: () => abrirLink("https://www.youtube.com/watch?v=CsxX6VdFJRY"),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _conteudoHorizontal(List<Widget> items) {
    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: items,
      ),
    );
  }

  Widget _conteudoBox({
    required String label,
    required VoidCallback onTap,
    IconData icon = Icons.menu_book,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black54),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.black),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
