import 'package:hive/hive.dart';

@HiveType(typeId: 3)
class LocationModel extends HiveObject {
  @HiveField(0)
  late String address;

  @HiveField(1)
  late double latitude;

  @HiveField(2)
  late double longitude;
}
