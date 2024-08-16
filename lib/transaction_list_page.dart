import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TransactionListPage extends StatefulWidget {
  @override
  _TransactionListPageState createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  Future<List<dynamic>> fetchTransactions() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.17/sertifikasi/admin.php'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Check if the response is successful and contains data
      if (jsonResponse['success']) {
        return jsonResponse['data'];
      } else {
        throw Exception('Tidak ada transaksi');
      }
    } else {
      throw Exception('Gagal memuat daftar transaksi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        title: Text('Daftar Transaksi'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada transaksi'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var transaction = snapshot.data![index];

                // Ensure address is handled as a string
                String customerAddress = (transaction['customer_address']);

                // Parse the quantity and total price
                int quantity = int.parse(transaction['quantity']);
                double totalPrice = double.parse(transaction['total_price']);

                return ListTile(
                  title: Text('${transaction['product_name']}'),
                  subtitle: Text('Customer: ${transaction['customer_name']}\n'
                      'Address: $customerAddress\n'
                      'Phone: ${transaction['customer_phone']}\n'
                      'Quantity: $quantity'),
                  trailing: Text('Total: Rp ${totalPrice.toStringAsFixed(0)}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
