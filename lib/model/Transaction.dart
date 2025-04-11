class Transaction {
  final String id;
  final String description;
  final double amount;
  final String type;
  final DateTime date;
  final String category;

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.date,
    required this.category,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'].toString(),
      description: json['description'] ?? '',
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] ?? 'expense',
      date: DateTime.parse(json['date']),
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'type': type,
      'date': date.toIso8601String(),
      'category': category,
    };
  }
}
