import 'package:school_management_system/Classes/filiere.dart';
import 'package:school_management_system/Classes/niveau.dart';
import 'package:school_management_system/Classes/ue.dart';

class Semestre {
  final int id;
  final String nomSemestre;
  final Niveau niveau;
  final Filiere filiere;
  final List<UE> ues;

  Semestre({
    required this.id,
    required this.nomSemestre,
    required this.niveau,
    required this.filiere,
    this.ues = const [],
  });

  factory Semestre.fromJson(Map<String, dynamic> json) {
    return Semestre(
      id: json['id'],
      nomSemestre: json['nomSemestre'],
      niveau: Niveau.fromJson(json['niveau']), // Correction ici
      filiere: Filiere.fromJson(json['filiere']), // Correction ici
      ues: (json['ues'] as List?)?.map((ue) => UE.fromJson(ue)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomSemestre': nomSemestre,
      'niveau': niveau.toJson(), // Correction ici
      'filiere': filiere.toJson(), // Correction ici
      'ues': ues.map((ue) => ue.toJson()).toList(),
    };
  }
}
