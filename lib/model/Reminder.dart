class ReminderModel {
  final int? id;
  final String? name;
  final DateTime time;
  final double price;
  final double collectedoprice;

  ReminderModel({
    this.id,
    this.name,
    required this.time,
    required this.price,
    required this.collectedoprice,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'],
      name: json['name'],
      time: DateTime.parse(json['time']),
      price: (json['price'] as num).toDouble(),
      collectedoprice: (json['collectedoprice'] as num).toDouble(),
    );
  }
}
