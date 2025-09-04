import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; //This ensures the entire widget tree is built and stable before any state updates are attempted. back button press
import 'package:myapp/contracts/mappable.dart';
import 'package:myapp/services/mock_api_service.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/util/snack_bar.dart';
import 'package:myapp/widgets/app_loading_overlay.dart';

//typedef DisplayStringCallback<T> = String Function(T item);
typedef CommitStateChangedCallback = void Function(bool isCommitted);
typedef FilterConditions = List<List<dynamic>>;

class AppSelectionField<T extends Mappable> extends StatefulWidget {
  final T? initialValue; // <<< ADD THIS NEW PROPERTY

  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  //final List<T> items;
  final void Function(T) onSelected;
  //final DisplayStringCallback<T> displayString;
  final CommitStateChangedCallback? onCommitStateChanged;
  final String selectionSheetTitle;
  final List<String> displayNames;
  final List<String> valueFields;
  final String mainField;
  final String dataUrl;
  final FilterConditions? filterConditions;
  final Future<bool> Function()? preRequest;

  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;

  const AppSelectionField({
    super.key,
    required this.controller,
    required this.labelText,
    this.icon = Icons.question_mark,
    required this.dataUrl,
    //required this.items,
    required this.onSelected,
    //required this.displayString,
    this.onCommitStateChanged, // Make it optional
    required this.selectionSheetTitle,
    required this.displayNames,
    required this.valueFields,
    required this.mainField,
    this.initialValue,
    this.filterConditions,
    this.preRequest, // <<< ADD THIS
    this.validator, // Added
    this.onChanged, // Added
    this.onFieldSubmitted, // Added
    this.textInputAction, // Added
  });

  @override
  State<AppSelectionField<T>> createState() => _AppSelectionFieldState<T>();
}

class _AppSelectionFieldState<T extends Mappable>
    extends State<AppSelectionField<T>> {
  T? _lastSelectedItem;
  List<T> _fetchedItems = [];
  late final AppLoadingOverlay _loadingOverlay;

  @override
  void initState() {
    super.initState();
    _loadingOverlay = AppLoadingOverlay();

    _lastSelectedItem = widget.initialValue;
    widget.controller.addListener(_handleTextChange);

    if (widget.initialValue != null) {
      // Set the text field's value immediately, which is safe.
      widget.controller.text = _getMainFieldValue(widget.initialValue as T);

      // Defer the callbacks that trigger state changes in parent widgets.
      SchedulerBinding.instance.addPostFrameCallback((_) {
        // This code will run after the first frame is rendered.
        if (mounted) {
          // Always check if the widget is still in the tree
          widget.onSelected(widget.initialValue as T);
          widget.onCommitStateChanged?.call(true);
        }
      });
    }
  }

  @override
  void dispose() {
    _loadingOverlay.hide();
    widget.controller.removeListener(_handleTextChange);
    super.dispose();
  }

  String _getMainFieldValue(T item) {
    final map = item.toMap();
    return map[widget.mainField]?.toString() ?? '';
  }

  void _handleTextChange() {
    if (_lastSelectedItem != null &&
        widget.controller.text != _getMainFieldValue(_lastSelectedItem as T)) {
      _lastSelectedItem = null;
      widget.onCommitStateChanged?.call(false);
    }
  }

  Future<void> _showSelectionSheet(BuildContext context) async {
    // // If items are already fetched, just show the selection sheet WITH OUT REFETCH
    // if (_fetchedItems.isNotEmpty) {
    //   await _presentSelectionSheet(context, _fetchedItems);
    //   return;
    // }

    if (widget.preRequest != null) {
      final shouldProceed = await widget.preRequest!();
      if (!shouldProceed) {
        return;
      }
    }

    _loadingOverlay.show(context); // Use the common overlay
    try {
      // --- Build the full URL with filters ---
      String fullUrl = widget.dataUrl;
      if (widget.filterConditions != null &&
          widget.filterConditions!.isNotEmpty) {
        // 1. Encode the filter list into a JSON string
        final String filterJson = jsonEncode(widget.filterConditions);
        // 2. URL-encode the JSON string to make it safe for a URL
        final String encodedFilters = Uri.encodeComponent(filterJson);
        // 3. Append it as a query parameter
        fullUrl = '${widget.dataUrl}?filters=$encodedFilters';
      }
      // --- End of URL building ---
      final items = await MockApiService.fetchData<T>(fullUrl);

      _loadingOverlay.hide();

      if (mounted) {
        setState(() {
          _fetchedItems = items;
        });
        await _presentSelectionSheet(context, _fetchedItems);
      }
    } catch (e) {
      _loadingOverlay.hide();
      if (mounted) {
        // Convert the exception to a string.
        String errorMessage = e.toString();

        // Remove the "Exception: " prefix, if it exists, for a cleaner message.
        if (errorMessage.startsWith('Exception: ')) {
          errorMessage = errorMessage.substring('Exception: '.length);
        }
        showSnackBar(
          context: context,
          message: errorMessage,
          type: MessageType.error,
        );
      }
    }
  }

  // Helper to present the actual selection sheet after data is ready
  Future<void> _presentSelectionSheet(
    BuildContext context,
    List<T> items,
  ) async {
    final initialQuery = widget.controller.text;

    if (initialQuery.isNotEmpty) {
      final exactMatches =
          items.where((item) {
            final map = item.toMap();
            final fieldValue =
                map[widget.mainField]?.toString().toLowerCase() ?? '';
            return fieldValue == initialQuery.toLowerCase();
          }).toList();

      if (exactMatches.length == 1) {
        final selectedItem = exactMatches.first;

        widget.controller.removeListener(_handleTextChange);
        _lastSelectedItem = selectedItem;
        widget.controller.text = _getMainFieldValue(selectedItem);
        widget.onSelected(selectedItem);
        widget.onCommitStateChanged?.call(true);
        widget.controller.addListener(_handleTextChange);

        return;
      }
    }

    final selectedItem = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SelectionSheet<T>(
          title: widget.selectionSheetTitle,
          items: items, // Pass the fetched items
          initialSearchQuery: initialQuery,
          displayNames: widget.displayNames,
          valueFields: widget.valueFields,
        );
      },
    );

    if (selectedItem != null) {
      widget.controller.removeListener(_handleTextChange);
      _lastSelectedItem = selectedItem;
      widget.controller.text = _getMainFieldValue(selectedItem);
      widget.onSelected(selectedItem);
      widget.onCommitStateChanged?.call(true);
      widget.controller.addListener(_handleTextChange);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Remove the Stack and Positioned.fill loading indicator
    return AppHelpTextField(
      controller: widget.controller,
      labelText: widget.labelText,
      icon: widget.icon,
      onIconPressed: () => _showSelectionSheet(context),

      validator: widget.validator,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      // The onChanged from the parent is passed directly,
      // while our internal _handleTextChange continues to work
      // via the listener added in initState.
      onChanged: widget.onChanged,
    );
  }
}

class AppHelpTextField extends StatelessWidget {
  final TextEditingController controller;

  final String labelText;
  final IconData icon; // Make the icon customizable
  final VoidCallback? onIconPressed;

  // --- 3. STANDARD TEXTFIELD PARAMETERS ---
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool hideBorder;
  final EdgeInsetsGeometry? contentPadding;

  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;

  const AppHelpTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.icon = Icons.search,
    this.onIconPressed,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.hideBorder = false,
    this.contentPadding,
    this.onChanged,
    this.onFieldSubmitted,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment
              .start, // Align items correctly with validation errors
      children: [
        Expanded(
          child: TextFormField(
            onChanged: onChanged,
            textInputAction: textInputAction,
            //autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller,
            onFieldSubmitted: (_) => onIconPressed!(),
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: const TextStyle(color: AppColors.borderDark),
              filled: true,
              fillColor: AppColors.white,
              contentPadding: contentPadding,

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    hideBorder
                        ? BorderSide.none
                        : const BorderSide(color: AppColors.borderDark),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    hideBorder
                        ? BorderSide.none
                        : const BorderSide(
                          color: AppColors.primary,
                          width: 2.0,
                        ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    hideBorder
                        ? BorderSide.none
                        : const BorderSide(color: AppColors.danger, width: 2.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    hideBorder
                        ? BorderSide.none
                        : const BorderSide(color: AppColors.danger, width: 2.0),
              ),
              floatingLabelStyle: MaterialStateTextStyle.resolveWith((states) {
                if (states.contains(MaterialState.error)) {
                  return const TextStyle(color: AppColors.danger);
                }
                // Use primary color when the field is focused.
                if (states.contains(MaterialState.focused)) {
                  return const TextStyle(color: AppColors.primary);
                }
                // Use border color when unfocused (but has content, so it's floating).
                return const TextStyle(color: AppColors.borderDark);
              }),
              errorStyle: const TextStyle(color: AppColors.danger),
            ),
          ),
        ),
        const SizedBox(width: 8),

        IconButton(
          onPressed: onIconPressed,
          icon: Icon(icon), // Use the customizable icon
          style: IconButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.all(14),
          ),
        ),
      ],
    );
  }
}

class SelectionSheet<T extends Mappable> extends StatefulWidget {
  final String title;
  final List<T> items;
  final String? initialSearchQuery;

  /// The header titles for the table (e.g., ['Account Code', 'Surname']).
  final List<String> displayNames;

  /// The property keys to look up in the map (e.g., ['accountCode', 'surname']).
  final List<String> valueFields;

  const SelectionSheet({
    super.key,
    required this.title,
    required this.items,
    this.initialSearchQuery,
    required this.displayNames,
    required this.valueFields,
  }) : assert(
         displayNames.length == valueFields.length,
         'Error: The number of display names must match the number of value fields.',
       );

  @override
  State<SelectionSheet<T>> createState() => _SelectionSheetState<T>();
}

class _SelectionSheetState<T extends Mappable>
    extends State<SelectionSheet<T>> {
  late final TextEditingController _searchController;
  late List<T> _filteredItems;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialSearchQuery);
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

  void _performFilter() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems =
            widget.items.where((item) {
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
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
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
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  controller:
                      scrollController, // This handles VERTICAL scrolling
                  child: SingleChildScrollView(
                    scrollDirection:
                        Axis.horizontal, // This handles HORIZONTAL scrolling
                    child: DataTable(
                      columns:
                          widget.displayNames.map((name) {
                            return DataColumn(
                              label: Text(
                                name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }).toList(),
                      rows:
                          _filteredItems.map((item) {
                            final map = item.toMap();
                            return DataRow(
                              cells:
                                  widget.valueFields.map((field) {
                                    final cellValue =
                                        map[field]?.toString() ?? '';
                                    return DataCell(
                                      Text(cellValue),
                                      onTap: () {
                                        Navigator.of(context).pop(item);
                                      },
                                    );
                                  }).toList(),
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
