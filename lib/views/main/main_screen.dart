import 'package:app_absensi/views/attendence/attendance_screen.dart';
import 'package:app_absensi/views/attendence/history_screen.dart';
import 'package:app_absensi/views/attendence/home_screen.dart';
import 'package:flutter/material.dart';
import '../../widgets/navigation_bar.dart';
import '../profile_session/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0; // default ke Profile

  final List<Widget> pages = [
    const HomeScreen(),
    const AttendanceScreen(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: CustomNavbar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
