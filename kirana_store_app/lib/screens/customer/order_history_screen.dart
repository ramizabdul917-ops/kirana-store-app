import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/shop_provider.dart';
import '../../services/whatsapp_service.dart';
import 'order_success_screen.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final shop = context.watch<ShopProvider>();
    final orders = orderProvider.orders;
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

    return Scaffold(
      appBar: AppBar(
        title: const Text('मेरे पुराने आर्डर (My Orders)'),
      ),
      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('📦', style: TextStyle(fontSize: 50)),
                  const SizedBox(height: 12),
                  const Text(
                    'कोई पिछला आर्डर नहीं है',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'No orders placed yet from this device.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('सामान खरीदें (Shop Now)'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final isParchi = order.orderType == "PARCHI";

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header row with Token & Date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFF0E8345)),
                              ),
                              child: Text(
                                order.tokenCode,
                                style: const TextStyle(
                                  color: Color(0xFF0E8345),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: order.status == "PACKED"
                                    ? const Color(0xFFDCFCE7)
                                    : const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                order.status == "PACKED" ? 'पैक हो गया (Packed)' : 'आर्डर प्राप्त (Received)',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: order.status == "PACKED"
                                      ? const Color(0xFF15803D)
                                      : const Color(0xFFB45309),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Text(
                          dateFormat.format(order.createdAt),
                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        ),

                        const SizedBox(height: 8),

                        // Order Type / Summary
                        if (isParchi)
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFBEB),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFFDE68A)),
                            ),
                            child: Row(
                              children: [
                                const Text('📝', style: TextStyle(fontSize: 16)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    order.parchiText != null && order.parchiText!.isNotEmpty
                                        ? order.parchiText!
                                        : 'पर्ची की फोटो दुकान पर भेजी गई',
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF92400E)),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Text(
                            '${order.items.length} सामान • कुल: ₹${order.grandTotal.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),

                        const SizedBox(height: 12),

                        // Action buttons: View Receipt & WhatsApp
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => OrderSuccessScreen(order: order)),
                                  );
                                },
                                child: const Text('रसीद देखें (View Bill)', style: TextStyle(fontSize: 12)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF25D366),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                ),
                                onPressed: () {
                                  WhatsAppService.sendOrderToWhatsApp(
                                    order: order,
                                    shopName: shop.shopName,
                                    shopPhone: shop.shopPhone,
                                  );
                                },
                                icon: const Icon(Icons.chat, size: 14),
                                label: const Text('WhatsApp', style: TextStyle(fontSize: 12)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
