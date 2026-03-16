//-------------------- Added by Darshan R on 16/03/2026 ------------------------//
import 'package:flutter/material.dart';
import 'package:myapp/contracts/mappable.dart';

// Type parameter [T] must implement [Mappable] interface for data mapping.
class DealerSelectionSheet<T extends Mappable> extends StatefulWidget {
  // Title displayed at the top of the selection sheet.
  final String title;

  // List of items to display in cards.
  final List<T> items;

  // Optional initial search query to pre-populate the search field.
  final String? initialSearchQuery;

  // Order must correspond to [valueFields].
  final List<String> displayNames;

  // Order must correspond to [displayNames].
  final List<String> valueFields;

  // This field is shown inline with the first value field in the header row.
  final String mainField;

  const DealerSelectionSheet({
    required this.title,
    required this.items,
    this.initialSearchQuery,
    required this.displayNames,
    required this.valueFields,
    required this.mainField,
  });

  @override
  State<DealerSelectionSheet<T>> createState() =>
      _DealerSelectionSheetState<T>();
}

class _DealerSelectionSheetState<T extends Mappable>
    extends State<DealerSelectionSheet<T>> {
  // Controller managing search input text.
  late TextEditingController _searchController;

  // Filtered list of items based on current search query.
  late List<T> _filteredItems;

  @override
  void initState() {
    super.initState();
    _searchController =
        TextEditingController(text: widget.initialSearchQuery ?? '');
    _filteredItems = [];
    _searchController.addListener(_performFilter);
    _performFilter();
  }

  @override
  void dispose() {
    _searchController.removeListener(_performFilter);
    _searchController.dispose();
    super.dispose();
  }

  // Search is case-insensitive and searches across all fields defined in [valueFields].
  void _performFilter() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items.where((item) {
          final map = item.toMap();
          return widget.valueFields.any((field) {
            final value = map[field]?.toString().toLowerCase() ?? '';
            return value.contains(query);
          });
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Header with title
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1),
              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search by any field...',
                    prefixIcon: const Icon(Icons.search),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const Divider(height: 1),
              // Cards list - displays filtered items in responsive card layout
              Expanded(
                child: _filteredItems.isEmpty
                    ? Center(
                        child: Text(
                          'No items found',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                      : OrientationBuilder(
                          builder: (context, orientation) {
                            return ListView.builder(
                              controller: scrollController,
                              padding: const EdgeInsets.all(12),
                              itemCount: _filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = _filteredItems[index];
                                final map = item.toMap();
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _buildDealerCard(context, item, map),
                                );
                              },
                            );
                          },
                        ),
              ),
            ],
          ),
        );
      },
    );
  }

  // The card becomes selectable on tap and returns the selected item to the caller.
  Widget _buildDealerCard(
    BuildContext context,
    T item,
    Map<String, dynamic> map,
  ) {
    return GestureDetector(
      onTap: () {
        // Return selected item to the caller (closes modal and passes selection)
        Navigator.of(context).pop(item);
      },
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: First value field | Main field
              // Uses Expanded + Align for precise positioning:
              // - Left side: Account Code (right-aligned within its space)
              // - Center: "|" separator (pinned to top line)
              // - Right side: Name/Main field (left-aligned within its space)
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        map[widget.valueFields[0]]?.toString() ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4), // Single whitespace gap
                  const Text('|', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 4), // Single whitespace gap
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        map[widget.mainField]?.toString() ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              // Remaining fields - displayed below the header row
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 1; i < widget.valueFields.length; i++)
                    if (widget.valueFields[i] != widget.mainField)
                      Column(
                        children: [
                          // Check if field should be centered based on field name
                          _isCenteredField(widget.displayNames[i])
                            ? Center(
                                child: _buildFieldInfo(
                                  map[widget.valueFields[i]]?.toString() ?? 'N/A',
                                ),
                              )
                            : _buildFieldInfo(
                                map[widget.valueFields[i]]?.toString() ?? 'N/A',
                              ),
                          // Add spacing between fields (except last field)
                          if (i < widget.valueFields.length - 1 && 
                              widget.valueFields[i + 1] != widget.mainField)
                            const SizedBox(height: 2),
                        ],
                      ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Determines if a field should be center-aligned based on its display name.
  bool _isCenteredField(String label) {
    return label.toLowerCase().contains('address') || 
           label.toLowerCase().contains('city');
  }

  // Used for displaying remaining fields below the header row.
  Widget _buildFieldInfo(String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}