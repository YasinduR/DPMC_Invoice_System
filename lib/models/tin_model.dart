import 'dart:ui';
import 'package:myapp/contracts/mappable.dart';
import 'package:myapp/helpers/common_functions.dart';
import 'package:myapp/models/part_model.dart';
import 'package:myapp/theme/app_colors.dart';

class TinData implements Mappable {
  final String tinNumber;
  final String orderNumber;
  final String payOnDel;
  final String paymentStatus; // P - Payment Pending, C - Payment Completed A- Payment Approved
  final double totalValue;
  final String dealercode;
  final List<Part> parts;
   // Added For Dispatch Note
  final int bagCount;
  final int tagCount;
  final int plasticBCount;
  final String remark;

  const TinData({
    required this.tinNumber,
    required this.orderNumber,
    required this.totalValue,
    required this.paymentStatus,
    required this.dealercode,
    this.payOnDel = 'N',
    this.parts = const [],
    this.bagCount = 0,
    this.tagCount = 0,
    this.plasticBCount = 0,
    this.remark = '',
    
  });

  String get _paymentStatusText {
    switch (paymentStatus) {
      case 'P':
        return 'Pending';
      case 'C':
        return 'Completed';
      case 'A':
        return 'Approved';
      default:
        return paymentStatus;
    }
  }

  Color get paymentStatusColor {
    switch (paymentStatus) {
      case 'P':
        return AppColors.warning;
      case 'C':
        return AppColors.success;
      case 'A':
        return AppColors.primary;
      default:
        return AppColors.disabled;
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'tinNumber': tinNumber,
      'orderNumber': orderNumber,
      'payOnDel': payOnDel,
      'paymentStatus': _paymentStatusText,
      'totalValue': formatNumber(totalValue),
      'dealerCode': dealercode,
      'bagCount': bagCount,
      'tagCount': tagCount,
      'plasticBCount': plasticBCount,
      'remark': remark,
      'parts': parts.map((part) => part.toMap()).toList(), // Serialize parts
    };
  }
}
