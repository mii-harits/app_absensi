import 'package:app_absensi/controllers/attendence_controller.dart';
import 'package:app_absensi/extension/navigator.dart';
import 'package:app_absensi/views/attendence/attendance_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AttendanceController>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          // ===== HEADER =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 30),
            decoration: const BoxDecoration(
              color: Color(0xFF1E3A8A),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              children: [
                const Text(
                  "MORNING",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  controller.attendance?.attendanceDate ?? "-",
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Durasi Kerja",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 5),
                Text(
                  controller.attendance?.workingHours ?? "-",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ===== CHECK IN / OUT CARD =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.05),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Check In
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed:
                          controller.isLoading ||
                              (controller.attendance?.checkOutTime != null ||
                                  controller.attendance?.status == "izin")
                          ? null
                          : () async {
                              final result = await context.push(
                                const AttendanceScreen(),
                              );

                              if (result == true) {
                                await controller.getTodayAttendance();
                              }
                            },
                      child: Column(
                        children: [
                          Text(
                            controller.attendance == null
                                ? "Check In"
                                : controller.attendance!.checkInTime != null &&
                                      controller.attendance!.checkOutTime ==
                                          null
                                ? "Check Out"
                                : "Selesai",
                          ),
                          const SizedBox(height: 5),
                          Text(
                            controller.attendance?.checkInTime ?? "--:--",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ===== RIWAYAT =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Riwayat Kehadiran",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text("Lihat Semua", style: TextStyle(color: Colors.blue)),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ===== LIST =====
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 5, // sementara dummy
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "${controller.attendance?.attendanceDate ?? '-'}",
                            ),
                            Text(
                              "${controller.attendance?.workingHours ?? '-'}",
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Check In: ${controller.attendance?.checkInTime ?? '-'}",
                            ),
                            Text(
                              "Check Out: ${controller.attendance?.checkOutTime ?? '-'}",
                            ),
                            Text(
                              "Status: ${controller.attendance?.status ?? '-'}",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
