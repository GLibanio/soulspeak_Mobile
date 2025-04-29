import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];
  bool isTyping = false;

  final String flaskUrl = 'http://192.168.0.5:5000/chatbot';

  final List<String> mensagensIniciais = [
    "Olá! Como posso te ajudar hoje?",
    "Oi! O que você gostaria de conversar?",
    "Como está o seu dia?",
    "Tudo bem por aí? Me conta como posso ajudar.",
    "Oi! Quer compartilhar algo comigo hoje?",
  ];

  @override
  void initState() {
    super.initState();
    final random = Random();
    final mensagem = mensagensIniciais[random.nextInt(mensagensIniciais.length)];
    messages.add({'sender': 'bot', 'text': mensagem});
  }

  Future<void> sendMessage(String userMessage) async {
    if (userMessage.trim().isEmpty) return;

    setState(() {
      messages.add({'sender': 'user', 'text': userMessage});
      isTyping = true;
    });

    try {
      final response = await http.post(
        Uri.parse(flaskUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': userMessage}),
      );

      String botMessage;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        botMessage = data['resposta'] ?? 'Erro na resposta.';
      } else {
        botMessage = 'Erro na comunicação com o servidor.';
      }

      setState(() {
        messages.add({'sender': 'bot', 'text': botMessage});
        isTyping = false;
      });
    } catch (e) {
      setState(() {
        messages.add({'sender': 'bot', 'text': 'Ocorreu um erro. Tente novamente.'});
        isTyping = false;
      });
    }
  }

  Widget buildMessage(Map<String, String> message) {
    bool isUser = message['sender'] == 'user';
    return Row(
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isUser)
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 5),
            child: CircleAvatar(
              backgroundImage: AssetImage('../assets/images/Lotus.png'),
              radius: 20,
            ),
          ),
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: isUser
                  ? Border.all(color: Colors.transparent)
                  : Border.all(color: Colors.black, width: 2),
            ),
            child: Text(
              message['text']!,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
        if (isUser)
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 5),
            child: CircleAvatar(
              backgroundImage: AssetImage('../assets/images/user_icon.png'),
              radius: 20,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6F927C),
      appBar: AppBar(
        backgroundColor: Color(0xFF6F927C),
        elevation: 0,
        centerTitle: true,
        title: Text("Chat com Lótus", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: messages.length + (isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length && isTyping) {
                  return buildMessage({'sender': 'bot', 'text': '...'});
                }
                return buildMessage(messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Digite aqui...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.black),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      sendMessage(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
