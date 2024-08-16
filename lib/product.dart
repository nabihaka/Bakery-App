class Product {
  final String name;
  final double price;
  final String imageUrl;
  final String description;

  Product({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: double.parse(json['price'].toString()),
      imageUrl: json['imageUrl'],
      description: json['description'],
    );
  }
}
