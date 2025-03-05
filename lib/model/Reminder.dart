class ReminderModel {
  int? id;
  String name;
  double amount;
  DateTime reminderDate;

  ReminderModel({
    this.id,
    required this.name,
    required this.amount,
    required this.reminderDate,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'],
      name: json['name'],
      amount: json['amount'].toDouble(),
      reminderDate: DateTime.parse(json['reminderDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'reminderDate': reminderDate.toIso8601String(),
    };
  }
}
