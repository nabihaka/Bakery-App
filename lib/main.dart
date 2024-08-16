import 'package:flutter/material.dart';
import 'package:sertifikasi_jmp/admin_page.dart'; // Import halaman Admin
import 'package:sertifikasi_jmp/home_page.dart';
import 'package:sertifikasi_jmp/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          const SplashScreen(), // Mulai dengan SplashScreen untuk pengecekan sesi
      routes: {
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/admin': (context) => AdminPage(), // Rute untuk halaman Admin
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text('Page Not Found'),
            ),
            body: Center(
              child: Text('404 - Page Not Found'),
            ),
          ),
        );
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _checkSession(context);
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> _checkSession(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');

    if (username != null) {
      // Jika username ditemukan di shared_preferences, arahkan ke HomePage atau AdminPage
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      // Jika tidak ditemukan, arahkan ke LoginPage
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }
}
