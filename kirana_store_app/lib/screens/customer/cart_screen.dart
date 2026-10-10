import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/shop_provider.dart';
import '../../providers/order_provider.dart';
import '../../widgets/upi_qr_widget.dart';
import 'order_success_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _paymentMethod = "CASH";
  bool _isPlacingOrder = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    final cart = context.read<CartProvider>();
    final shop = context.read<ShopProvider>();
    final orderProvider = context.read<OrderProvider>();

    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('कार्ट खाली है (Cart is Empty)')),
      );
      return;
    }

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('कृपया अपना नाम दर्ज करें (Enter Your Name)')),
      );
      return;
    }

    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('कृपया 10 अंकों का मोबाइल नंबर दर्ज करें (Enter 10-Digit Mobile Number)')),
      );
      return;
    }

    setState(() => _isPlacingOrder = true);

    try {
      final items = cart.cartList;
      final subtotal = cart.subtotal;
      final discount = cart.totalSavings;
      final grandTotal = cart.grandTotal;

      final newOrder = await orderProvider.placeCartOrder(
        customerName: name,
        customerPhone: phone,
        customerAddress: address.isEmpty ? 'दुकान से पिकअप (Self Pickup)' : address,
        items: items,
        subtotal: subtotal,
        discount: discount,
        grandTotal: grandTotal,
        paymentMethod: _paymentMethod,
      );

      // Clear cart on successful order creation
      cart.clearCart();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderSuccessScreen(order: newOrder),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('आर्डर में त्रुटि: $e')),
      );
    } finally {
      if (mounted) setState(() => _isPlacingOrder = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final shop = context.watch<ShopProvider>();

    if (cart.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('आपका बिल (Cart & Bill)')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🛒', style: TextStyle(fontSize: 60)),
              const SizedBox(height: 14),
              const Text(
                'आपकी कार्ट खाली है!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 6),
              const Text(
                'दुकान से सामान चुनें या पर्ची से आर्डर करें',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('सामान देखें (Continue Shopping)'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('सामान और बिल (Cart & Bill)'),
        actions: [
          TextButton.icon(
            onPressed: () {
              cart.clearCart();
            },
            icon: const Icon(Icons.delete_outline, color: Colors.white, size: 18),
            label: const Text('खाली करें', style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Items List Breakdown Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'चुने गए सामान (${cart.totalItemCount} Items)',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          'कुल: ₹${cart.subtotal.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0E8345),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cart.cartList.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, indent: 14, endIndent: 14),
                    itemBuilder: (context, index) {
                      final item = cart.cartList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            // Product Emoji Icon
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(item.product.imageEmoji, style: const TextStyle(fontSize: 18)),
                              ),
                            ),
                            const SizedBox(width: 10),

                            // Name & Unit
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.titleHindi,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E293B),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${item.variant.label} • ₹${item.variant.price.toStringAsFixed(0)}',
                                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                  ),
                                ],
                              ),
                            ),

                            // Stepper
                            Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFF0E8345)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                                    icon: const Icon(Icons.remove, size: 14, color: Color(0xFF0E8345)),
                                    onPressed: () {
                                      cart.removeItem(item.product, item.variant);
                                    },
                                  ),
                                  Text(
                                    '${item.quantity}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0E8345),
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                                    icon: const Icon(Icons.add, size: 14, color: Color(0xFF0E8345)),
                                    onPressed: () {
                                      cart.addItem(item.product, item.variant);
                                    },
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Line Item Total
                            Text(
                              '₹${item.itemTotal.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 2. Bill Summary Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'बिल विवरण (Bill Summary)',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('सामान का मूल्य (Items Total)', style: TextStyle(color: Color(0xFF475569), fontSize: 12.5)),
                      Text('₹${cart.subtotal.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  if (cart.totalSavings > 0) ...[
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('आपकी छूट/बचत (Discount)', style: TextStyle(color: Color(0xFFDC2626), fontSize: 12.5)),
                        Text('-₹${cart.totalSavings.toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                  const SizedBox(height: 6),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('डिलीवरी चार्ज (Delivery)', style: TextStyle(color: Color(0xFF475569), fontSize: 12.5)),
                      Text('मुफ़्त (FREE)', style: TextStyle(color: Color(0xFF0E8345), fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'कुल देय राशि (Grand Total)',
                        style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      Text(
                        '₹${cart.grandTotal.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0E8345)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 3. Customer Details Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.person_pin_rounded, color: Color(0xFF0E8345), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'ग्राहक का विवरण (Customer Details)',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'आपका नाम (Customer Name) *',
                      prefixIcon: Icon(Icons.person_outline_rounded, color: Color(0xFF0E8345)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: const InputDecoration(
                      labelText: 'मोबाइल नंबर (10-Digit Mobile Number) *',
                      prefixIcon: Icon(Icons.phone_outlined, color: Color(0xFF0E8345)),
                      prefixText: '+91 ',
                    ),
                  ),
                  const SizedBox(height: 2),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'घर का पता / गली नंबर / लैंडमार्क',
                      hintText: 'उदा: मकान नं. 24, गली 4, मंदिर के पास',
                      prefixIcon: Icon(Icons.location_on_outlined, color: Color(0xFF0E8345)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 4. Payment Selection Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.payments_rounded, color: Color(0xFF0E8345), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'भुगतान का तरीका (Payment Method)',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  RadioListTile<String>(
                    title: const Text('सामान मिलने पर नकद दें (Cash on Delivery / Counter)'),
                    subtitle: const Text('दुकान पर या घर पर नकद भुगतान करें (डिफ़ॉल्ट)', style: TextStyle(fontSize: 11)),
                    value: "CASH",
                    groupValue: _paymentMethod,
                    activeColor: const Color(0xFF0E8345),
                    onChanged: (val) {
                      if (val != null) setState(() => _paymentMethod = val);
                    },
                  ),
                  const Divider(height: 1),
                  RadioListTile<String>(
                    title: const Text('दुकान के UPI से भुगतान करें (Pay via Shop UPI)'),
                    subtitle: const Text('GPay, PhonePe, Paytm QR कोड द्वारा पेमेंट', style: TextStyle(fontSize: 11)),
                    value: "UPI",
                    groupValue: _paymentMethod,
                    activeColor: const Color(0xFF0E8345),
                    onChanged: (val) {
                      if (val != null) setState(() => _paymentMethod = val);
                    },
                  ),

                  // UPI QR Preview when UPI is selected
                  if (_paymentMethod == "UPI") ...[
                    const SizedBox(height: 12),
                    UpiQrWidget(
                      upiId: shop.shopUpi,
                      shopName: shop.shopName,
                      amount: cart.grandTotal,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Place Order Button (No upfront payment required, token generated)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _isPlacingOrder ? null : _placeOrder,
                icon: _isPlacingOrder
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.check_circle_rounded, size: 22),
                label: Text(
                  _isPlacingOrder
                      ? 'टोकन जारी हो रहा है...'
                      : 'आर्डर बुक करें • ₹${cart.grandTotal.toStringAsFixed(0)} (Place Order)',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
