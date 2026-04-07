import 'package:app_absensi/api/api_service.dart';
import 'package:app_absensi/extension/navigator.dart';
import 'package:app_absensi/storage/preference.dart';
import 'package:app_absensi/views/auth/register_screen.dart';
import 'package:app_absensi/views/main/main_screen.dart';
import 'package:app_absensi/widgets/background_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isVisibility = true;
  bool isLoading = false;

  void visibilityOnOff() {
    setState(() {
      isVisibility = !isVisibility;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 40),

            // TITLE
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 24),
                child: Text(
                  "Presence App",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            SizedBox(height: 60),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Log in",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 20),

                      // EMAIL
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: "Masukkan Email",
                          labelText: "Email",
                          filled: true,
                          fillColor: Colors.grey.shade300,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email wajib diisi";
                          } else if (!value.contains("@")) {
                            return "Email tidak valid";
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 16),

                      // PASSWORD
                      TextFormField(
                        controller: passwordController,
                        obscureText: isVisibility,
                        decoration: InputDecoration(
                          hintText: "Masukkan Kata Sandi",
                          labelText: "Kata Sandi",
                          filled: true,
                          fillColor: Colors.grey.shade300,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: IconButton(
                            onPressed: visibilityOnOff,
                            icon: Icon(
                              isVisibility
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                        ),
                        validator: (value) {
                          final password = value ?? "";
                          if (password.isEmpty) {
                            return 'Password wajib diisi';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 24),

                      // BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => isLoading = true);

                                    try {
                                      final result = await ApiService.login(
                                        emailController.text,
                                        passwordController.text,
                                      );

                                      print("LOGIN RESULT: $result");

                                      final token =
                                          result['data']?['token'] ??
                                          result['token'];

                                      if (token != null) {
                                        await PreferenceHandler().storingToken(
                                          token,
                                        );
                                        await PreferenceHandler()
                                            .storingIsLogin(true);

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text("Login Berhasil"),
                                          ),
                                        );

                                        context.pushAndRemoveAll(
                                          const MainScreen(),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              result['message'] ??
                                                  "Login gagal, jika belum punya akun, silahkan buat akun terlebih dahulu",
                                            ),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text("Error: $e")),
                                      );
                                    }

                                    setState(() => isLoading = false);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1E3A8A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text("Masuk"),
                        ),
                      ),

                      SizedBox(height: 12),

                      Center(
                        child: Text(
                          "Lupa Kata Sandi?",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),

                      Spacer(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Belum punya akun? "),
                          TextButton(
                            onPressed: () {
                              print("Ke halaman register");
                              context.push(RegisterScreen());
                            },
                            style: TextButton.styleFrom(
                              padding:
                                  EdgeInsets.zero, // biar rapet kayak desain
                              minimumSize: Size(
                                0,
                                0,
                              ), // hilangkan tinggi default
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),
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
}
