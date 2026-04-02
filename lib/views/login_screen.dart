import 'package:app_absensi/widgets/background_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Dibutuhkan untuk mengatur warna Status Bar

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'dummy@gmail.com');
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Warna biru navy persis tombol login
    const Color navyColor = Color(0xFF15348A);

    return Scaffold(
      backgroundColor: Colors.white,
      // Mengatur warna bar bagian paling atas
      appBar: AppBar(
        toolbarHeight:
            0, // Menyembunyikan AppBar tapi tetap mempertahankan status bar
        elevation: 0,
        backgroundColor: navyColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: navyColor, // Untuk Android
          statusBarIconBrightness: Brightness.light, // Ikon putih (jam, sinyal)
          statusBarBrightness: Brightness.dark, // Untuk iOS agar teks putih
        ),
      ),
      body: Stack(
        children: [
          // Background oranye estetik dengan gradasi dan bayangan
          const AuthBackground(),

          // Konten Form
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 30,
                  ), // Mengurangi sedikit jarak agar seimbang
                  // Header: Judul Aplikasi
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Presence App',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 120),

                  // Teks Log In
                  const Text(
                    'Log in',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Input Email
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Input Kata Sandi
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: 'Kata Sandi',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tombol Log In
                  ElevatedButton(
                    onPressed: () {
                      // Logika login di sini
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navyColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Lupa Kata Sandi
                  GestureDetector(
                    onTap: () {
                      // Navigasi ke Lupa Sandi
                    },
                    child: const Text(
                      'Lupa Kata Sandi?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Footer: Register
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Belum punya akun? ',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigasi ke Register
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: navyColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
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
}
