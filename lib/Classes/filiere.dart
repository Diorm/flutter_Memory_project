import 'package:school_management_system/Classes/niveau.dart';

class Filiere {
  final int? id;
  final String nomFiliere;
  final List<Niveau> niveaux;

  Filiere({this.id, required this.nomFiliere, this.niveaux = const []});

  factory Filiere.fromJson(Map<String, dynamic> json) {
    return Filiere(
      id: json['id'] as int?,
      nomFiliere: json['nomFiliere'] as String,
      niveaux: (json['niveaux'] as List? ?? [])
          .map((niveau) => Niveau.fromJson(niveau as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomFiliere': nomFiliere,
      'niveaux': niveaux.map((niveau) => niveau.toJson()).toList(),
    };
  }
} 