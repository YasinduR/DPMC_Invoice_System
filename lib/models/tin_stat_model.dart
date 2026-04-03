import 'package:myapp/models/tin_model.dart';

class TinStat {
  final int approved;
  final double totalPayment;
  final String? error;

  const TinStat({
    this.approved = 0,
    this.totalPayment = 0.0,
    this.error,
  });

  factory TinStat.fromTinList(List<TinData> tins, {String? error}) {
    final approvedItems = tins.where((t) => t.paymentStatus == 'A').toList();
    final int approved = approvedItems.length;
    final double total = approvedItems.fold<double>(0.0, (s, t) => s + t.totalValue);
    return TinStat(approved: approved, totalPayment: total, error: error);
  }

  TinStat copyWith({int? approved, double? totalPayment, String? error}) {
    return TinStat(
      approved: approved ?? this.approved,
      totalPayment: totalPayment ?? this.totalPayment,
      error: error ?? this.error,
    );
  }
}