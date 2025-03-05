class Expense {
  final double value;
  final String type;
  final String date;

  Expense({required this.value, required this.type, required this.date});

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      value: json['value'],
      type: json['type'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'type': type,
      'date': date,
    };
  }
}
