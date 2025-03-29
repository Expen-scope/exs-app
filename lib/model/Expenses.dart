class Expense {
  final int? id;
  final String name;
  final double value;
  final String type;
  final String date;

  Expense({
    this.id,
    required this.name,
    required this.value,
    required this.type,
    required this.date,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      name: json['name_of_expense'],
      value: double.parse(json['price'].toString()),
      type: json['category'],
      date: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name_of_expense': name,
      'price': value.toString(),
      'category': type,
      'time': date,
    };
  }
}
