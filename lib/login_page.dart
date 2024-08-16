import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sertifikasi_jmp/admin_page.dart';
import 'package:sertifikasi_jmp/home_page.dart';
import 'package:sertifikasi_jmp/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController controllerUsername = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  Future<void> login(BuildContext context) async {
    String url = 'http://192.168.1.17/sertifikasi/user/login.php';
    var response = await http.post(Uri.parse(url), body: {
      'username': controllerUsername.text,
      'password': controllerPassword.text,
    });

    // Decode the response
    Map<String, dynamic> responseBody = jsonDecode(response.body);

    if (responseBody['success']) {
      String role = responseBody['role'] ?? '';
      String username = responseBody['username'] ?? '';

      if (username.isNotEmpty && role.isNotEmpty) {
        // Save username to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login Success'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate based on role
        if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AdminPage(),
            ),
          );
        } else if (role == 'user') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login Failed: Invalid username or role'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login Failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.network(
              'http://192.168.1.17/sertifikasi/images/login_page.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      controller: controllerUsername,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: controllerPassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => login(context),
                        child: Text('Login'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
