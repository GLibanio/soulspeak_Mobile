import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'video_call.dart';

class ChatPsicologoScreen extends StatefulWidget {
  final String token;

  ChatPsicologoScreen({required this.token});

  @override
  _ChatPsicologoScreenState createState() => _ChatPsicologoScreenState();
}

class _ChatPsicologoScreenState extends State<ChatPsicologoScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> _iniciarChat(String pacienteId, String pacienteNome) async {
    final user = _auth.currentUser;
    if (user == null) {
      _mostrarErro("Erro: Psicólogo não autenticado!");
      return;
    }

    String nomeFinal = pacienteNome;
    if (nomeFinal == "Paciente Anônimo") {
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(pacienteId).get();
        if (userDoc.exists && userDoc.data() != null) {
          final userData = userDoc.data() as Map<String, dynamic>;
          nomeFinal = userData['nome'] ?? "Paciente Anônimo";
        }
      } catch (e) {
        print("Erro ao buscar nome do paciente: $e");
      }
    }

    final chatId = '${pacienteId}_${user.uid}';
    try {
      final chatRef = _firestore.collection('chats').doc(chatId);
      final chatDoc = await chatRef.get();

      if (!chatDoc.exists) {
        await chatRef.set({
          "pacienteId": pacienteId,
          "psicologoId": user.uid,
          "inicio": FieldValue.serverTimestamp(),
          "nomePaciente": nomeFinal,
          "nomePsicologo": user.displayName ?? "Psicólogo",
          "solicitacaoVideo": false,
          "recusaVideo": false,
          "pacienteAceitouVideo": false,
          "solicitanteVideoId": null,
          "pacienteSaiu": false, // Adiciona flag para saída do paciente
        });
      } else {
        await chatRef.update({
          "solicitacaoVideo": false,
          "recusaVideo": false,
          "pacienteAceitouVideo": false,
          "solicitanteVideoId": null,
          "pacienteSaiu": false, // Reseta a flag ao (re)iniciar chat
        });
      }

      await _firestore.collection('fila_espera').doc(pacienteId).delete();
      _navegarParaChat(chatId, nomeFinal);
    } catch (e) {
      _mostrarErro("Erro ao iniciar chat: $e");
    }
  }

  void _mostrarErro(String mensagem) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(
        content: Text(mensagem), backgroundColor: Colors.redAccent));
  }

   void _mostrarInfo(String mensagem) {
     if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem), backgroundColor: Colors.blueAccent));
  }

  void _navegarParaChat(String chatId, String pacienteNome) {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(chatId: chatId, username: pacienteNome),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fila de Espera")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('fila_espera')
            .orderBy('timestamp')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print("Erro no StreamBuilder da fila: ${snapshot.error}");
            return Center(child: Text("Erro ao carregar fila de espera"));
          }

          final fila = snapshot.data?.docs ?? [];

          if (fila.isEmpty) {
            return Center(child: Text("Nenhum paciente na fila"));
          }

          return ListView.builder(
            itemCount: fila.length,
            itemBuilder: (context, index) {
              final doc = fila[index];
              final pacienteData = doc.data() as Map<String, dynamic>? ?? {};
              final pacienteId = doc.id;
              final pacienteNome = pacienteData['nome'] ?? "Paciente Anônimo";

              final timestamp = pacienteData['timestamp'] as Timestamp?;
              String horaEntrada = timestamp != null
                  ? TimeOfDay.fromDateTime(timestamp.toDate()).format(context)
                  : 'Horário indisponível';

              return ListTile(
                leading: Icon(Icons.person_outline),
                title: Text(pacienteNome),
                subtitle: Text("Aguardando desde: $horaEntrada"),
                trailing: ElevatedButton(
                  onPressed: () => _iniciarChat(pacienteId, pacienteNome),
                  child: Text("Atender"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String username;

  ChatScreen({required this.chatId, required this.username});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  late CollectionReference _chatRef;
  String? _userId;
  bool _pacientePresente = true; // Assume que o paciente está presente inicialmente

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid;
    _chatRef = _firestore
        .collection('chats')
        .doc(widget.chatId)
        .collection('mensagens');

    if (_userId != null) {
      _escutarEstadoChat();
    } else {
      print("Erro: Usuário psicólogo não encontrado no initState do ChatScreen");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mostrarErro("Erro de autenticação. Por favor, faça login novamente.");
        if (mounted) {
           Navigator.of(context).popUntil((route) => route.isFirst);
        }
      });
    }
  }

  void _escutarEstadoChat() {
    _firestore
        .collection('chats')
        .doc(widget.chatId)
        .snapshots()
        .listen((snapshot) async {
      if (snapshot.exists && mounted) {
        final dados = snapshot.data() as Map<String, dynamic>;
        final solicitacao = dados['solicitacaoVideo'] ?? false;
        final recusa = dados['recusaVideo'] ?? false;
        final solicitanteVideoId = dados['solicitanteVideoId'];
        final pacienteAceitou = dados['pacienteAceitouVideo'] ?? false;
        final pacienteSaiu = dados['pacienteSaiu'] ?? false;

        // Verifica se o paciente saiu
        if (pacienteSaiu && _pacientePresente) {
             setState(() {
               _pacientePresente = false;
             });
             _mostrarInfo("O paciente saiu do chat.");
             // Não reseta a flag aqui, permite ao psicólogo ver o estado
        } else if (!pacienteSaiu && !_pacientePresente) {
            // Se o paciente voltou (improvável nesta lógica, mas para consistência)
            setState(() {
               _pacientePresente = true;
             });
        }


        // Lógica de Vídeo (só processa se paciente estiver presente)
        if (_pacientePresente) {
            if (solicitacao && solicitanteVideoId == _userId && pacienteAceitou && !recusa) {
              print("Psicólogo (${_userId}) detectou aceite do paciente. Navegando para vídeo...");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VideoCallScreen(
                    userId: _userId!,
                    userName: FirebaseAuth.instance.currentUser?.displayName ?? "Psicólogo",
                    callId: widget.chatId,
                  ),
                ),
              );

              try {
                await _firestore
                    .collection('chats')
                    .doc(widget.chatId)
                    .update({
                  "solicitacaoVideo": false,
                  "pacienteAceitouVideo": false,
                  "recusaVideo": false,
                });
                print("Flags de vídeo resetadas pelo psicólogo após aceite.");
              } catch (e) {
                print("Erro ao resetar flags de vídeo pelo psicólogo: $e");
              }
            } else if (recusa && solicitanteVideoId == _userId) {
              print("Psicólogo (${_userId}) detectou recusa do paciente.");
              if (mounted) {
                _mostrarErro("O paciente recusou a chamada de vídeo.");
              }
              try {
                await _firestore
                    .collection('chats')
                    .doc(widget.chatId)
                    .update({
                  "recusaVideo": false,
                  "solicitacaoVideo": false,
                  "pacienteAceitouVideo": false,
                });
                print("Flags de vídeo resetadas pelo psicólogo após recusa.");
              } catch (e) {
                print("Erro ao resetar flags de vídeo após recusa: $e");
              }
            }
        }

      } else if (!snapshot.exists && mounted) {
        print("Chat ${widget.chatId} não existe mais. Encerrando tela.");
        _mostrarInfo("A conversa foi encerrada.");
        Navigator.of(context).pop();
      }
    }, onError: (error) {
      print("Erro ao escutar chat ${widget.chatId}: $error");
      if (mounted) {
        _mostrarErro("Erro de conexão com o chat.");
      }
    });
  }

  void _enviarMensagem() async {
    final textoMensagem = _controller.text.trim();
     // Não permite enviar mensagem se o paciente saiu
    if (textoMensagem.isEmpty || _userId == null || !_pacientePresente) {
        if(!_pacientePresente) {
            _mostrarErro("Não é possível enviar mensagem, o paciente saiu do chat.");
        }
        return;
    }

    try {
      await _chatRef.add({
        "remetente": _userId,
        "mensagem": textoMensagem,
        "timestamp": FieldValue.serverTimestamp(),
      });
      _controller.clear();
      print("Mensagem enviada pelo psicólogo $_userId");
    } catch (e) {
      print("Erro ao enviar mensagem: $e");
      _mostrarErro("Erro ao enviar mensagem: $e");
    }
  }

  void _encerrarConversa() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Encerrar Conversa"),
        content: Text(
            "Tem certeza que deseja encerrar esta conversa? O histórico será perdido."),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text("Cancelar")),
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text("Encerrar", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        await _firestore.collection('chats').doc(widget.chatId).delete();
        print("Chat ${widget.chatId} encerrado pelo psicólogo.");

        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        print("Erro ao encerrar a conversa: $e");
        _mostrarErro("Erro ao encerrar a conversa: $e");
      }
    }
  }

  void _iniciarVideoChamada() async {
    if (_userId == null) {
      _mostrarErro("Erro de autenticação ao iniciar vídeo.");
      return;
    }
    // Não inicia vídeo se o paciente saiu
    if (!_pacientePresente) {
       _mostrarErro("Não é possível iniciar vídeo, o paciente saiu do chat.");
       return;
    }

    try {
      await _firestore.collection('chats').doc(widget.chatId).update({
        "solicitacaoVideo": true,
        "recusaVideo": false,
        "pacienteAceitouVideo": false,
        "solicitanteVideoId": _userId,
      });
      print(
          "Psicólogo ($_userId) solicitou videochamada para chat ${widget.chatId}");
      _mostrarInfo("Solicitação de videochamada enviada ao paciente.");
    } catch (e) {
      print("Erro ao solicitar videochamada: $e");
      _mostrarErro("Erro ao solicitar videochamada: $e");
    }
  }

  void _mostrarErro(String mensagem) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(mensagem), backgroundColor: Colors.redAccent));
  }

  void _mostrarInfo(String mensagem) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(mensagem), backgroundColor: Colors.blueAccent));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat com ${widget.username}" + (_pacientePresente ? "" : " (Saiu)")),
        actions: [
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: _iniciarVideoChamada,
            tooltip: "Iniciar Vídeo Chamada",
            color: _pacientePresente ? null : Colors.grey, // Desabilita visualmente
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: _encerrarConversa,
            tooltip: "Encerrar Conversa Definitivamente",
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatRef.orderBy('timestamp', descending: false).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  print(
                      "Erro no StreamBuilder de mensagens: ${snapshot.error}");
                  return Center(child: Text("Erro ao carregar mensagens"));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    // Mostra mensagem se paciente saiu e não há mensagens
                   if (!_pacientePresente) {
                        return Center(child: Text("O paciente saiu do chat."));
                   }
                  return Center(child: Text("Inicie a conversa!"));
                }

                final mensagens = snapshot.data!.docs;

                return ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemCount: mensagens.length,
                  itemBuilder: (context, index) {
                    final msgDoc = mensagens[index];
                    final msgData = msgDoc.data() as Map<String, dynamic>? ?? {};
                    final mensagemTexto =
                        msgData["mensagem"] as String? ?? "[mensagem inválida]";
                    final remetenteId = msgData["remetente"] as String?;

                    if (remetenteId == null) {
                      return SizedBox.shrink();
                    }

                    final bool isPsicologo = remetenteId == _userId;

                     // Mensagem indicando que o paciente saiu (opcional, pode ser só no appbar)
                     // if (index == mensagens.length -1 && !_pacientePresente) {
                     //     return Center(child: Padding(
                     //       padding: const EdgeInsets.all(8.0),
                     //       child: Text("--- O paciente saiu do chat ---", style: TextStyle(color: Colors.grey)),
                     //     ));
                     // }

                    return Align(
                      alignment: isPsicologo
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        decoration: BoxDecoration(
                          color: isPsicologo
                              ? Colors.blueAccent[100]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomLeft: isPsicologo
                                ? Radius.circular(12)
                                : Radius.circular(0),
                            bottomRight: isPsicologo
                                ? Radius.circular(0)
                                : Radius.circular(12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 1),
                              blurRadius: 2,
                              color: Colors.black12,
                            )
                          ]
                        ),
                        child: Text(
                          mensagemTexto,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0, top: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: _pacientePresente ? "Digite uma mensagem..." : "Paciente saiu do chat",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: _pacientePresente ? Colors.grey[200] : Colors.grey[350],
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: _pacientePresente ? (_) => _enviarMensagem() : null,
                    enabled: _pacientePresente, // Desabilita input se paciente saiu
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  mini: true,
                  onPressed: _pacientePresente ? _enviarMensagem : null, // Desabilita botão
                  child: Icon(Icons.send, color: Colors.white),
                  backgroundColor: _pacientePresente ? Colors.teal : Colors.grey, // Muda cor se desabilitado
                  elevation: _pacientePresente ? 2 : 0,
                  tooltip: _pacientePresente ? 'Enviar' : 'Paciente saiu',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}