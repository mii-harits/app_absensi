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
      backgroundColor: Colors.grey[200],

      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ===== HEADER ORANGE =====
                Container(
                  width: double.infinity,
                  height: 260,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF59E0B), // orange
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.yellow,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                            "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Nama
                      Text(
                        user?['name'] ?? '-',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      // NIM
                      Text(
                        user?['email'] ?? '-',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ===== MENU LIST =====
                _buildMenuItem(
                  icon: Icons.person_outline,
                  text: "Ubah Profil",
                  color: Colors.blue,
                  onTap: () async {
                    await context.push(const EditProfileScreen());

                    // 🔥 refresh data setelah balik
                    fetchProfile();
                  },
                ),

                _buildDivider(),

                _buildMenuItem(
                  icon: Icons.lock_outline,
                  text: "Ubah Kata Sandi",
                  color: Colors.blue,
                  onTap: () {
                    print("Klik Ubah Kata Sandi");
                  },
                ),

                _buildDivider(),

                _buildMenuItem(
                  icon: Icons.logout,
                  text: "Keluar",
                  color: Colors.red,
                  onTap: () {
                    print("Logout");
                    PreferenceHandler().storingIsLogin(false);
                    context.pushAndRemoveAll(LoginScreen());
                  },
                ),
              ],
            ),
    );
  }

  // ===== WIDGET MENU =====
  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 15),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Divider(),
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
