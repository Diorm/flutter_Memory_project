import 'dart:convert';

import 'package:school_management_system/Classes/filiere.dart';
import 'package:http/http.dart' as http;

class FiliereService {
  final String baseUrl = 'http://localhost:9000';

  //Get
  Future<List<Filiere>> getFilieres() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/filieres'));

      if (response.statusCode == 200) {
        // Décodez la réponse JSON
        List<dynamic> jsonResponse = json.decode(response.body);

        // Convertissez chaque objet JSON en une instance de Filiere
        return jsonResponse
            .map((filiere) => Filiere.fromJson(filiere as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Erreur lors de la récupération des filières');
      }
    } catch (e) {
      print("Erreur lors de la requête : $e");
      throw Exception('Erreur lors de la récupération des filières');
    }
  }

  //Create

  Future<Filiere> createFiliere(Filiere filiere) async {
    final response = await http.post(
      Uri.parse('$baseUrl/filieres'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: json.encode(filiere.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Filiere.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Echec lors de l\'ajout  de la Filiere :${response.body}');
    }
  }

  //Delete

  Future<void> deleteFiliere(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/filieres/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });
    if (response.statusCode != 204) {
      throw Exception('Echec de la supression de la  Filiere');
    }
  }

//Exist

  Future<bool> filiereExists(String filiereName) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/filieres?nomFiliere=$filiereName'));

      if (response.statusCode == 200) {
        List<dynamic> filieres = json.decode(response.body);
        return filieres.any((filiere) => filiere['nomFiliere'] == filiereName);
      } else {
        throw Exception('Erreur lors de la vérification des filières');
      }
    } catch (e) {
      print('Erreur lors de la vérification des filières : $e');
      throw Exception('Erreur lors de la vérification des filières');
    }
  }

  ///
}
