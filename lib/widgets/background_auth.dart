import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget? body;

  const AuthBackground({super.key, this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // BACKGROUND
          Container(color: Colors.grey.shade200),

          // SHAPE ORANGE (CUSTOM)
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: ClipPath(
                clipper: OrangeShapeClipper(),
                child: Container(
                  width: 260,
                  height: double.infinity,
                  color: const Color(0xFFF59E42),
                ),
              ),
            ),
          ),

          // CONTENT
          if (body != null) body!,
        ],
      ),
    );
  }
}

class OrangeShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // mulai dari kiri atas
    path.moveTo(0, 0);

    // garis ke kanan sedikit
    path.lineTo(size.width * 0.8, 0);

    // curve ke tengah
    path.quadraticBezierTo(
      size.width,
      size.height * 0.3,
      size.width * 0.6,
      size.height * 0.5,
    );

    // curve ke bawah
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.8,
      size.width * 0.8,
      size.height,
    );

    // turun lurus ke bawah kiri
    path.lineTo(0, size.height);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
