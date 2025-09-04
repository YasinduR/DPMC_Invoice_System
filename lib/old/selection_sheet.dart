import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart';

class SelectionSheet<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final Widget headerBuilder;
  final TextEditingController
  searchController; // MODIFIED: Added search controller

  const SelectionSheet({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    required this.headerBuilder,
    required this.searchController, // MODIFIED: Required in constructor
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Search and Filter Bar
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.filter_list),
                      label: const Text('Filter'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller:
                            searchController, // MODIFIED: Linked controller
                        decoration: InputDecoration(
                          hintText: 'Search',
                          prefixIcon: const Icon(Icons.search),
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Header for the list
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: headerBuilder,
              ),
              const Divider(height: 1),
              // Scrollable List of Items
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: items.length,
                  separatorBuilder:
                      (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    return itemBuilder(items[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}





// class SelectionSheet<T> extends StatelessWidget {
//   final String title;
//   final List<T> items;
//   final Widget Function(T item) itemBuilder;
//    final Widget Function(BuildContext context) headerBuilder;
//   final TextEditingController searchController; // Add this

//   const SelectionSheet({
//     super.key,
//     required this.title,
//     required this.items,
//     required this.itemBuilder,
//     required this.headerBuilder,
//     required this.searchController,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return DraggableScrollableSheet(
//       expand: false,
//       initialChildSize: 0.7,
//       maxChildSize: 0.9,
//       builder: (context, scrollController) {
//         return Container(
//           decoration: const BoxDecoration(
//             color: AppColors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           child: Column(
//             children: [
//               // Search and Filter Bar
//               Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Row(
//                   children: [
//                     TextButton.icon(
//                       onPressed: () {},
//                       icon: const Icon(Icons.filter_list),
//                       label: const Text('Filter'),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: TextField(
//                         controller: searchController,
//                         decoration: InputDecoration(
//                           hintText: 'Search',
//                           prefixIcon: const Icon(Icons.search),
//                           isDense: true,
//                           border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Header for the list
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                 child: headerBuilder(context),
//               ),
//               const Divider(height: 1),
//               // Scrollable List of Items
//               Expanded(
//                 child: ListView.separated(
//                   controller: scrollController,
//                   itemCount: items.length,
//                   separatorBuilder: (context, index) => const Divider(height: 1),
//                   itemBuilder: (context, index) {
//                     return itemBuilder(items[index]);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }