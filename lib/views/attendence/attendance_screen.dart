import 'package:app_absensi/controllers/attendence_controller.dart';
import 'package:app_absensi/models/attendence_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  LatLng? currentLatLng;
  String address = "Mengambil lokasi...";
  final TextEditingController alasanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  // ================= GET LOCATION =================
  Future<void> getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;

    final position = await Geolocator.getCurrentPosition();

    setState(() {
      currentLatLng = LatLng(position.latitude, position.longitude);
    });

    // GET ADDRESS
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    setState(() {
      address = "${placemarks.first.locality}, ${placemarks.first.country}";
    });
  }

  // ================= STATUS UI =================
  Color getStatusColor(Attendance? att) {
    if (att == null) return Colors.grey;
    if (att.status == "izin") return Colors.orange;
    if (att.checkInTime != null && att.checkOutTime == null) return Colors.red;
    return Colors.green;
  }

  String getStatusText(Attendance? att) {
    if (att == null) return "Belum mengisi absensi";
    if (att.status == "izin") return "Izin";
    if (att.checkOutTime == null) return "Belum check out";
    return "Sudah mengisi absensi";
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AttendanceController>(context);

    final attendance = controller.attendance;
    final hasAttendance = attendance != null;

    return Scaffold(
      appBar: AppBar(title: const Text("Absensi")),
      body: Column(
        children: [
          // ===== MAP =====
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
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

          // ===== STATUS =====
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: getStatusColor(attendance).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: getStatusColor(attendance)),
                const SizedBox(width: 10),
                Text(
                  getStatusText(attendance),
                  style: TextStyle(color: getStatusColor(attendance)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ===== ADDRESS =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(address, style: const TextStyle(fontSize: 14)),
          ),

          const SizedBox(height: 20),

          // ===== PILIHAN =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: !hasAttendance
                        ? () async {
                            if (currentLatLng == null) return;
                            await controller.doCheckIn(
                              lat: currentLatLng!.latitude,
                              lng: currentLatLng!.longitude,
                              address: address,
                            );
                            await controller.getTodayAttendance();
                          }
                        : null,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: attendance?.status == "hadir"
                            ? Colors.blue
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(child: Text("Hadir")),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: !hasAttendance
                        ? () async {
                            await controller.doIzin(alasanController.text);
                            await controller.getTodayAttendance();
                          }
                        : null,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: attendance?.status == "izin"
                            ? Colors.orange
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(child: Text("Izin")),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ===== INPUT IZIN =====
          if (attendance?.status == "izin" && !hasAttendance)
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: alasanController,
                decoration: const InputDecoration(
                  hintText: "Masukkan alasan izin",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

          const Spacer(),

          // ===== BUTTON =====
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: !hasAttendance || attendance.checkOutTime == null
                  ? () async {
                      if (currentLatLng == null) return;

                      if (!hasAttendance) {
                        await controller.doCheckIn(
                          lat: currentLatLng!.latitude,
                          lng: currentLatLng!.longitude,
                          address: address,
                        );
                      } else if (attendance.checkOutTime == null) {
                        await controller.doCheckOut(
                          lat: currentLatLng!.latitude,
                          lng: currentLatLng!.longitude,
                          address: address,
                        );
                      }

                      await controller.getTodayAttendance();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: controller.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      !hasAttendance
                          ? "Check In"
                          : attendance.checkOutTime == null
                          ? "Check Out"
                          : "Selesai",
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
