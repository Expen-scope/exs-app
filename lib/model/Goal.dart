class GoalModel {
  String name;
  double totalAmount;
  double savedAmount;
  String type;
  DateTime startDate;
  DateTime? deadline;

  GoalModel({
    required this.name,
    required this.totalAmount,
    required this.savedAmount,
    required this.type,
    required this.startDate,
    this.deadline,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      name: json['name'],
      totalAmount: json['totalAmount'].toDouble(),
      savedAmount: json['savedAmount'].toDouble(),
      type: json['type'],
      startDate: DateTime.parse(json['startDate']),
      deadline:
          json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "totalAmount": totalAmount,
      "savedAmount": savedAmount,
      "type": type,
      "startDate": startDate.toIso8601String(),
      "deadline": deadline?.toIso8601String(),
    };
  }
}
