import 'dart:ui';
import 'package:app_absensi/controllers/attendence_controller.dart';
import 'package:app_absensi/views/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  LatLng currentLatLng = const LatLng(-6.186486, 106.834091);
  String address = "📡 Mengambil lokasi...";
  bool isIzin = false;
  bool isLoading = false;

  final alasanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final p = placemarks.first;

      if (mounted) {
        setState(() {
          currentLatLng = LatLng(position.latitude, position.longitude);
          address = "${p.street}, ${p.locality}, ${p.administrativeArea}";
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => address = "❌ Gagal mengambil lokasi");
      }
    }
  }

  Future<void> showSuccessDialog(String title, String message) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (Navigator.canPop(context)) Navigator.pop(context);
        });

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 60),
                const SizedBox(height: 15),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(message, textAlign: TextAlign.center),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<AttendanceController>();
    final att = c.attendance;

    String buttonText;
    List<Color> gradient;
    IconData icon;

    if (att == null) {
      buttonText = isIzin ? "Kirim Izin" : "Check In";
      gradient = isIzin
          ? [Color(0xFF6366F1), Color(0xFF8B5CF6)]
          : [Color(0xFF4FACFE), Color(0xFF00F2FE)];
      icon = isIzin ? Icons.send : Icons.login;
    } else if (att.checkOutTime == null) {
      buttonText = "Check Out";
      gradient = [Color(0xFFFF9966), Color(0xFFFF5E62)];
      icon = Icons.logout;
    } else {
      buttonText = "Selesai";
      gradient = [Colors.green.shade400, Colors.green.shade600];
      icon = Icons.check_circle;
    }

    return Scaffold(
      body: Stack(
        children: [
          // 🌈 SAME THEME AS HOME
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
            child: Column(
              children: [
                const SizedBox(height: 10),

                // MAP
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      height: 200,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: currentLatLng,
                          zoom: 16,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId("me"),
                            position: currentLatLng,
                          ),
                        },
                        myLocationEnabled: true,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text("Status: "),
                                    Text(
                                      att == null
                                          ? "Belum Check In"
                                          : att.checkOutTime == null
                                          ? "Sudah Check In"
                                          : "Selesai",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(address),
                              ],
                            ),
                          ),

                          const SizedBox(height: 15),

                          if (att == null)
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => isIzin = false),
                                    child: _optionCard("Hadir", !isIzin),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => isIzin = true),
                                    child: _optionCard("Izin", isIzin),
                                  ),
                                ),
                              ],
                            ),

                          if (isIzin)
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: _input(),
                            ),

                          const SizedBox(height: 15),

                          _card(child: _infoCard(att)),

                          const SizedBox(height: 30),

                          // 🔥 MODERN BUTTON
                          GestureDetector(
                            onTap: (address.contains("Mengambil") || isLoading)
                                ? null
                                : () async {
                                    setState(() => isLoading = true);

                                    try {
                                      if (att == null) {
                                        if (isIzin) {
                                          await c.doIzin(alasanController.text);
                                        } else {
                                          await c.doCheckIn(
                                            lat: currentLatLng.latitude,
                                            lng: currentLatLng.longitude,
                                            address: address,
                                          );
                                        }
                                      } else if (att.checkOutTime == null) {
                                        await c.doCheckOut(
                                          lat: currentLatLng.latitude,
                                          lng: currentLatLng.longitude,
                                          address: address,
                                        );
                                      }

                                      await showSuccessDialog(
                                        "$buttonText Berhasil",
                                        "Data tersimpan",
                                      );

                                      MainScreen.of(context)?.changePage(0);
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text("Error: $e")),
                                      );
                                    }

                                    if (mounted) {
                                      setState(() => isLoading = false);
                                    }
                                  },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: gradient),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: gradient.first.withOpacity(0.4),
                                    blurRadius: 15,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(icon, color: Colors.white),
                                          const SizedBox(width: 10),
                                          Text(
                                            buttonText,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= UI COMPONENT =================

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

  Widget _input() {
    return TextField(
      controller: alasanController,
      decoration: InputDecoration(
        hintText: "Masukkan alasan izin",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _optionCard(String text, bool active) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: active
            ? const LinearGradient(
                colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
              )
            : null,
        color: active ? null : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _infoCard(att) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [const Text("Check In"), Text(att?.checkInTime ?? "-")],
        ),
        Container(width: 1, height: 30, color: Colors.grey[300]),
        Column(
          children: [const Text("Check Out"), Text(att?.checkOutTime ?? "-")],
        ),
      ],
    );
  }
}

// SAME SHAPE AS HOME
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
