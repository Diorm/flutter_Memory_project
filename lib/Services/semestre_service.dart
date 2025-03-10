import 'dart:convert';

import 'package:school_management_system/Classes/filiere.dart';
import 'package:school_management_system/Classes/semestre.dart';
import 'package:http/http.dart' as http;

class SemestreService {
  final String baseUrl = "http://localhost:9000/semestres";

  //Get all semestres
  Future<List<Semestre>> getSemestres() async {
    final response = await http.get(Uri.parse(baseUrl)); // Utilise baseUrl

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      // Débogage : Affiche les données reçues
      print("Données reçues : $data");

      // Convertit les données en objets Semestre
      return data.map((json) => Semestre.fromJson(json)).toList();
    } else {
      throw Exception('Échec du chargement des semestres');
    }
  }

  //Get semestres by Niveau
  Future<List<Semestre>> getSemestreByNiveau(int niveauId) async {
    final response = await http.get(Uri.parse('$baseUrl/niveau/$niveauId'));

    print("Réponse de l'API : ${response.body}");

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((semestre) => Semestre.fromJson(semestre)).toList();
    } else {
      throw Exception(
          'Échec du chargement des semestres pour le niveau $niveauId');
    }
  }

  //Create semestre
  Future<void> addSemestreToNiveau(
      int niveauId, String nomSemestre, Filiere filiere) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$niveauId/semestre'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nomSemestre': nomSemestre,
          'niveau': {'id': niveauId},
          'filiere': filiere.toJson(), // Inclure la filière dans la requête
        }),
      );
      print("Ajout de Semestre a un niveau");
      print(response.statusCode);

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Semestre ajouté avec succès');
      } else if (response.statusCode == 409) {
        throw Exception('Ce semestre existe déjà dans le niveau');
      } else {
        throw Exception('Échec de l\'ajout du semestre : ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout du semestre : $e');
    }
  }

  //Delete semestre
  Future<void> deleteSemestre(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'), // Utilise baseUrl directement
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 204) {
      throw Exception("Échec de la suppression du semestre : ${response.body}");
    }
  }

  //Update semestre
  Future<void> updateSemestre(Semestre semestre) async {
    final body = jsonEncode(semestre.toJson());
    print("Données envoyées : $body");

    final response = await http.put(
      Uri.parse('$baseUrl/${semestre.id}'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception("Échec de la mise à jour du semestre : ${response.body}");
    }
  }

  Future<bool> semestreExist(String semestreName, int niveauId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/exists?nomSemestre=$semestreName&niveauId=$niveauId'),
      );

      print("Statut de la réponse : ${response.statusCode}");
      print("Réponse du serveur : ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as bool;
      } else {
        throw Exception(
            "Erreur lors de la vérification du semestre : ${response.body}");
      }
    } catch (e) {
      throw Exception("Erreur lors de la vérification du semestre : $e");
    }
  }
}
