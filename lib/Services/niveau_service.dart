import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school_management_system/Classes/niveau.dart';

class NiveauService {
  final String baseUrl = "http://localhost:9000/niveaux";

  // Récupérer les niveaux pour une filière
  Future<List<Niveau>> getNiveauxByFiliere(int filiereId) async {
    final response = await http.get(Uri.parse('$baseUrl/filiere/$filiereId'));

    print("Réponse API des niveaux  pour les filieres: ${response.body}");

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((niveau) => Niveau.fromJson(niveau)).toList();
    } else {
      throw Exception('Failed to load niveaux');
    }
  }

  Future<void> addNiveauToFiliere(int filiereId, String nomNiveau) async {
    final response = await http.post(
      Uri.parse('$baseUrl/filiere/$filiereId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'nomNiveau': nomNiveau}),
    );

    if (response.statusCode == 201) {
      print('Niveau added successfully');
    } else if (response.statusCode == 409) {
      throw Exception('This niveau already exists in the filière');
    } else {
      throw Exception('Failed to add niveau');
    }
  }

  // Mettre à jour un niveau
  Future<Niveau> updateNiveau(int id, Niveau niveau) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(niveau.toJson()),
    );

    if (response.statusCode == 200) {
      return Niveau.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update niveau');
    }
  }

  // Get all niveaux
  Future<List<Niveau>> getNiveaux() async {
    final response = await http.get(Uri.parse('$baseUrl'));

    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return List<Niveau>.from(
          jsonResponse.map((model) => Niveau.fromJson(model)));
    } else {
      throw Exception('Erreur lors de la recupération des Niveaux');
    }
  }

  // Delete a niveau
  Future<void> deleteNiveau(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
    print(
        "Réponse de l'API : ${response.statusCode}"); // Ajoutez ce log pour vérifier

    if (response.statusCode != 204) {
      throw Exception('Echec de la supression du Niveau');
    }
  }

  Future<bool> niveauExist(String niveauName, int filiereId) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/filiere/$filiereId/niveau-exist?nomNiveau=$niveauName'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as bool;
    } else {
      throw Exception("Erreur lors de la vérification du niveau");
    }
  }
}
