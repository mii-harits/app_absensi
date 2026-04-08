import 'dart:ui';
import 'package:app_absensi/api/api_service.dart';
import 'package:app_absensi/extension/navigator.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isVisibility = true;
  bool isLoading = false;
  bool isLoadingData = true;

  List<dynamic> batchList = [];
  List<dynamic> jurusanList = [];

  String? selectedBatch;
  String? selectedJurusan;
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final batchResponse = await ApiService.getBatch();
      final jurusanResponse = await ApiService.getJurusan();

      setState(() {
        batchList = batchResponse['data'];
        jurusanList = jurusanResponse['data'];
        isLoadingData = false;
      });
    } catch (e) {
      setState(() => isLoadingData = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingData) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // BACKGROUND
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

          Positioned(top: -60, right: -60, child: _blurCircle(220)),
          Positioned(bottom: -60, left: -60, child: _blurCircle(250)),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // HEADER
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
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
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 40),

                          _glassCard(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  _input("Nama", nameController),
                                  const SizedBox(height: 12),

                                  _input("Email", emailController),
                                  const SizedBox(height: 12),

                                  _input(
                                    "Password",
                                    passwordController,
                                    obscure: isVisibility,
                                    suffix: IconButton(
                                      onPressed: () => setState(
                                        () => isVisibility = !isVisibility,
                                      ),
                                      icon: Icon(
                                        isVisibility
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // BATCH
                                  _dropdown(
                                    "Batch",
                                    selectedBatch,
                                    batchList.map((item) {
                                      return DropdownMenuItem(
                                        value: item['id'].toString(),
                                        child: Text(
                                          "Batch ${item['batch_ke']}",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                    (v) => setState(() => selectedBatch = v),
                                  ),

                                  const SizedBox(height: 12),

                                  // JURUSAN (FIX OVERFLOW)
                                  _dropdown(
                                    "Jurusan",
                                    selectedJurusan,
                                    jurusanList.map((item) {
                                      return DropdownMenuItem(
                                        value: item['id'].toString(),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            item['title'],
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    (v) => setState(() => selectedJurusan = v),
                                  ),

                                  const SizedBox(height: 15),

                                  // GENDER
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _genderCard(
                                          "Laki-laki",
                                          selectedGender == "L",
                                          () => setState(
                                            () => selectedGender = "L",
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: _genderCard(
                                          "Perempuan",
                                          selectedGender == "P",
                                          () => setState(
                                            () => selectedGender = "P",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 25),

                                  // BUTTON
                                  GestureDetector(
                                    onTap: isLoading
                                        ? null
                                        : () async {
                                            if (!_formKey.currentState!
                                                    .validate() ||
                                                selectedGender == null ||
                                                selectedBatch == null ||
                                                selectedJurusan == null) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    "Semua data harus diisi",
                                                  ),
                                                ),
                                              );
                                              return;
                                            }

                                            setState(() => isLoading = true);

                                            try {
                                              final result =
                                                  await ApiService.register(
                                                    nameController.text,
                                                    emailController.text,
                                                    passwordController.text,
                                                    selectedBatch!,
                                                    selectedJurusan!,
                                                    selectedGender!,
                                                  );

                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    result['message'],
                                                  ),
                                                ),
                                              );

                                              if (result['message']
                                                  .toLowerCase()
                                                  .contains("berhasil")) {
                                                context.pop();
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text("Error: $e"),
                                                ),
                                              );
                                            }

                                            setState(() => isLoading = false);
                                          },
                                    child: Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Colors.orange,
                                            Colors.deepOrange,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(18),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.25,
                                            ),
                                            blurRadius: 15,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      alignment: Alignment.center,
                                      child: isLoading
                                          ? const CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                          : const Text(
                                              "Daftar",
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

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= COMPONENT =================

  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white24),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _input(
    String label,
    TextEditingController controller, {
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      validator: (v) => v == null || v.isEmpty ? "$label wajib diisi" : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _dropdown(
    String label,
    String? value,
    List<DropdownMenuItem<String>> items,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      isExpanded: true, // 🔥 FIX OVERFLOW
      value: value,
      dropdownColor: Colors.white,
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
      items: items,
      onChanged: onChanged,
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
