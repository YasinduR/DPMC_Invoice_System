import 'package:flutter/material.dart';
import 'package:myapp/theme/app_colors.dart';

// class SelectionCard<T> extends StatelessWidget {
//   final T data;
//   final VoidCallback onTap;

//   // Functions to extract values
//   final String Function(T) title;
//   final String Function(T) value;

//   const SelectionCard({
//     super.key,
//     required this.data,
//     required this.onTap,
//     required this.title,
//     required this.value,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final title_ = title(data);
//     final value_ = value(data);

//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         margin: EdgeInsets.zero,
//         elevation: 6,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             children: [
//               // Left text
//               Expanded(
//                 flex: 1,
//                 child: Text(
//                   title_,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.text,
//                   ),
//                   maxLines: 1,
//                 ),
//               ),

//               // Right text
//               Expanded(
//                 flex: 1,
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 16),
//                   child: Text(
//                     value_,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.text,
//                     ),
//                     textAlign: TextAlign.right,
//                     maxLines: 1,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:auto_size_text/auto_size_text.dart';

class SelectionCard<T> extends StatelessWidget {
  final T data;
  final VoidCallback onTap;

  final String Function(T) title;
  final String Function(T) value;

  final double titleRatio;

  const SelectionCard({
    super.key,
    required this.data,
    required this.onTap,
    required this.title,
    required this.value,
    this.titleRatio = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    final title_ = title(data);
    final value_ = value(data);

    final ratio = titleRatio.clamp(0.1, 0.9);
    final int titleFlex = (ratio * 100).toInt();
    final int valueFlex = 100 - titleFlex;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Title
              Expanded(
                flex: titleFlex,
                child: AutoSizeText(
                  title_,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                  maxLines: 1,
                  minFontSize: 10, // 👈 added
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Value
              Expanded(
                flex: valueFlex,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: AutoSizeText(
                    value_,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    minFontSize: 10, // 👈 added
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}