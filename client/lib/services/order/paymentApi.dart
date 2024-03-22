
import 'package:found_adoption_application/models/invoice.dart';
import 'package:found_adoption_application/services/api.dart';

Future<Invoice> getInvoice(orderId) async {
  var responseData;
  try {
    responseData = await api('payment/$orderId', 'GET', '');
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
  Invoice order = Invoice.fromJson(responseData['data']);
  return order;
}