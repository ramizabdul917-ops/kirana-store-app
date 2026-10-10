import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/order.dart';
import '../../providers/shop_provider.dart';
import '../../services/whatsapp_service.dart';
import 'home_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  final OrderModel order;

  const OrderSuccessScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const CustomerHomeScreen()),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF0FDF4),
        appBar: AppBar(
          title: const Text('आर्डर पुष्टि (Order Confirmed)'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.home_rounded),
              tooltip: 'Home',
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const CustomerHomeScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Success Icon & Badge
              Container(
                width: 76,
                height: 76,
                decoration: const BoxDecoration(
                  color: Color(0xFF0E8345),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 48),
              ),

              const SizedBox(height: 12),

              const Text(
                'बधाई! आपका आर्डर दर्ज हो गया',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF14532D),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Order Placed Successfully (Anti-Fake Verified)',
                style: TextStyle(fontSize: 12, color: Color(0xFF15803D)),
              ),

              const SizedBox(height: 18),

              // Prominent 4-Digit Token Code Box (#K-104)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFF0E8345), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0E8345).withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'आपका आर्डर टोकन कोड (ORDER TOKEN)',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF64748B),
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          order.tokenCode,
                          style: const TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0E8345),
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, color: Color(0xFF0E8345), size: 20),
                          tooltip: 'Copy Token',
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: order.tokenCode));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Token ${order.tokenCode} Copied!')),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '💡 दुकान पर यह टोकन नंबर दिखाकर 1 मिनट में सामान लें!',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF92400E),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // WhatsApp Summary Button (Primary CTA)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366), // WhatsApp Green
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    final sent = await WhatsAppService.sendOrderToWhatsApp(
                      order: order,
                      shopName: shop.shopName,
                      shopPhone: shop.shopPhone,
                    );
                    if (!sent && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('व्हाट्सएप नहीं खुला। कृपया मैन्युअल रूप से टोकन बताएं।')),
                      );
                    }
                  },
                  icon: const Icon(Icons.chat_rounded, size: 22),
                  label: const Text(
                    'Order Summary to WhatsApp (दुकानदार को भेजें)',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Call Shopkeeper button
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0E8345),
                  side: const BorderSide(color: Color(0xFF0E8345)),
                  minimumSize: const Size(double.infinity, 44),
                ),
                onPressed: () async {
                  final callUri = Uri.parse('tel:${shop.shopPhone}');
                  if (await canLaunchUrl(callUri)) {
                    await launchUrl(callUri);
                  }
                },
                icon: const Icon(Icons.phone_in_talk_rounded, size: 18),
                label: Text('दुकानदार को कॉल करें (+91 ${shop.shopPhone})'),
              ),

              const SizedBox(height: 18),

              // Receipt Details Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'रसीद विवरण (Receipt Details)',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        ),
                        Text(
                          'पेमेंट: नकद/UPI',
                          style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    _receiptRow('ग्राहक / Name:', order.customerName),
                    _receiptRow('फोन / Mobile:', '+91 ${order.customerPhone}'),
                    _receiptRow('पता / Address:', order.customerAddress),
                    _receiptRow('तारीख / Date:', dateFormat.format(order.createdAt)),
                    _receiptRow('भुगतान / Mode:', order.paymentMethod == "UPI" ? "Shop UPI" : "Cash at Counter / Delivery"),

                    const Divider(height: 20),

                    if (order.orderType == "PARCHI") ...[
                      const Text(
                        'पर्ची का सामान (Handwritten Items):',
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.parchiText ?? '[पर्ची की फोटो दुकान पर भेज दी गई है]',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
                      ),
                    ] else ...[
                      const Text(
                        'सामान सूची (Items):',
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 6),
                      ...order.items.map((item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.product.titleHindi} (${item.variant.label}) x ${item.quantity}',
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF334155)),
                                  ),
                                ),
                                Text(
                                  '₹${item.itemTotal.toStringAsFixed(0)}',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          )),
                      const Divider(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'कुल बिल (Total Bill):',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                          ),
                          Text(
                            '₹${order.grandTotal.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0E8345)),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Back to Home Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0E8345),
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const CustomerHomeScreen()),
                    (route) => false,
                  );
                },
                child: const Text('मुख्य पृष्ठ पर जाएं (Back to Store)'),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _receiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
            ),
          ),
        ],
      ),
    );
  }
}
