import 'package:flutter/material.dart';
import 'package:myapp/models/dealer_stat_model.dart';
import 'package:myapp/models/tin_model.dart';

class DealerTinView extends StatelessWidget {
  final DealerStat dealer;
  final List<TinData> tins;
  const DealerTinView({super.key, required this.dealer, required this.tins});
  @override
  Widget build(BuildContext context) {
    final dealerTins = tins.where((t) => t.dealercode == dealer.accountCode).toList();
    return dealerTins.isEmpty
        ? const Center(child: Text('No TINs found'))
        : ListView.builder(
          itemCount: dealerTins.length,
          itemBuilder: (context, index) {
            final tin = dealerTins[index];
            return ListTile(
              title: Text('TIN No: ${tin.tinNumber}'),
              subtitle: Text('Rs: ${tin.totalValue}'),
              trailing: Text(tin.paymentStatusText, style: TextStyle(color: tin.paymentStatusColor,fontWeight: FontWeight.bold)));
          },
        );
  }
}
