import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart';

class CustomSelectionFormField<T> extends StatelessWidget {
  final String labelText;
  final T? selectedValue;
  final String Function(T) displayString;
  final Future<void> Function(BuildContext) onShowPicker;

  // 1. ADDED: A callback for the new help button.
  //final VoidCallback? onHelpPressed;

  const CustomSelectionFormField({
    super.key,
    required this.labelText,
    this.selectedValue,
    required this.displayString,
    required this.onShowPicker,
    // this.onHelpPressed, // Added to the constructor.
  });

  @override
  Widget build(BuildContext context) {
    // 2. MODIFIED: Using a Row to layout the field and button horizontally.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 3. MODIFIED: Expanded is necessary to prevent a layout overflow error.
        Expanded(
          child: InkWell(
            onTap: () => onShowPicker(context),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: labelText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                selectedValue != null
                    ? displayString(selectedValue as T)
                    : 'Tap to select',
              ),
            ),
          ),
        ),
        // 4. ADDED: The help icon button, which only appears if onHelpPressed is provided.
        //  if (onHelpPressed != null) ...[
        const SizedBox(width: 8),
        // Using an IconButton for semantics and correct tap target size.
        IconButton(
          onPressed: () => onShowPicker(context),
          icon: const Icon(Icons.question_mark_rounded),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.primary, // Blue color from the image
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.all(14),
          ),
        ),
        // ],
      ],
    );
  }
}













// class CustomSelectionFormField<T> extends StatelessWidget {
//   final String labelText;
//   final T? selectedValue;
//   final String Function(T) displayString;
//   final Future<void> Function(BuildContext) onShowPicker;

//   const CustomSelectionFormField({
//     super.key,
//     required this.labelText,
//     this.selectedValue,
//     required this.displayString,
//     required this.onShowPicker,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//     InkWell(
//       onTap: () => onShowPicker(context),
//       child: InputDecorator(
//         decoration: InputDecoration(
//           labelText: labelText,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         child: Text(selectedValue != null ? displayString(selectedValue as T) : 'Tap to select'),
//       ),
//     ),
//         const SizedBox(width: 8),
//         ElevatedButton(
//           onPressed: () => onShowPicker(context),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppColors.primary,
//             shape: const CircleBorder(),
//             padding: const EdgeInsets.all(16),
//           ),
//           child: const Icon(Icons.question_mark, color: AppColors.white),
//         ),
//       ],
//     );
//   }
//}

// This worked well but 
// class CustomSelectionFormField<T> extends StatelessWidget {
//   final String labelText;
//   final T? selectedValue;
//   final String Function(T) displayString;
//   final Future<void> Function(BuildContext) onShowPicker;

//   const CustomSelectionFormField({
//     super.key,
//     required this.labelText,
//     this.selectedValue,
//     required this.displayString,
//     required this.onShowPicker,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () => onShowPicker(context),
//       child: InputDecorator(
//         decoration: InputDecoration(
//           labelText: labelText,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         child: Text(selectedValue != null ? displayString(selectedValue as T) : 'Tap to select'),
//       ),
//     );
//   }
// }












//   Widget build(BuildContext context) {
//     // Controller to manually set the text of the field
//     // final controller = TextEditingController(
//     //   text: selectedValue != null ? displayString(selectedValue!) : '',
//     // );

//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           child: GestureDetector(
//             onTap: () => onShowPicker(context),
//             child: AbsorbPointer(
//               child: TextField(
//                 controller: controller,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: AppColors.white,
//                   labelText: labelText,
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
//                   suffixIcon: const Icon(Icons.arrow_drop_down),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 8),
//         ElevatedButton(
//           onPressed: () => onShowPicker(context),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppColors.primary,
//             shape: const CircleBorder(),
//             padding: const EdgeInsets.all(16),
//           ),
//           child: const Icon(Icons.question_mark, color: AppColors.white),
//         ),
//       ],
//     );
//   }
// }