import 'package:auto_size_text/auto_size_text.dart' show AutoSizeText;
import 'package:flutter/material.dart';
import 'package:myapp/contracts/mappable.dart';
import 'package:myapp/models/column_model.dart';
import 'package:myapp/theme/app_theme.dart';

// Common Data Grid of the Application

class AppDataGrid<T extends Mappable> extends StatefulWidget {
  /// The list of items to display.
  final List<T> items;

  /// The list of columns to display in the table.
  final List<DynamicColumn<T>> columns;

  /// The list of field names to be used for filtering.
  final List<String> filterableFields;

  /// Callback for when the filter button is pressed.
  final VoidCallback? onFilterPressed;

  /// The hint text to display in the search input field.
  final String searchHintText;

  // Visibilty of filter bar over the table by Default true
  final bool hasFilter;

  const AppDataGrid({
    super.key,
    required this.items,
    required this.columns,
    required this.filterableFields,
    this.onFilterPressed,
    this.hasFilter = true,
    this.searchHintText = 'Search...',
  });

  @override
  State<AppDataGrid<T>> createState() => _AppDataGridState<T>();
}

class _AppDataGridState<T extends Mappable> extends State<AppDataGrid<T>> {
  final TextEditingController _searchController = TextEditingController();

  List<T> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _searchController.addListener(_performFilter);
  }

  @override
  void didUpdateWidget(AppDataGrid<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      _filteredItems = widget.items;
      _performFilter();
    }
  }

  void _performFilter() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems =
            widget.items.where((item) {
              final itemMap = item.toMap();
              return widget.filterableFields.any((field) {
                final value = itemMap[field];
                return value != null &&
                    value.toString().toLowerCase().contains(query);
              });
            }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_performFilter);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.hasFilter) _buildFilterAndSearch(),
        const SizedBox(height: 1),
        _buildHeader(),
        Container(height: 1, color: Colors.grey.shade300),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    if (_filteredItems.isEmpty) {
      return const Center(child: Text('No items found.'));
    }

    return ListView.builder(
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        return _buildRow(_filteredItems[index]);
      },
    );
  }

  Widget _buildFilterAndSearch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: widget.onFilterPressed,
            icon: const Icon(Icons.filter_alt_outlined),
            label: const Text('Filter'),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          ),
          const VerticalDivider(width: 1, indent: 8, endIndent: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: widget.searchHintText,
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      color: AppColors.white,
      child: Row(
        children:
            widget.columns.map((column) {
              return Expanded(
                flex: column.flex,
                child: AutoSizeText(
                  column.label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  maxLines: 2, // allow up to 2 lines
                  minFontSize:
                      10, // optional: shrink font instead of overflowing
                  overflowReplacement: Text(
                    column.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildRow(T item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:
            widget.columns.map((column) {
              return Expanded(
                flex: column.flex,
                child: column.cellBuilder(context, item),
              );
            }).toList(),
      ),
    );
  }
}
