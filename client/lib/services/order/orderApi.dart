import 'dart:convert';
import 'package:found_adoption_application/models/order.dart';
import 'package:found_adoption_application/services/api.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';

Future<String?> createOrder(
    buyer,
    isCenterSeller,
    sellerId,
    pet,
    address,
    transportFee,
    voucher,
    voucherProduct,
    voucherShipping,
    voucherTotal,
    totalFee,
    totalPayment,
    paymentMethods,
    price) async {
  try {
    var body = jsonEncode({
      "buyer": buyer,
      "seller": {"typeSeller": "C", "userId": null, "centerId": sellerId},
      "petId": pet.id,
      "address": address,
      "price": price.toString(),
      "code": voucher,
      "transportFee": transportFee.toString(),
      "totalFee": totalFee.toString(),
      "voucherProduct": voucherProduct,
      "voucherShipping": voucherShipping,
      "voucherTotal": voucherTotal,
      "totalPayment": totalPayment,
      "paymentMethods": paymentMethods
    });
    var responseData = await api('order', 'POST', body);
    return responseData['orderId'];
  } catch (e) {
    // print(e.toString());
    notification("Order: ${e.toString()}", true);
    return null;
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

Future<List<Order>> getOrdersBySeller(statusOrder) async {
  var responseData;
  try {
    responseData =
        await api('order/seller?statusOrder=$statusOrder', 'GET', '');
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
  var orderList = responseData['data'] as List<dynamic>;
  List<Order> orders = orderList.map((json) => Order.fromJson(json)).toList();
  return orders;
}

Future<Order> getOrderDetailBySeller(orderId) async {
  var responseData;
  try {
    responseData = await api('order/seller/$orderId', 'GET', '');
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
  var orderRes = responseData['data'] as dynamic;
  Order orders = Order.fromJson(orderRes);
  return orders;
}

Future<void> changeStatusOrder(orderId, statusOrder) async {
  var responseData;
  var body = jsonEncode({'statusOrder': statusOrder});
  try {
    responseData = await api('order/$orderId', 'PUT', body);
    notification(responseData['message'], false);
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
}

Future<List<Order>> getRevenue(centerId, status, start, end) async {
  var responseData;
  try {
    responseData =
        await api('order/$centerId/payment?status=$status&start=$start&end=$end', 'GET', '');
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
  var orderList = responseData['data'] as List<dynamic>;
  List<Order> orders = orderList.map((json) => Order.fromJson(json)).toList();
  return orders;
}

Future<void> confirmPayment(orderId) async {
  try {
    await api('order/$orderId/payment', 'PUT', '');
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
}
