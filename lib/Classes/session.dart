class Session {
  final int? id; // Identifiant optionnel
  final String nomSession; // Nom de la session (en Dart)

  Session({this.id, required this.nomSession});

  // Méthode pour convertir un JSON en objet Session
  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      nomSession:
          json['nomSession'], 
    );
  }

  // Méthode pour convertir un objet Session en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id, 
      'nomSession':
          nomSession, 
    };
  }
}
