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

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal ambil profile: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            // ===== APP BAR =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Ubah Profil",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ===== AVATAR =====
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.yellow,
                  child: const CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage(
                      "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ===== FORM =====
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  children: [
                    // NAMA
                    _buildTextField(label: "Nama", controller: nameController),

                    const SizedBox(height: 15),

                    // EMAIL (LOCK)
                    _buildTextField(
                      label: "Email",
                      controller: TextEditingController(
                        text: profile?['email'] ?? '',
                      ),
                      enabled: false,
                      fillColor: Colors.orange[200],
                    ),

                    const SizedBox(height: 15),

                    // BATCH (LOCK)
                    _buildTextField(
                      label: "Batch",
                      controller: TextEditingController(
                        text: "Batch ${profile?['batch']?['batch_ke'] ?? '-'}",
                      ),
                      enabled: false,
                      fillColor: Colors.orange[200],
                    ),

                    const SizedBox(height: 15),

                    // JURUSAN (LOCK)
                    // JURUSAN (LOCK)
                    _buildTextField(
                      label: "Jurusan",
                      controller: TextEditingController(
                        text: "Jurusan ID ${profile?['training_id'] ?? '-'}",
                      ),
                      enabled: false,
                      fillColor: Colors.orange[200],
                    ),

                    const SizedBox(height: 20),

                    // ===== GENDER =====
                    const Text("Jenis Kelamin"),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => selectedGender = "L"),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: selectedGender == "L"
                                    ? const Color(0xFF1E3A8A)
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  "Laki-laki",
                                  style: TextStyle(
                                    color: selectedGender == "L"
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => selectedGender = "P"),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: selectedGender == "P"
                                    ? const Color(0xFF1E3A8A)
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  "Perempuan",
                                  style: TextStyle(
                                    color: selectedGender == "P"
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // ===== BUTTON =====
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isSubmit
                            ? null
                            : () async {
                                setState(() => isSubmit = true);

                                try {
                                  final result = await ApiService.updateProfile(
                                    nameController.text,
                                    selectedGender ?? "",
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(result['message'])),
                                  );

                                  Navigator.pop(context);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Error: $e")),
                                  );
                                }

                                setState(() => isSubmit = false);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A8A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: isSubmit
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Done",
                                style: TextStyle(fontSize: 16),
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
    );
  }

  // ===== TEXTFIELD CUSTOM =====
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool enabled = true,
    Color? fillColor,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: fillColor ?? Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
