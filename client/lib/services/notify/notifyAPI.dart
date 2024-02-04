import 'package:found_adoption_application/models/notify.dart';
import 'package:found_adoption_application/services/api.dart';

Future<List<Notify>> getNotify() async {
  var responseData;
  List<Notify> adopts = List.empty();
  try {
    responseData = await api('/notify/', 'GET', '');

    if (responseData['success']) {
      var adoptList = responseData['data'] as List<dynamic>;
      adopts =
          adoptList.map((json) => Notify.fromJson(json)).toList();
      return adopts;
    }
  } catch (e) {
    print(e);
    // notification(e.toString(), true);
  }
  return adopts;
}