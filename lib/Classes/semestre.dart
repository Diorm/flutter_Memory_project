import 'package:school_management_system/Classes/ue.dart';

class Semestre {
  final int? id;
  final String nomSemestre;
  final int? niveauId;
  final List<UE> ues;

  Semestre(
      {this.id, required this.nomSemestre, this.niveauId, this.ues = const []});

  factory Semestre.fromJson(Map<String, dynamic> json) {
    return Semestre(
      id: json['id'],
      nomSemestre: json['nomSemestre'],
      niveauId: json['niveauId'],
      ues: (json['ues'] as List).map((ue) => UE.fromJson(ue)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomSemestre': nomSemestre,
      'niveau': {'id': niveauId}, // Envoyez un objet niveau avec id
      'ues': ues.map((ue) => ue.toJson()).toList(),
    };
  }
}
