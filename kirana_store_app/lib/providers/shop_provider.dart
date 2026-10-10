import 'package:flutter/foundation.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class ShopProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Category> _categories = AppConstants.defaultCategories;
  String _selectedCategoryId = 'all';
  String _searchQuery = '';

  String _shopName = AppConstants.defaultShopName;
  String _shopPhone = AppConstants.defaultShopPhone;
  String _shopUpi = AppConstants.defaultShopUpi;
  String _openingHours = AppConstants.defaultOpeningHours;
  String _announcement = AppConstants.defaultAnnouncement;
  String _adminPin = AppConstants.defaultAdminPin;
  bool _isAdminMode = false;
  bool _isLoading = true;

  ShopProvider() {
    init();
  }

  // Getters
  List<Product> get products => _products;
  List<Category> get categories => _categories;
  String get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;
  String get shopName => _shopName;
  String get shopPhone => _shopPhone;
  String get shopUpi => _shopUpi;
  String get openingHours => _openingHours;
  String get announcement => _announcement;
  bool get isAdminMode => _isAdminMode;
  bool get isLoading => _isLoading;

  List<Product> get filteredProducts {
    return _products.where((product) {
      final matchesCategory = _selectedCategoryId == 'all' || product.categoryId == _selectedCategoryId;
      if (!matchesCategory) return false;

      if (_searchQuery.trim().isEmpty) return true;

      final q = _searchQuery.toLowerCase().trim();
      final titleEn = product.titleEnglish.toLowerCase();
      final titleHi = product.titleHindi.toLowerCase();
      final desc = product.description.toLowerCase();

      return titleEn.contains(q) || titleHi.contains(q) || desc.contains(q);
    }).toList();
  }

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    // Load custom settings
    final settings = await StorageService.loadShopSettings();
    if (settings['shopName']!.isNotEmpty) _shopName = settings['shopName']!;
    if (settings['shopPhone']!.isNotEmpty) _shopPhone = settings['shopPhone']!;
    if (settings['shopUpi']!.isNotEmpty) _shopUpi = settings['shopUpi']!;
    if (settings['shopHours']!.isNotEmpty) _openingHours = settings['shopHours']!;
    if (settings['shopAnnouncement']!.isNotEmpty) _announcement = settings['shopAnnouncement']!;
    if (settings['adminPin']!.isNotEmpty) _adminPin = settings['adminPin']!;

    // Load products from storage or fallback to defaults
    final loadedProducts = await StorageService.loadProducts();
    if (loadedProducts != null && loadedProducts.isNotEmpty) {
      _products = loadedProducts;
    } else {
      _products = AppConstants.defaultProducts;
      await StorageService.saveProducts(_products);
    }

    _isLoading = false;
    notifyListeners();
  }

  void selectCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  bool verifyAdminPin(String enteredPin) {
    return enteredPin.trim() == _adminPin.trim();
  }

  void setAdminMode(bool enabled) {
    _isAdminMode = enabled;
    notifyListeners();
  }

  // Stock Management (Admin)
  Future<void> toggleProductStock(String productId) async {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      _products[index].inStock = !_products[index].inStock;
      notifyListeners();
      await StorageService.saveProducts(_products);
    }
  }

  // Price Management for daily fluctuating rates (Admin)
  Future<void> updateVariantPrice(String productId, String variantId, double newPrice) async {
    final pIndex = _products.indexWhere((p) => p.id == productId);
    if (pIndex != -1) {
      final vIndex = _products[pIndex].variants.indexWhere((v) => v.id == variantId);
      if (vIndex != -1) {
        _products[pIndex].variants[vIndex].price = newPrice;
        notifyListeners();
        await StorageService.saveProducts(_products);
      }
    }
  }

  // Shop Settings Update (Admin)
  Future<void> updateShopSettings({
    required String shopName,
    required String shopPhone,
    required String shopUpi,
    required String shopHours,
    required String announcement,
    required String adminPin,
  }) async {
    _shopName = shopName;
    _shopPhone = shopPhone;
    _shopUpi = shopUpi;
    _openingHours = shopHours;
    _announcement = announcement;
    _adminPin = adminPin;
    notifyListeners();

    await StorageService.saveShopSettings(
      shopName: shopName,
      shopPhone: shopPhone,
      shopUpi: shopUpi,
      shopHours: shopHours,
      shopAnnouncement: announcement,
      adminPin: adminPin,
    );
  }

  // Reset to default inventory (Admin helper)
  Future<void> resetToDefaults() async {
    _products = AppConstants.defaultProducts;
    notifyListeners();
    await StorageService.saveProducts(_products);
  }
}
