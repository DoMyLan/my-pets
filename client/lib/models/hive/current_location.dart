
import 'package:hive/hive.dart';

// part 'hive_solUser.g.dart';

@HiveType(typeId: 2)
class CurrentLocation extends HiveObject {
  @HiveField(0)
  late String latitude;
  @HiveField(1)
  late String longitude;
  CurrentLocation({required this.latitude, required this.longitude});
}

// HiveAdapter cho Location
class LocationAdapter extends TypeAdapter<CurrentLocation> {
  @override
  final int typeId = 2;

  @override
  CurrentLocation read(BinaryReader reader) {
    final currentLocation = CurrentLocation(latitude: '', longitude: '')
      ..latitude = reader.readString()
      ..longitude = reader.readString();

    return currentLocation;
  }

  @override
  void write(BinaryWriter writer, CurrentLocation obj) {
    writer.writeString(obj.latitude);
    writer.writeString(obj.longitude);
  
  }
}

