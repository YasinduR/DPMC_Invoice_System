
import 'package:myapp/contracts/mappable.dart';

class InvoiceItem {
  final String invoiceNumber;
  final String invoiceAmount;

  const InvoiceItem({required this.invoiceNumber, required this.invoiceAmount});
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
}