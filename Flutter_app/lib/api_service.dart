import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:5000";
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<Map<String, dynamic>> register(
    String username,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 201) {
      await _db.collection("usuarios").add({
        "username": username,
        "email": email,
      });
    }

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    return jsonDecode(response.body);
  }

    static Future<Map<String, dynamic>> registerPsicologo(
    String username,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register_psicologo"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
        }),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        await _db.collection("psicologos").add({
          "username": username,
          "email": email,
        });

        return jsonDecode(response.body);
      } else {
        return {"error": "Erro ao cadastrar. Status: ${response.statusCode}"};
      }
    } catch (e) {
      print("Erro ao registrar psicólogo: $e");
      return {"error": "Erro de conexão"};
    }
  }


  static Future<Map<String, dynamic>> loginPsicologo(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login_psicologo"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    return jsonDecode(response.body);
  }

  static Future<bool> entrarNaFila(String token) async {
    final response = await http.post(
      Uri.parse("$baseUrl/entrar_fila"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    return response.statusCode == 201;
  }

  static Future<bool> sairDaFila(String token) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/sair_fila"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    return response.statusCode == 200;
  }

  // Salvar entrada no diário
  static Future<bool> salvarEntradaDiario(String texto) async {
    try {
      await _db.collection("diario").add({
        "content": texto,
        "timestamp": FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print("Erro ao salvar entrada: $e");
      return false;
    }
  }

  // Carregar entradas do diário
  static Future<List<Map<String, dynamic>>> carregarEntradasDiario() async {
    try {
      QuerySnapshot snapshot = await _db
          .collection("diario")
          .orderBy("timestamp", descending: true)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return {
          "id": doc.id,
          "content": data["content"] ?? "Sem conteúdo",
          "timestamp": data["timestamp"] != null
              ? data["timestamp"].toDate().toString()
              : "Sem data",
        };
      }).toList();
    } catch (e) {
      print("Erro ao carregar entradas: $e");
      return [];
    }
  }

  static Future<bool> deletarEntradaDiario(String id) async {
    try {
      await _db.collection("diario").doc(id).delete();
      return true;
    } catch (e) {
      print("Erro ao excluir entrada: $e");
      return false;
    }
  }

  static Future<bool> atualizarEntradaDiario(String id, String novoTexto) async {
  try {
    await _db.collection("diario").doc(id).update({
      "content": novoTexto,
      "timestamp": FieldValue.serverTimestamp(), // Atualiza o timestamp, se desejar
    });
    return true;
  } catch (e) {
    print("Erro ao atualizar entrada: $e");
    return false;
  }
}

}
