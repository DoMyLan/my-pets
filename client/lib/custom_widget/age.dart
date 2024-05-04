

class AgePet {
  static String convertAge(DateTime birthday) {
    String age = '';
    DateTime now = DateTime.now();
    int months = now.month - birthday.month + 12 * (now.year - birthday.year);
    if (now.day < birthday.day) {
      months--;
    }

    if (months < 1) {
      // If age is less than 1 month, calculate in weeks
      int weeks = (now.difference(birthday).inDays / 7).floor();
      age = weeks.toString() + ' weeks';
    } else if (months < 12) {
      // If age is less than 1 year, calculate in months
      age = months.toString() + ' months';
    } else {
      // If age is 1 year or more, calculate in years and months
      int years = months ~/ 12;
      months %= 12;
      age = years.toString() + ' years ' + months.toString() + ' months';
    }

    return age;
  }
}

class AgeConverter {
  static String convertAge(double humanAge) {
    if (humanAge * 12 < 1) {
      // Nếu tuổi dưới 1 tháng, tính theo tuần
      return '${(humanAge * 52).toInt()} weeks';
    } else if (humanAge < 1) {
      // Nếu tuổi dưới 1 năm, tính theo tháng
      return '${(humanAge * 12).toInt()} months';
    } else {
      // Tuổi 1 năm trở lên, tính theo năm
      return '${humanAge.toInt()} years';
    }
  }
}