class Income {
  final int id;
  final String name;
  final double price;
  final String category;
  final String time;

  Income({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.time,
  });

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      id: json['id'],
      name: json['nameinc'],
      price: json['price'].toDouble(),
      category: json['category'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nameinc': name,
      'price': price,
      'category': category,
      'time': time,
    };
  }
}
