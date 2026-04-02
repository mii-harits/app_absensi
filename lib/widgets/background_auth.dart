import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(child: CustomPaint(painter: BackgroundPainter()));
  }
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Definisikan Path Lengkungan
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height * 0.85);
    path.lineTo(size.width * 0.52, size.height * 0.85);
    path.quadraticBezierTo(
      size.width * 0.52,
      size.height * 0.45,
      size.width * 0.0,
      size.height * 0.25,
    );
    path.close(); // Menutup path ke titik awal (0,0)

    // 2. Buat Efek Bayangan (Shadow) agar terlihat mengambang dan keren
    canvas.drawShadow(
      path,
      Colors.black.withAlpha(80), // Warna bayangan yang lembut
      8.0, // Radius blur bayangan
      true, // Efek transparansi pada bayangan
    );

    // 3. Buat Gradasi Warna Oranye yang estetik
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFB35A), // Oranye agak terang di pojok kiri atas
          Color(0xFFFFA23A), // Oranye utama di tengah
          Color(0xFFE68110), // Oranye lebih gelap di kanan bawah
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width * 0.55, size.height * 0.85))
      ..style = PaintingStyle.fill;

    // 4. Gambar path dengan warna gradasi tersebut
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
