import 'package:app_absensi/controllers/attendence_controller.dart';
import 'package:app_absensi/extension/navigator.dart';
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
  LatLng? currentLatLng;
  String address = "Mengambil lokasi...";
  bool isLocationLoaded = false;

  final alasanController = TextEditingController();
  bool isIzin = false;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => address = "GPS tidak aktif");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => address = "Permission ditolak permanen");
        return;
      }

      final position = await Geolocator.getCurrentPosition();

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      setState(() {
        currentLatLng = LatLng(position.latitude, position.longitude);
        address = "${placemarks.first.locality}, ${placemarks.first.country}";
      });
    } catch (e) {
      setState(() => address = "Gagal ambil lokasi");
      debugPrint("LOCATION ERROR: $e");
    }
  }

  String getStatus(att) {
    if (att == null) return "Belum mengisi absensi hari ini";
    if (att.checkOutTime == null) return "Belum check out";
    return "Hari ini sudah Absensi";
  }

  String buttonText(att) {
    if (att == null) return "Check In";
    if (att.checkOutTime == null) return "Check Out";
    return "Selesai";
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<AttendanceController>();
    final att = c.attendance;

    return Scaffold(
      appBar: AppBar(title: const Text("Absensi")),
      body: Column(
        children: [
          // MAP
          SizedBox(
            height: 200,
            child: currentLatLng == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: currentLatLng!,
                      zoom: 16,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId("me"),
                        position: currentLatLng!,
                      ),
                    },
                  ),
          ),

          const SizedBox(height: 10),

          // STATUS
          Text(getStatus(att)),

          const SizedBox(height: 10),

          Text(address),

          const SizedBox(height: 20),

          // HADIR / IZIN
          if (att == null)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => isIzin = false);
                    },
                    child: const Text("Hadir"),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => isIzin = true);
                    },
                    child: const Text("Izin"),
                  ),
                ),
              ],
            ),

          if (isIzin)
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: alasanController,
                decoration: const InputDecoration(
                  hintText: "Masukkan alasan izin",
                ),
              ),
            ),

          const Spacer(),

          // BUTTON
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () async {
                if (currentLatLng == null) return;

                if (att == null) {
                  if (isIzin) {
                    await c.doIzin(alasanController.text);
                  } else {
                    await c.doCheckIn(
                      lat: currentLatLng!.latitude,
                      lng: currentLatLng!.longitude,
                      address: address,
                    );
                  }
                } else if (att.checkOutTime == null) {
                  await c.doCheckOut(
                    lat: currentLatLng!.latitude,
                    lng: currentLatLng!.longitude,
                    address: address,
                  );
                } else {
                  context.pop(true);
                  return;
                }

                await c.getTodayAttendance();
                await c.getHistory();
                await c.getStats();
              },
              child: Text(buttonText(att)),
            ),
          ),
        ],
      ),
    );
  }
}
