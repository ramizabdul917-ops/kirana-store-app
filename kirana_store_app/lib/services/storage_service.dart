import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/order.dart';

class StorageService {
  static const String keyProducts = 'kirana_products_v1';
  static const String keyOrders = 'kirana_orders_v1';
  static const String keyShopName = 'kirana_shop_name';
  static const String keyShopPhone = 'kirana_shop_phone';
  static const String keyShopUpi = 'kirana_shop_upi';
  static const String keyShopHours = 'kirana_shop_hours';
  static const String keyShopAnnouncement = 'kirana_shop_announcement';
  static const String keyAdminPin = 'kirana_admin_pin';
  static const String keyTokenCounter = 'kirana_token_counter';

  // Products
  static Future<void> saveProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = products.map((p) => p.toJson()).toList();
    await prefs.setString(keyProducts, jsonEncode(jsonList));
  }

  static Future<List<Product>?> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(keyProducts);
    if (str == null || str.isEmpty) return null;
    try {
      final List<dynamic> decoded = jsonDecode(str);
      return decoded.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return null;
    }
  }

  // Orders
  static Future<void> saveOrders(List<OrderModel> orders) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = orders.map((o) => o.toJson()).toList();
    await prefs.setString(keyOrders, jsonEncode(jsonList));
  }

  static Future<List<OrderModel>> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(keyOrders);
    if (str == null || str.isEmpty) return [];
    try {
      final List<dynamic> decoded = jsonDecode(str);
      return decoded.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  // Token Counter (Generates unique #K-101, #K-102...)
  static Future<int> getNextTokenNumber() async {
    final prefs = await SharedPreferences.getInstance();
    int current = prefs.getInt(keyTokenCounter) ?? 100;
    current++;
    if (current > 9999) current = 101; // Cycle 4 digits
    await prefs.setInt(keyTokenCounter, current);
    return current;
  }

  // Shop Settings
  static Future<Map<String, String>> loadShopSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'shopName': prefs.getString(keyShopName) ?? '',
      'shopPhone': prefs.getString(keyShopPhone) ?? '',
      'shopUpi': prefs.getString(keyShopUpi) ?? '',
      'shopHours': prefs.getString(keyShopHours) ?? '',
      'shopAnnouncement': prefs.getString(keyShopAnnouncement) ?? '',
      'adminPin': prefs.getString(keyAdminPin) ?? '1234',
    };
  }

  static Future<void> saveShopSettings({
    required String shopName,
    required String shopPhone,
    required String shopUpi,
    required String shopHours,
    required String shopAnnouncement,
    required String adminPin,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyShopName, shopName);
    await prefs.setString(keyShopPhone, shopPhone);
    await prefs.setString(keyShopUpi, shopUpi);
    await prefs.setString(keyShopHours, shopHours);
    await prefs.setString(keyShopAnnouncement, shopAnnouncement);
    await prefs.setString(keyAdminPin, adminPin);
  }
}
