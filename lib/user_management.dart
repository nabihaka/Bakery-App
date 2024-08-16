import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sertifikasi_jmp/add_edit_user_page.dart';

class UserManagementPage extends StatefulWidget {
  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  List<dynamic> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.17/sertifikasi/get_users.php'),
    );

    print('Response body: ${response.body}'); // Tambahkan log ini

    if (response.statusCode == 200) {
      try {
        setState(() {
          _users = json.decode(response.body);
        });
      } catch (e) {
        print('Error decoding JSON: $e');
        setState(() {
          _users = []; // Set empty list or show an error message
        });
        throw Exception('Failed to decode JSON');
      }
    } else {
      print('Error: ${response.statusCode}');
      setState(() {
        _users = []; // Set empty list or show an error message
      });
      throw Exception('Failed to load users');
    }
  }

  void _navigateToAddUser(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditUserPage()),
    ).then((value) => _fetchUsers());
  }

  void _navigateToEditUser(BuildContext context, Map<String, dynamic> user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditUserPage(user: user)),
    ).then((value) => _fetchUsers());
  }

  Future<void> _deleteUser(String id) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.17/sertifikasi/delete_user.php'),
      body: jsonEncode({'id': int.parse(id)}), // Convert id to integer
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      _fetchUsers();
    } else {
      throw Exception('Failed to delete user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        title: Text('Kelola User'),
        centerTitle: true,
      ),
      body: _users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                var user = _users[index];
                return ListTile(
                  title: Text(user['username']),
                  subtitle: Text(user['role']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _navigateToEditUser(context, user),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteUser(user['id']
                            .toString()), // Ensure id is passed as a string
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        onPressed: () => _navigateToAddUser(context),
        child: Icon(Icons.add),
        tooltip: 'Tambah User',
      ),
    );
  }
}
