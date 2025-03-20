class ReminderModel {
  final int? id;
  final String name;
  final DateTime time;
  final double price;

  ReminderModel({
    this.id,
    required this.name,
    required this.time,
    required this.price,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'],
      name: json['name'],
      time: DateTime.parse(json['time']),
      price: json['price'].toDouble(),
    );
  }
}