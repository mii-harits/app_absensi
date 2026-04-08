import 'dart:ui';
import 'package:app_absensi/api/api_service.dart';
import 'package:app_absensi/extension/navigator.dart';
import 'package:app_absensi/storage/preference.dart';
import 'package:app_absensi/views/auth/login_screen.dart';
import 'package:app_absensi/views/profile_session/edit_profile.screen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ================= BACKGROUND =================
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1E3A8A),
                  Color(0xFF2563EB),
                  Color(0xFF60A5FA),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          Positioned(top: -50, right: -50, child: _blurCircle(200)),
          Positioned(bottom: -60, left: -40, child: _blurCircle(250)),

          SafeArea(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : Column(
                    children: [
                      const SizedBox(height: 20),

                      // ================= AVATAR =================
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24, width: 3),
                        ),
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ================= NAME =================
                      Text(
                        user?['name'] ?? '-',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        user?['email'] ?? '-',
                        style: const TextStyle(color: Colors.white70),
                      ),

                      const SizedBox(height: 25),

                      // ================= MENU =================
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            _menuCard(
                              icon: Icons.person_outline,
                              text: "Ubah Profil",
                              onTap: () async {
                                await context.push(const EditProfileScreen());
                                fetchProfile();
                              },
                            ),

                            const SizedBox(height: 12),

                            _menuCard(
                              icon: Icons.lock_outline,
                              text: "Ubah Kata Sandi",
                              onTap: () {
                                print("Klik Ubah Password");
                              },
                            ),

                            const SizedBox(height: 12),

                            _menuCard(
                              icon: Icons.logout,
                              text: "Keluar",
                              isDanger: true,
                              onTap: () {
                                PreferenceHandler().storingIsLogin(false);
                                context.pushAndRemoveAll(LoginScreen());
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  // ================= COMPONENT =================

  Widget _menuCard({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              children: [
                Icon(icon, color: isDanger ? Colors.redAccent : Colors.white),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isDanger ? Colors.redAccent : Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.white70,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _blurCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
    );
  }

  Future<void> fetchProfile() async {
    try {
      final result = await ApiService.getProfile();

      setState(() {
        user = result['data'];
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }
}
