import 'package:found_adoption_application/models/statistical.dart';
import 'package:found_adoption_application/services/api.dart';

Future<List<StatisticalYear>> getStatisticalYear(year) async {
  var responseData;
  try {
    responseData = await api('statistical/year?y=$year', 'GET', '');
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
  var statisticalList = responseData['data'] as List<dynamic>;
  List<StatisticalYear> statisticals =
      statisticalList.map((json) => StatisticalYear.fromJson(json)).toList();
  return statisticals;
}

Future<List<StatisticalMonth>> getStatisticalMonth(year, month) async {
  var responseData;
  try {
    responseData = await api('statistical/year/month?y=$year&m=$month', 'GET', '');
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
  var statisticalList = responseData['data'] as List<dynamic>;
  List<StatisticalMonth> statisticals =
      statisticalList.map((json) => StatisticalMonth.fromJson(json)).toList();
  return statisticals;
}
