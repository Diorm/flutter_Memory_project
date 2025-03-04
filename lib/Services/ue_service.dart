import 'dart:convert';

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
    print("Réponse de l'API : ${response.body}");
    print("Code de la réponse de l'API : ${response.statusCode}");
    print("URL de l'API : $baseUrl/semestre/$semestreId");

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> data = json.decode(response.body);
      return data.map((ue) => UE.fromJson(ue)).toList();
    } else {
      throw Exception('Failed to load ues');
    }
  }

  //Create
  // Future<void> addUeToSemestre(int semestreId, String nomUe) async {
  //   final response = await http.post(
  //     Uri.parse('$baseUrl/semestre/$semestreId'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode({'nomUe': nomUe}),
  //   );

  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     print("UE ajoutée avec succès");
  //   } else if (response.statusCode == 400) {
  //     throw Exception('L\'UE existe déjà');
  //   } else {
  //     throw Exception('Échec de l\'ajout de l\'ue');
  //   }
  // }
  Future<void> addUeToSemestre(int semestreId, UE ue) async {
    final response = await http.post(
      Uri.parse('$baseUrl/semestre/$semestreId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nomUE': ue.nomUE,
        'codeUE': ue.codeUE,
        'nbreCredit': ue.nbreCredit,
        'filiere': ue.filiere, // ID ou objet JSON valide
        'semestreId': ue.semestreId,
        'dateAjout': ue.dateAjout?.toIso8601String(),
        'niveau': ue.niveau, // Doit être un ID ou un objet JSON
      }),
    );

    if (response.statusCode == 201) {
      print("UE ajoutée avec succès");
    } else if (response.statusCode == 409) {
      throw Exception("L'UE existe déjà");
    } else {
      throw Exception("Échec de l'ajout de l'UE");
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

    if (response.statusCode != 204) {
      throw Exception('Échec de la suppression de l\'ue');
    }
  }

  //Update
  Future<UE> updateUe(UE ue) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${ue.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(ue
          .toJson()), // Utilise toJson() pour formater correctement les données
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return UE
          .fromJson(json.decode(response.body)); // Parse la réponse en objet UE
    } else {
      throw Exception('Échec de la mise à jour de l\'ue : ${response.body}');
    }
  }

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
        .get(Uri.parse('$baseUrl/semestre/$semestreId/ue-exist?nomUE=$nomUe'));

    print("Réponse de l'API : ${response.body}");
    print("Code de la réponse de l'API : ${response.statusCode}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body) as bool;
    } else {
      throw Exception('Failed to load ues');
    }
  }
}
