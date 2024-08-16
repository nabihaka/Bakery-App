import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sertifikasi_jmp/login_page.dart';
import 'package:sertifikasi_jmp/product.dart';
import 'package:sertifikasi_jmp/product_detail_page.dart';
import 'package:sertifikasi_jmp/transaction_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  Future<List<Product>> fetchProducts() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.17/sertifikasi/product.php'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Gagal mengambil data produk');
    }
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username'); // Clear the username

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        title: Text(
          'Menu ',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserTransactionPage()),
              );
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Positioned.fill(
            child: Image.network(
              'http://192.168.1.17/sertifikasi/images/home_page.png',
              fit: BoxFit.cover,
            ),
          ),
          // Product List
          FutureBuilder<List<Product>>(
            future: fetchProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No Products Found'));
              } else {
                List<Product> products = snapshot.data!;
                return ListView.builder(
                  itemCount: (products.length + 1) ~/ 2,
                  itemBuilder: (context, index) {
                    final int firstIndex = index * 2;
                    final int secondIndex = firstIndex + 1;

                    return ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            child:
                                buildProductCard(context, products[firstIndex]),
                          ),
                          SizedBox(width: 8),
                          if (secondIndex < products.length)
                            Expanded(
                              child: buildProductCard(
                                  context, products[secondIndex]),
                            ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _logout(context),
        child: Icon(Icons.logout),
        backgroundColor: Colors.red,
        tooltip: 'Logout',
      ),
    );
  }

  Widget buildProductCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                height: 150,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Rp ${product.price.toStringAsFixed(0)}',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
