import 'package:app_absensi/api/api_service.dart';
import 'package:app_absensi/extension/navigator.dart';
import 'package:flutter/material.dart';
import 'package:app_absensi/widgets/background_auth.dart';

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

  // 🔥 DATA API
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

  void toggleVisibility() {
    setState(() {
      isVisibility = !isVisibility;
    });
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
      setState(() {
        isLoadingData = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal ambil data: $e")));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingData) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return AuthBackground(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
              ),
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 24),
                child: Text(
                  "Presence App",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 40),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      const Text(
                        "Register Account",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // NAMA
                      _buildTextField(nameController, "Nama"),

                      const SizedBox(height: 12),

                      // EMAIL
                      _buildTextField(emailController, "Email"),

                      const SizedBox(height: 12),

                      // PASSWORD
                      TextFormField(
                        controller: passwordController,
                        obscureText: isVisibility,
                        decoration: _inputDecoration("Kata Sandi").copyWith(
                          suffixIcon: IconButton(
                            onPressed: toggleVisibility,
                            icon: Icon(
                              isVisibility
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // 🔥 BATCH
                      DropdownButtonFormField<String>(
                        value: selectedBatch,
                        decoration: _inputDecoration("Batch"),
                        items: batchList.map((item) {
                          return DropdownMenuItem(
                            value: item['id'].toString(),
                            child: Text("Batch ${item['batch_ke']}"),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => selectedBatch = value);
                        },
                        validator: (v) => v == null ? "Pilih batch" : null,
                      ),

                      const SizedBox(height: 12),

                      // 🔥 JURUSAN
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: selectedJurusan,
                        decoration: _inputDecoration("Jurusan"),
                        items: jurusanList.map((item) {
                          return DropdownMenuItem(
                            value: item['id'].toString(),
                            child: Text(
                              item['title'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => selectedJurusan = value);
                        },
                        validator: (v) => v == null ? "Pilih jurusan" : null,
                      ),

                      const SizedBox(height: 12),

                      // 🔥 GENDER
                      const Text(
                        "Jenis Kelamin",
                        style: TextStyle(color: Colors.white),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() => selectedGender = "L");
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
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
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() => selectedGender = "P");
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
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
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // BUTTON
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  if (!_formKey.currentState!.validate() ||
                                      selectedGender == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Semua data harus diisi"),
                                      ),
                                    );
                                    return;
                                  }
                                  print({
                                    "batch": selectedBatch,
                                    "jurusan": selectedJurusan,
                                    "gender": selectedGender,
                                  });

                                  setState(() => isLoading = true);

                                  try {
                                    final result = await ApiService.register(
                                      nameController.text,
                                      emailController.text,
                                      passwordController.text,
                                      selectedBatch!,
                                      selectedJurusan!,
                                      selectedGender!,
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(result['message']),
                                      ),
                                    );

                                    if (result['message']
                                        .toLowerCase()
                                        .contains("berhasil")) {
                                      context.pop();
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Error: $e")),
                                    );
                                  }

                                  setState(() => isLoading = false);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A8A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text("Daftar"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔧 Helper UI
  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label),
      validator: (value) =>
          value == null || value.isEmpty ? "$label wajib diisi" : null,
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade300,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
