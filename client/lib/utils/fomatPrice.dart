import 'package:intl/intl.dart';

String formatPrice(int price) {
  final formatter = NumberFormat('#,###', 'vi_VN');
  return formatter.format(price);
}
