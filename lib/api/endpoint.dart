class Endpoint {
  // BASE URL (ganti dengan punyamu)
  static const String baseUrl = "https://appabsensi.mobileprojp.com/api";

  // AUTH
  static const String register = "$baseUrl/register";
  static const String login = "$baseUrl/login";
  static const String deviceToken = "$baseUrl/device-token";

  // ABSEN
  static const String checkIn = "$baseUrl/absen/check-in";
  static const String checkOut = "$baseUrl/absen/check-out";
  static const String izin = "$baseUrl/izin";
  static const String absenToday = "$baseUrl/absen/today";
  static const String absenStats = "$baseUrl/absen/stats";
  static const String deleteAbsen = "$baseUrl/absen/delete";

  // PROFILE
  static const String profile = "$baseUrl/profile";
  static const String editProfile = "$baseUrl/profile";
  static const String editPhoto = "$baseUrl/profile/photo";

  // HISTORY
  static const String historyAbsen = "$baseUrl/absen/history";

  // USER
  static const String allUser = "$baseUrl/users";

  // TRAINING (PUBLIC)
  static const String trainings = "$baseUrl/trainings";
  static String trainingDetail(int id) => "$baseUrl/trainings/$id";
  static const String allBatches = "$baseUrl/batches";

  // OTP / RESET PASSWORD
  static const String requestOtp = "$baseUrl/auth/request-otp";
  static const String resetPassword = "$baseUrl/auth/reset-password";
}
