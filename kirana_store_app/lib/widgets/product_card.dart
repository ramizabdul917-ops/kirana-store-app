import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late ProductVariant _selectedVariant;

  @override
  void initState() {
    super.initState();
    _selectedVariant = widget.product.defaultVariant;
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final quantity = cart.getQuantity(widget.product, _selectedVariant);
    final isOutOfStock = !widget.product.inStock;

    final discountPercent = _selectedVariant.mrp > _selectedVariant.price
        ? (((_selectedVariant.mrp - _selectedVariant.price) / _selectedVariant.mrp) * 100).round()
        : 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: quantity > 0 ? const Color(0xFF0E8345) : const Color(0xFFE2E8F0),
          width: quantity > 0 ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: quantity > 0
                ? const Color(0xFF0E8345).withOpacity(0.08)
                : Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Icon Avatar with Discount Badge
            Stack(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Center(
                    child: Text(
                      widget.product.imageEmoji,
                      style: const TextStyle(fontSize: 34),
                    ),
                  ),
                ),
                if (discountPercent > 0 && !isOutOfStock)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: const BoxDecoration(
                        color: Color(0xFFDC2626),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Text(
                        '$discountPercent% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (isOutOfStock)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'स्टॉक खत्म\n(Out of Stock)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 12),

            // Product Details Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hindi Name (Bold Primary)
                  Text(
                    widget.product.titleHindi,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                      letterSpacing: -0.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // English Subtitle
                  Text(
                    widget.product.titleEnglish,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF64748B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  // Variant / Unit Selector Dropdown
                  Row(
                    children: [
                      Container(
                        height: 28,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<ProductVariant>(
                            value: _selectedVariant,
                            isDense: true,
                            icon: const Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF475569)),
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                            items: widget.product.variants.map((v) {
                              return DropdownMenuItem<ProductVariant>(
                                value: v,
                                child: Text(v.label),
                              );
                            }).toList(),
                            onChanged: (newVariant) {
                              if (newVariant != null) {
                                setState(() {
                                  _selectedVariant = newVariant;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Price Row & Stepper Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Rate display
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '₹${_selectedVariant.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0E8345),
                            ),
                          ),
                          if (_selectedVariant.mrp > _selectedVariant.price) ...[
                            const SizedBox(width: 5),
                            Text(
                              '₹${_selectedVariant.mrp.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF94A3B8),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),

                      // Direct Quantity Stepper Button
                      if (isOutOfStock)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFCBD5E1)),
                          ),
                          child: const Text(
                            'अनुपलब्ध (Not in stock)',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      else if (quantity == 0)
                        InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            cart.addItem(widget.product, _selectedVariant);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0E8345),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0E8345).withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add, size: 14, color: Colors.white),
                                SizedBox(width: 3),
                                Text(
                                  'जोड़ें (Add)',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Container(
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF0E8345), width: 1.2),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                icon: const Icon(Icons.remove, size: 15, color: Color(0xFF0E8345)),
                                onPressed: () {
                                  cart.removeItem(widget.product, _selectedVariant);
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: Text(
                                  '$quantity',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0E8345),
                                  ),
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                icon: const Icon(Icons.add, size: 15, color: Color(0xFF0E8345)),
                                onPressed: () {
                                  cart.addItem(widget.product, _selectedVariant);
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
