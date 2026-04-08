import 'dart:convert';
import 'package:app_absensi/api/endpoint.dart';
import 'package:app_absensi/models/attendence_model.dart';
import 'package:http/http.dart' as http;

class AttendanceService {
  static String token = "";

  // ================= GET TODAY =================
  static Future<Attendance?> getTodayAttendance() async {
    print("TOKEN DIPAKAI API (TODAY): $token");

    final res = await http.get(
      Uri.parse(Endpoint.absenToday),
      headers: {"Authorization": "Bearer $token"},
    );

    print("STATUS CODE: ${res.statusCode}");
    print("RESPONSE TODAY:");
    print(res.body);

    try {
      final data = jsonDecode(res.body);
      return data['data'] != null ? Attendance.fromJson(data['data']) : null;
    } catch (e) {
      print("ERROR PARSE TODAY: $e");
      return null;
    }
  }

  // ================= CHECK IN =================
  static Future<Attendance?> checkIn({
    required String date,
    required String time,
    required double lat,
    required double lng,
    required String address,
  }) async {
    print("TOKEN DIPAKAI API (CHECK IN): $token");

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

    print("STATUS CODE: ${res.statusCode}");
    print("RESPONSE CHECK IN:");
    print(res.body);

    try {
      final data = jsonDecode(res.body);
      return Attendance.fromJson(data['data']);
    } catch (e) {
      print("ERROR PARSE CHECK IN: $e");
      return null;
    }
  }

  // ================= CHECK OUT =================
  static Future<Attendance?> checkOut({
    required String date,
    required String time,
    required double lat,
    required double lng,
    required String address,
  }) async {
    print("TOKEN DIPAKAI API (CHECK OUT): $token");

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

    print("STATUS CODE: ${res.statusCode}");
    print("RESPONSE CHECK OUT:");
    print(res.body);

    try {
      final data = jsonDecode(res.body);
      return Attendance.fromJson(data['data']);
    } catch (e) {
      print("ERROR PARSE CHECK OUT: $e");
      return null;
    }
  }

  // ================= IZIN =================
  static Future<Attendance?> izin({
    required String date,
    required String alasan,
  }) async {
    print("TOKEN DIPAKAI API (IZIN): $token");

    final res = await http.post(
      Uri.parse(Endpoint.izin),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"date": date, "alasan_izin": alasan}),
    );

    print("STATUS CODE: ${res.statusCode}");
    print("RESPONSE IZIN:");
    print(res.body);

    try {
      final data = jsonDecode(res.body);
      return Attendance.fromJson(data['data']);
    } catch (e) {
      print("ERROR PARSE IZIN: $e");
      return null;
    }
  }

  // ================= HISTORY =================
  static Future<List<Attendance>> getHistory() async {
    final res = await http.get(
      Uri.parse(Endpoint.historyAbsen),
      headers: {"Authorization": "Bearer $token"},
    );

    print("STATUS HISTORY: ${res.statusCode}");
    print("BODY HISTORY: ${res.body}");

    try {
      final data = jsonDecode(res.body);

      if (data['data'] != null) {
        return (data['data'] as List)
            .map((e) => Attendance.fromJson(e))
            .toList();
      }

      return [];
    } catch (e) {
      print("ERROR HISTORY: $e");
      return [];
    }
  }

  // ================= STATS =================
  static Future<Map<String, dynamic>?> getStats() async {
    print("TOKEN DIPAKAI API (STATS): $token");

    final res = await http.get(
      Uri.parse(Endpoint.absenStats),
      headers: {"Authorization": "Bearer $token"},
    );

    print("STATUS CODE: ${res.statusCode}");
    print("RESPONSE STATS:");
    print(res.body);

    try {
      final data = jsonDecode(res.body);
      return data['data'];
    } catch (e) {
      print("ERROR PARSE STATS: $e");
      return null;
    }
  }

  // ================= DELETE =================
  static Future<void> deleteAttendance(int id) async {
    final res = await http.delete(
      Uri.parse("https://appabsensi.mobileprojp.com/api/absen/$id"),
      headers: {"Authorization": "Bearer $token"},
    );

    print("DELETE STATUS: ${res.statusCode}");
    print("DELETE BODY: ${res.body}");

    if (res.statusCode != 200) {
      throw Exception("Gagal delete data");
    }
  }
}
