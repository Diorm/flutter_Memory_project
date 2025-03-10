class Note {
  final int id;
  final double valeur; // Valeur de la note
  final DateTime date; // Date de la note

  Note({
    required this.id,
    required this.valeur,
    required this.date,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      valeur: json['valeur'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'valeur': valeur,
      'date': date.toIso8601String(),
    };
  }
}