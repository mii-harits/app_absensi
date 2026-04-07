import 'package:app_absensi/controllers/attendence_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AttendanceController>().getHistory();
    context.read<AttendanceController>().getStats();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<AttendanceController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Kehadiran")),
      body: Column(
        children: [
          if (c.stats != null)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Total: ${c.stats!['total_absen']} | Masuk: ${c.stats!['total_masuk']} | Izin: ${c.stats!['total_izin']}",
              ),
            ),

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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(h.status ?? "-"),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await c.delete(h.id!);
                        },
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
