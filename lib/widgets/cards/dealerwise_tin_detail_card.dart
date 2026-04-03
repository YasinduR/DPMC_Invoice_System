// Added by Darshan R on 2026-04-03
import 'package:flutter/material.dart';
import 'package:myapp/models/tin_model.dart';
import 'package:myapp/theme/app_colors.dart';
import 'package:myapp/widgets/cards/dealerwise_tin_part_detail_card.dart';

class DealerTinCard extends StatefulWidget {
  final TinData tin;

  const DealerTinCard({
    super.key,
    required this.tin,
  });

  @override
  State<DealerTinCard> createState() => _DealerTinCardState();
}

class _DealerTinCardState extends State<DealerTinCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.description_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TIN: ${widget.tin.tinNumber}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rs: ${widget.tin.totalValue.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: AppColors.textFaded,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: widget.tin.paymentStatusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.tin.paymentStatusText,
                          style: TextStyle(
                            color: widget.tin.paymentStatusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _isExpanded
                            ? Icons.expand_less_rounded
                            : Icons.expand_more_rounded,
                        color: AppColors.textFaded,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_isExpanded && widget.tin.parts.isNotEmpty) _buildPartsList(),
            if (_isExpanded && widget.tin.parts.isEmpty)
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  'No parts associated with this TIN',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: AppColors.disabled),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartsList() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Divider(height: 1),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: const [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Part Number',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: AppColors.textFaded,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: AppColors.textFaded,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Qty',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: AppColors.textFaded,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Parts List using new extracted widget
              ...widget.tin.parts.map((p) => DealerTinPartDetailCard(part: p)),
            ],
          ),
        ),
      ],
    );
  }
}
