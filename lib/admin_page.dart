import 'package:flutter/material.dart';
import 'package:sertifikasi_jmp/add_product_page.dart';
import 'package:sertifikasi_jmp/transaction_list_page.dart';
import 'package:sertifikasi_jmp/user_management.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  void _navigateToTransactionList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TransactionListPage()),
    );
  }

  void _navigateToUserManagement(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserManagementPage()),
    );
  }

  void _navigateToAddProduct(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProductPage()),
    );
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username'); // Hapus sesi admin

    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        title: Text('Admin Dashboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              leading: Icon(Icons.list_alt, size: 40.0),
              title: Text('Daftar Transaksi', style: TextStyle(fontSize: 18.0)),
              subtitle: Text('Kelola daftar transaksi'),
              onTap: () => _navigateToTransactionList(context),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.people, size: 40.0),
              title: Text('Kelola User', style: TextStyle(fontSize: 18.0)),
              subtitle: Text('Kelola pengguna aplikasi'),
              onTap: () => _navigateToUserManagement(context),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_shopping_cart, size: 40.0),
              title: Text('Tambah Produk', style: TextStyle(fontSize: 18.0)),
              subtitle: Text('Tambah produk baru ke dalam sistem'),
              onTap: () => _navigateToAddProduct(context),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _logout(context),
        child: Icon(Icons.logout),
        backgroundColor: Colors.red,
        tooltip: 'Logout',
      ),
    );
  }
}
