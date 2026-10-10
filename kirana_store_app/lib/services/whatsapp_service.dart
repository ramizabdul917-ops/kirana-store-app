import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/order.dart';

class WhatsAppService {
  static String formatOrderMessage(OrderModel order, String shopName) {
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    final formattedDate = dateFormat.format(order.createdAt);
    final buffer = StringBuffer();

    buffer.writeln('🛒 *नया किराना आर्डर | NEW ORDER*');
    buffer.writeln('🏪 *$shopName*');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('🏷️ *टोकन नंबर / TOKEN:* *${order.tokenCode}*');
    buffer.writeln('📅 *तारीख / Date:* $formattedDate');
    buffer.writeln('👤 *ग्राहक / Customer:* ${order.customerName}');
    buffer.writeln('📞 *मोबाइल / Phone:* ${order.customerPhone}');
    buffer.writeln('📍 *पता / Address:* ${order.customerAddress}');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━');

    if (order.orderType == "PARCHI") {
      buffer.writeln('📝 *हस्तलिखित पर्ची आर्डर / PARCHI LIST:*');
      if (order.parchiText != null && order.parchiText!.trim().isNotEmpty) {
        buffer.writeln(order.parchiText!.trim());
      } else {
        buffer.writeln('📷 [ग्राहक ने पर्ची की फोटो भेजी है / Photo attached]');
      }
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━');
      buffer.writeln('💰 *भुगतान का प्रकार / Payment:* ${order.paymentMethod == "UPI" ? "Shop UPI" : "Cash on Delivery / Counter"}');
    } else {
      buffer.writeln('📦 *सामान की सूची / ITEMS LIST:*');
      for (int i = 0; i < order.items.length; i++) {
        final item = order.items[i];
        buffer.writeln(
          '${i + 1}. ${item.product.titleHindi} (${item.variant.label}) '
          'x ${item.quantity} = ₹${item.itemTotal.toStringAsFixed(0)}',
        );
      }
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━');
      buffer.writeln('🧾 *सामान का मूल्य:* ₹${order.subtotal.toStringAsFixed(0)}');
      if (order.discount > 0) {
        buffer.writeln('🎁 *बचत / Discount:* -₹${order.discount.toStringAsFixed(0)}');
      }
      buffer.writeln('💵 *कुल बिल राशि / Grand Total:* *₹${order.grandTotal.toStringAsFixed(0)}*');
      buffer.writeln('💰 *भुगतान का प्रकार / Payment:* ${order.paymentMethod == "UPI" ? "Shop UPI" : "Cash at Counter / Delivery"}');
    }

    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('कृपया यह आर्डर पैक करके तैयार रखें। धन्यवाद!');

    return buffer.toString();
  }

  static Future<bool> sendOrderToWhatsApp({
    required OrderModel order,
    required String shopName,
    required String shopPhone,
  }) async {
    final message = formatOrderMessage(order, shopName);
    final cleanPhone = shopPhone.replaceAll(RegExp(r'\D'), '');
    final phoneWithCountry = cleanPhone.length == 10 ? '91$cleanPhone' : cleanPhone;

    final encodedMessage = Uri.encodeComponent(message);
    final whatsappUrl = Uri.parse('https://wa.me/$phoneWithCountry?text=$encodedMessage');

    try {
      if (await canLaunchUrl(whatsappUrl)) {
        return await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to generic URL launch
        return await launchUrl(whatsappUrl);
      }
    } catch (_) {
      return false;
    }
  }
}
