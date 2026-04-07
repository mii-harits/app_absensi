import 'package:app_absensi/models/attendence_model.dart';
import 'package:app_absensi/services/attendence_service.dart';
import 'package:flutter/material.dart';

class AttendanceController extends ChangeNotifier {
  Attendance? attendance;
  bool isLoading = false;

  // ================= GET TODAY =================
  Future<void> getTodayAttendance() async {
    try {
      isLoading = true;
      notifyListeners();

      attendance = await AttendanceService.getTodayAttendance();
    } catch (e) {
      debugPrint("getTodayAttendance error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
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

  // ================= HELPERS =================
  String _today() {
    final now = DateTime.now();
    return "${now.year}-${_two(now.month)}-${_two(now.day)}";
  }

  String _now() {
    final now = DateTime.now();
    return "${_two(now.hour)}:${_two(now.minute)}";
  }

  String _two(int n) => n.toString().padLeft(2, '0');
}
