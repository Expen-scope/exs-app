class GoalModel {
  final int id;
  String name;
  double totalAmount;
  double savedAmount;
  String type;
  DateTime startDate;
  DateTime? deadline;

  GoalModel({
    required this.id,
    required this.name,
    required this.totalAmount,
    required this.savedAmount,
    required this.type,
    required this.startDate,
    this.deadline,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'],
      name: json['name'],
      totalAmount: (json['totalAmount'] as num).toDouble(),
      savedAmount: (json['savedAmount'] as num).toDouble(),
      type: json['type'],
      startDate: DateTime.parse(json['startDate']),
      deadline:
          json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      "name": name,
      "totalAmount": totalAmount,
      "savedAmount": savedAmount,
      "type": type,
      "startDate": startDate.toIso8601String(),
      "deadline": deadline?.toIso8601String(),
    };
  }

  // إضافة copyWith لتحديث البيانات بسهولة
  GoalModel copyWith({
    int? id,
    String? name,
    double? totalAmount,
    double? savedAmount,
    String? type,
    DateTime? startDate,
    DateTime? deadline,
  }) {
    return GoalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      totalAmount: totalAmount ?? this.totalAmount,
      savedAmount: savedAmount ?? this.savedAmount,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      deadline: deadline ?? this.deadline,
    );
  }
}
