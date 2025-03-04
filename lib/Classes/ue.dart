import 'package:school_management_system/Classes/module.dart';

class UE {
  final int? id;
  final String nomUE;
  final String codeUE;
  final int nbreCredit;
  final int? filiere;
  final int? niveau;
  final int? semestreId;
  final List<Module> modules;
  final DateTime? dateAjout;

  UE(
      {this.id,
      required this.nomUE,
      required this.codeUE,
      required this.nbreCredit,
      required this.filiere,
      required this.niveau,
      required this.semestreId,
      required this.dateAjout,
      this.modules = const []});

  factory UE.fromJson(Map<String, dynamic> json) {
    return UE(
      id: json['id'],
      nomUE: json['nomUE'],
      codeUE: json['codeUE'],
      nbreCredit: json['nbreCredit'],
      filiere: json['filiere'],
      niveau: json['niveau'],
      semestreId: json['semestreId'],
      dateAjout: DateTime.parse(json['dateAjout']),
      modules: (json['modules'] as List)
          .map((module) => Module.fromJson(module))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomUE': nomUE,
      'codeUE': codeUE,
      'nbreCredit': nbreCredit,
      'filiere': filiere,
      'niveau': niveau,
      'semestreId': semestreId,
      'dateAjout': dateAjout?.toIso8601String(),
      'modules': modules.map((module) => module.toJson()).toList(),
    };
  }
}
