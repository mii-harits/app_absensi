import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static const double officeLat = -6.200000; // GANTI
  static const double officeLng = 106.816666; // GANTI

  // ================= GET POSITION =================
  static Future<Position> getPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception("GPS tidak aktif");

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // ================= GET ADDRESS =================
  static Future<String> getAddress(double lat, double lng) async {
    final placemarks = await placemarkFromCoordinates(lat, lng);

    final p = placemarks.first;

    return "${p.street}, ${p.subLocality}, ${p.locality}";
  }

  // ================= DISTANCE =================
  static double getDistance(double lat, double lng) {
    return Geolocator.distanceBetween(lat, lng, officeLat, officeLng);
  }
}
