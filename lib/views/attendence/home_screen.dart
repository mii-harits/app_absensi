import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_absensi/controllers/attendence_controller.dart';
import 'package:app_absensi/extension/navigator.dart';
import 'package:app_absensi/views/attendence/history_screen.dart';
import 'package:app_absensi/views/attendence/history_detail_screen.dart';
import 'package:app_absensi/views/main/main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isFirstLoad = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isFirstLoad) {
      _isFirstLoad = false;

      final c = context.read<AttendanceController>();
      c.getTodayAttendance();
      c.getHistory();
      c.getStats();
      c.getLocationData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<AttendanceController>();
    final att = c.attendance;
    bool isDone = att?.checkOutTime != null;

    return Scaffold(
      body: Stack(
        children: [
          // BACKGROUND
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFF0F9FF),
                  Color(0xFFEDE9FE),
                  Color(0xFFFDF2F8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          Positioned.fill(child: CustomPaint(painter: BlobPainter())),

          SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await c.getTodayAttendance();
                await c.getHistory();
                await c.getStats();
              },
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // HEADER
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getGreeting(),
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Muhammad Harits",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // STATUS
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Status Absensi Hari Ini",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        _row("Check In", att?.checkInTime ?? "-"),
                        const SizedBox(height: 10),
                        _row("Check Out", att?.checkOutTime ?? "-"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔥 NEW BUTTON
                  _attendanceButton(
                    isDone: isDone,
                    isCheckIn: att == null,
                    onTap: () {
                      MainScreen.of(context)?.changePage(1);
                    },
                  ),

                  const SizedBox(height: 20),

                  // STATS
                  _card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _stat("Total", c.stats?['total_absen'] ?? 0),
                        _divider(),
                        _stat("Hadir", c.stats?['total_masuk'] ?? 0),
                        _divider(),
                        _stat("Izin", c.stats?['total_izin'] ?? 0),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // LOCATION
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Lokasi Anda",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                c.currentAddress ?? "Mengambil alamat...",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // HISTORY
                  _card(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Riwayat Kehadiran",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () =>
                                  context.push(const HistoryScreen()),
                              child: const Text("Lihat Semua"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: c.history.take(5).map((h) {
                            return InkWell(
                              // ✅ HANYA INI YANG DITAMBAH
                              onTap: () {
                                context.push(
                                  HistoryDetailScreen(
                                    data: h,
                                  ), // ⚠️ sesuaikan kalau beda param
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(formatDate(h.attendanceDate)),
                                        Text("IN: ${h.checkInTime ?? '-'}"),
                                        Text("OUT: ${h.checkOutTime ?? '-'}"),
                                      ],
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= BUTTON MODERN =================
  Widget _attendanceButton({
    required bool isDone,
    required bool isCheckIn,
    required VoidCallback onTap,
  }) {
    Color start;
    Color end;
    IconData icon;
    String text;

    if (isDone) {
      start = Colors.green.shade400;
      end = Colors.green.shade600;
      icon = Icons.check_circle;
      text = "Sudah Absensi";
    } else if (isCheckIn) {
      start = const Color(0xFF4FACFE);
      end = const Color(0xFF00F2FE);
      icon = Icons.login;
      text = "Check In";
    } else {
      start = const Color(0xFFFF9966);
      end = const Color(0xFFFF5E62);
      icon = Icons.logout;
      text = "Check Out";
    }

    return GestureDetector(
      onTap: isDone ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [start, end]),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: start.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= COMPONENT =================

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _row(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _stat(String title, dynamic value) {
    return Column(
      children: [
        Text("$value", style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(title),
      ],
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 30, color: Colors.grey[300]);
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Selamat Pagi";
    if (hour < 15) return "Selamat Siang";
    if (hour < 18) return "Selamat Sore";
    return "Selamat Malam";
  }

  String formatDate(String date) {
    final d = DateTime.parse(date);
    return "${d.day} ${_monthName(d.month)} ${d.year}";
  }

  String _monthName(int m) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "Mei",
      "Jun",
      "Jul",
      "Agu",
      "Sep",
      "Okt",
      "Nov",
      "Des",
    ];
    return months[m - 1];
  }
}

// ================= CUSTOM SHAPE =================

class BlobPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    final path = Path();
    path.moveTo(0, size.height * 0.2);

    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.05,
      size.width * 0.6,
      size.height * 0.2,
    );

    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.35,
      size.width,
      size.height * 0.1,
    );

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    paint.shader = const LinearGradient(
      colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    paint.color = paint.color.withOpacity(0.2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
