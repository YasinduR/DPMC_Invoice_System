import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; //This ensures the entire widget tree is built and stable before any state updates are attempted. back button press
import 'package:myapp/config/app_config.dart';
import 'package:myapp/contracts/mappable.dart';
import 'package:myapp/exceptions/app_exceptions.dart';
import 'package:myapp/models/bank_branch_model.dart';
import 'package:myapp/models/bank_model.dart';
import 'package:myapp/models/region_model.dart';
import 'package:myapp/models/assignee_model.dart';
import 'package:myapp/models/return_request_model.dart';
//import 'package:myapp/services/api_util_service.dart';
import 'package:myapp/services/mock_api_service.dart';
import 'package:myapp/services/secure_storage_services.dart';
import 'package:myapp/theme/app_colors.dart';
import 'package:myapp/theme/app_theme_helper.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/widgets/app_loading_overlay.dart';
import 'package:myapp/widgets/cards/common_selection_card.dart';
import 'package:myapp/widgets/cards/dealer_selection_card.dart';
import 'package:myapp/widgets/app_empty_list.dart';
import 'package:myapp/widgets/app_search_text_field.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/models/tin_model.dart';
import 'package:myapp/widgets/cards/tin_selection_card.dart';

typedef CommitStateChangedCallback = void Function(bool isCommitted);
typedef FilterConditions = List<List<dynamic>>;

enum SelectionSheetLayoutType { table, card }

// Common Helper of the Application

class AppSelectionField<T extends Mappable> extends StatefulWidget {
  final TextEditingController
  controller; // The controller for the text field to manage its content.
  final String
  labelText; // The text that appears as the label for the input field.
  final IconData
  icon; // The icon displayed on the button next to the text field. Defaults to a question mark.
  final String
  dataUrl; // The API endpoint URL from where to fetch the list of selectable items.
  final void Function(T)
  onSelected; // Callback function that is triggered when an item is selected from the list.
  final CommitStateChangedCallback?
  onCommitStateChanged; // Callback to notify the parent widget whether the current value is a valid, selected item.
  // This is useful for enabling/disabling buttons based on a committed selection.

  final String
  selectionSheetTitle; // The title displayed at the top of the modal bottom sheet.
  final List<String>
  displayNames; // The list of column headers to show in the data table on the selection sheet.
  final List<String>
  valueFields; // The list of field names from the data model (T) to get the values for the columns.
  // The order must correspond to `displayNames`.

  final String
  mainField; // The specific field name from the data model (T) whose value should be displayed in the text field.
  final T?
  initialValue; // The initial value to populate the field with when the widget is first built.
  final FilterConditions?
  filterConditions; // Optional list of filters to be sent with the API request to narrow down the data.
  // Example: [['status', '=', 'active'], ['department', '=', 'sales']]

  final Future<bool> Function()? preRequest;

  /// An optional asynchronous function to run before fetching data.If it returns `false`, the data fetching process is cancelled.
  final String? Function(String?)?
  validator; // A standard validator function for the underlying TextFormField.
  final void Function(String)? onChanged;

  /// A standard onChanged callback for the underlying TextFormField.
  final void Function(String)?
  onFieldSubmitted; // A standard onFieldSubmitted callback for the underlying TextFormField.
  final TextInputAction? textInputAction;

  /// The type of action button to display on the keyboard (e.g., next, done).

  final bool
  showHelperOnInitialization; // Optional flag to show selection sheet on initialization. automate ? press

  // The first rule whoich rows `shouldColor`.
  final List<DataHelperColorRule<T>>? colorRules;

  // Selection sheet layout type (table or card)
  final SelectionSheetLayoutType layoutType;

  const AppSelectionField({
    super.key,
    required this.controller,
    required this.labelText,
    this.icon = Icons.question_mark,
    required this.dataUrl,
    required this.onSelected,
    this.onCommitStateChanged, // Make it optional
    required this.selectionSheetTitle,
    required this.displayNames,
    required this.valueFields,
    required this.mainField,
    this.initialValue,
    this.filterConditions,
    this.preRequest,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.textInputAction,
    this.showHelperOnInitialization = false,
    this.colorRules,
    this.layoutType = SelectionSheetLayoutType.table, // default to table
  });

  @override
  State<AppSelectionField<T>> createState() => _AppSelectionFieldState<T>();
}

class _AppSelectionFieldState<T extends Mappable>
    extends State<AppSelectionField<T>> {
  T? _lastSelectedItem;
  List<T> _fetchedItems = [];
  late final AppLoadingOverlay _loadingOverlay;
  final SecureStorageService _secureStorageService =
      SecureStorageService(); // Instantiate SecureStorageService

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
        // //  Optionally show the selection sheet on initialization even if value selected
        // Consider enablaling this later

        // if (widget.showHelperOnInitialization == true) {
        //   _showSelectionSheet(context);
        // }
        //---------
      });
    } else if (widget.showHelperOnInitialization == true) {
      // If no initialValue and helper on init required sheet should still show
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showSelectionSheet(context);
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

  // Future<void> _showSelectionSheet(BuildContext context) async {
  //   if (widget.preRequest != null) {
  //     final shouldProceed = await widget.preRequest!();
  //     if (!shouldProceed) {
  //       return;
  //     }

  //     try {
  //       String fullUrl = widget.dataUrl;
  //       if (widget.filterConditions != null &&
  //           widget.filterConditions!.isNotEmpty) {
  //         final String filterJson = jsonEncode(widget.filterConditions);
  //         final String encodedFilters = Uri.encodeComponent(filterJson);
  //         fullUrl = '${widget.dataUrl}?filters=$encodedFilters';
  //       }

  //       await inquire<T>(
  //         context: context,
  //         dataUrl: fullUrl,
  //         onSuccess: (items) async {
  //           if (mounted) {
  //             setState(() {
  //               _fetchedItems = items;
  //               print(_fetchedItems);
  //             });
  //             await _presentSelectionSheet(context, _fetchedItems);
  //           }
  //         },
  //         onError: (errorMessage) {
  //           if (mounted) {
  //             showSnackBar(
  //               context: context,
  //               message: errorMessage,
  //               type: MessageType.error,
  //             );
  //           }
  //         },
  //       );
  //     } catch (e) {
  //       if (mounted) {
  //         String errorMessage = e.toString();
  //         if (errorMessage.startsWith('Exception: ')) {
  //           errorMessage = errorMessage.substring('Exception: '.length);
  //         }
  //         showSnackBar(
  //           context: context,
  //           message: errorMessage,
  //           type: MessageType.error,
  //         );
  //       }
  //     }
  //   }
  // }

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
      //Sring baseUrl =;
      String baseUrl = Config.baseUrl;
      String fullUrl = baseUrl + widget.dataUrl;
      if (widget.filterConditions != null &&
          widget.filterConditions!.isNotEmpty) {
        final String filterJson = jsonEncode(widget.filterConditions);
        final String encodedFilters = Uri.encodeComponent(filterJson);
        fullUrl = '${fullUrl}?filters=$encodedFilters';
      }
      print(fullUrl);
      final String? accessToken = await _secureStorageService.getAccessToken();

      if (accessToken == null) {
        // Handle case where no token is found (e.g., user not logged in)
        print('Error: No access token found. User is not authenticated.');
        // You might want to navigate to a login screen or show an error message
        throw UnauthorisedException('Please log in to access this data.');
      }

      final items = await MockApiService.get<T>(
        fullUrl,
        authToken: accessToken, // Pass the retrieved access token
      );
      //final items = await MockApiService.get<T>(fullUrl);
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
        String errorMessage = e.toString();
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
  // Helper to present the actual selection sheet after data is ready
  Future<void> _presentSelectionSheet(
    BuildContext context,
    List<T> items,
  ) async {
    print('Openning sheet');
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
        // Switch based on layout type - Added by Darshan R on 16/03/2026
        switch (widget.layoutType) {
          case SelectionSheetLayoutType.card:
            switch (T) {
              // Switch case Added  by Yasindu Ganegoda
              case Dealer:
                return CardSelectionSheet(
                  title: widget.selectionSheetTitle,
                  initialSearchQuery: initialQuery,
                  valueFields: widget.valueFields,
                  items: items as List<Dealer>,
                  cardBuilder: (context, dealer, onTap) {
                    return DealerSelectionCard(dealer: dealer, onTap: onTap);
                  },
                );
              case TinData:
                return CardSelectionSheet(
                  title: widget.selectionSheetTitle,
                  initialSearchQuery: initialQuery,
                  valueFields: widget.valueFields,
                  items: items as List<TinData>,
                  cardBuilder: (context, tin, onTap) {
                    return TinSelectionCard(tin: tin, onTap: onTap);
                  },
                );
              case Region:
                return CardSelectionSheet(
                  title: widget.selectionSheetTitle,
                  initialSearchQuery: initialQuery,
                  valueFields: widget.valueFields,
                  items: items as List<Region>,
                  cardBuilder: (context, data, onTap) {
                    return SelectionCard(
                      onTap: onTap,
                      data: data,
                      title: (t) => t.region,
                      value: (t) => t.regionCode,
                    );
                  },
                );
                case Bank:
                return CardSelectionSheet(
                  title: widget.selectionSheetTitle,
                  initialSearchQuery: initialQuery,
                  valueFields: widget.valueFields,
                  items: items as List<Bank>,
                  cardBuilder: (context, data, onTap) {
                    return SelectionCard(
                      onTap: onTap,
                      data: data,
                      title: (t) => t.bankName,
                      value: (t) => t.bankCode,
                      titleRatio: 0.8
                    );
                  },
                );
                case BankBranch:
                return CardSelectionSheet(
                  title: widget.selectionSheetTitle,
                  initialSearchQuery: initialQuery,
                  valueFields: widget.valueFields,
                  items: items as List<BankBranch>,
                  cardBuilder: (context, data, onTap) {
                    return SelectionCard(
                      onTap: onTap,
                      data: data,
                      title: (t) => t.branchName,
                      value: (t) => t.branchCode,
                      titleRatio: 0.8
                    );
                  },
                );
                case ReturnRequest:
                return CardSelectionSheet(
                  title: widget.selectionSheetTitle,
                  initialSearchQuery: initialQuery,
                  valueFields: widget.valueFields,
                  items: items as List<ReturnRequest>,
                  cardBuilder: (context, data, onTap) {
                    return SelectionCard(
                      onTap: onTap,
                      data: data,
                      title: (t) => t.returnId,
                      value: (t) => t.returnType,
                    );
                  },
                );
                case Assignee:
                return CardSelectionSheet(
                  title: widget.selectionSheetTitle,
                  initialSearchQuery: initialQuery,
                  valueFields: widget.valueFields,
                  items: items as List<Assignee>,
                  cardBuilder: (context, data, onTap) {
                    return SelectionCard(
                      onTap: onTap,
                      data: data,
                      title: (t) => t.name,
                      value: (t) => t.assigneeId,
                      titleRatio: 0.7,
                    );
                  },
                );


              default:
                break;
            }
          case SelectionSheetLayoutType.table:
            break;
        }

        //or default table - Added by Darshan R on 16/03/2026
        return SelectionSheet<T>(
          title: widget.selectionSheetTitle,
          items: items,
          initialSearchQuery: initialQuery,
          displayNames: widget.displayNames,
          valueFields: widget.valueFields,
          colorRules: widget.colorRules,
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
    return AppHelpTextField(
      controller: widget.controller,
      labelText: widget.labelText,
      icon: widget.icon,
      onIconPressed: () => _showSelectionSheet(context),

      validator: widget.validator,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      onChanged: widget.onChanged,
    );
  }
}

class AppHelpTextField extends StatelessWidget {
  final TextEditingController controller;

  final String labelText;
  final IconData icon;
  final VoidCallback? onIconPressed;
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
    InputDecoration baseDecoration = InputDecoration(labelText: labelText);

    // Apply specific border overrides if hideBorder is true
    if (hideBorder) {
      OutlineInputBorder baseOut = AppThemeHelpers.getAppRoundedBorder(
        type: AppBorderType.none,
      );

      baseDecoration = baseDecoration.copyWith(
        border: baseOut,
        enabledBorder: baseOut,
        focusedBorder: baseOut,
        errorBorder: baseOut,
        focusedErrorBorder: baseOut,
        disabledBorder: baseOut,
      );
    }
    InputDecoration effectiveDecoration = baseDecoration.applyDefaults(
      Theme.of(context).inputDecorationTheme,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            onChanged: onChanged,
            textInputAction: textInputAction,
            // cursorColor: AppColors.primary, // Add this line
            //autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller,
            onFieldSubmitted: (_) => onIconPressed!(),
            keyboardType: keyboardType,
            validator: validator,
            decoration: effectiveDecoration,
          ),
        ),
        const SizedBox(width: 8),

        IconButton(
          onPressed: onIconPressed,
          icon: Icon(icon), // Use the customizable icon
          style: AppThemeHelpers.getHelperIconButtonStyle(),
        ),
      ],
    );
  }
}

class SelectionSheet<T extends Mappable> extends StatefulWidget {
  final String title;
  final List<T> items;
  final String? initialSearchQuery;
  final List<String> displayNames;

  final List<String> valueFields;
  final List<DataHelperColorRule<T>>? colorRules;

  const SelectionSheet({
    super.key,
    required this.title,
    required this.items,
    this.initialSearchQuery,
    required this.displayNames,
    required this.valueFields,
    this.colorRules,
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
    // Determine effective palette from Theme
    final effectivePalette = Theme.of(context).extension<AppColorsExtension>()?.palette;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: effectivePalette?.white ?? Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: SearchTextField(
                  controller: _searchController,
                  onChanged: (_) => _performFilter(),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child:
                    _filteredItems.isEmpty
                        ? const EmptyListWidget()
                        : SingleChildScrollView(
                          controller: scrollController,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              showCheckboxColumn: false,
                              columns:
                                  widget.displayNames.map((name) {
                                    return DataColumn(
                                      label: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          // Modified by Darshan R on 18/03/2026
                                          vertical: 8.0,
                                          horizontal: 12.0,
                                        ),
                                        child: Text(
                                          name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: effectivePalette?.text,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                              rows:
                                  // added data cells merges to row and commented old code by Darshan R on 10/03/2026
                                  // _filteredItems.map((item) {
                                  //   final map = item.toMap();
                                  //   return DataRow(
                                  //     cells:
                                  //         widget.valueFields.map((field) {
                                  //           final cellValue =
                                  //               map[field]?.toString() ?? '';
                                  //           return DataCell(
                                  //             Text(cellValue),
                                  //             onTap: () {
                                  //               Navigator.of(context).pop(item);
                                  //             },
                                  //           );
                                  //         }).toList(),
                                  //   );
                                  // }).toList(),
                                  _filteredItems.map((item) {
                                    final map = item.toMap();

                                    final List<Widget> cellWidgets =
                                        widget.valueFields.map((field) {
                                          final cellValue =
                                              map[field]?.toString() ?? '';
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8.0,
                                              horizontal: 12.0,
                                            ),
                                            child: Text(
                                              cellValue,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: effectivePalette?.text,
                                              ),
                                            ),
                                          );
                                        }).toList();

                                    final List<DataCell> cells =
                                        cellWidgets
                                            .map((w) => DataCell(w))
                                            .toList();

                                    // find applicable color rule
                                    DataHelperColorRule<T>? appliedRule;
                                    if (widget.colorRules != null) {
                                      for (var rule in widget.colorRules!) {
                                        if (rule.shouldColor(item)) {
                                          appliedRule = rule;
                                          break;
                                        }
                                      }
                                    }

                                    // apply particular color for the row
                                    Color? rowColor;
                                    if (appliedRule?.decorationBuilder !=
                                        null) {
                                      final dec = appliedRule!
                                          .decorationBuilder!(context, item);
                                      rowColor = dec.color?.withOpacity(0.12);
                                    }

                                    return DataRow(
                                      color:
                                          rowColor != null
                                              ? MaterialStateProperty.all(
                                                rowColor,
                                              )
                                              : null,
                                      cells: cells,
                                      onSelectChanged: (_) {
                                        Navigator.of(context).pop(item);
                                      },
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

// NEW: Generic Color Rule Definition
class DataHelperColorRule<T> {
  /// A predicate function to determine if this rule should apply to a given item.
  final bool Function(T item) shouldColor;
  final int startColumnIndex;
  final int endColumnIndex;

  /// A builder function for the content of the colored cell.
  final Widget Function(BuildContext context, T item) coloredCellBuilder;

  /// An optional builder for the decoration of the colored cell container.
  final BoxDecoration Function(BuildContext context, T item)? decorationBuilder;

  DataHelperColorRule({
    required this.shouldColor,
    required this.startColumnIndex,
    required this.endColumnIndex,
    required this.coloredCellBuilder,
    this.decorationBuilder,
  }) : assert(startColumnIndex >= 0, 'startColumnIndex must be non-negative'),
       assert(endColumnIndex >= 0, 'endColumnIndex must be non-negative'),
       assert(
         endColumnIndex >= startColumnIndex,
         'endColumnIndex must be greater than or equal to startColumnIndex',
       );
}

//Used for card view in helper - Added by Darshan R on 17/03/2026
class CardSelectionSheet<T extends Mappable> extends StatefulWidget {
  final String title;
  final List<T> items;
  final List<String> valueFields; // if null, search all fields
  final String? initialSearchQuery;

  // Builder function to create a card widget for each item
  final Widget Function(BuildContext context, T item, VoidCallback onTap)
  cardBuilder;

  const CardSelectionSheet({
    required this.title,
    required this.items,
    required this.cardBuilder,
    required this.valueFields,
    this.initialSearchQuery,
  });

  @override
  State<CardSelectionSheet<T>> createState() => _CardSelectionSheetState<T>();
}

class _CardSelectionSheetState<T extends Mappable>
    extends State<CardSelectionSheet<T>> {
  late TextEditingController _searchController;
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

  // void _performFilter() {
  //   final query = _searchController.text.toLowerCase();
  //   setState(() {
  //     if (query.isEmpty) {
  //       _filteredItems = widget.items;
  //     } else {
  //       _filteredItems =
  //           widget.items.where((item) {
  //             final map = item.toMap();
  //             return map.values.any((value) {
  //               return value.toString().toLowerCase().contains(query);
  //             });
  //           }).toList();
  //     }
  //   });
  // }

  // extends State<SelectionSheet<T>> {
  // late final TextEditingController _searchController;
  // late List<T> _filteredItems;

  // @override
  // void initState() {
  //   super.initState();
  //   _searchController = TextEditingController(text: widget.initialSearchQuery);
  //   _filteredItems = [];
  //   _searchController.addListener(_performFilter);
  //   _performFilter();
  // }

  // @override
  // void dispose() {
  //   _searchController.removeListener(_performFilter);
  //   _searchController.dispose();
  //   super.dispose();
  // }

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
    // Determine the effective palette from Theme
    final effectivePalette = Theme.of(context).extension<AppColorsExtension>()?.palette;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: effectivePalette?.white ?? Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: SearchTextField(
                  controller: _searchController,
                  onChanged: (_) => _performFilter(),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child:
                    _filteredItems.isEmpty
                        ? const EmptyListWidget()
                        : ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.all(12),
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = _filteredItems[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: widget.cardBuilder(
                                context,
                                item,
                                () => Navigator.of(context).pop(item),
                              ),
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
}
