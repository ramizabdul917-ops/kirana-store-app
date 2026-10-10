import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/shop_provider.dart';

class AdminPinDialog extends StatefulWidget {
  const AdminPinDialog({super.key});

  @override
  State<AdminPinDialog> createState() => _AdminPinDialogState();
}

class _AdminPinDialogState extends State<AdminPinDialog> {
  final TextEditingController _pinController = TextEditingController();
  String _errorMessage = '';

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _verifyAndEnter() {
    final shop = context.read<ShopProvider>();
    final entered = _pinController.text.trim();

    if (shop.verifyAdminPin(entered)) {
      shop.setAdminMode(true);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF0E8345),
          content: Text('दुकानदार मोड सक्रिय (Shopkeeper Admin Mode Activated)'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      setState(() {
        _errorMessage = 'गलत पिन! डिफ़ॉल्ट पिन 1234 है (Incorrect PIN)';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: const Row(
        children: [
          Icon(Icons.security_rounded, color: Color(0xFF0E8345)),
          SizedBox(width: 8),
          Text(
            'दुकानदार पिन (Admin PIN)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'दुकानदार डैशबोर्ड खोलने के लिए 4 अंकों का पिन दर्ज करें:\n(डिफ़ॉल्ट पिन: 1234)',
            style: TextStyle(fontSize: 12.5, color: Color(0xFF475569)),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _pinController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            autofocus: true,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 8),
            decoration: InputDecoration(
              counterText: '',
              hintText: '••••',
              errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
            ),
            onSubmitted: (_) => _verifyAndEnter(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('रद्द करें (Cancel)'),
        ),
        ElevatedButton(
          onPressed: _verifyAndEnter,
          child: const Text('प्रवेश करें (Enter)'),
        ),
      ],
    );
  }
}
