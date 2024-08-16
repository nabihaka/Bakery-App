import 'package:flutter/material.dart';
import 'package:sertifikasi_jmp/checkout_page.dart';
import 'package:sertifikasi_jmp/product.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          // Main Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Center(
                  child: Image.network(
                    product.imageUrl,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16),

                // Product Name
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),

                // Product Price
                Text(
                  'Rp ${product.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 16),

                // Product Description
                Text(
                  product.description,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 16),

                // Quantity Selector
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: _decrementQuantity,
                        color: Colors.black,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '$_quantity',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: _incrementQuantity,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                Spacer(),

                // Purchase Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutPage(
                            productName: product.name,
                            productPrice: product.price,
                            quantity: _quantity,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Warna background
                      foregroundColor: Colors.white, // Warna teks
                    ),
                    child: Text('Beli Sekarang'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
