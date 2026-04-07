import 'package:app_absensi/controllers/attendence_controller.dart';
import 'package:app_absensi/extension/navigator.dart';
import 'package:app_absensi/views/attendence/attendance_screen.dart';
import 'package:app_absensi/views/attendence/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<AttendanceController>();
    final att = c.attendance;

    bool isDone = att?.checkOutTime != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 30),
            decoration: const BoxDecoration(
              color: Color(0xFF1E3A8A),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            child: Column(
              children: const [
                Text(
                  "MORNING",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(height: 5),
                Text(
                  "Muhammad Harits",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // BUTTON / STATUS
          Padding(
            padding: const EdgeInsets.all(20),
            child: isDone
                ? Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text("Hari ini sudah absensi ✅"),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () async {
                      final result = await context.push(
                        const AttendanceScreen(),
                      );

                      if (result == true) {
                        final c = context.read<AttendanceController>();

                        await c.getTodayAttendance();
                        await c.getHistory();
                        await c.getStats();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: const Size(double.infinity, 60),
                    ),
                    child: Text(att == null ? "Check In" : "Check Out"),
                  ),
          ),

          // STATS
          if (c.stats != null)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Masuk: ${c.stats!['total_masuk']} | Izin: ${c.stats!['total_izin']}",
              ),
            ),

          // HISTORY
          Expanded(
            child: ListView.builder(
              itemCount: c.history.length,
              itemBuilder: (_, i) {
                final h = c.history[i];

                return ListTile(
                  title: Text(h.attendanceDate),
                  subtitle: Text(
                    "${h.checkInTime ?? '-'} - ${h.checkOutTime ?? '-'}",
                  ),
                  trailing: Text(h.status ?? "-"),
                  onTap: () async {
                    await context.push(HistoryScreen());

                    final c = context.read<AttendanceController>();
                    await c.getTodayAttendance();
                    await c.getHistory();
                    await c.getStats();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
