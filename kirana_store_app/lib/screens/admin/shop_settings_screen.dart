import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/shop_provider.dart';

class ShopSettingsScreen extends StatefulWidget {
  const ShopSettingsScreen({super.key});

  @override
  State<ShopSettingsScreen> createState() => _ShopSettingsScreenState();
}

class _ShopSettingsScreenState extends State<ShopSettingsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _upiController;
  late TextEditingController _hoursController;
  late TextEditingController _announcementController;
  late TextEditingController _pinController;

  @override
  void initState() {
    super.initState();
    final shop = context.read<ShopProvider>();
    _nameController = TextEditingController(text: shop.shopName);
    _phoneController = TextEditingController(text: shop.shopPhone);
    _upiController = TextEditingController(text: shop.shopUpi);
    _hoursController = TextEditingController(text: shop.openingHours);
    _announcementController = TextEditingController(text: shop.announcement);
    _pinController = TextEditingController(text: '1234');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _upiController.dispose();
    _hoursController.dispose();
    _announcementController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    final shop = context.read<ShopProvider>();
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final upi = _upiController.text.trim();
    final hours = _hoursController.text.trim();
    final announcement = _announcementController.text.trim();
    final pin = _pinController.text.trim();

    if (name.isEmpty || phone.isEmpty || pin.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('कृपया सभी जरूरी जानकारी व 4-अंक पिन भरें')),
      );
      return;
    }

    shop.updateShopSettings(
      shopName: name,
      shopPhone: phone,
      shopUpi: upi,
      shopHours: hours,
      announcement: announcement,
      adminPin: pin,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF0E8345),
        content: Text('दुकान की सेटिंग्स सुरक्षित हो गईं! (Settings Saved)'),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Text('दुकान सेटिंग्स (Shop Settings)'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'दुकान की मुख्य जानकारी (Store Profile)',
              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 12),

            // Shop Name
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'दुकान का नाम (Shop Name) *',
                prefixIcon: Icon(Icons.storefront_rounded, color: Color(0xFF0E8345)),
              ),
            ),
            const SizedBox(height: 12),

            // Phone
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: const InputDecoration(
                labelText: 'दुकानदार का व्हाट्सएप फोन नंबर *',
                helperText: 'इसी नंबर पर ग्राहक का व्हाट्सएप आर्डर पहुंचेगा',
                prefixIcon: Icon(Icons.chat_rounded, color: Color(0xFF25D366)),
                prefixText: '+91 ',
              ),
            ),
            const SizedBox(height: 12),

            // UPI ID
            TextField(
              controller: _upiController,
              decoration: const InputDecoration(
                labelText: 'दुकानदार का UPI ID (QR कोड के लिए)',
                hintText: 'उदा: shreeganeshkirana@upi',
                prefixIcon: Icon(Icons.qr_code_2_rounded, color: Color(0xFF0E8345)),
              ),
            ),
            const SizedBox(height: 12),

            // Hours
            TextField(
              controller: _hoursController,
              decoration: const InputDecoration(
                labelText: 'दुकान का समय (Opening Hours)',
                hintText: 'सुबह 7:00 AM - रात 10:00 PM',
                prefixIcon: Icon(Icons.access_time_rounded, color: Color(0xFF0E8345)),
              ),
            ),
            const SizedBox(height: 12),

            // Announcement
            TextField(
              controller: _announcementController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'दुकान का ऑफर / घोषणा संदेश (Announcement)',
                hintText: '🎉 ₹300 से अधिक के आर्डर पर मुफ़्त होम डिलीवरी!',
                prefixIcon: Icon(Icons.campaign_rounded, color: Color(0xFFF59E0B)),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'सुरक्षा पिन (Admin Security PIN)',
              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 12),

            // Admin PIN
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '4-अंक दुकानदार पिन (Admin PIN) *',
                helperText: 'डैशबोर्ड में प्रवेश करने के लिए इस्तेमाल होता है',
                prefixIcon: Icon(Icons.lock_rounded, color: Color(0xFF0E8345)),
              ),
            ),

            const SizedBox(height: 24),

            // Save Settings Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0E8345),
                ),
                onPressed: _saveSettings,
                icon: const Icon(Icons.save_rounded),
                label: const Text('सेटिंग्स सेव करें (Save Settings)', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(height: 20),

            // Reset Inventory Helper
            Center(
              child: TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: const Color(0xFFDC2626)),
                icon: const Icon(Icons.restore_rounded, size: 16),
                label: const Text('डिफ़ॉल्ट सामान सूची रीसेट करें (Reset Default Inventory)'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('रीसेट करें?'),
                      content: const Text('क्या आप मूल 24+ किराना सामान सूची वापस लोड करना चाहते हैं?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('रद्द')),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626)),
                          onPressed: () {
                            shop.resetToDefaults();
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('मूल सामान सूची रीसेट हो गई')),
                            );
                          },
                          child: const Text('हाँ, रीसेट करें'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
