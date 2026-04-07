class Attendance {
  final int? id;
  final String attendanceDate;
  final String? checkInTime;
  final String? checkOutTime;
  final String? status;
  final String? address;

  Attendance({
    this.id,
    required this.attendanceDate,
    this.checkInTime,
    this.checkOutTime,
    this.status,
    this.address,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      attendanceDate: json['attendance_date'],
      checkInTime: json['check_in_time'],
      checkOutTime: json['check_out_time'],
      status: json['status'],
      address: json['check_in_address'] ?? json['check_out_address'],
    );
  }

  String get workingHours {
    if (checkInTime == null || checkOutTime == null) return "-";

    try {
      final checkIn = DateTime.parse("2024-01-01 $checkInTime");
      final checkOut = DateTime.parse("2024-01-01 $checkOutTime");

      final diff = checkOut.difference(checkIn);

      final hours = diff.inHours;
      final minutes = diff.inMinutes.remainder(60);

      return "${hours}j ${minutes}m";
    } catch (e) {
      return "-";
    }
  }
}
