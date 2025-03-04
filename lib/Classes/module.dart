class Module {
  final int? id;
  final String nomModule;
  final int? ueId;

  Module({this.id, required this.nomModule, this.ueId});

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'],
      nomModule: json['nomModule'],
      ueId: json['ueId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomModule': nomModule,
      'ueId': ueId,
    };
  }
}
