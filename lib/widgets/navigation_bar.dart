import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

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
      height: 65,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: Color(0xFF1E3A8A),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(0, PhosphorIcons.house, "Beranda"),
          _buildItem(1, PhosphorIcons.checkSquare, "Kehadiran"),
          _buildItem(2, PhosphorIcons.clock, "Riwayat"),
          _buildItem(3, PhosphorIcons.user, "Profil"),
        ],
      ),
    );
  }

  Widget _buildItem(
    int index,
    IconData Function([PhosphorIconsStyle]) icon,
    String label,
  ) {
    final bool isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 70,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔥 ICON + LIFT + GLOW
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                transform: Matrix4.translationValues(
                  0,
                  isActive ? -5 : 0, // 🔥 naik dikit
                  0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 1,
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(
                    isActive
                        ? icon(PhosphorIconsStyle.fill)
                        : icon(PhosphorIconsStyle.regular),
                    size: 24,
                    color: isActive
                        ? Colors.orange
                        : Colors.orange.withOpacity(0.5),
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // 🔥 TEXT ANIMATION
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isActive ? 1 : 0.6,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: isActive
                        ? Colors.orange
                        : Colors.orange.withOpacity(0.6),
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
