import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myapp/theme/app_colors.dart';

// Used TO SHOW Non editable textfield used in time fieds in attendence.
class FixedTextField extends StatelessWidget {
  final String?
  headerLabelText; // Optional label text displayed above the field.
  final String?
  inputFieldLabelText; // Optional label text for the InputDecorator.
  final String?
  selectedOption; // The current Option picked if non shows inputFieldLabelText in shaded.
  //final bool isDisabled;

  const FixedTextField({
    super.key,
    this.headerLabelText,
    this.inputFieldLabelText,
    required this.selectedOption,
   // this.isDisabled=false
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // Align header and field to the start
      children: [
        if (headerLabelText != null && headerLabelText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
            ), // Spacing between header label and input
            child: Text(
              headerLabelText!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.primary,
              ),
            ),
          ),
  
    Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Adjust margins as needed
      elevation: 2, // Subtle shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
      ),
      child: InkWell(
        onTap: null, // Handled by the parent widget
        borderRadius: BorderRadius.circular(12.0), // Match card border for InkWell splash
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.,
            mainAxisSize: MainAxisSize.min, 
            children: [
              Icon(
                Icons.access_time_outlined,
                color: AppColors.primary, // Dark grey icon color
                size: 20,
              ),
              const SizedBox(width: 9.0),
              Flexible(
                fit: FlexFit.loose, // Use Expanded to ensure the text takes available space
                child: AutoSizeText(
                  selectedOption!,
                  maxLines: 1,
                  minFontSize: 8,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[850], // Darker grey text color
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
        // // IntrinsicWidth wraps the entire tappable field (InkWell)
        // IntrinsicWidth( // This makes the InkWell take only the width needed by its child
        //   child: InkWell(
        //     onTap: null, // This field is non-editable
        //     borderRadius: BorderRadius.circular(12),
        //     child: InputDecorator(
        //       isEmpty: selectedOption == null || selectedOption!.isEmpty,
        //       decoration: InputDecoration(
        //         labelText: inputFieldLabelText,
        //         // Make content padding more compact for a tighter fit around the text
        //         contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        //         enabled: !isDisabled,
        //         fillColor: isDisabled ? Colors.grey.shade100 : Colors.white,
        //         filled: true,
        //         border: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(12),
        //           borderSide: BorderSide(
        //             color: isDisabled ? Colors.grey.shade300 : Colors.grey.shade400,
        //             width: 1.0,
        //           ),
        //         ),
        //         enabledBorder: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(12),
        //           borderSide: BorderSide(
        //             color: Colors.grey.shade300,
        //             width: 1.0,
        //           ),
        //         ),
        //         disabledBorder: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(12),
        //           borderSide: BorderSide(
        //             color: Colors.grey.shade300,
        //             width: 1.0,
        //           ),
        //         ),
        //         hintStyle: TextStyle(
        //           fontSize: 16,
        //           color: Colors.grey.shade500,
        //         ),
        //         labelStyle: TextStyle(
        //           color: Colors.grey.shade700,
        //         ),
        //       ),
        //       // IMPORTANT: The child of InputDecorator should be the actual content.
        //       // We remove the inner Padding/Row/Expanded here.
        //       child: AutoSizeText(
        //         selectedOption ?? '', // Display empty string if null
        //         style: TextStyle(
        //           fontSize: 16,
        //           color: AppColors.text,
        //         ),
        //         maxLines: 1,
        //         minFontSize: 8,
        //         overflow: TextOverflow.ellipsis,
        //         textAlign: TextAlign.start,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
    // return Column(
    //        crossAxisAlignment: CrossAxisAlignment.start, // Align header and InkWell to the start
    //   mainAxisSize: MainAxisSize.min, // Allow column to shrink wrap its children
    //   //crossAxisAlignment: CrossAxisAlignment.stretch,
    //   children: [
    //     if (headerLabelText != null && headerLabelText!.isNotEmpty)
    //       Padding(
    //         padding: const EdgeInsets.only(
    //           bottom: 8.0,
    //         ), // Spacing between header label and input
    //         child: Center(
    //           child: Text(
    //             headerLabelText!,
    //             style: const TextStyle(
    //               fontWeight: FontWeight.bold,
    //               fontSize: 14,
    //               color:AppColors.primary, 
    //             ),
    //           ),
    //         ),
    //       ),
    //     IntrinsicWidth( child:InkWell(
    //       onTap: null,
    //       borderRadius: BorderRadius.circular(12),
    //       child: InputDecorator(
    //         isEmpty: selectedOption == null,
    //         decoration: InputDecoration(labelText: inputFieldLabelText),
    //         child: Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2.0),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Expanded(
    //                 child: AutoSizeText(
    //                   selectedOption == null ? '' : selectedOption!,
    //                   style: const TextStyle(
    //                     fontSize: 16,
    //                     color: AppColors.text,
    //                   ),
    //                   maxLines: 1, 
    //                   minFontSize: 8, 
    //                   overflow:TextOverflow.ellipsis, 
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     )),
    //   ],
    // );
  }
}
