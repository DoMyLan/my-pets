class StatisticalYear {
  final int month;
  final int total;
  final int paid;
  final int pending;

  StatisticalYear(
      {required this.month,
      required this.total,
      required this.paid,
      required this.pending});

  factory StatisticalYear.fromJson(Map<String, dynamic> json) {
    return StatisticalYear(
      month: json['month'],
      total: json['total'],
      paid: json['paid'],
      pending: json['pending'],
    );
  }
}

class StatisticalMonth {
  final int day;
  final int total;
  final int paid;
  final int pending;

  StatisticalMonth({
    required this.day,
    required this.total,
    required this.paid,
    required this.pending,
  });

  factory StatisticalMonth.fromJson(Map<String, dynamic> json) {
    return StatisticalMonth(
      day: json['day'],
      total: json['total'],
      paid: json['paid'],
      pending: json['pending'],
    );
  }
}
