# 🛒 Shree Ganesh Kirana & Grocery Store App (श्री गणेश किराना स्टोर)

A complete, production-ready, zero-server-cost Kirana & Grocery Store Android App built using **Flutter (Dart)**. Designed specifically for local Indian grocery stores, neighbourhood vyaparis, and non-tech-savvy customers.

---

## 🌟 Key Highlights & Features

### 1. 🏪 Customer Home & Bilingual Catalog
* **Store Header**: Displays store name (*श्री गणेश किराना स्टोर*), live operating hours (*7:00 AM - 10:00 PM*), and promotional announcement banners (*Free delivery on ₹300+*).
* **7 Core Indian Grocery Categories**:
  1. 🌾 **Atta & Grains (आटा और अनाज)**: Aashirvaad Chakki Atta, India Gate Basmati Rice, Sooji, Besan.
  2. 🫘 **Dal & Pulses (दाल और दलहन)**: Toor/Arhar Dal, Moong Dal Dhuli, Chana Dal, Kabuli Chana.
  3. 🛢️ **Cooking Oils & Ghee (तेल और घी)**: Kachi Ghani Mustard Oil, Fortune Soyabean Oil, Amul Cow Ghee.
  4. 🌶️ **Spices & Masala (मसाले)**: Everest Haldi, Tikhalal Mirchi, Dhania Powder, Tata Salt.
  5. 🥛 **Dairy (दूध और डेयरी)**: Amul Taaza Milk, Fresh Paneer, Amul Butter.
  6. ☕ **Tea & Snacks (चाय और नमकीन)**: Red Label Tea, Madhur Clean Sugar, Haldiram Bhujia, Parle-G.
  7. 🧺 **Cleaning Supplies (सफाई सामग्री)**: Surf Excel, Vim Bar, Dettol Handwash.
* **Instant Unit/Variant Selectors**: Select between units (*250g, 500g, 1kg, 5kg, 1L, 5L*) directly on the card with real-time price updates.
* **Quantity Steppers**: Instant `+` / `-` buttons with haptic feedback.
* **Instant Live Search**: Search by Hindi or English name (*उदा: आटा, दाल, तेल, Sugar*).

---

### 2. 📝 Parchi (List) Upload Option
* **"Parchi Se Order Karein"** prominent banner right on the home screen.
* **Two Order Modes**:
  1. 📷 **Snap Photo**: Take a camera picture or upload a gallery photo of a handwritten paper grocery slip.
  2. ✍️ **Type List**: Simple multi-line text pad where elderly or busy customers can quickly type their grocery list without searching through catalogs.
* Generates an instant Anti-Fake Token Code upon submission.

---

### 3. 🧾 Smart Cart & Live Billing
* **Floating Live Cart Bar**: Displays real-time item count, total bill amount, and discount savings.
* **Transparent Breakdown**:
  * Itemized bill showing rates and quantities.
  * Subtotal, printed MRP savings, and **Free Local Delivery**.
* **Customer Details**: Name, 10-digit Phone, and Landmark / Gali No.
* **Flexible Payments**:
  1. 💵 **Cash at Counter / Delivery (Default)**: Pay cash upon pickup or delivery.
  2. 📱 **Shop UPI**: Dynamic on-screen QR Code preview (Google Pay, PhonePe, Paytm) with one-tap copy UPI ID.

---

### 4. 🏷️ Token-Based Order Confirmation (Anti-Fake Order System)
* **No Upfront Payment Barrier**: Eliminates customer cart abandonment.
* **Unique 4-Digit Token Code**: Every order generates an unmistakable identifier (e.g., **`#K-104`**).
* **One-Tap WhatsApp Summary**:
  * Formats a clean itemized receipt with customer name, phone, address, token ID, and total bill.
  * Opens WhatsApp directly with the store owner's pre-filled chat for instant packing.

---

### 5. 🛠️ Shopkeeper / Admin Dashboard Mode
* **4-Digit PIN Security**: Tap the "दुकानदार" button in the top bar and enter PIN (Default: **`1234`**) to switch views.
* **1-Minute Rapid Packing Token Lookup**:
  * Shopkeeper types the customer's token (e.g. `104` or `#K-104`).
  * Instantly displays customer details, direct phone dialer, and an interactive **Packing Checklist with checkboxes** to check off items while bagging.
* **Price & Stock Manager**:
  * Quick-edit screen to update daily fluctuating commodities (*mustard oil, sugar, dal*).
  * One-tap **In-Stock / Out-of-Stock** toggle switch.
* **Shop Settings**:
  * Change store name, WhatsApp phone number, UPI ID, operating hours, announcement text, and admin PIN.

---

## 🏗️ Architecture & Code Organization

```
lib/
├── main.dart                          # App bootstrap, MultiProvider & Theme
├── models/
│   ├── category.dart                  # Category schema with bilingual names
│   ├── product.dart                   # Product & Variant schema with JSON
│   ├── cart_item.dart                 # Cart item model with rate calculations
│   └── order.dart                     # Order schema with token & parchi support
├── providers/
│   ├── shop_provider.dart             # Catalog, search, stock & admin mode state
│   ├── cart_provider.dart             # Live cart management & billing logic
│   └── order_provider.dart            # Token generator (#K-104), order lifecycle
├── services/
│   ├── storage_service.dart           # Offline persistence (SharedPreferences)
│   └── whatsapp_service.dart          # Formatted WhatsApp receipt dispatcher
├── utils/
│   ├── constants.dart                 # Default store inventory & categories
│   └── theme.dart                     # Modern Material 3 fresh grocery green theme
├── widgets/
│   ├── shop_header.dart               # Store header with admin toggle & announcements
│   ├── category_item.dart             # Vibrant category chips
│   ├── product_card.dart              # Product card with variant picker & stepper
│   ├── floating_cart_bar.dart         # Floating live bill bar
│   ├── parchi_banner.dart             # Parchi upload call-to-action banner
│   └── upi_qr_widget.dart             # Shop UPI QR code generator & copy button
└── screens/
    ├── customer/
    │   ├── home_screen.dart           # Main shopping catalog view
    │   ├── parchi_upload_screen.dart  # Handwritten list photo/text uploader
    │   ├── cart_screen.dart           # Smart cart, customer details & checkout
    │   ├── order_success_screen.dart  # Anti-fake token receipt & WhatsApp dispatch
    │   └── order_history_screen.dart  # Past order list with token lookup
    └── admin/
        ├── admin_pin_dialog.dart      # 4-Digit PIN authentication modal
        ├── admin_dashboard_screen.dart# 1-Minute token packing dashboard
        ├── price_stock_manager_screen.dart # Daily rate & stock editor
        └── shop_settings_screen.dart  # Store configuration & profile editor
```

---

## 🚀 How to Run the App

1. Ensure Flutter is installed on your computer:
   ```bash
   flutter doctor
   ```
2. Navigate to the project directory:
   ```bash
   cd kirana_store_app
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run on your connected Android phone or Emulator:
   ```bash
   flutter run
   ```
5. To build release APK:
   * **Option A — Cloud Build (Zero installation needed)**:
     Simply double-click:
     ```
     cloud_build_apk.bat
     ```
     This automatically builds the production APK on GitHub's cloud servers and downloads `app-release.apk` directly to your folder!
   * **Option B — Local Build (Requires local Flutter + Android SDK)**:
     ```bash
     flutter build apk --release
     ```
     Or double-click `build_apk.bat`. Output will be generated at `build/app/outputs/flutter-apk/app-release.apk`.

