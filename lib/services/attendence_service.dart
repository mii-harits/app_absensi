import 'dart:convert';
import 'package:app_absensi/api/endpoint.dart';
import 'package:app_absensi/models/attendence_model.dart';
import 'package:http/http.dart' as http;

class AttendanceService {
  static const String token = "YOUR_TOKEN"; // ambil dari storage

  // ================= GET TODAY =================
  static Future<Attendance?> getTodayAttendance() async {
    final res = await http.get(
      Uri.parse(Endpoint.absenToday),
      headers: {"Authorization": "Bearer $token"},
    );
    final data = jsonDecode(res.body);
    return data['data'] != null ? Attendance.fromJson(data['data']) : null;
  }

  // ================= CHECK IN / OUT / IZIN =================
  static Future<Attendance?> checkIn({
    required String date,
    required String time,
    required double lat,
    required double lng,
    required String address,
  }) async {
    final res = await http.post(
      Uri.parse(Endpoint.checkIn),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "attendance_date": date,
        "check_in": time,
        "check_in_lat": lat,
        "check_in_lng": lng,
        "check_in_address": address,
        "status": "masuk",
      }),
    );
    final data = jsonDecode(res.body);
    return Attendance.fromJson(data['data']);
  }

  static Future<Attendance?> checkOut({
    required String date,
    required String time,
    required double lat,
    required double lng,
    required String address,
  }) async {
    final res = await http.post(
      Uri.parse(Endpoint.checkOut),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "attendance_date": date,
        "check_out": time,
        "check_out_lat": lat,
        "check_out_lng": lng,
        "check_out_address": address,
      }),
    );
    final data = jsonDecode(res.body);
    return Attendance.fromJson(data['data']);
  }

  static Future<Attendance?> izin({
    required String date,
    required String alasan,
  }) async {
    final res = await http.post(
      Uri.parse(Endpoint.izin),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"date": date, "alasan_izin": alasan}),
    );
    final data = jsonDecode(res.body);
    return Attendance.fromJson(data['data']);
  }

  // ================= HISTORY =================
  static Future<List<Attendance>> getHistory() async {
    final res = await http.post(
      Uri.parse(Endpoint.historyAbsen),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"email": "YOUR_EMAIL", "password": "YOUR_PASSWORD"}),
    );
    final data = jsonDecode(res.body);
    if (data['data'] != null) {
      return (data['data'] as List).map((e) => Attendance.fromJson(e)).toList();
    }
    return [];
  }

  // ================= STATS =================
  static Future<Map<String, dynamic>?> getStats() async {
    final res = await http.get(
      Uri.parse(Endpoint.absenStats),
      headers: {"Authorization": "Bearer $token"},
    );
    final data = jsonDecode(res.body);
    return data['data'];
  }

  // ================= DELETE =================
  static Future<void> deleteAttendance(int id) async {
    await http.delete(
      Uri.parse("${Endpoint.deleteAbsen}/$id"),
      headers: {"Authorization": "Bearer $token"},
    );
  }
}
