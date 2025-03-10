import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:school_management_system/Classes/filiere.dart';
import 'package:school_management_system/Classes/niveau.dart';
import 'package:school_management_system/Classes/semestre.dart';
import 'package:http/http.dart' as http;
import 'package:school_management_system/Classes/ue.dart';

import 'package:school_management_system/Services/ue_service.dart';

class AddUEPage extends StatefulWidget {
  @override
  _AddUEPageState createState() => _AddUEPageState();
}

class _AddUEPageState extends State<AddUEPage> {
  final _formKey = GlobalKey<FormState>();

  String _nomUE = '';
  String _codeUE = '';
  int _nbreCredit = 0;
  Filiere? _filiereSelectionnee;
  Niveau? _niveauSelectionne;
  Semestre? _semestreSelectionne;

  List<Filiere> _filieres = [];
  List<Niveau> _niveaux = [];
  List<Semestre> _semestres = [];

  final String baseUrl = 'http://localhost:9000';

  @override
  void initState() {
    super.initState();
    _loadFilieres();
  }

  // Méthodes pour récupérer les données depuis l'API
  Future<void> _loadFilieres() async {
    try {
      final filieres = await getFilieres();
      setState(() {
        _filieres = filieres;
      });
    } catch (e) {
      print("Erreur lors du chargement des filières : $e");
      // Gérer l'erreur (afficher un message à l'utilisateur, etc.)
    }
  }

  Future<void> _loadNiveaux(int filiereId) async {
    try {
      final niveaux = await getNiveauxByFiliere(filiereId);
      setState(() {
        _niveaux = niveaux;
        // Réinitialiser les semestres lorsque le niveau change
        _semestres = [];
        _niveauSelectionne = null;
        _semestreSelectionne = null;
      });
    } catch (e) {
      print("Erreur lors du chargement des niveaux : $e");
      // Gérer l'erreur
    }
  }

  Future<void> _loadSemestres(int niveauId) async {
    try {
      final semestres = await getSemestreByNiveau(niveauId);
      setState(() {
        _semestres = semestres;
        _semestreSelectionne = null;
      });
    } catch (e) {
      print("Erreur lors du chargement des semestres : $e");
      // Gérer l'erreur
    }
  }

  // API calls
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

  Future<List<Niveau>> getNiveauxByFiliere(int filiereId) async {
    final url = Uri.parse('$baseUrl/niveaux/filiere/$filiereId');
    print('URL de l\'API : $url');

    final response = await http.get(url);
    print('Réponse API : ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((niveau) => Niveau.fromJson(niveau)).toList();
    } else {
      throw Exception('Failed to load niveaux');
    }
  }

  Future<List<Semestre>> getSemestreByNiveau(int niveauId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/semestres/niveau/$niveauId'));

    print("Réponse de l'API : ${response.body}");

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((semestre) => Semestre.fromJson(semestre)).toList();
    } else {
      throw Exception(
          'Échec du chargement des semestres pour le niveau $niveauId');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une UE'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom de l\'UE'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom de l\'UE';
                  }
                  return null;
                },
                onSaved: (value) => _nomUE = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Code de l\'UE'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le code de l\'UE';
                  }
                  return null;
                },
                onSaved: (value) => _codeUE = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre de crédits'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nombre de crédits';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
                onSaved: (value) => _nbreCredit = int.parse(value!),
              ),
              DropdownButtonFormField<Filiere>(
                decoration: InputDecoration(labelText: 'Filière'),
                value: _filiereSelectionnee,
                items: _filieres.map((filiere) {
                  return DropdownMenuItem<Filiere>(
                    value: filiere,
                    child: Text(filiere.nomFiliere),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _filiereSelectionnee = value;
                    // Charger les niveaux lorsque la filière change
                    if (value != null) {
                      _loadNiveaux(value.id!);
                    } else {
                      // Réinitialiser les niveaux et semestres si aucune filière n'est sélectionnée
                      _niveaux = [];
                      _semestres = [];
                      _niveauSelectionne = null;
                      _semestreSelectionne = null;
                    }
                  });
                },
                validator: (value) =>
                    value == null ? 'Veuillez sélectionner une filière' : null,
              ),
              DropdownButtonFormField<Niveau>(
                decoration: InputDecoration(labelText: 'Niveau'),
                value: _niveauSelectionne,
                items: _niveaux.map((niveau) {
                  return DropdownMenuItem<Niveau>(
                    value: niveau,
                    child: Text(niveau.nomNiveau),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _niveauSelectionne = value;
                    // Charger les semestres lorsque le niveau change
                    if (value != null) {
                      _loadSemestres(value.id!);
                    } else {
                      // Réinitialiser les semestres si aucun niveau n'est sélectionné
                      _semestres = [];
                      _semestreSelectionne = null;
                    }
                  });
                },
                validator: (value) =>
                    value == null ? 'Veuillez sélectionner un niveau' : null,
              ),
              DropdownButtonFormField<Semestre>(
                decoration: InputDecoration(labelText: 'Semestre'),
                value: _semestreSelectionne,
                items: _semestres.map((semestre) {
                  return DropdownMenuItem<Semestre>(
                    value: semestre,
                    child: Text(semestre.nomSemestre),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _semestreSelectionne = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Veuillez sélectionner un semestre' : null,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Créer l'objet UE
                    final newUE = UE(
                      nomUE: _nomUE,
                      codeUE: _codeUE,
                      nbreCredit: _nbreCredit,
                      filiere: _filiereSelectionnee,
                      niveau: _niveauSelectionne,
                      semestre: _semestreSelectionne,
                      dateAjout: DateTime.now(),
                    );
                   

                    await UeService()
                        .addUeToSemestre(_semestreSelectionne!.id, newUE);
                    // Envoyer l'objet UE à votre API (à implémenter)
                    print(newUE.toJson());
                    // Pour le débogage
                  }
                },
                child: Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
