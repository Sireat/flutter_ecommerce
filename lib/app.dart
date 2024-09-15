import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/repositories/product_repository_impl.dart';
import 'presentation/providers/cart_provider.dart';
import 'presentation/screens/product_list_screen.dart';
import 'presentation/screens/cart_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Override the Http client to allow self-signed or untrusted certificates for development.
    HttpOverrides.global = MyHttpOverrides();

    return MultiProvider(
      providers: [
        Provider<ProductRepositoryImpl>(
          create: (_) => ProductRepositoryImpl(),
        ),
        ChangeNotifierProvider<CartProvider>(
          create: (_) => CartProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'E-Commerce App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ProductListScreen(),
        routes: {
          '/cart': (context) => const CartScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

/// Custom HttpOverrides to handle SSL certificate verification.
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
