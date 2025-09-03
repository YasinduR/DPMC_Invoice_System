import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/column_model.dart';
import 'package:myapp/models/region_model.dart';
import 'package:myapp/models/return_item_model.dart';
import 'package:myapp/providers/region_provider.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/util/api_util.dart';
import 'package:myapp/util/snack_bar.dart';
import 'package:myapp/views/region_selection_view.dart';
import 'package:myapp/widgets/action_button.dart';
//import 'package:myapp/widgets/action_button.dart';
import 'package:myapp/widgets/app_page.dart';
import 'package:myapp/widgets/app_table.dart';
import 'package:myapp/widgets/dealer_info_card.dart';
import 'package:myapp/widgets/option_picker_dialog.dart';
import 'package:myapp/widgets/option_picker_field.dart';
//import 'package:myapp/widgets/custom_selection_form_field.dart';
import 'package:myapp/views/select_dealer_view.dart';
import 'package:myapp/views/select_tin_view.dart';
//import 'package:myapp/widgets/selection_sheet.dart';
import 'package:myapp/models/tin_model.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/views/auth_dealer_view.dart';
import 'package:myapp/widgets/tin_info_card.dart';
import 'package:myapp/widgets/titled_radio_group.dart';

class ReturnScreen extends ConsumerStatefulWidget {
  const ReturnScreen({super.key});

  @override
  ConsumerState<ReturnScreen> createState() => _ReturnScreenState();
}

class _ReturnScreenState extends ConsumerState<ReturnScreen> {
  int _currentStep = 0;
  Dealer? _selectedDealer;
  TinData? _selectedTin;

  // Regional settings
  Region? _selectedRegion;

  void _onRegionSelected(Region region) {
    setState(() {
      _selectedRegion = region;
    });
  }

  void _submitRegion() {
    if (_selectedRegion != null) {
      ref.read(regionProvider.notifier).setRegion(_selectedRegion!);
      showSnackBar(
        context: context,
        message: 'Region set to: ${_selectedRegion!.region}',
        type: MessageType.success,
      );
      setState(() {
        _currentStep = 0; // Move to the inital
      });
    }
  }

  void _onRegionSelectionRequested() {
    setState(() {
      _currentStep = -1; // Move to Region selection step
    });
  }
  //--- Regional Settings

  void _onDealerSelected(Dealer dealer) {
    setState(() {
      _selectedDealer = dealer;
    });
  }

  void _submitDealer() {
    if (_selectedDealer != null) {
      setState(() {
        _currentStep = 1; // Move to Authenticate step
      });
    }
  }

  void _onAuthenticated() {
    setState(() {
      _currentStep = 2; // Move selct tin
    });
  }

  // MODIFIED: Added callbacks for TIN selection
  void _onTinSelected(TinData tin) {
    setState(() {
      _selectedTin = tin;
    });
  }

  void _submitTin() {
    if (_selectedTin != null) {
      setState(() {
        _currentStep = 3; // Move to Create Invoice step
      });
    }
  }

  void _saveReturn() {
    setState(() {
      _currentStep = 2; // Move to the tinselaction
    });
    showSnackBar(
      context: context,
      message: "Invoice Saved !",
      type: MessageType.success,
    );
  }

  void _goBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedRegion = ref.watch(regionProvider).selectedRegion;
    Widget currentView;
    switch (_currentStep) {
      case -1:
        currentView = SelectRegionView(
          selectedRegion: selectedRegion,
          onRegionSelected: _onRegionSelected,
          onSubmit: _submitRegion,
        );
        break;
      case 0:
        currentView = SelectDealerView(
          onRegionSelectionRequested: _onRegionSelectionRequested,
          selectedRegion: selectedRegion,
          selectedDealer: _selectedDealer,
          onDealerSelected: _onDealerSelected,
          onSubmit: _submitDealer, // Pass submit callback
        );
        break;
      case 1:
        currentView = AuthenticateDealerView(
          dealer: _selectedDealer!,
          onAuthenticated: _onAuthenticated,
        );
        break;
      case 2:
        currentView = SelectTinNumberView(
          dealer: _selectedDealer!,
          selectedTin: _selectedTin,
          onTinNumberSelected: _onTinSelected,
          onSubmit: _submitTin,
        );
        break;
      case 3:
        currentView = ReturnsView(
          dealer: _selectedDealer!,
          tinData: _selectedTin!,
          onSubmit: _saveReturn,
        );
        break;
      default:
        currentView = const Center(child: Text('Error'));
    }
    final String currentTitle;
    switch (_currentStep) {
      case -1:
        currentTitle = 'Select Region'; // New title
        break;
      case 0:
        currentTitle = 'Select Dealer';
        break;
      case 1:
        currentTitle = 'Authenticate Dealer';
        break;
      case 2:
        currentTitle = 'Select TIN';
        break;
      case 3:
        currentTitle = 'Returns';
        break;
      default:
        currentTitle = 'Error';
    }

    return AppPage(
      title: currentTitle,
      onBack: _goBack,
      contentPadding: EdgeInsets.zero,
      child: currentView,
    );
  }
}

// NOTE: Make sure to import your 'Dealer', 'TinData', and 'ReturnItem' models here.

class ReturnsView extends StatefulWidget {
  final Dealer dealer;
  final TinData tinData;
  final VoidCallback onSubmit;

  const ReturnsView({
    super.key,
    required this.dealer,
    required this.tinData,
    required this.onSubmit,
  });

  @override
  State<ReturnsView> createState() => _ReturnsViewState();
}

class _ReturnsViewState extends State<ReturnsView> {
  // final List<ReturnItem> _items = [
  //   ReturnItem(partNo: 'AC2000123230', requestQty: 5),
  //   ReturnItem(partNo: 'AC2000123266', requestQty: 8),
  //   ReturnItem(partNo: 'AC2000123267', requestQty: 7),
  // ];
  List<ReturnItem> _items = []; // Initialize with an empty list
  bool _isLoading = true; // Flag to manage loading state
  String? _errorMessage; // To store any potential error message

  String _selectedReturnType = 'Discrepancy Returns';
  String? _selectedReason;
  final List<String> _reasonOptions = [
    'LEAKAGES (PETROL/OIL)',
    'LOYALTY DISCOUNT',
    'MANUFACTURING DEFECT',
    'REFUND',
    'OTHERS',
    'Bead Failure - BF',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadReturnItems());
  }

  /// Fetches the list of returnable items using the reusable 'inquire' function.
  Future<void> _loadReturnItems() async {
    // Set the initial loading state before making the API call
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Use the generic data loading function
    await inquire<ReturnItem>(
      context: context,
      dataUrl: 'api/return-items/list', // The API endpoint for return items
      onSuccess: (List<ReturnItem> data) {
        // If the widget is still mounted, update the state with the fetched data.
        if (mounted) {
          setState(() {
            _items = data;
            _isLoading = false;
          });
        }
      },
      onError: (String message) {
        // If the widget is still mounted, update the state with the error message.
        if (mounted) {
          setState(() {
            _errorMessage = message;
            _isLoading = false;

            showSnackBar(
              context: context,
              message: _errorMessage!,
              type: MessageType.success,
            );
          });
        }
      },
    );
  }

  void _togglePartSelection(String partNo) {
    setState(() {
      final part = _items.firstWhere((p) => p.partNo == partNo);
      part.isSelected = !part.isSelected;
    });
  }

  Future<void> _showReasonPicker() async {
    final result = await showDialog<String>(
      context: context,
      builder:
          (context) => SelectionModal(
            title: 'Reason',
            options: _reasonOptions,
            initialValue: _selectedReason,
          ),
    );

    if (result != null) {
      setState(() {
        _selectedReason = result;
      });
    }
  }

  bool get isAnyItemSelected {
    return _items.any((item) => item.isSelected);
  }

  Widget _buildItemsList() {
    // First, check if the data is still loading.
    if (_isLoading) {
      return const Center(child: Text("Loading items..."));
    }

    // Next, check if an error has occurred.
    if (_errorMessage != null) {
      return const Center(child: Text("No data Found"));
    }

    // If there is no error and loading is complete, show the list.
    return FilterableListView<ReturnItem>(
      searchHintText: 'Search by Part No or Quantity',
      onFilterPressed: () {},
      filterableFields: const ['partNo', 'requestQty'],
      items: _items,
      columns: [
        DynamicColumn<ReturnItem>(
          label: 'Part No',
          flex: 3,
          cellBuilder:
              (context, part) => Text(
                part.partNo,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
        ),
        DynamicColumn<ReturnItem>(
          label: 'Request Qty',
          flex: 2,
          cellBuilder:
              (context, part) =>
                  Center(child: Text(part.requestQty.toString())),
        ),
        DynamicColumn<ReturnItem>(
          label: 'Select',
          flex: 2,
          cellBuilder:
              (context, part) => Center(
                child: Checkbox(
                  value: part.isSelected,
                  activeColor: AppColors.primary,
                  checkColor: Colors.white,
                  onChanged: (value) => _togglePartSelection(part.partNo),
                ),
              ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. The root widget is now a Column, which allows us to stack a
    //    scrolling area on top of a fixed area.

    return Column(
      children: [
        // 2. The main content area is wrapped in Expanded. This tells it to
        //    take up all available vertical space, pushing the button to the bottom.
        Expanded(
          // 3. The ListView now handles the scrolling for the form content.
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              DealerInfoCard(dealer: widget.dealer),
              const SizedBox(height: 12),
              TinInfoDisplay(tinData: widget.tinData),
              const SizedBox(height: 16),

              SizedBox(height: 250.0, child: _buildItemsList()),

              const SizedBox(height: 24),
              TitledRadioGroup(
                title: 'Return Type',
                options: const ['Field Returns', 'Discrepancy Returns'],
                selectedValue: _selectedReturnType,
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedReturnType = value);
                  }
                },
              ),
              const SizedBox(height: 24),
              PickerFormField(
                labelText: 'Reason',
                displayValue: _selectedReason ?? 'Select a reason',
                onTap: _showReasonPicker,
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            24,
          ), // Adjust padding as needed
          child: ActionButton(
            icon: Icons.check_circle_outline,
            label: 'Save',
            disabled: !isAnyItemSelected || _selectedReason == null,
            onPressed: widget.onSubmit,
          ),
        ),
      ],
    );
  }
}
