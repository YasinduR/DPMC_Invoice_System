import 'package:flutter/material.dart';

// Represent Column 
class DynamicColumn<T> {
  final String label;
  final int flex;

  final Widget Function(BuildContext context, T item) cellBuilder;

  const DynamicColumn({
    required this.label,
    this.flex = 1,
    required this.cellBuilder,
  });
  
}