import 'dart:convert';

import 'package:school_management_system/Classes/session.dart';
import 'package:http/http.dart' as http;

class ServiceSession {
  final String baseUrl = 'http://localhost:9000/sessions';

  //Get
  Future<List<Session>> getSessions() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return List<Session>.from(
          jsonResponse.map((model) => Session.fromJson(model)));
    } else {
      throw Exception('Failed to load sessions');
    }
  }

  //Create
 Future<Session> createSession(Session session) async {
  final response = await http.post(
    Uri.parse(baseUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(session.toJson()), // Utilise toJson() pour formater correctement les données
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    return Session.fromJson(json.decode(response.body)); // Parse la réponse en objet Session
  } else {
    throw Exception('Échec de l\'ajout de la session : ${response.body}');
  }
}

  //Delete
  Future<void> deleteSession(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Échec de la suppression de la session');
    }
  }
}
