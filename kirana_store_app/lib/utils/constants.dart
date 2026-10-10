import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/product.dart';

class AppConstants {
  static const String defaultShopName = 'श्री गणेश किराना स्टोर';
  static const String defaultShopNameEnglish = 'Shree Ganesh Kirana & General Store';
  static const String defaultShopPhone = '9876543210';
  static const String defaultShopUpi = 'shreeganeshkirana@upi';
  static const String defaultOpeningHours = 'सुबह 7:00 AM - रात 10:00 PM (खुला है)';
  static const String defaultAnnouncement = '🎉 ₹300 से अधिक के आर्डर पर मुफ़्त होम डिलीवरी! (Free Home Delivery on ₹300+)';
  static const String defaultShopAddress = 'दुकान नं. 12, मेन बाजार चौक, नियर हनुमान मंदिर';
  static const String defaultAdminPin = '1234';

  static final List<Category> defaultCategories = [
    const Category(
      id: 'all',
      nameHindi: 'सभी सामान',
      nameEnglish: 'All Items',
      icon: Icons.storefront_rounded,
      color: Color(0xFF0E8345),
    ),
    const Category(
      id: 'atta_grains',
      nameHindi: 'आटा और अनाज',
      nameEnglish: 'Atta & Grains',
      icon: Icons.grain_rounded,
      color: Color(0xFFD97706),
    ),
    const Category(
      id: 'dal_pulses',
      nameHindi: 'दाल और दलहन',
      nameEnglish: 'Dal & Pulses',
      icon: Icons.egg_alt_rounded,
      color: Color(0xFFEA580C),
    ),
    const Category(
      id: 'cooking_oils',
      nameHindi: 'तेल और घी',
      nameEnglish: 'Cooking Oils',
      icon: Icons.opacity_rounded,
      color: Color(0xFFCA8A04),
    ),
    const Category(
      id: 'spices_masala',
      nameHindi: 'मसाले',
      nameEnglish: 'Spices & Masala',
      icon: Icons.whatshot_rounded,
      color: Color(0xFFDC2626),
    ),
    const Category(
      id: 'dairy',
      nameHindi: 'दूध और डेयरी',
      nameEnglish: 'Dairy',
      icon: Icons.water_drop_rounded,
      color: Color(0xFF2563EB),
    ),
    const Category(
      id: 'tea_snacks',
      nameHindi: 'चाय और नमकीन',
      nameEnglish: 'Tea & Snacks',
      icon: Icons.emoji_food_beverage_rounded,
      color: Color(0xFF7C3AED),
    ),
    const Category(
      id: 'cleaning_supplies',
      nameHindi: 'सफाई सामग्री',
      nameEnglish: 'Cleaning Supplies',
      icon: Icons.cleaning_services_rounded,
      color: Color(0xFF0D9488),
    ),
  ];

  static List<Product> get defaultProducts => [
    // 1. Atta & Grains
    Product(
      id: 'p_atta_01',
      titleHindi: 'आशीर्वाद शुद्ध चक्की आटा',
      titleEnglish: 'Aashirvaad Shudh Chakki Atta',
      categoryId: 'atta_grains',
      imageEmoji: '🌾',
      description: '100% शुद्ध संपूर्ण गेहूं से बना प्रीमियम आटा।',
      variants: [
        ProductVariant(id: 'v_1kg', label: '1 kg', price: 46.0, mrp: 52.0),
        ProductVariant(id: 'v_5kg', label: '5 kg', price: 220.0, mrp: 245.0),
        ProductVariant(id: 'v_10kg', label: '10 kg', price: 425.0, mrp: 480.0),
      ],
    ),
    Product(
      id: 'p_rice_01',
      titleHindi: 'इंडिया गेट बासमती चावल',
      titleEnglish: 'India Gate Basmati Rice (Dubar)',
      categoryId: 'atta_grains',
      imageEmoji: '🍚',
      description: 'खुशबूदार और लंबे दानेदार बासमती चावल।',
      variants: [
        ProductVariant(id: 'v_1kg', label: '1 kg', price: 110.0, mrp: 130.0),
        ProductVariant(id: 'v_5kg', label: '5 kg', price: 520.0, mrp: 610.0),
      ],
    ),
    Product(
      id: 'p_suji_01',
      titleHindi: 'राजधानी सूजी / रवा',
      titleEnglish: 'Rajdhani Sooji / Rawa',
      categoryId: 'atta_grains',
      imageEmoji: '🥣',
      description: 'हलवा और उपमा के लिए शुद्ध दानेदार सूजी।',
      variants: [
        ProductVariant(id: 'v_500g', label: '500 g', price: 32.0, mrp: 38.0),
        ProductVariant(id: 'v_1kg', label: '1 kg', price: 60.0, mrp: 72.0),
      ],
    ),
    Product(
      id: 'p_besan_01',
      titleHindi: 'फॉर्च्यून शुद्ध चना बेसन',
      titleEnglish: 'Fortune Shudh Chana Besan',
      categoryId: 'atta_grains',
      imageEmoji: '🟡',
      description: '100% शुद्ध चना दाल से तैयार महीन बेसन।',
      variants: [
        ProductVariant(id: 'v_500g', label: '500 g', price: 58.0, mrp: 68.0),
        ProductVariant(id: 'v_1kg', label: '1 kg', price: 112.0, mrp: 130.0),
      ],
    ),

    // 2. Dal & Pulses
    Product(
      id: 'p_dal_arhar',
      titleHindi: 'देसी अरहर / तुवर दाल',
      titleEnglish: 'Desi Toor / Arhar Dal (Unpolished)',
      categoryId: 'dal_pulses',
      imageEmoji: '🫘',
      description: 'स्वादिष्ट, जल्दी गलने वाली बिना पॉलिश की तुवर दाल।',
      variants: [
        ProductVariant(id: 'v_500g', label: '500 g', price: 82.0, mrp: 95.0),
        ProductVariant(id: 'v_1kg', label: '1 kg', price: 160.0, mrp: 185.0),
      ],
    ),
    Product(
      id: 'p_dal_moong',
      titleHindi: 'मूंग दाल धुली (पीली)',
      titleEnglish: 'Moong Dal Dhuli (Yellow)',
      categoryId: 'dal_pulses',
      imageEmoji: '✨',
      description: 'हल्की और पौष्टिक पीली मूंग दाल।',
      variants: [
        ProductVariant(id: 'v_500g', label: '500 g', price: 62.0, mrp: 72.0),
        ProductVariant(id: 'v_1kg', label: '1 kg', price: 120.0, mrp: 140.0),
      ],
    ),
    Product(
      id: 'p_dal_chana',
      titleHindi: 'चना दाल प्रीमियम',
      titleEnglish: 'Chana Dal Premium',
      categoryId: 'dal_pulses',
      imageEmoji: '🟡',
      description: 'स्वच्छ और चुने हुए दानों की चना दाल।',
      variants: [
        ProductVariant(id: 'v_500g', label: '500 g', price: 48.0, mrp: 56.0),
        ProductVariant(id: 'v_1kg', label: '1 kg', price: 92.0, mrp: 108.0),
      ],
    ),
    Product(
      id: 'p_chhole_01',
      titleHindi: 'काबुली चना / छोले',
      titleEnglish: 'Kabuli Chana / White Chickpeas',
      categoryId: 'dal_pulses',
      imageEmoji: '🥟',
      description: 'बड़े दानेदार स्वादिष्ट काबुली चना।',
      variants: [
        ProductVariant(id: 'v_500g', label: '500 g', price: 74.0, mrp: 86.0),
        ProductVariant(id: 'v_1kg', label: '1 kg', price: 142.0, mrp: 165.0),
      ],
    ),

    // 3. Cooking Oils
    Product(
      id: 'p_oil_mustard',
      titleHindi: 'सलोनी / इंजन कच्ची घानी सरसों तेल',
      titleEnglish: 'Engine / Saloni Mustard Oil Kachi Ghani',
      categoryId: 'cooking_oils',
      imageEmoji: '🛢️',
      description: 'तेज झार वाला असली शुद्ध सरसों तेल।',
      variants: [
        ProductVariant(id: 'v_1l', label: '1 Litre Pouch', price: 145.0, mrp: 165.0),
        ProductVariant(id: 'v_2l', label: '2 Litre Bottle', price: 305.0, mrp: 340.0),
        ProductVariant(id: 'v_5l', label: '5 Litre Jar', price: 740.0, mrp: 820.0),
      ],
    ),
    Product(
      id: 'p_oil_refined',
      titleHindi: 'फॉर्च्यून सनफ्लावर / सोयाबीन तेल',
      titleEnglish: 'Fortune Refined Soyabean Oil',
      categoryId: 'cooking_oils',
      imageEmoji: '🌻',
      description: 'हल्का और सुपाच्य रिफाइंड कुकिंग ऑइल।',
      variants: [
        ProductVariant(id: 'v_1l', label: '1 Litre Pouch', price: 118.0, mrp: 135.0),
        ProductVariant(id: 'v_5l', label: '5 Litre Jar', price: 595.0, mrp: 680.0),
      ],
    ),
    Product(
      id: 'p_ghee_amul',
      titleHindi: 'अमूल शुद्ध देसी घी',
      titleEnglish: 'Amul Pure Cow Ghee',
      categoryId: 'cooking_oils',
      imageEmoji: '🧈',
      description: 'दानेदार और मनमोहक खुशबू वाला शुद्ध घी।',
      variants: [
        ProductVariant(id: 'v_500ml', label: '500 ml', price: 310.0, mrp: 330.0),
        ProductVariant(id: 'v_1l', label: '1 Litre Carton', price: 610.0, mrp: 650.0),
      ],
    ),

    // 4. Spices & Masala
    Product(
      id: 'p_sp_haldi',
      titleHindi: 'एमडीएच / एवरेस्ट हल्दी पाउडर',
      titleEnglish: 'Everest / MDH Haldi (Turmeric Powder)',
      categoryId: 'spices_masala',
      imageEmoji: '🟡',
      description: 'प्राकृतिक रंग और गुणकारी खुशबूदार हल्दी।',
      variants: [
        ProductVariant(id: 'v_100g', label: '100 g', price: 36.0, mrp: 40.0),
        ProductVariant(id: 'v_200g', label: '200 g', price: 68.0, mrp: 78.0),
        ProductVariant(id: 'v_500g', label: '500 g', price: 160.0, mrp: 185.0),
      ],
    ),
    Product(
      id: 'p_sp_mirchi',
      titleHindi: 'एवरेस्ट तीखालाल लाल मिर्च पाउडर',
      titleEnglish: 'Everest Tikhalal Red Chilli Powder',
      categoryId: 'spices_masala',
      imageEmoji: '🌶️',
      description: 'गहरे लाल रंग और तीखे स्वाद वाली मिर्च।',
      variants: [
        ProductVariant(id: 'v_100g', label: '100 g', price: 48.0, mrp: 54.0),
        ProductVariant(id: 'v_200g', label: '200 g', price: 92.0, mrp: 105.0),
        ProductVariant(id: 'v_500g', label: '500 g', price: 220.0, mrp: 250.0),
      ],
    ),
    Product(
      id: 'p_sp_dhania',
      titleHindi: 'कैच धनिया पाउडर',
      titleEnglish: 'Catch Coriander (Dhania) Powder',
      categoryId: 'spices_masala',
      imageEmoji: '🌿',
      description: 'खुशबूदार पिसा हुआ हरा धनिया पाउडर।',
      variants: [
        ProductVariant(id: 'v_200g', label: '200 g', price: 46.0, mrp: 52.0),
        ProductVariant(id: 'v_500g', label: '500 g', price: 110.0, mrp: 125.0),
      ],
    ),
    Product(
      id: 'p_sp_namak',
      titleHindi: 'टाटा नमक (देश का नमक)',
      titleEnglish: 'Tata Salt Vacuum Evaporated (Iodized)',
      categoryId: 'spices_masala',
      imageEmoji: '🧂',
      description: 'आयोडीन युक्त शुद्ध सफेद टाटा नमक।',
      variants: [
        ProductVariant(id: 'v_1kg', label: '1 kg Packet', price: 27.0, mrp: 28.0),
      ],
    ),

    // 5. Dairy
    Product(
      id: 'p_dairy_milk',
      titleHindi: 'अमूल ताजा / टोंड दूध',
      titleEnglish: 'Amul Taaza Homogenised Toned Milk',
      categoryId: 'dairy',
      imageEmoji: '🥛',
      description: 'हर दिन ताजा और स्वच्छ पाश्चुरीकृत दूध।',
      variants: [
        ProductVariant(id: 'v_500ml', label: '500 ml Pouch', price: 27.0, mrp: 27.0),
        ProductVariant(id: 'v_1l', label: '1 Litre Tetra', price: 72.0, mrp: 75.0),
      ],
    ),
    Product(
      id: 'p_dairy_paneer',
      titleHindi: 'अमूल मलाई पनीर',
      titleEnglish: 'Amul Fresh Malai Paneer',
      categoryId: 'dairy',
      imageEmoji: '🧀',
      description: 'मुलायम और ताजा मलाईदार पनीर।',
      variants: [
        ProductVariant(id: 'v_200g', label: '200 g Pack', price: 92.0, mrp: 98.0),
      ],
    ),
    Product(
      id: 'p_dairy_butter',
      titleHindi: 'अमूल बटर (मक्खन)',
      titleEnglish: 'Amul Pasteurized Butter',
      categoryId: 'dairy',
      imageEmoji: '🧈',
      description: 'असली अमूल मक्खन, Utterly Butterly Delicious!',
      variants: [
        ProductVariant(id: 'v_100g', label: '100 g', price: 56.0, mrp: 60.0),
        ProductVariant(id: 'v_500g', label: '500 g', price: 275.0, mrp: 290.0),
      ],
    ),

    // 6. Tea & Snacks
    Product(
      id: 'p_tea_redlabel',
      titleHindi: 'रेड लेबल चाय पत्ती',
      titleEnglish: 'Brooke Bond Red Label Tea',
      categoryId: 'tea_snacks',
      imageEmoji: '☕',
      description: 'स्वाद अपनों का, कड़क और ताजगी भरी चाय।',
      variants: [
        ProductVariant(id: 'v_250g', label: '250 g', price: 130.0, mrp: 145.0),
        ProductVariant(id: 'v_500g', label: '500 g', price: 250.0, mrp: 285.0),
        ProductVariant(id: 'v_1kg', label: '1 kg Box', price: 480.0, mrp: 540.0),
      ],
    ),
    Product(
      id: 'p_sugar_01',
      titleHindi: 'मधुर सल्फर-फ्री सफेद चीनी',
      titleEnglish: 'Madhur Pure & Hygienic Sugar (Clean)',
      categoryId: 'tea_snacks',
      imageEmoji: '🍬',
      description: 'सल्फर मुक्त चमकदार और स्वच्छ सफेद चीनी।',
      variants: [
        ProductVariant(id: 'v_1kg', label: '1 kg', price: 45.0, mrp: 50.0),
        ProductVariant(id: 'v_5kg', label: '5 kg Bag', price: 220.0, mrp: 245.0),
      ],
    ),
    Product(
      id: 'p_snack_bhujia',
      titleHindi: 'हल्दीराम भुजिया सेव',
      titleEnglish: 'Haldiram Nagpur Aloo Bhujia / Sev',
      categoryId: 'tea_snacks',
      imageEmoji: '🥨',
      description: 'चाय के साथ कुरकुरी और चटपटी नमकीन।',
      variants: [
        ProductVariant(id: 'v_200g', label: '200 g', price: 55.0, mrp: 60.0),
        ProductVariant(id: 'v_400g', label: '400 g', price: 105.0, mrp: 120.0),
      ],
    ),
    Product(
      id: 'p_snack_parle',
      titleHindi: 'पारले-जी ग्लूकोज बिस्कुट',
      titleEnglish: 'Parle-G Gold Glucose Biscuits',
      categoryId: 'tea_snacks',
      imageEmoji: '🍪',
      description: 'भारत का सबसे पसंदीदा चाय का बिस्कुट।',
      variants: [
        ProductVariant(id: 'v_250g', label: '250 g Pack', price: 28.0, mrp: 30.0),
        ProductVariant(id: 'v_1kg', label: '1 kg Family Pack', price: 100.0, mrp: 115.0),
      ],
    ),

    // 7. Cleaning Supplies
    Product(
      id: 'p_clean_surf',
      titleHindi: 'सर्फ एक्सेल ईज़ी वॉश डिटर्जेंट',
      titleEnglish: 'Surf Excel Easy Wash Detergent Powder',
      categoryId: 'cleaning_supplies',
      imageEmoji: '🧺',
      description: 'कठिन दागों को चुटकियों में साफ करे।',
      variants: [
        ProductVariant(id: 'v_500g', label: '500 g', price: 74.0, mrp: 82.0),
        ProductVariant(id: 'v_1kg', label: '1 kg', price: 142.0, mrp: 160.0),
      ],
    ),
    Product(
      id: 'p_clean_vim',
      titleHindi: 'विम डिशवॉश बार / साबुन',
      titleEnglish: 'Vim Dishwash Bar with Lemon',
      categoryId: 'cleaning_supplies',
      imageEmoji: '🧼',
      description: 'नींबू की शक्ति से बर्तनों की चिकनाई हटाए।',
      variants: [
        ProductVariant(id: 'v_200g', label: '200 g Single Bar', price: 15.0, mrp: 15.0),
        ProductVariant(id: 'v_multipack', label: '3 x 150g Multipack', price: 42.0, mrp: 45.0),
      ],
    ),
    Product(
      id: 'p_clean_dettol',
      titleHindi: 'डेटॉल ओरिजिनल हैंडवॉश रिफिल',
      titleEnglish: 'Dettol Original Germ Protection Handwash',
      categoryId: 'cleaning_supplies',
      imageEmoji: '🧴',
      description: '100% कीटाणुओं से सुरक्षित रखे।',
      variants: [
        ProductVariant(id: 'v_175ml', label: '175 ml Pouch', price: 45.0, mrp: 50.0),
        ProductVariant(id: 'v_675ml', label: '675 ml Refill', price: 110.0, mrp: 125.0),
      ],
    ),
  ];
}
