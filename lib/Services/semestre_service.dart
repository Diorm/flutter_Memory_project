import 'dart:convert';

import 'package:school_management_system/Classes/semestre.dart';
import 'package:http/http.dart' as http;

class SemestreService {
  final String baseUrl = "http://localhost:9000/semestres";

  //Get all semestres
  Future<List<Semestre>> getSemestres() async {
    final response = await http.get(Uri.parse('$baseUrl/semestres'));

    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return List<Semestre>.from(
          jsonResponse.map((model) => Semestre.fromJson(model)));
    } else {
      throw Exception('Erreur lors de la recupération des Semestres');
    }
  }

  //Get semestres by filiere
  Future<List<Semestre>> getSemestreByNiveau(int niveauId) async {
    final response = await http.get(Uri.parse('$baseUrl/niveau/$niveauId'));
    print("Réponse de l'API : ${response.body}");
    print("URL de l'API : $baseUrl/semestres/semestre/$niveauId");

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> data = json.decode(response.body);
      return data.map((semestre) => Semestre.fromJson(semestre)).toList();
    } else {
      throw Exception('Failed to load semestres');
    }
  }

  //Create semestre
  Future<void> addSemestreToNiveau(int niveauId, String nomSemestre) async {
    final response = await http.post(
      Uri.parse('$baseUrl/niveau/$niveauId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'nomSemestre': nomSemestre}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Semestre added successfully');
    } else if (response.statusCode == 409) {
      throw Exception('Ce semestre existe dèjà dans le niveau 🙄🙄🙄');
    } else {
      throw Exception('Failed to add Semestre');
    }
  }

  //Delete semestre
  Future<void> deleteSemestre(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/semestres/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });

    if (response.statusCode != 204) {
      throw Exception("Échec de la suppression du semestre");
    }
  }

  //Update semestre
  Future<void> updateSemestre(Semestre semestre) async {
    final body = jsonEncode(semestre.toJson());
    print("Envoi des données : $body");

    final response = await http.put(
      Uri.parse('$baseUrl/semestres/${semestre.id}'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception("Échec de la mise à jour du semestre");
    }
  }

  Future<bool> semestreExist(String semestreName, int niveauId) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/niveau/$niveauId/semestre-exist?nomSemestre=$semestreName'),
    );

    print("Status Code: ${response.statusCode}"); // Ajoutez ceci pour déboguer
    print("Response Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body) as bool;
    } else {
      throw Exception("Erreur lors de la vérification du semestre");
    }
  }
}
