import 'package:flutter/material.dart';

class CustomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Color(0xFF1E3A8A), // biru
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(0, Icons.home, Icons.home_outlined, "Home"),
          _buildItem(1, Icons.person, Icons.person_outline, "Profile"),
          _buildItem(
            2,
            Icons.qr_code_scanner,
            Icons.qr_code_scanner_outlined,
            "Scan",
          ),
          _buildItem(
            3,
            Icons.assignment,
            Icons.assignment_outlined,
            "Kehadiran",
          ),
          _buildItem(4, Icons.map, Icons.map_outlined, "Maps"),
        ],
      ),
    );
  }

  Widget _buildItem(
    int index,
    IconData activeIcon,
    IconData inactiveIcon,
    String label,
  ) {
    final bool isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isActive ? activeIcon : inactiveIcon,
            color: Colors.orange, // warna icon
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.orange,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
