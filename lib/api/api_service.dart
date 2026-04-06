import 'dart:convert';
import 'package:app_absensi/api/endpoint.dart';
import 'package:app_absensi/storage/preference.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // REGISTER
  static Future register(
    String name,
    String email,
    String password,
    String batch,
    String jurusan,
    String gender,
  ) async {
    final response = await http.post(
      Uri.parse(Endpoint.register),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "batch_id": batch,
        "training_id": jurusan,
        "jenis_kelamin": gender,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body); // sukses
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Register gagal');
    }
  }

  // LOGIN
  static Future login(String email, String password) async {
    final response = await http.post(
      Uri.parse(Endpoint.login),
      headers: {"Accept": "application/json"},
      body: {"email": email, "password": password},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body); // sukses
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Register gagal');
    }
  }

  // PROFILE
  static Future getProfile() async {
    final token = await PreferenceHandler().getToken();

    final response = await http.get(
      Uri.parse(Endpoint.profile),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body); // sukses
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Register gagal');
    }
  }

  // UPDATE PROFILE
  static Future updateProfile(String name, String gender) async {
    final token = await PreferenceHandler().getToken();

    final response = await http.put(
      Uri.parse(Endpoint.editProfile),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      body: {"name": name, "jenis_kelamin": gender},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body); // sukses
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Register gagal');
    }
  }

  // GET JURUSAN
  static Future<dynamic> getJurusan() async {
    final response = await http.get(
      Uri.parse(Endpoint.trainings), // 🔥 sesuaikan endpoint kamu
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal ambil jurusan");
    }
  }

  // GET BATCH
  static Future<dynamic> getBatch() async {
    final response = await http.get(
      Uri.parse(Endpoint.allBatches), // 🔥 sesuaikan endpoint
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal ambil batch");
    }
  }
}
