import 'package:school_management_system/Classes/semestre.dart';

class Niveau {
  final int? id;
  final String nomNiveau;
  final int? filiereId;
  final List<Semestre> semestres;

  Niveau({
    this.id,
    required this.nomNiveau,
    this.filiereId,
    this.semestres = const [],
  });

  factory Niveau.fromJson(Map<String, dynamic> json) {
    return Niveau(
      id: json['id'],
      nomNiveau: json['nomNiveau'],
      filiereId: json['filiere']?['id'], // ✅ Correction ici
      semestres: (json['semestres'] != null)
          ? (json['semestres'] as List)
              .map((semestre) => Semestre.fromJson(semestre))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomNiveau': nomNiveau,
      'filiereId': filiereId,
      'semestres': semestres.map((semestre) => semestre.toJson()).toList(),
    };
  }
}
