import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserTransactionPage extends StatefulWidget {
  @override
  _UserTransactionPageState createState() => _UserTransactionPageState();
}

class _UserTransactionPageState extends State<UserTransactionPage> {
  List<dynamic> _transactions = []; // Initialize _transactions
  String? _username; // Username retrieved from SharedPreferences

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username');
    });
    _fetchTransactions(); // Fetch transactions once username is loaded
  }

  Future<void> _fetchTransactions() async {
    if (_username == null) return;

    final response = await http.post(
      Uri.parse('http://192.168.1.17/sertifikasi/user_transactions.php'),
      body: jsonEncode({'username': _username}),
      headers: {'Content-Type': 'application/json'},
    );

    // Debugging: Periksa status kode dan body respons
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['success']) {
        setState(() {
          _transactions = jsonResponse['data'];
        });
      } else {
        setState(() {
          _transactions = [];
        });
        throw Exception('No transactions found');
      }
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Transactions',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: _transactions.isEmpty
          ? Center(child: Text('No transactions found'))
          : ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                var transaction = _transactions[index];
                return ListTile(
                  title: Text(transaction['product_name']),
                  subtitle: Text('Quantity: ${transaction['quantity']}'),
                  trailing: Text('Rp ${transaction['total_price']}'),
                );
              },
            ),
    );
  }
}
