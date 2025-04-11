class FinancialSummary {
  final double totalIncome;
  final double totalExpenses;
  final double balance;
  final Map<String, double> categoryBreakdown;

  FinancialSummary({
    required this.totalIncome,
    required this.totalExpenses,
    required this.balance,
    required this.categoryBreakdown,
  });

  factory FinancialSummary.fromJson(Map<String, dynamic> json) {
    return FinancialSummary(
      totalIncome: json['total_income'].toDouble(),
      totalExpenses: json['total_expenses'].toDouble(),
      balance: json['balance'].toDouble(),
      categoryBreakdown: Map<String, double>.from(json['category_breakdown']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_income': totalIncome,
      'total_expenses': totalExpenses,
      'balance': balance,
      'category_breakdown': categoryBreakdown,
    };
  }
}
