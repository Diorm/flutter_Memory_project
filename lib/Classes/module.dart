import 'package:school_management_system/Classes/filiere.dart';
import 'package:school_management_system/Classes/niveau.dart';
import 'package:school_management_system/Classes/note.dart';
import 'package:school_management_system/Classes/semestre.dart';
import 'package:school_management_system/Classes/ue.dart';

class Module {
  final int? id;
  final String nomModule;
  final int volumeHoraire; // Volume horaire du module
  final Filiere? filiere; // Filière associée
  final Niveau? niveau; // Niveau associé
  final Semestre? semestre; // Semestre associé
  final UE? ue; // UE associée
  final List<Note> notes; // Liste des notes associées
  final DateTime? dateAjout;

  Module({
    this.id,
    required this.nomModule,
    required this.volumeHoraire,
    this.dateAjout,
    this.filiere,
    this.niveau,
    this.semestre,
    this.ue,
    this.notes = const [], // Liste des notes initialisée par défaut
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'],
      nomModule: json['nomModule'] ?? "Nom inconnu",
      volumeHoraire: json['volumeHoraire'] ?? 0,
      dateAjout: json['dateAjout'] != null
          ? DateTime.tryParse(json['dateAjout'])
          : null,
      filiere:
          json['filiere'] != null ? Filiere.fromJson(json['filiere']) : null,
      niveau: json['niveau'] != null ? Niveau.fromJson(json['niveau']) : null,
      semestre:
          json['semestre'] != null ? Semestre.fromJson(json['semestre']) : null,
      ue: json['ue'] != null ? UE.fromJson(json['ue']) : null,
      notes: (json['notes'] != null)
          ? (json['notes'] as List).map((note) => Note.fromJson(note)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomModule': nomModule,
      'volumeHoraire': volumeHoraire,
      'dateAjout': dateAjout?.toIso8601String(),
      'filiere': filiere?.toJson(),
      'niveau': niveau?.toJson(),
      'semestre': semestre?.toJson(),
      'ue': ue?.toJson(),
      'notes': notes.map((note) => note.toJson()).toList(),
    };
  }
}
