class GoalModel {
  final int? id;
  String name;
  double price;
  double collectedmoney;
  String category;
  DateTime time;
  DateTime createdAt;

  GoalModel({
    required this.id,
    required this.name,
    required this.price,
    required this.collectedmoney,
    required this.category,
    required this.time,
    required this.createdAt,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      collectedmoney: (json['collectedmoney'] as num).toDouble(),
      category: json['category'] as String,
      time: DateTime.parse(json['time'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'collectedmoney': collectedmoney,
        'category': category,
        'time': time.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
      };

  GoalModel copyWith({
    int? id,
    String? name,
    double? price,
    double? collectedmoney,
    String? category,
    DateTime? time,
    DateTime? createdAt,
  }) =>
      GoalModel(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        collectedmoney: collectedmoney ?? this.collectedmoney,
        category: category ?? this.category,
        time: time ?? this.time,
        createdAt: createdAt ?? this.createdAt,
      );
}
