// Helper widget for creating each card in the menu grid
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myapp/theme/app_colors.dart';

// class MenuCard extends StatelessWidget {
//   const MenuCard({
//     required this.icon,
//     required this.label,
//     required this.onTap,
//   });

//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 1,
//               blurRadius: 5,
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 40, color: AppColors.primary),
//             const SizedBox(height: 10),
//             AutoSizeText(
//               maxLines: 2,
//               label,
//               textAlign: TextAlign.center,
//               minFontSize: 8,
//               style: Theme.of(context).textTheme.labelMedium
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MenuCard extends StatefulWidget {
//   const MenuCard({
//     super.key,
//     required this.icon,
//     required this.label,
//     required this.onTap,
//   });

//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;

//   @override
//   State<MenuCard> createState() => _MenuCardState();
// }

// class _MenuCardState extends State<MenuCard> {
//   bool _isPressed = false;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       // Detect when the finger touches down
//       onTapDown: (_) => setState(() => _isPressed = true),
//       // Detect when the finger lifts up
//       onTapUp: (_) => setState(() => _isPressed = false),
//       // Detect when the finger drags away/cancels
//       onTapCancel: () => setState(() => _isPressed = false),
//       onTap: widget.onTap,
//       child: AnimatedScale(
//         scale: _isPressed ? 0.90 : 1.0, // Shrink slightly when pressed
//         duration: const Duration(milliseconds: 100),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 100),
//           decoration: BoxDecoration(
//             color: AppColors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 // Shadow becomes darker and more spread out when pressed
//                 color: _isPressed
//                     ? Colors.black.withOpacity(0.15)
//                     : Colors.grey.withOpacity(0.2),
//                 spreadRadius: _isPressed ? 2 : 1,
//                 blurRadius: _isPressed ? 10 : 5,
//                 offset: _isPressed ? const Offset(0, 4) : const Offset(0, 2),
//               ),
//             ],
//             border: Border.all(
//               color: _isPressed ? AppColors.primary.withOpacity(0.5) : Colors.transparent,
//               width: 1.5,
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 100),
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: _isPressed
//                       ? AppColors.primary.withOpacity(0.2)
//                       : AppColors.primary.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   widget.icon,
//                   size: 32,
//                   color: AppColors.primary
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: AnimatedDefaultTextStyle(
//                   duration: const Duration(milliseconds: 100),
//                   style: Theme.of(context).textTheme.labelMedium!.copyWith(
//                     // FONT CHANGE: Becomes bold and slightly larger on press
//                     fontWeight: _isPressed ? FontWeight.bold : FontWeight.w500,
//                     color: _isPressed ? AppColors.primary : Colors.black87,
//                   ),
//                   child: AutoSizeText(
//                     widget.label,
//                     maxLines: 2,
//                     textAlign: TextAlign.center,
//                     minFontSize: 8,
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

class MenuCard extends StatefulWidget {
  const MenuCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  bool _isPressed = false;
  
  @override
  Widget build(BuildContext context) {
    Color color = widget.color;
    return GestureDetector(
      // Detect when the finger touches down
      onTapDown: (_) => setState(() => _isPressed = true),
      // Detect when the finger lifts up
      onTapUp: (_) => setState(() => _isPressed = false),
      // Detect when the finger drags away/cancels
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.90 : 1.0, // Shrink slightly when pressed
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                // Shadow becomes darker and more spread out when pressed
                color:
                    _isPressed
                        ? Colors.black.withOpacity(0.15)
                        : Colors.grey.withOpacity(0.2),
                spreadRadius: _isPressed ? 2 : 2,
                blurRadius: _isPressed ? 10 : 7,
                offset: _isPressed ? const Offset(0, 4) : const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color:
                  _isPressed
                      //? AppColors.primary.withOpacity(0.5)
                      ? color.withOpacity(0.6)
                      : color.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 40, color: color),
              const SizedBox(height: 8),
              AutoSizeText(
                widget.label,
                maxLines: 2,
                wrapWords: false,
                textAlign: TextAlign.center,
                minFontSize: 10,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        )),
      ),
    );
  }
}
