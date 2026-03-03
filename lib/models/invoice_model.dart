import 'package:myapp/contracts/mappable.dart';
import 'package:myapp/models/part_model.dart';

// --- Invoice Model ---
class InvoiceSave implements Mappable {
  final String invoiceNumber;
  final String tinNo;
  final String orderNo;
  final String payOndel;
  final String route;
  final String dealerName;
  final String dealerVatNo;
  final String dealerAddress;
  final String dealerId;
  final String userId;
  final double invoiceAmount;
  final DateTime invoiceTime;
  final List<Part> parts;

  InvoiceSave({
    required this.invoiceNumber,
    required this.tinNo,
    required this.orderNo,
    required this.payOndel,
    required this.route,
    required this.dealerName,
    required this.dealerVatNo,
    required this.dealerAddress,
    required this.dealerId,
    required this.userId,
    required this.invoiceAmount,
    required this.invoiceTime,
    required this.parts,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'invoiceNumber': invoiceNumber,
      'tinNo': tinNo,
      'orderNo': orderNo,
      'payOndel': payOndel,
      'route': route,
      'dealerName': dealerName,
      'dealerVatNo': dealerVatNo,
      'dealerAddress': dealerAddress,
      'dealerId': dealerId,
      'userId': userId,
      'invoiceAmount': invoiceAmount,
      'invoiceTime': invoiceTime.toIso8601String(),
      'parts': parts.map((item) => item.toMap()).toList(),
    };
  }

  InvoiceSave copyWith({
    String? invoiceNumber,
    String? tinNo,
    String? orderNo,
    String? payOndel,
    String? route,
    String? dealerName,
    String? dealerAddress,
    String? dealerVatNo,
    String? dealerId,
    String? userId,
    double? invoiceAmount,
    DateTime? invoiceTime,
    List<Part>? parts,
  }) {
    return InvoiceSave(
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      tinNo: tinNo ?? this.tinNo,
      orderNo: orderNo ?? this.orderNo,
      payOndel: payOndel ?? this.payOndel,
      route: route ?? this.route,
      dealerName: dealerName ?? this.dealerName,
      dealerAddress: dealerAddress ?? this.dealerAddress,
      dealerVatNo: dealerVatNo ?? this.dealerVatNo,
      dealerId: dealerId ?? this.dealerId,
      userId: userId ?? this.userId,
      invoiceAmount: invoiceAmount ?? this.invoiceAmount,
      invoiceTime: invoiceTime ?? this.invoiceTime,
      parts: parts ?? this.parts,
    );
  }
}

class Invoice implements Mappable {
  final String date;
  final String invoiceNumber;
  final String customer;
  final double totalValue;

  const Invoice({
    required this.date,
    required this.invoiceNumber,
    required this.customer,
    required this.totalValue,
  });

  /// Converts the Invoice instance into a map.
  /// This allows the AppSelectionField to dynamically access its properties
  /// for display and filtering.
  @override
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'invoiceNumber': invoiceNumber,
      'customer': customer,
      'totalValue': totalValue,
    };
  }

  Invoice copyWith({
    String? date,
    String? invoiceNumber,
    String? customer,
    double? totalValue,
  }) {
    return Invoice(
      date: date ?? this.date,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      customer: customer ?? this.customer,
      totalValue: totalValue ?? this.totalValue,
    );
  }
}
