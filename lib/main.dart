import 'package:app_absensi/controllers/attendence_controller.dart';
import 'package:app_absensi/services/attendence_service.dart';
import 'package:app_absensi/storage/preference.dart';
import 'package:app_absensi/views/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final token = await PreferenceHandler().getToken();

  if (token != null) {
    AttendanceService.token = token;
    print("TOKEN DARI STORAGE: $token");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AttendanceController(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),

        home: const LoginScreen(),
      ),
    );
  }
}
