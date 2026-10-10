import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/shop_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/shop_header.dart';
import '../../widgets/parchi_banner.dart';
import '../../widgets/category_item.dart';
import '../../widgets/product_card.dart';
import '../../widgets/floating_cart_bar.dart';
import '../admin/admin_dashboard_screen.dart';
import 'order_history_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();

    // If shopkeeper switched to admin mode, show Admin Dashboard
    if (shop.isAdminMode) {
      return const AdminDashboardScreen();
    }

    final filteredProducts = shop.filteredProducts;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(130),
        child: const SafeArea(child: ShopHeader()),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Search Bar & Action Shortcuts
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFCBD5E1)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) {
                              shop.setSearchQuery(val);
                            },
                            decoration: InputDecoration(
                              hintText: 'सामान खोजें... (Search Atta, Dal, Oil)',
                              hintStyle: const TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
                              prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF0E8345), size: 20),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, size: 18, color: Color(0xFF64748B)),
                                      onPressed: () {
                                        _searchController.clear();
                                        shop.setSearchQuery('');
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // My Orders Shortcut
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
                          );
                        },
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFCBD5E1)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.receipt_long_rounded,
                            color: Color(0xFF0E8345),
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Parchi Prominent Upload Banner
              const SliverToBoxAdapter(
                child: ParchiBannerWidget(),
              ),

              // Categories Horizontal Bar
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'श्रेणियाँ (Categories)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            '${filteredProducts.length} सामान उपलब्ध',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 52,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: shop.categories.length,
                        itemBuilder: (context, index) {
                          final cat = shop.categories[index];
                          return CategoryItemWidget(
                            category: cat,
                            isSelected: shop.selectedCategoryId == cat.id,
                            onTap: () {
                              shop.selectCategory(cat.id);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 6)),

              // Product Catalog Section
              if (filteredProducts.isEmpty)
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        const Text('🔍', style: TextStyle(fontSize: 40)),
                        const SizedBox(height: 10),
                        const Text(
                          'कोई सामान नहीं मिला (Item Not Found)',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'कृपया स्पेलिंग जांचें या पर्ची से आर्डर करें।',
                          style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton.icon(
                          onPressed: () {
                            _searchController.clear();
                            shop.setSearchQuery('');
                            shop.selectCategory('all');
                          },
                          icon: const Icon(Icons.refresh, size: 16),
                          label: const Text('सभी सामान देखें (View All)'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = filteredProducts[index];
                      return ProductCard(product: product);
                    },
                    childCount: filteredProducts.length,
                  ),
                ),

              // Bottom Padding for Floating Cart Bar
              const SliverToBoxAdapter(
                child: SizedBox(height: 90),
              ),
            ],
          ),

          // Floating Cart Bar (appears when items > 0)
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FloatingCartBar(),
          ),
        ],
      ),
    );
  }
}
