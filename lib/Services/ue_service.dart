import 'dart:convert';
import 'dart:ffi';

import 'package:school_management_system/Classes/ue.dart';
import 'package:http/http.dart' as http;

class UeService {
  final String baseUrl = 'http://localhost:9000/ues';

  //Get
  Future<List<UE>> getUes() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return List<UE>.from(jsonResponse.map((model) => UE.fromJson(model)));
    } else {
      throw Exception('Failed to load ues');
    }
  }

  //get Ues by semestre

  Future<List<UE>> getUesBySemestre(int semestreId) async {
    final response = await http.get(Uri.parse('$baseUrl/semestre/$semestreId'));

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> data = json.decode(response.body);
      return data.map((ue) => UE.fromJson(ue)).toList();
    } else {
      throw Exception('Failed to load ues');
    }
  }

  //Create

  Future<void> addUeToSemestre(int semestreId, UE ue) async {
    final url = Uri.parse('$baseUrl/$semestreId/ue');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode(ue.toJson());

    print("Ajout d'une UE à un Semestre");
    print("URL: $url");
    print("Body: $body");

    final response = await http.post(url, headers: headers, body: body);

    print("Statut de la réponse: ${response.statusCode}");
    print("Réponse: ${response.body}");
    print("JSON envoyé : ${jsonEncode(ue.toJson())}");

    if (response.statusCode == 201 || response.statusCode == 200) {
      print("UE ajoutée avec succès !");
    } else {
      print("Erreur lors de l'ajout de l'UE : ${response.body}");
      print("Statut: ${response.statusCode}");
      throw Exception("Erreur lors de l'ajout de l'UE : ${response.body}");
    }
  }

  //Delete
  Future<void> deleteUe(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print("Response de la supression");
    print(response.body);
    print(response.statusCode);

    if (response.statusCode != 204) {
      throw Exception('Échec de la suppression de l\'ue');
    }
  }

  //Update
  Future<void> updateUE(int id, UE ue) async {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ue.toJson()),
    );
    print("Recuperation de la methode updateUE");
    print('$baseUrl/ue/$id');
    print(response.statusCode);
    print(response);
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Mise à jour réussie
      print('UE mise à jour avec succès');
    } else if (response.statusCode == 404) {
      // UE non trouvée
      print('UE non trouvée');
    } else {
      // Autre erreur
      print('Erreur lors de la mise à jour: ${response.statusCode}');
    }
  }
  // Future<UE> updateUe(UE ue) async {
  //   final response = await http.put(
  //     Uri.parse('$baseUrl/${ue.id}'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: json.encode(ue
  //         .toJson()), // Utilise toJson() pour formater correctement les données
  //   );

  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     return UE
  //         .fromJson(json.decode(response.body)); // Parse la réponse en objet UE
  //   } else {
  //     throw Exception('Échec de la mise à jour de l\'ue : ${response.body}');
  //   }
  // }

  //Get by id
  Future<UE> getUeById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return UE.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load ue');
    }
  }

  //Verification de l'existence d'une UE
  Future<bool> ueExist(String nomUe, int semestreId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/exists?nomUE=$nomUe&semestreId=$semestreId'));

    print("Réponse de l'API : ${response.body}");
    print("Code de la réponse de l'API : ${response.statusCode}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body) as bool;
    } else {
      throw Exception('Failed to load ues');
    }
  }
}
