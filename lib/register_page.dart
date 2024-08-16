import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sertifikasi_jmp/login_page.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController controllerUsername = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> register(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      String url = 'http://192.168.1.17/sertifikasi/user/register.php';
      var response = await http.post(Uri.parse(url), body: {
        'username': controllerUsername.text,
        'password': controllerPassword.text,
      });

      Map responseBody = jsonDecode(response.body);
      if (responseBody['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration Successful'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      } else {
        String errorMessage =
            responseBody['message'] == "Username already exists"
                ? 'Username already taken'
                : 'Registration Failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Positioned.fill(
            child: Image.network(
              'http://192.168.1.17/sertifikasi/images/login_page.png',
              fit: BoxFit.cover,
            ),
          ),
          // Register Form
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        controller: controllerUsername,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a username';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: controllerPassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => register(context),
                          child: Text('Register'),
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
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Already have an account? Login',
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
          ),
        ],
      ),
    );
  }
}
