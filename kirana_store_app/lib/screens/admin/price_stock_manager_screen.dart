import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/shop_provider.dart';

class PriceStockManagerScreen extends StatefulWidget {
  const PriceStockManagerScreen({super.key});

  @override
  State<PriceStockManagerScreen> createState() => _PriceStockManagerScreenState();
}

class _PriceStockManagerScreenState extends State<PriceStockManagerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showEditPriceDialog(Product product, ProductVariant variant, ShopProvider shop) {
    final priceController = TextEditingController(text: variant.price.toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.edit_note_rounded, color: Color(0xFF0E8345)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'दाम बदलें: ${variant.label}',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.titleHindi,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            Text(
              product.titleEnglish,
              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'नया सेलिंग भाव (New Selling Rate) *',
                prefixText: '₹ ',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('रद्द करें (Cancel)'),
          ),
          ElevatedButton(
            onPressed: () {
              final newPrice = double.tryParse(priceController.text.trim());
              if (newPrice != null && newPrice >= 0) {
                shop.updateVariantPrice(product.id, variant.id, newPrice);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color(0xFF0E8345),
                    content: Text('${product.titleHindi} (${variant.label}) का भाव ₹$newPrice अपडेट हुआ'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text('सेव करें (Save)'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();
    final allProducts = shop.products;

    final filtered = allProducts.where((p) {
      if (_query.trim().isEmpty) return true;
      final q = _query.toLowerCase().trim();
      return p.titleHindi.toLowerCase().contains(q) ||
          p.titleEnglish.toLowerCase().contains(q) ||
          p.categoryId.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Text('दाम व स्टॉक मैनेजर (Rates & Stock)'),
      ),
      body: Column(
        children: [
          // Search & Filter header
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() => _query = val);
              },
              decoration: InputDecoration(
                hintText: 'सामान खोजें (Search Dal, Oil, Sugar)...',
                prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF0E8345)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),

          const Divider(height: 1),

          // Tip Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            color: const Color(0xFFFEF3C7),
            child: const Row(
              children: [
                Text('💡', style: TextStyle(fontSize: 14)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'रोजाना बदलते भाव (सरसों तेल, चीनी, दाल) यहाँ से 1 सेकंड में बदलें।',
                    style: TextStyle(fontSize: 11, color: Color(0xFF92400E), fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          // Product Rates List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final product = filtered[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row: Product Name + Stock Switch
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(product.imageEmoji, style: const TextStyle(fontSize: 18)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.titleHindi,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    product.titleEnglish,
                                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            // In Stock Switch
                            Column(
                              children: [
                                Transform.scale(
                                  scale: 0.8,
                                  child: Switch(
                                    value: product.inStock,
                                    activeColor: const Color(0xFF0E8345),
                                    onChanged: (val) {
                                      shop.toggleProductStock(product.id);
                                    },
                                  ),
                                ),
                                Text(
                                  product.inStock ? 'उपलब्ध (In Stock)' : 'स्टॉक खत्म (Out)',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: product.inStock ? const Color(0xFF0E8345) : const Color(0xFFDC2626),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Variant Rates Chips
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: product.variants.map((v) {
                            return InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () => _showEditPriceDialog(product, v, shop),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFFCBD5E1)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${v.label}: ',
                                      style: const TextStyle(fontSize: 11.5, color: Color(0xFF475569)),
                                    ),
                                    Text(
                                      '₹${v.price.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF0E8345),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.edit_outlined, size: 13, color: Color(0xFF64748B)),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
