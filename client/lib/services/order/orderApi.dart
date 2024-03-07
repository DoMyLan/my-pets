import 'dart:convert';

import 'package:found_adoption_application/models/order.dart';
import 'package:found_adoption_application/services/api.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';

Future<bool> createOrder(buyer, isCenterSeller, sellerId, pet, address,
    transportFee, totalFee) async {
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

Future<List<Order>> getOrdersByBuyer(statusOrder) async {
  var responseData;
  try {
    responseData = await api('order/buyer?statusOrder=$statusOrder', 'GET', '');
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
  var orderList = responseData['data'] as List<dynamic>;
  List<Order> orders = orderList.map((json) => Order.fromJson(json)).toList();
  return orders;
}

Future<Order> getOrderDetailByBuyer(orderId) async {
  var responseData;
  try {
    responseData = await api('order/buyer/$orderId', 'GET', '');
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
  var orderRes = responseData['data'] as dynamic;
  Order orders = Order.fromJson(orderRes);
  return orders;
}
