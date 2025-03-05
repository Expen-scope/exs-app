class Income {
  int? id;
  double value;
  String type;

  Income({this.id, required this.value, required this.type});

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      id: json['id'],
      value: (json['value'] as num).toDouble(),
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'type': type,
    };
  }
}
