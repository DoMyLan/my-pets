class StatisticalYear {
  final int month;
  final int total;

  StatisticalYear({required this.month, required this.total});

  factory StatisticalYear.fromJson(Map<String, dynamic> json) {
    return StatisticalYear(
      month: json['month'],
      total: json['total'],
    );
  }
}

class StatisticalMonth {
  final int day;
  final int total;

  StatisticalMonth({required this.day, required this.total});

  factory StatisticalMonth.fromJson(Map<String, dynamic> json) {
    return StatisticalMonth(
      day: json['day'],
      total: json['total'],
    );
  }
}