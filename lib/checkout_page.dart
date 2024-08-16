import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sertifikasi_jmp/home_page.dart';
import 'package:sertifikasi_jmp/map_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutPage extends StatefulWidget {
  final String productName;
  final double productPrice;
  final int quantity;

  CheckoutPage({
    required this.productName,
    required this.productPrice,
    required this.quantity,
  });

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController =
      TextEditingController(text: '+62');

  double? _selectedLatitude;
  double? _selectedLongitude;
  bool _locationSelected = false;

  double get _totalPrice => widget.productPrice * widget.quantity;

  void _selectLocation(double latitude, double longitude) {
    setState(() {
      _selectedLatitude = latitude;
      _selectedLongitude = longitude;
      _locationSelected = true;
    });
  }

  // ignore: unused_element
  void _resetLocation() {
    setState(() {
      _selectedLatitude = null;
      _selectedLongitude = null;
      _locationSelected = false;
    });
  }

  Future<void> _submitPurchase() async {
    if (_formKey.currentState!.validate() && _locationSelected) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String username = prefs.getString('username') ?? '';
      print("Stored Username: $username");

      String url = 'http://192.168.1.17/sertifikasi/purchase.php';

      Map<String, dynamic> data = {
        'username': username,
        'name': _nameController.text,
        'address': _addressController.text,
        'phone': _phoneController.text,
        'product_name': widget.productName,
        'product_price': widget.productPrice.toString(),
        'quantity': widget.quantity,
        'latitude': _selectedLatitude.toString(),
        'longitude': _selectedLongitude.toString(),
      };

      var response = await http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      print("Response body: ${response.body}"); // Debug response

      try {
        Map responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          // Handle success
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Purchase Successful'),
            backgroundColor: Colors.green,
          ));

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false,
          );
        } else {
          // Handle failure
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Pemesanan Gagal nih, Coba lagi ya'),
            backgroundColor: Colors.red,
          ));
        }
      } catch (e) {
        print("Error parsing response: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Unexpected error occurred.'),
          backgroundColor: Colors.red,
        ));
      }
    } else if (!_locationSelected) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Pilih lokasinya dong di peta'),
        backgroundColor: Colors.red,
      ));
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
          'Checkout',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Boleh kenalan namanya siapa ? ';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Rumah mu dimana? aku boleh mampir dong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.startsWith('+62')) {
                      return 'Boleh minta nomernya ga ?';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                _locationSelected
                    ? Text(
                        'Lokasi udah ditentuin, pastikan lagi benar ya',
                        style: TextStyle(color: Colors.green),
                      )
                    : Text(
                        'Kamu dimana? tentuin dulu titik lokasinya',
                        style: TextStyle(color: Colors.red),
                      ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final selectedLocation = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapPage(
                                initialLatitude: _selectedLatitude,
                                initialLongitude: _selectedLongitude,
                              )),
                    );
                    if (selectedLocation != null) {
                      _selectLocation(selectedLocation.latitude,
                          selectedLocation.longitude);
                    }
                  },
                  child: Text('Buka Peta'),
                ),
                SizedBox(height: 20),
                Text(
                  'Total Price: Rp ${_totalPrice.toStringAsFixed(0)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _submitPurchase,
                  child: Text('Pesan Sekarang'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
