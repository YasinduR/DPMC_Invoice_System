import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:myapp/config/app_config.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/services/mock_api_service.dart';
import 'package:myapp/services/secure_storage_services.dart';
import 'package:myapp/theme/app_theme_helper.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/widgets/app_loading_overlay.dart';
import 'cards/dealer_selection_view.dart';

typedef DealerCommitStateChanged = void Function(bool isCommitted);
typedef DealerFilterConditions = List<List<dynamic>>;

class AppSelectionFieldCard extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final String dataUrl;
  final Function(Dealer) onSelected;
  final DealerCommitStateChanged? onCommitStateChanged;
  final String selectionSheetTitle;
  final List<String> displayNames;
  final List<String> valueFields;
  final String mainField;
  final Dealer? initialValue;
  final DealerFilterConditions? filterConditions;
  final Future<bool> Function()? preRequest;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final bool showSelectionSheetOnInit;

  const AppSelectionFieldCard({
    super.key,
    required this.controller,
    required this.labelText,
    this.icon = Icons.question_mark,
    required this.dataUrl,
    required this.onSelected,
    this.onCommitStateChanged,
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
    this.showSelectionSheetOnInit = false,
  });

  @override
  State<AppSelectionFieldCard> createState() =>
      _AppSelectionFieldCardState();
}

class _AppSelectionFieldCardState
    extends State<AppSelectionFieldCard> {
  Dealer? _lastSelectedDealer;
  List<Dealer> _fetchedDealers = [];
  late final AppLoadingOverlay _loadingOverlay;
  final SecureStorageService _secureStorageService =
      SecureStorageService();

  @override
  void initState() {
    super.initState();
    _loadingOverlay = AppLoadingOverlay();

    _lastSelectedDealer = widget.initialValue;
    widget.controller.addListener(_handleTextChange);

    if (widget.initialValue != null) {
      widget.controller.text = _getDealerDisplayValue(widget.initialValue!);

      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onSelected(widget.initialValue!);
          widget.onCommitStateChanged?.call(true);
        }
      });
    } else if (widget.showSelectionSheetOnInit == true) {
      // If no initialValue and auto-show is enabled
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

  String _getDealerDisplayValue(Dealer dealer) {
    return dealer.toMap()[widget.mainField]?.toString() ?? '';
  }

  void _handleTextChange() {
    if (_lastSelectedDealer != null &&
        widget.controller.text !=
            _getDealerDisplayValue(_lastSelectedDealer!)) {
      _lastSelectedDealer = null;
      widget.onCommitStateChanged?.call(false);
    }
  }

  Future<void> _showSelectionSheet(BuildContext context) async {
    if (widget.preRequest != null) {
      final shouldProceed = await widget.preRequest!();
      if (!shouldProceed) {
        return;
      }
    }

    _loadingOverlay.show(context);

    try {
      String baseUrl = Config.baseUrl;
      String fullUrl = baseUrl + widget.dataUrl;

      if (widget.filterConditions != null &&
          widget.filterConditions!.isNotEmpty) {
        final String filterJson = jsonEncode(widget.filterConditions);
        final String encodedFilters = Uri.encodeComponent(filterJson);
        fullUrl = '$fullUrl?filters=$encodedFilters';
      }

      print('Fetching from: $fullUrl');

      final String? accessToken =
          await _secureStorageService.getAccessToken();

      if (accessToken == null) {
        throw Exception('Please log in to access this data.');
      }

      final dealers = await MockApiService.get<Dealer>(
        fullUrl,
        authToken: accessToken,
      );

      _loadingOverlay.hide();

      if (mounted) {
        setState(() {
          _fetchedDealers = dealers;
        });
        await _presentSelectionSheet(context, dealers);
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

  Future<void> _presentSelectionSheet(
    BuildContext context,
    List<Dealer> dealers,
  ) async {
    final initialQuery = widget.controller.text;

    if (initialQuery.isNotEmpty) {
      final exactMatches = dealers.where((dealer) {
        final map = dealer.toMap();
        final fieldValue =
            map[widget.mainField]?.toString().toLowerCase() ?? '';
        return fieldValue == initialQuery.toLowerCase();
      }).toList();

      if (exactMatches.length == 1) {
        final selectedDealer = exactMatches.first;

        widget.controller.removeListener(_handleTextChange);
        _lastSelectedDealer = selectedDealer;
        widget.controller.text = _getDealerDisplayValue(selectedDealer);
        widget.onSelected(selectedDealer);
        widget.onCommitStateChanged?.call(true);
        widget.controller.addListener(_handleTextChange);

        return;
      }
    }

    final selectedDealer = await showModalBottomSheet<Dealer>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DealerSelectionSheet<Dealer>(
          title: widget.selectionSheetTitle,
          items: dealers,
          initialSearchQuery: initialQuery,
          displayNames: widget.displayNames,
          valueFields: widget.valueFields,
          mainField: widget.mainField,
        );
      },
    );

    if (selectedDealer != null) {
      widget.controller.removeListener(_handleTextChange);
      _lastSelectedDealer = selectedDealer;
      widget.controller.text = _getDealerDisplayValue(selectedDealer);
      widget.onSelected(selectedDealer);
      widget.onCommitStateChanged?.call(true);
      widget.controller.addListener(_handleTextChange);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            onChanged: widget.onChanged,
            textInputAction: widget.textInputAction,
            controller: widget.controller,
            onFieldSubmitted: (_) => _showSelectionSheet(context),
            keyboardType: TextInputType.text,
            validator: widget.validator,
            decoration: InputDecoration(
              labelText: widget.labelText,
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => _showSelectionSheet(context),
          icon: Icon(widget.icon),
          style: AppThemeHelpers.getHelperIconButtonStyle(),
        ),
      ],
    );
  }
}