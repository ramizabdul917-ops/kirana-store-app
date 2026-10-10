import 'cart_item.dart';

class OrderModel {
  final String id;
  final String tokenCode; // e.g. "#K-104"
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final List<CartItem> items;
  final String? parchiText;
  final String? parchiImagePath;
  final double subtotal;
  final double discount;
  final double grandTotal;
  final String paymentMethod; // "CASH" or "UPI"
  final String orderType; // "CART" or "PARCHI"
  String status; // "PENDING", "PACKED", "DELIVERED", "CANCELLED"
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.tokenCode,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.items,
    this.parchiText,
    this.parchiImagePath,
    required this.subtotal,
    required this.discount,
    required this.grandTotal,
    required this.paymentMethod,
    this.orderType = "CART",
    this.status = "PENDING",
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tokenCode': tokenCode,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'items': items.map((i) => i.toJson()).toList(),
      'parchiText': parchiText,
      'parchiImagePath': parchiImagePath,
      'subtotal': subtotal,
      'discount': discount,
      'grandTotal': grandTotal,
      'paymentMethod': paymentMethod,
      'orderType': orderType,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      tokenCode: json['tokenCode'] as String,
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      customerAddress: json['customerAddress'] as String,
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => CartItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      parchiText: json['parchiText'] as String?,
      parchiImagePath: json['parchiImagePath'] as String?,
      subtotal: (json['subtotal'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      grandTotal: (json['grandTotal'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String? ?? "CASH",
      orderType: json['orderType'] as String? ?? "CART",
      status: json['status'] as String? ?? "PENDING",
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
