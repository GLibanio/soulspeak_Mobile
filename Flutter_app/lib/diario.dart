import 'package:flutter/material.dart';
import 'api_service.dart';

class DiarioScreen extends StatefulWidget {
  @override
  _DiarioScreenState createState() => _DiarioScreenState();
}

class _DiarioScreenState extends State<DiarioScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _entradas = [];
  String? _editandoId; // Para saber se está editando

  Future<void> _salvarOuAtualizarEntrada() async {
    String texto = _controller.text.trim();
    if (texto.isEmpty) return;

    bool sucesso = false;

    if (_editandoId != null) {
      sucesso = await ApiService.atualizarEntradaDiario(_editandoId!, texto);
    } else {
      sucesso = await ApiService.salvarEntradaDiario(texto);
    }

    if (sucesso) {
      _controller.clear();
      _editandoId = null;
      await _carregarEntradas();
      _scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_editandoId == null ? "Entrada salva!" : "Entrada atualizada!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao ${_editandoId == null ? 'salvar' : 'atualizar'} entrada")),
      );
    }
  }

  Future<void> _carregarEntradas() async {
    List<Map<String, dynamic>> entradas =
        await ApiService.carregarEntradasDiario();
    setState(() {
      _entradas = entradas.reversed.toList();
    });
  }

  Future<void> _confirmarDelecao(String id) async {
    bool? confirmacao = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmar exclusão"),
        content: Text("Tem certeza que deseja excluir esta entrada?"),
        actions: [
          TextButton(
            child: Text("Cancelar"),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text("Excluir", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmacao == true) {
      _deletarEntrada(id);
    }
  }

  Future<void> _deletarEntrada(String id) async {
    bool sucesso = await ApiService.deletarEntradaDiario(id);
    if (sucesso) {
      await _carregarEntradas();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Entrada excluída com sucesso!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao excluir entrada")),
      );
    }
  }

  void _editarEntrada(Map<String, dynamic> entrada) {
    setState(() {
      _controller.text = entrada['content'];
      _editandoId = entrada['id'];
    });
  }

  @override
  void initState() {
    super.initState();
    _carregarEntradas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Color(0xFF5E8962),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "DIÁRIO",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            shadows: [Shadow(blurRadius: 2, color: Colors.white)],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 4),
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.brown[300],
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 2)],
                          ),
                          child: Text("Sinta-se livre", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.psychology_alt, color: Colors.white),
                ],
              ),
            ),

            // Área de texto
            Expanded(
              child: Stack(
                children: [
                  _buildNotebookLines(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(fontSize: 16, height: 2.5),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 48, top: 0),
                        border: InputBorder.none,
                        hintText: 'Escreva como se fosse em um diário...',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Botão salvar/atualizar
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton.icon(
                onPressed: _salvarOuAtualizarEntrada,
                icon: Icon(_editandoId == null ? Icons.save : Icons.edit),
                label: Text(_editandoId == null ? "Salvar" : "Atualizar"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5E8962),
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),

            // Lista de entradas
            if (_entradas.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: ExpansionTile(
                  title: Text("Visualizar Entradas"),
                  initiallyExpanded: false,
                  children: [
                    Container(
                      height: 200,
                      child: ListView(
                        controller: _scrollController,
                        children: _entradas.map((entrada) {
                          return Card(
                            color: Colors.white,
                            margin: EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text(
                                entrada['content'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(entrada['timestamp']),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => _editarEntrada(entrada),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _confirmarDelecao(entrada['id']),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
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

  Widget _buildNotebookLines() {
    return CustomPaint(painter: NotebookLinesPainter(), size: Size.infinite);
  }
}

class NotebookLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final redPaint = Paint()..color = Colors.red..strokeWidth = 1;
    final bluePaint = Paint()..color = Colors.blue..strokeWidth = 1;

    canvas.drawLine(Offset(40, 0), Offset(40, size.height), bluePaint);

    double y = 40;
    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), redPaint);
      y += 40;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
