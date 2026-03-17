// Added by Darshan R on 16/03/2026
import 'package:flutter/material.dart';

class EmptyListWidget extends StatelessWidget {
  final String message;

  const EmptyListWidget({
    Key? key,
    this.message = 'No items found',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}