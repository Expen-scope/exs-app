class Income {
  final String id;
  final double price;
  final String category;
  final String nameOfExpense;
  final DateTime time;
  final String userId;

  Income({
    required this.id,
    required this.price,
    required this.category,
    required this.nameOfExpense,
    required this.time,
    required this.userId,
  });

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      id: json['id'].toString(),
      price: json['price']?.toDouble() ?? 0.0,
      category: json['category'] ?? '',
      nameOfExpense: json['name_of_expense'] ?? '',
      time: DateTime.parse(json['time']),
      userId: json['user_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'category': category,
      'name_of_expense': nameOfExpense,
      'time': time.toIso8601String(),
      'user_id': userId,
    };
  }
}