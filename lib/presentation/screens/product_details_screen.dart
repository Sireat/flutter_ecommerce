import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../../domain/entities/product.dart';
import '../providers/cart_provider.dart';

/// Screen that displays detailed information about a product.
class ProductDetailsScreen extends StatefulWidget {
  final ProductEntity product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late ConfettiController _confettiController;
  bool _isCelebrating = false; // To control the display of the star icon

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _celebrateAndAddToCart() {
    // Start the confetti animation
    _confettiController.play();

    // Set the flag to show the star icon
    setState(() {
      _isCelebrating = true;
    });

    // Add the product to the cart
    Provider.of<CartProvider>(context, listen: false).addToCart(widget.product);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to cart!')),
    );

    // Reset the celebration flag after a delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isCelebrating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.title),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.pushNamed(context, '/cart');
                    },
                  ),
                  if (cartProvider.itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.red,
                        child: Text(
                          cartProvider.itemCount.toString(),
                          style: const TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Images Row
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Main Product Image
                      Expanded(
                        flex: 7,
                        child: Container(
                          color: Colors.grey[200],
                          child: Center(
                            child: Image.network(
                              widget.product.image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: MediaQuery.of(context).size.width * 0.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Flipped Image for Side View
                      Expanded(
                        flex: 3, // Adjust the flex to control the width ratio
                        child: Container(
                          color: const Color.fromARGB(255, 224, 222, 222),
                          child: Stack(
                            children: [
                              // Product Image
                              Center(
                                child: Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(3.14), // Flip horizontally
                                  child: Image.network(
                                    widget.product.image,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.width * 0.3,
                                  ),
                                ),
                              ),
                              // Heart Icon for Bookmark
                              Positioned(
                                top: 8,
                                right: 8,
                                child: IconButton(
                                  icon: const Icon(Icons.favorite_border, color: Colors.red),
                                  onPressed: () {
                                    // Handle bookmark action here
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Product Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    widget.product.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                // Brand and Sale Price
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand
                      Expanded(
                        child: Text(
                          widget.product.brand.isNotEmpty
                              ? widget.product.brand
                              : 'No brand available',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Sale Price
                      Text(
                        '\$${(widget.product.price * (1 - widget.product.discountPercentage / 100)).toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 20, color: Colors.red),
                      ),
                    ],
                  ),
                ),
                // Category
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    widget.product.category.isNotEmpty
                        ? widget.product.category
                        : 'No category available',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // Rating
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      // Display star icons based on rating
                      Row(
                        children: List.generate(5, (index) {
                          double starValue = widget.product.rating - index;
                          if (starValue >= 1) {
                            return const Icon(Icons.star, color: Colors.amber, size: 16);
                          } else if (starValue >= 0.5) {
                            return const Icon(Icons.star_half, color: Colors.amber, size: 16);
                          } else {
                            return const Icon(Icons.star_border, color: Colors.amber, size: 16);
                          }
                        }),
                      ),
                      const SizedBox(width: 4),
                      // Display rating value in brackets
                      Text(
                        '(${widget.product.rating.toStringAsFixed(1)})',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Product Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    widget.product.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),
                // Add to Cart Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _celebrateAndAddToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(double.infinity, 50),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('ADD TO CART'),
                  ),
                ),
              ],
            ),
          ),
          // Confetti Widget
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.red, Colors.blue, Colors.green, Colors.yellow],
            ),
          ),
          // Celebratory Star Icon
          if (_isCelebrating)
            Center(
              child: Icon(
                Icons.star,
                size: 100,
                color: Colors.amber.withOpacity(0.8),
              ),
            ),
        ],
      ),
    );
  }
}
