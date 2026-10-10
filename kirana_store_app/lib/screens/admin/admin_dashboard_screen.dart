import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/order.dart';
import '../../providers/order_provider.dart';
import '../../providers/shop_provider.dart';
import 'price_stock_manager_screen.dart';
import 'shop_settings_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final TextEditingController _tokenSearchController = TextEditingController();
  OrderModel? _searchedOrder;
  final Set<String> _packedItemsChecklist = {};

  @override
  void dispose() {
    _tokenSearchController.dispose();
    super.dispose();
  }

  void _onSearchToken(String query, OrderProvider orderProvider) {
    if (query.trim().isEmpty) {
      setState(() => _searchedOrder = null);
      return;
    }
    final result = orderProvider.findOrderByToken(query);
    setState(() {
      _searchedOrder = result;
      _packedItemsChecklist.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();
    final orderProvider = context.watch<OrderProvider>();
    final orders = orderProvider.orders;
    final dateFormat = DateFormat('dd MMM, hh:mm a');

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A), // Dark slate admin theme
        title: const Row(
          children: [
            Icon(Icons.store_mall_directory_rounded, color: Color(0xFF4ADE80), size: 22),
            SizedBox(width: 8),
            Text(
              'दुकानदार डैशबोर्ड (Admin View)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          // Switch to Customer View Button
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF0E8345),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              ),
              icon: const Icon(Icons.people_alt_rounded, size: 16),
              label: const Text('Customer View', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              onPressed: () {
                shop.setAdminMode(false);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Navigation Shortcuts
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PriceStockManagerScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
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
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('🏷️', style: TextStyle(fontSize: 20)),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'दाम व स्टॉक\n(Price & Stock)',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Text(
                            'दैनिक भाव व स्टॉक बदलें',
                            style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ShopSettingsScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
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
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('⚙️', style: TextStyle(fontSize: 20)),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'दुकान सेटिंग्स\n(Shop Settings)',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Text(
                            'UPI, नाम, पिन, समय बदलें',
                            style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 1-Minute Rapid Packing Token Lookup Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF0E8345), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0E8345).withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.bolt_rounded, color: Color(0xFFD97706), size: 24),
                      SizedBox(width: 6),
                      Text(
                        '1-मिनट पैकिंग: टोकन सर्च (Quick Token Lookup)',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'ग्राहक का 4-अंक टोकन नंबर डालें और तुरंत सामान पैक करें:',
                    style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _tokenSearchController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'उदा: 104 या #K-104',
                            prefixIcon: const Icon(Icons.tag_rounded, color: Color(0xFF0E8345)),
                            suffixIcon: _tokenSearchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () {
                                      _tokenSearchController.clear();
                                      setState(() => _searchedOrder = null);
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (val) => _onSearchToken(val, orderProvider),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        onPressed: () => _onSearchToken(_tokenSearchController.text, orderProvider),
                        child: const Text('सर्च'),
                      ),
                    ],
                  ),

                  // Display Searched Order Card if found
                  if (_searchedOrder != null) ...[
                    const SizedBox(height: 16),
                    _buildActivePackingCard(_searchedOrder!, orderProvider),
                  ] else if (_tokenSearchController.text.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 18),
                          SizedBox(width: 8),
                          Text(
                            'इस टोकन का कोई आर्डर नहीं मिला (No Order Found)',
                            style: TextStyle(fontSize: 12, color: Color(0xFFB91C1C), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Recent Orders Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'हाल के आर्डर (${orders.length} Total)',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                Text(
                  'पेक करें व ट्रैक करें',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
              ],
            ),

            const SizedBox(height: 10),

            if (orders.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Column(
                  children: [
                    Text('📦', style: TextStyle(fontSize: 36)),
                    SizedBox(height: 8),
                    Text(
                      'अभी कोई आर्डर नहीं आया है',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                    ),
                    Text(
                      'ग्राहक द्वारा आर्डर करने पर यहाँ दिखेगा।',
                      style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final isPacked = order.status == "PACKED";

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isPacked ? const Color(0xFF86EFAC) : const Color(0xFFCBD5E1),
                        width: isPacked ? 1.5 : 1.0,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      leading: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: isPacked ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isPacked ? const Color(0xFF0E8345) : const Color(0xFFF59E0B),
                          ),
                        ),
                        child: Text(
                          order.tokenCode,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: isPacked ? const Color(0xFF0E8345) : const Color(0xFFB45309),
                          ),
                        ),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              order.customerName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            order.orderType == "PARCHI" ? '📝 पर्ची' : '₹${order.grandTotal.toStringAsFixed(0)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0E8345)),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 2),
                          Text(
                            '📞 +91 ${order.customerPhone} • ${dateFormat.format(order.createdAt)}',
                            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          ),
                          Text(
                            '📍 ${order.customerAddress}',
                            style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          isPacked ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: isPacked ? const Color(0xFF0E8345) : const Color(0xFF94A3B8),
                        ),
                        tooltip: isPacked ? 'Mark as Pending' : 'Mark as Packed',
                        onPressed: () {
                          orderProvider.updateOrderStatus(
                            order.id,
                            isPacked ? "PENDING" : "PACKED",
                          );
                        },
                      ),
                      onTap: () {
                        setState(() {
                          _searchedOrder = order;
                          _tokenSearchController.text = order.tokenCode;
                          _packedItemsChecklist.clear();
                        });
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  // 1-Minute Packing Checklist Box
  Widget _buildActivePackingCard(OrderModel order, OrderProvider orderProvider) {
    final isPacked = order.status == "PACKED";

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0E8345),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      order.tokenCode,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    order.customerName,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.phone_forwarded, color: Color(0xFF0E8345), size: 20),
                tooltip: 'Call Customer',
                onPressed: () => launchUrl(Uri.parse('tel:${order.customerPhone}')),
              ),
            ],
          ),

          const SizedBox(height: 6),
          Text('📍 पता: ${order.customerAddress}', style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
          Text('💰 भुगतान मोड: ${order.paymentMethod == "UPI" ? "Shop UPI" : "Cash on Delivery / Counter"}', style: const TextStyle(fontSize: 12, color: Color(0xFF0E8345), fontWeight: FontWeight.w600)),

          const Divider(height: 18),

          if (order.orderType == "PARCHI") ...[
            const Text(
              '📝 पर्ची का सामान (Handwritten Parchi List):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                order.parchiText != null && order.parchiText!.isNotEmpty
                    ? order.parchiText!
                    : '[फोटो अटैचमेंट - ग्राहक ने पर्ची भेजी है]',
                style: const TextStyle(fontSize: 13, color: Color(0xFF78350F)),
              ),
            ),
          ] else ...[
            const Text(
              '📦 पैकिंग चेकलिस्ट (Check off as you pack):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 6),
            ...order.items.map((item) {
              final key = '${item.product.id}_${item.variant.id}';
              final isChecked = _packedItemsChecklist.contains(key);

              return CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                value: isChecked,
                activeColor: const Color(0xFF0E8345),
                title: Text(
                  '${item.product.titleHindi} (${item.variant.label})',
                  style: TextStyle(
                    fontSize: 12.5,
                    decoration: isChecked ? TextDecoration.lineThrough : null,
                    color: isChecked ? Colors.grey : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text('मात्रा: ${item.quantity} पीस  •  ₹${item.itemTotal.toStringAsFixed(0)}'),
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      _packedItemsChecklist.add(key);
                    } else {
                      _packedItemsChecklist.remove(key);
                    }
                  });
                },
              );
            }),
            const Divider(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('कुल बिल राशि:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  '₹${order.grandTotal.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF0E8345)),
                ),
              ],
            ),
          ],

          const SizedBox(height: 14),

          // Mark as packed toggle button
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isPacked ? const Color(0xFFD97706) : const Color(0xFF0E8345),
              ),
              onPressed: () {
                orderProvider.updateOrderStatus(order.id, isPacked ? "PENDING" : "PACKED");
                setState(() {
                  order.status = isPacked ? "PENDING" : "PACKED";
                });
              },
              icon: Icon(isPacked ? Icons.undo_rounded : Icons.check_circle_rounded, size: 18),
              label: Text(
                isPacked ? 'पैकिंग वापस लें (Mark Pending)' : '✓ सामान पैक हो गया (Mark as Packed)',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
