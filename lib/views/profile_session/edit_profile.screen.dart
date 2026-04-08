import 'dart:ui';
import 'package:app_absensi/api/api_service.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();

  Map<String, dynamic>? profile;
  bool isLoading = true;
  bool isSubmit = false;

  String? selectedGender;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final result = await ApiService.getProfile();
      final data = result['data'];

      nameController.text = data['name'] ?? '';
      selectedGender = data['jenis_kelamin'];

      setState(() {
        profile = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

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
            child: Column(
              children: [
                // ================= HEADER =================
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Text(
                        "Edit Profil",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // ================= AVATAR =================
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 3),
                  ),
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 25),

                // ================= FORM =================
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView(
                      children: [
                        _glassInput(label: "Nama", controller: nameController),

                        const SizedBox(height: 15),

                        _glassInput(
                          label: "Email",
                          controller: TextEditingController(
                            text: profile?['email'] ?? '',
                          ),
                          enabled: false,
                        ),

                        const SizedBox(height: 15),

                        _glassInput(
                          label: "Batch",
                          controller: TextEditingController(
                            text:
                                "Batch ${profile?['batch']?['batch_ke'] ?? '-'}",
                          ),
                          enabled: false,
                        ),

                        const SizedBox(height: 15),

                        _glassInput(
                          label: "Jurusan",
                          controller: TextEditingController(
                            text:
                                "Jurusan ID ${profile?['training_id'] ?? '-'}",
                          ),
                          enabled: false,
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Jenis Kelamin",
                          style: TextStyle(color: Colors.white70),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: _genderCard(
                                "Laki-laki",
                                selectedGender == "L",
                                () => setState(() => selectedGender = "L"),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _genderCard(
                                "Perempuan",
                                selectedGender == "P",
                                () => setState(() => selectedGender = "P"),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // ================= BUTTON =================
                        GestureDetector(
                          onTap: isSubmit
                              ? null
                              : () async {
                                  setState(() => isSubmit = true);

                                  try {
                                    final result =
                                        await ApiService.updateProfile(
                                          nameController.text,
                                          selectedGender ?? "",
                                        );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(result['message']),
                                      ),
                                    );

                                    Navigator.pop(context);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Error: $e")),
                                    );
                                  }

                                  setState(() => isSubmit = false);
                                },
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.orange, Colors.deepOrange],
                              ),
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: isSubmit
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Simpan Perubahan",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
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

  // ================= COMPONENT =================

  Widget _glassInput({
    required String label,
    required TextEditingController controller,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _genderCard(String text, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: active
              ? const LinearGradient(colors: [Colors.orange, Colors.deepOrange])
              : null,
          color: active ? null : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: active ? Colors.white : Colors.white70,
              fontWeight: FontWeight.bold,
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
}
