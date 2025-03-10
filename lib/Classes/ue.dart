import 'package:school_management_system/Classes/filiere.dart';
import 'package:school_management_system/Classes/module.dart';
import 'package:school_management_system/Classes/niveau.dart';
import 'package:school_management_system/Classes/semestre.dart';

class UE {
  final int? id;
  final String nomUE;
  final String codeUE;
  final int nbreCredit;
  final Filiere? filiere;
  final Niveau? niveau;
  final Semestre? semestre;
  final List<Module> modules;
  final DateTime? dateAjout;

  UE({
    this.id,
    required this.nomUE,
    required this.codeUE,
    required this.nbreCredit,
    required this.filiere,
    required this.niveau,
    required this.semestre,
    required this.dateAjout,
    this.modules = const [],
  });

  
  factory UE.fromJson(Map<String, dynamic> json) {
    return UE(
      id: json['id'],
      nomUE: json['nomUE'] ?? "Nom inconnu",
      codeUE: json['codeUE'] ?? "Code inconnu",
      nbreCredit: json['nbreCredit'] ?? 0,
      filiere:
          json['filiere'] != null ? Filiere.fromJson(json['filiere']) : null,
      niveau: json['niveau'] != null ? Niveau.fromJson(json['niveau']) : null,
      semestre:
          json['semestre'] != null ? Semestre.fromJson(json['semestre']) : null,
      dateAjout: json['dateAjout'] != null
          ? DateTime.tryParse(json['dateAjout'])
          : null,
      modules: (json['modules'] != null)
          ? (json['modules'] as List)
              .map((module) => Module.fromJson(module))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nomUE': nomUE,
      'codeUE': codeUE,
      'nbreCredit': nbreCredit,
      'filiere': {'id': filiere?.id},
      'niveau': {'id': niveau?.id},
      'semestre': {'id': semestre?.id},
      'dateAjout': dateAjout != null
          ? dateAjout!.toIso8601String().substring(0, 23) // Garde 3 décimales
          : null,
      'modules': modules.map((module) => module.toJson()).toList(),
    };
  }
}
// factory UE.fromJson(Map<String, dynamic> json) {
  //   return UE(
  //     id: json['id'],
  //     nomUE: json['nomUE'],
  //     codeUE: json['codeUE'],
  //     nbreCredit: json['nbreCredit'],
  //     filiere:
  //         Filiere.fromJson(json['filiere']), // Désérialiser l'objet Filiere
  //     niveau: Niveau.fromJson(json['niveau']), // Désérialiser l'objet Niveau
  //     semestre:
  //         Semestre.fromJson(json['semestre']), // Désérialiser l'objet Semestre
  //     dateAjout: DateTime.parse(json['dateAjout']),
  //     modules: (json['modules'] as List)
  //         .map((module) => Module.fromJson(module))
  //         .toList(),
  //   );
  // }