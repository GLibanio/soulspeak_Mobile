import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'video_call.dart';

class UsuarioChatScreen extends StatefulWidget {
  final String token;

  const UsuarioChatScreen({required this.token, Key? key}) : super(key: key);

  @override
  _UsuarioChatScreenState createState() => _UsuarioChatScreenState();
}

class _UsuarioChatScreenState extends State<UsuarioChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _controller = TextEditingController();

  String? userId;
  String? userName;
  bool estaNaFila = false;
  String? chatId;
  bool _exibirPopupVideochamada = false;
  bool _processandoAcao = false;

  @override
  void initState() {
    super.initState();
    _verificarEstadoUsuario();
  }

  void _verificarEstadoUsuario() async {
    final user = _auth.currentUser;
    if (user == null) {
      print("Erro: Usuário não autenticado.");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mostrarErro("Sua sessão expirou. Faça login novamente.");
         if(mounted) {
            Navigator.of(context).popUntil((route) => route.isFirst);
         }
      });
      return;
    }

    String? fetchedUserName = user.displayName;
    if (fetchedUserName == null || fetchedUserName.isEmpty) {
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists && userDoc.data() != null) {
          final userData = userDoc.data() as Map<String, dynamic>;
          fetchedUserName = userData['nome'] ?? "Paciente";
        } else {
          fetchedUserName = "Paciente";
        }
      } catch (e) {
        print("Erro ao buscar nome do usuário no Firestore: $e");
        fetchedUserName = "Paciente";
      }
    }

    if (mounted) {
      setState(() {
        userId = user.uid;
        userName = fetchedUserName;
      });
    } else {
      return;
    }

    try {
      final doc = await _firestore.collection('fila_espera').doc(user.uid).get();
      if (mounted) {
        setState(() => estaNaFila = doc.exists);
      }

      _firestore
          .collection('fila_espera')
          .doc(user.uid)
          .snapshots()
          .listen((doc) {
        if (mounted) {
          final naFilaAgora = doc.exists;
          if (estaNaFila && !naFilaAgora) {
            print("Usuário removido da fila, verificando chat...");
          }
          setState(() => estaNaFila = naFilaAgora);
        }
      }, onError: (error) {
        print("Erro ao escutar fila_espera: $error");
        if (mounted) _mostrarErro("Erro de conexão com a fila.");
      });
    } catch (e) {
      print("Erro ao verificar fila inicial: $e");
      if (mounted) _mostrarErro("Erro ao verificar status da fila.");
    }

    _firestore
        .collection('chats')
        .where('pacienteId', isEqualTo: user.uid)
        .snapshots()
        .listen((snapshot) {
      if (mounted) {
        if (snapshot.docs.isNotEmpty) {
          final chatDoc = snapshot.docs.first;
          // Verifica se o paciente não marcou que saiu anteriormente
          final chatData = chatDoc.data();
          final pacienteJaSaiu = chatData['pacienteSaiu'] ?? false;

          if (!pacienteJaSaiu) {
              setState(() {
                  chatId = chatDoc.id;
                  estaNaFila = false;
              });
              print("Chat ativo encontrado: $chatId para paciente $userId");
              _ouvirSolicitacoesDeVideochamada();
           } else {
                // Se a flag pacienteSaiu é true, o paciente não deve reentrar automaticamente
                print("Chat $chatId encontrado, mas paciente marcou saída anteriormente.");
                 if (chatId != null) { // Se já estava com um chatId, anula
                     setState(() => chatId = null);
                 }
           }

        } else {
          if (chatId != null) {
            print("Chat $chatId não encontrado mais. Voltando para a fila/inicial.");
          }
          setState(() => chatId = null);
        }
      }
    }, onError: (error) {
      print("Erro ao escutar coleção 'chats': $error");
      if (mounted) _mostrarErro("Erro de conexão com o chat.");
    });
  }

  Future<void> _entrarNaFila() async {
    if (userId == null || _processandoAcao) return;
    if (mounted) setState(() => _processandoAcao = true);

    try {
      await _firestore.collection('fila_espera').doc(userId).set({
        "userId": userId,
        "nome": userName ?? "Paciente Anônimo",
        "timestamp": FieldValue.serverTimestamp(),
      });
      if (mounted) {
        setState(() => estaNaFila = true);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Você entrou na fila de espera."),
            backgroundColor: Colors.green));
      }
    } catch (e) {
      print("Erro ao entrar na fila: $e");
      _mostrarErro("Não foi possível entrar na fila. Tente novamente.");
    } finally {
      if (mounted) setState(() => _processandoAcao = false);
    }
  }

  Future<void> _sairDaFila() async {
    if (userId == null || _processandoAcao) return;
    if (mounted) setState(() => _processandoAcao = true);

    try {
      await _firestore.collection('fila_espera').doc(userId).delete();
      if (mounted) {
        setState(() => estaNaFila = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Você saiu da fila."),
            backgroundColor: Colors.orange));
      }
    } catch (e) {
      print("Erro ao sair da fila: $e");
      _mostrarErro("Não foi possível sair da fila. Tente novamente.");
    } finally {
      if (mounted) setState(() => _processandoAcao = false);
    }
  }

  Future<void> _aceitarVideochamada() async {
    if (chatId == null || userId == null || _processandoAcao) return;
    if (mounted) setState(() => _processandoAcao = true);

    try {
      await _firestore.collection('chats').doc(chatId!).update({
        "pacienteAceitouVideo": true,
      });
      print("Paciente ($userId) aceitou videochamada no chat $chatId. Atualizando Firestore.");

      if (_exibirPopupVideochamada && mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoCallScreen(
              userId: userId!,
              userName: userName ?? "Paciente",
              callId: chatId!,
            ),
          ),
        );
        setState(() => _exibirPopupVideochamada = false);
      }
    } catch (e) {
      print("Erro ao aceitar videochamada: $e");
      try {
        await FirebaseFirestore.instance
            .collection('chats')
            .doc(chatId!)
            .update({
          "pacienteAceitouVideo": false,
        });
      } catch (resetError) {
        print("Erro ao resetar flag de aceite após falha: $resetError");
      }
      if (mounted)
        _mostrarErro("Erro ao iniciar a videochamada. Tente novamente.");
    } finally {
      if (mounted) setState(() => _processandoAcao = false);
    }
  }

  Future<void> _recusarVideochamada() async {
    if (chatId == null || _processandoAcao) return;
    if (mounted) setState(() => _processandoAcao = true);

    try {
      if (_exibirPopupVideochamada && mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      await _firestore.collection('chats').doc(chatId!).update({
        "recusaVideo": true,
        "solicitacaoVideo": false,
        "pacienteAceitouVideo": false,
      });
      print("Paciente ($userId) recusou videochamada no chat $chatId.");

      if (mounted) {
        setState(() => _exibirPopupVideochamada = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Chamada de vídeo recusada."),
            backgroundColor: Colors.orange));
      }
    } catch (e) {
      print("Erro ao recusar a chamada de vídeo: $e");
      if (mounted) _mostrarErro("Erro ao recusar a chamada. Tente novamente.");
    } finally {
      if (mounted) setState(() => _processandoAcao = false);
    }
  }

  void _ouvirSolicitacoesDeVideochamada() {
    if (chatId == null) return;

    _firestore.collection('chats').doc(chatId!).snapshots().listen((doc) {
      if (doc.exists && mounted) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        final solicitacaoPendente = data['solicitacaoVideo'] ?? false;
        final recusaRegistrada = data['recusaVideo'] ?? false;
        final aceiteRegistrado = data['pacienteAceitouVideo'] ?? false;
        final pacienteJaSaiu = data['pacienteSaiu'] ?? false;

        // Não mostra popup se o paciente já saiu
        if (pacienteJaSaiu) {
             if (_exibirPopupVideochamada) {
                 Navigator.of(context, rootNavigator: true).pop();
                 setState(() => _exibirPopupVideochamada = false);
             }
             return;
        }

        if (solicitacaoPendente &&
            !recusaRegistrada &&
            !aceiteRegistrado &&
            !_exibirPopupVideochamada) {
          setState(() => _exibirPopupVideochamada = true);
          _mostrarPopupVideochamada();
          print("Solicitação de vídeo recebida para chat $chatId. Exibindo popup.");
        }
      } else if (!doc.exists && mounted) {
        print("Chat $chatId não existe mais (encerrado pelo psicólogo).");
        setState(() => chatId = null);
        _mostrarErro("A conversa foi encerrada pelo psicólogo.");
        if (_exibirPopupVideochamada) {
          Navigator.of(context, rootNavigator: true).pop();
          setState(() => _exibirPopupVideochamada = false);
        }
      }
    }, onError: (error) {
      print("Erro ao escutar solicitações de vídeo para $chatId: $error");
      if (mounted) {
        _mostrarErro("Erro de conexão ao verificar chamadas de vídeo.");
      }
    });
  }

  void _mostrarPopupVideochamada() {
    if (!mounted || !_exibirPopupVideochamada) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Chamada de Vídeo"),
        content: const Text(
          "O psicólogo está iniciando uma videochamada. Deseja atender?",
        ),
        actions: [
          TextButton(
            onPressed: _processandoAcao ? null : () {
                _recusarVideochamada();
              },
            child: const Text(
              "Recusar",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
          ElevatedButton(
            onPressed: _processandoAcao ? null : () {
                _aceitarVideochamada();
              },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal[400],
              foregroundColor: Colors.white,
            ),
            child: _processandoAcao
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Text("Atender"),
          ),
        ],
      ),
    ).then((_) {
      if (mounted && _exibirPopupVideochamada) {
        print("Popup de vídeo fechado. Resetando flag _exibirPopupVideochamada.");
        setState(() => _exibirPopupVideochamada = false);
      }
    });
  }

  Future<void> _enviarMensagem() async {
    final textoMensagem = _controller.text.trim();
    if (textoMensagem.isEmpty || chatId == null || userId == null) return;

    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('mensagens')
          .add({
        "remetente": userId,
        "mensagem": textoMensagem,
        "timestamp": FieldValue.serverTimestamp(),
      });
      _controller.clear();
      print("Mensagem enviada pelo paciente $userId no chat $chatId");
    } catch (e) {
      print("Erro ao enviar mensagem: $e");
      _mostrarErro("Erro ao enviar a mensagem.");
    }
  }

   Future<void> _sairDoChatPeloPaciente() async {
       if (chatId == null || _processandoAcao) return;

        final confirmar = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
                title: Text("Sair do Chat"),
                content: Text("Tem certeza que deseja sair desta conversa? Você precisará entrar na fila novamente para ser atendido."),
                actions: [
                    TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text("Cancelar")),
                    TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text("Sair", style: TextStyle(color: Colors.orange))),
                ],
            ),
        );

        if (confirmar == true) {
             if (mounted) setState(() => _processandoAcao = true);
             try {
                // Atualiza o documento do chat para indicar que o paciente saiu
                await _firestore.collection('chats').doc(chatId!).update({
                    "pacienteSaiu": true,
                    // Opcional: adicionar uma mensagem do sistema?
                });
                print("Paciente ($userId) marcou saída do chat $chatId.");

                // Remove o paciente da interface de chat localmente
                if (mounted) {
                    setState(() {
                        chatId = null; // Isso fará a UI voltar para _buildFilaInterface
                         // Resetar flags de vídeo locais, se houver
                         _exibirPopupVideochamada = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Você saiu do chat."),
                        backgroundColor: Colors.orange)
                    );
                }

             } catch (e) {
                print("Erro ao sair do chat pelo paciente: $e");
                if (mounted) _mostrarErro("Erro ao tentar sair do chat.");
             } finally {
                if (mounted) setState(() => _processandoAcao = false);
             }
        }
   }

  void _mostrarErro(String mensagem) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(mensagem),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 3),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        title: Text(
          chatId != null ? "Chat com Psicólogo" : "Fila de Atendimento",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: chatId != null
            ? [
                IconButton(
                  icon: const Icon(Icons.exit_to_app, color: Colors.white),
                  onPressed: _sairDoChatPeloPaciente,
                  tooltip: "Sair do Chat",
                ),
              ]
            : null,
      ),
      body: chatId != null ? _buildChatInterface() : _buildFilaInterface(),
    );
  }

  Widget _buildFilaInterface() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                estaNaFila ? Icons.hourglass_top_rounded : Icons.meeting_room_outlined,
                size: 80,
                color: Colors.teal[300]),
            const SizedBox(height: 20),
            Text(
              estaNaFila
                  ? "Você está na fila de espera.\nAguarde, um psicólogo irá chamá-lo em breve."
                  : "Toque abaixo para entrar na fila de atendimento.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey[800], height: 1.4),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: Icon(estaNaFila ? Icons.exit_to_app : Icons.group_add, size: 20),
              label: Text(
                estaNaFila ? "Sair da Fila" : "Entrar na Fila",
                style: const TextStyle(fontSize: 16),
              ),
              onPressed: _processandoAcao ? null : (estaNaFila ? _sairDaFila : _entrarNaFila),
              style: ElevatedButton.styleFrom(
                backgroundColor: estaNaFila ? Colors.orangeAccent[700] : Colors.teal[400],
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 3,
              ),
            ),
            if (_processandoAcao) ...[
              const SizedBox(height: 15),
              const CircularProgressIndicator(),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildChatInterface() {
    if (chatId == null) {
      return _buildFilaInterface();
    }
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('chats')
                .doc(chatId)
                .collection('mensagens')
                .orderBy('timestamp', descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.teal),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("Aguardando mensagens do psicólogo..."),
                );
              }
              if (snapshot.hasError) {
                print(
                    "Erro no StreamBuilder de mensagens (paciente): ${snapshot.error}");
                return Center(child: Text("Erro ao carregar mensagens"));
              }

              final mensagens = snapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: mensagens.length,
                itemBuilder: (context, index) {
                  final msgDoc = mensagens[index];
                  final msgData =
                      msgDoc.data() as Map<String, dynamic>? ?? {};
                  final mensagemTexto =
                      msgData["mensagem"] as String? ?? "[mensagem inválida]";
                  final remetenteId = msgData["remetente"] as String?;

                  if (remetenteId == null) return SizedBox.shrink();

                  final bool isUsuario = remetenteId == userId;

                  return Align(
                    alignment: isUsuario
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: isUsuario ? Colors.teal[200] : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft:
                              isUsuario ? Radius.circular(20) : Radius.circular(0),
                          bottomRight:
                              isUsuario ? Radius.circular(0) : Radius.circular(20),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        mensagemTexto,
                        style: TextStyle(
                          color: isUsuario ? Colors.white : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        _buildInputArea(),
      ],
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -1),
              blurRadius: 4,
              color: Colors.black.withOpacity(0.05),
            )
          ]),
      child: SafeArea(
          child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Digite sua mensagem...",
                filled: true,
                fillColor: Colors.blueGrey[50],
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
              minLines: 1,
              maxLines: 5,
              onSubmitted: (_) => _enviarMensagem(),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            mini: true,
            onPressed: _enviarMensagem,
            child: const Icon(Icons.send, color: Colors.white, size: 18),
            backgroundColor: Colors.teal,
            tooltip: 'Enviar Mensagem',
            elevation: 2,
          )
        ],
      )),
    );
  }
}