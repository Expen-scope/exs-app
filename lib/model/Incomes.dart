class Income {
  final String id;
  final double price;
  final String category;
  final String nameOfIncome;
  final DateTime time;
  final String userId;

  Income({
    required this.id,
    required this.price,
    required this.category,
    required this.nameOfIncome,
    required this.time,
    required this.userId,
  });

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      id: json['id']?.toString() ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      category: json['category']?.toString() ?? '',
      nameOfIncome: json['name_of_income']?.toString() ?? '',
      time:
          json['time'] != null ? DateTime.parse(json['time']) : DateTime.now(),
      userId: json['user_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'category': category,
      'name_of_income': nameOfIncome,
      'time': time.toIso8601String(),
      'user_id': userId,
    };
  }
}
