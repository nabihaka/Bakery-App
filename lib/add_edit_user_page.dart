import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddEditUserPage extends StatefulWidget {
  final Map<String, dynamic>? user;

  AddEditUserPage({this.user});

  @override
  _AddEditUserPageState createState() => _AddEditUserPageState();
}

class _AddEditUserPageState extends State<AddEditUserPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  String _role = 'user';

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _username = widget.user!['username'];
      _role = widget.user!['role'];
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final url = widget.user == null
          ? 'http://192.168.1.17/sertifikasi/add_user.php'
          : 'http://192.168.1.17/sertifikasi/edit_user.php';
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'id': widget.user?['id'],
          'username': _username,
          'password': _password,
          'role': _role,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success']) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('User berhasil disimpan'),
          ));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Gagal menyimpan user: ${jsonResponse['message']}'),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gagal menyimpan user'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        title: Text(widget.user == null ? 'Tambah User' : 'Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                initialValue: _username,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Username tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) {
                  _username = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (widget.user == null && value!.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) {
                  if (value!.isNotEmpty) _password = value;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Role'),
                value: _role,
                items: ['user', 'admin']
                    .map((role) => DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _role = value!;
                  });
                },
                onSaved: (value) {
                  _role = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: _submitForm,
                child: Text(
                    widget.user == null ? 'Tambah User' : 'Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
