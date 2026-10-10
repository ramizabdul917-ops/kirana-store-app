import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import 'order_success_screen.dart';

class ParchiUploadScreen extends StatefulWidget {
  const ParchiUploadScreen({super.key});

  @override
  State<ParchiUploadScreen> createState() => _ParchiUploadScreenState();
}

class _ParchiUploadScreenState extends State<ParchiUploadScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _listTextController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String _paymentMethod = "CASH";
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _listTextController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('कैमरा / गैलरी लोड नहीं हुआ: $e')),
      );
    }
  }

  Future<void> _submitParchiOrder() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();
    final textList = _listTextController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('कृपया अपना नाम दर्ज करें (Enter Your Name)')),
      );
      return;
    }

    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('कृपया 10 अंकों का मोबाइल नंबर दर्ज करें (Enter 10-digit Phone)')),
      );
      return;
    }

    if (_tabController.index == 0 && _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('कृपया पर्ची की फोटो खींचें या गैलरी से चुनें (Select Parchi Photo)')),
      );
      return;
    }

    if (_tabController.index == 1 && textList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('कृपया सामान की सूची लिखें (Type Grocery List)')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final orderProvider = context.read<OrderProvider>();
      final newOrder = await orderProvider.placeParchiOrder(
        customerName: name,
        customerPhone: phone,
        customerAddress: address.isEmpty ? 'दुकान से पिकअप (Self Pickup)' : address,
        parchiText: _tabController.index == 1 ? textList : null,
        parchiImagePath: _imageFile?.path,
        paymentMethod: _paymentMethod,
      );

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
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('पर्ची से आर्डर करें (Parchi Order)'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF59E0B)),
                ),
                child: const Row(
                  children: [
                    Text('💡', style: TextStyle(fontSize: 22)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'कागज पर लिखी पर्ची की फोटो भेजें या नीचे सीधे सामान लिख दें। दुकानदार देखकर पैक कर देगा!',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Tab Bar: Photo vs Typed List
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFF0E8345),
                  unselectedLabelColor: const Color(0xFF475569),
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.camera_alt_rounded, size: 18),
                      text: 'फोटो खींचें (Snap Photo)',
                    ),
                    Tab(
                      icon: Icon(Icons.edit_note_rounded, size: 20),
                      text: 'यहाँ लिखें (Type List)',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Tab View Content
              SizedBox(
                height: 220,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Tab 1: Image Capture
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: _imageFile != null
                          ? Stack(
                              alignment: Alignment.topRight,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    _imageFile!,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                IconButton(
                                  icon: const CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 14,
                                    child: Icon(Icons.close, size: 16, color: Colors.white),
                                  ),
                                  onPressed: () {
                                    setState(() => _imageFile = null);
                                  },
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('📷', style: TextStyle(fontSize: 36)),
                                const SizedBox(height: 8),
                                const Text(
                                  'पर्ची की साफ फोटो अपलोड करें',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () => _pickImage(ImageSource.camera),
                                      icon: const Icon(Icons.camera_alt, size: 16),
                                      label: const Text('Camera'),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    OutlinedButton.icon(
                                      onPressed: () => _pickImage(ImageSource.gallery),
                                      icon: const Icon(Icons.photo_library, size: 16),
                                      label: const Text('Gallery'),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),

                    // Tab 2: Multi-line text input
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: TextField(
                        controller: _listTextController,
                        maxLines: 8,
                        decoration: const InputDecoration(
                          hintText: 'सामान की सूची यहाँ लिखें...\nउदाहरण:\n1. 5kg आशीर्वाद आटा\n2. 1L सरसों तेल\n3. 1kg अरहर दाल\n4. 1 पैकेट टाटा नमक',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'ग्राहक का विवरण (Customer Details)',
                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 10),

              // Customer Name
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'आपका नाम (Your Full Name) *',
                  prefixIcon: Icon(Icons.person_outline_rounded, color: Color(0xFF0E8345)),
                ),
              ),
              const SizedBox(height: 10),

              // Phone Number
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: const InputDecoration(
                  labelText: 'मोबाइल नंबर (10-Digit Mobile) *',
                  prefixIcon: Icon(Icons.phone_outlined, color: Color(0xFF0E8345)),
                  prefixText: '+91 ',
                ),
              ),
              const SizedBox(height: 2),

              // Delivery Address / Landmark
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'घर का पता / गली नंबर / लैंडमार्क',
                  hintText: 'उदा: मकान नं. 14, गली 3, शिव मंदिर के पास',
                  prefixIcon: Icon(Icons.location_on_outlined, color: Color(0xFF0E8345)),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'भुगतान का तरीका (Payment Method)',
                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 8),

              // Payment Radios
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('सामान मिलने पर नकद दें (Cash on Delivery / Counter)'),
                      subtitle: const Text('दुकान पर या डिलीवरी के समय भुगतान करें', style: TextStyle(fontSize: 11)),
                      value: "CASH",
                      groupValue: _paymentMethod,
                      activeColor: const Color(0xFF0E8345),
                      onChanged: (val) {
                        if (val != null) setState(() => _paymentMethod = val);
                      },
                    ),
                    const Divider(height: 1),
                    RadioListTile<String>(
                      title: const Text('दुकान UPI से ऑनलाइन भुगतान (Pay via Shop UPI)'),
                      subtitle: const Text('बिल बनने के बाद QR कोड से पेमेंट करें', style: TextStyle(fontSize: 11)),
                      value: "UPI",
                      groupValue: _paymentMethod,
                      activeColor: const Color(0xFF0E8345),
                      onChanged: (val) {
                        if (val != null) setState(() => _paymentMethod = val);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Submit Parchi Order Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _submitParchiOrder,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.check_circle_outline_rounded),
                  label: Text(
                    _isSubmitting ? 'आर्डर दर्ज हो रहा है...' : 'पर्ची आर्डर बुक करें (Place Parchi Order)',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
