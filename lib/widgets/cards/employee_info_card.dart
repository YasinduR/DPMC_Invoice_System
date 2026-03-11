import 'package:flutter/material.dart';
import 'package:myapp/models/employee_model.dart';
import 'package:myapp/theme/app_colors.dart';

class EmployeeInfoCard extends StatelessWidget {
  final Employee employee;

  const EmployeeInfoCard({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    return Container( // Use Container to add border and padding
      margin: const EdgeInsets.symmetric(horizontal: 16.0), // Margin outside the card
      padding: const EdgeInsets.all(16.0), // Padding inside the card
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, // Use cardColor for background
        borderRadius: BorderRadius.circular(12.0), // Rounded corners for the card
        border: Border.all(
          color: Theme.of(context).dividerColor, // A subtle border color
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.borderDark, // Optional: Add a subtle shadow
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30, // Adjust the size of the profile photo as needed
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Icon(
              Icons.person, // Profile icon as a placeholder
              size: 30, // Reduced icon size slightly to fit better
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            employee.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold, // Make employee name bold
              fontSize: 18, // Adjust font size as needed
            ),
          ),
          const SizedBox(height: 5),
          Text(
            employee.compName,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color, // Use a subtle color for company name
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}



// class EmployeeInfoCard extends StatelessWidget {
//   final Employee employee;

//   const EmployeeInfoCard({
//     super.key,
//     required this.employee,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
//       child: 
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//             CircleAvatar(
//             radius: 30, // Adjust the size of the profile photo as needed
//             backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
//             child: Icon(
//               Icons.person, // Profile icon as a placeholder
//               size: 50,
//               color: Theme.of(context).primaryColor,
//             ),
//           ),
//           const SizedBox(height: 10),
//               Text(
//                 employee.name,
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 employee.compName,
//               ),
//             ],
//           ),
//        //],
//       //),
//     );
//   }
// }