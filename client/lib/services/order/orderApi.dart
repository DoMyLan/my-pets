import 'dart:convert';

import 'package:found_adoption_application/services/api.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';

Future<bool> createOrder(
    buyer, isCenterSeller, sellerId, pet, address, transportFee, totalFee) async {
  try {
    var body = jsonEncode({
      "buyer": buyer,
      "seller": {
        "typeSeller": isCenterSeller ? "C" : "U",
        "userId": isCenterSeller ? null : sellerId,
        "centerId": isCenterSeller ? sellerId : null
      },
      "petId": pet.id,
      "address": address,
      "price": pet.price,
      "transportFee": transportFee.toString(),
      "totalFee": totalFee.toString(),
      "paymentMethods": "COD"
    });
    var responseData = await api('order', 'POST', body);

    if (responseData['success']) {
      notification(responseData['message'], false);
      return true;
    } else {
      notification(responseData['message'], true);
      return false;
    }
  } catch (e) {
    // print(e.toString());
    notification("Order: ${e.toString()}", true);
    return false;
  }
}
