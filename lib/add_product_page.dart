import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _price = '';
  String _imageUrl = '';
  String _description = '';

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final response = await http.post(
        Uri.parse('http://192.168.1.17/sertifikasi/add_product.php'),
        body: jsonEncode({
          'name': _name,
          'price': _price,
          'imageUrl': _imageUrl,
          'description': _description,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success']) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Produk berhasil ditambahkan'),
          ));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Gagal menambahkan produk: ${jsonResponse['message']}'),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gagal menambahkan produk'),
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
        title: Text('Tambah Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nama Produk'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Nama produk tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Harga Produk'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Harga produk tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) {
                  _price = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'URL Gambar Produk'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'URL gambar tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) {
                  _imageUrl = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Deskripsi Produk'),
                maxLines: 3,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Deskripsi produk tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: _submitForm,
                child: Text('Tambah Produk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
