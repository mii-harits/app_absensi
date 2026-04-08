import 'package:app_absensi/models/attendence_model.dart';
import 'package:app_absensi/services/attendence_service.dart';
import 'package:app_absensi/services/location_service.dart';
import 'package:flutter/material.dart';

class AttendanceController extends ChangeNotifier {
  Attendance? attendance;
  List<Attendance> history = [];
  Map<String, dynamic>? stats;

  bool isLoading = false;

  double? distance;
  String? currentAddress;

  // ================= TODAY =================
  Future<void> getTodayAttendance() async {
    try {
      isLoading = true;
      notifyListeners();

      attendance = await AttendanceService.getTodayAttendance();
    } catch (e) {
      debugPrint("today error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================= HISTORY =================
  Future<void> getHistory() async {
    try {
      history = await AttendanceService.getHistory();
      notifyListeners();
    } catch (e) {
      debugPrint("history error: $e");
    }
  }

  // ================= STATS =================
  Future<void> getStats() async {
    try {
      stats = await AttendanceService.getStats();
      notifyListeners();
    } catch (e) {
      debugPrint("stats error: $e");
    }
  }

  // ================= CHECK IN =================
  Future<void> doCheckIn({
    required double lat,
    required double lng,
    required String address,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      attendance = await AttendanceService.checkIn(
        date: _today(),
        time: _now(),
        lat: lat,
        lng: lng,
        address: address,
      );
    } catch (e) {
      debugPrint("checkin error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================= CHECK OUT =================
  Future<void> doCheckOut({
    required double lat,
    required double lng,
    required String address,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      attendance = await AttendanceService.checkOut(
        date: _today(),
        time: _now(),
        lat: lat,
        lng: lng,
        address: address,
      );
    } catch (e) {
      debugPrint("checkout error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================= IZIN =================
  Future<void> doIzin(String alasan) async {
    try {
      isLoading = true;
      notifyListeners();

      attendance = await AttendanceService.izin(date: _today(), alasan: alasan);
    } catch (e) {
      debugPrint("izin error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================= DELETE =================
  Future<void> delete(int id) async {
    try {
      await AttendanceService.deleteAttendance(id);

      attendance = null; // 🔥 RESET LOCAL STATE

      await getHistory();
      await getTodayAttendance();
      await getStats();
    } catch (e) {
      debugPrint("delete error: $e");
    }
  }

  // ================= HELPER =================
  String _today() {
    final now = DateTime.now();
    return "${now.year}-${_two(now.month)}-${_two(now.day)}";
  }

  String _now() {
    final now = DateTime.now();
    return "${_two(now.hour)}:${_two(now.minute)}";
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  // ================= GET LOCATION DATA =================
  Future<void> getLocationData() async {
    try {
      final pos = await LocationService.getPosition();

      distance = LocationService.getDistance(pos.latitude, pos.longitude);

      currentAddress = await LocationService.getAddress(
        pos.latitude,
        pos.longitude,
      );

      notifyListeners();
    } catch (e) {
      debugPrint("location error: $e");
    }
  }
}
