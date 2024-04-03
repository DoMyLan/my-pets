import 'dart:convert';

import 'package:found_adoption_application/models/voucher_model.dart';
import 'package:found_adoption_application/services/api.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';
import 'package:intl/intl.dart';

Future<String?> createVoucher(Voucher voucher) async {
  try {
    var body = jsonEncode({
      "code": voucher.code,
      "type": voucher.type,
      "discount": voucher.discount,
      "maxDiscount": voucher.maxDiscount,
      "startDate": DateFormat("MM-dd-yyyy HH:mm").format(voucher.startDate),
      "endDate": DateFormat("MM-dd-yyyy HH:mm").format(voucher.endDate),
      "status": voucher.status,
      "createdBy": voucher.createdBy,
      "quantity": voucher.quantity,
    });
    var responseData = await api('voucher', 'POST', body);

    if (responseData['success']) {
      notification(responseData['message'], false);
    } else {
      notification(responseData['message'], true);
      return null;
    }
  } catch (e) {
    notification("Order: ${e.toString()}", true);
    return null;
  }
  return null;
}

Future<List<Voucher>> getVoucher(centerId, use) async {
  var responseData;
  try {
    if (use == -1) {
      responseData = await api('voucher/$centerId', 'GET', '');
    } else {
      responseData = await api('voucher/$centerId?use=$use', 'GET', '');
    }
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
  var orderList = responseData['data'] as List<dynamic>;
  List<Voucher> orders =
      orderList.map((json) => Voucher.fromJson(json)).toList();
  return orders;
}

Future<Voucher?> applyVoucher(code) async {
  var responseData;
  // ignore: cast_from_null_always_fails
  var orders = null;
  try {
    responseData = await api('voucher/apply/$code', 'GET', '');
    var order = responseData['data'] as dynamic;
    orders = Voucher.fromJson(order);
  } catch (e) {
    print(e);
    // notification(e.toString(), true);
  }
  return orders;
}
