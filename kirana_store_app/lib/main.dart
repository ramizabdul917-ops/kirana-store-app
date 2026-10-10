import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/shop_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'screens/customer/home_screen.dart';
import 'utils/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KiranaStoreApp());
}

class KiranaStoreApp extends StatelessWidget {
  const KiranaStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ShopProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        title: 'श्री गणेश किराना स्टोर (Shree Ganesh Kirana)',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const CustomerHomeScreen(),
      ),
    );
  }
}
