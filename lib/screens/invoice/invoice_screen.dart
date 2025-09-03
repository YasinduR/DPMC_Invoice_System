import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/column_model.dart';
import 'package:myapp/models/part_model.dart';
import 'package:myapp/models/region_model.dart';
//import 'package:myapp/models/region_model.dart';
import 'package:myapp/providers/region_provider.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/util/api_util.dart';
import 'package:myapp/util/snack_bar.dart';
import 'package:myapp/views/region_selection_view.dart';
import 'package:myapp/widgets/action_button.dart';
import 'package:myapp/widgets/app_page.dart';
import 'package:myapp/widgets/app_table.dart';
import 'package:myapp/widgets/dealer_info_card.dart';
import 'package:myapp/widgets/quantity_selector.dart';
import 'package:myapp/views/select_dealer_view.dart';
import 'package:myapp/views/select_tin_view.dart';
import 'package:myapp/models/tin_model.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/views/auth_dealer_view.dart';
import 'package:myapp/widgets/tin_info_card.dart';

class InvoiceScreen extends ConsumerStatefulWidget {
  const InvoiceScreen({super.key});

  @override
  ConsumerState<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends ConsumerState<InvoiceScreen> {
  int _currentStep = 0;
  //Dealer? _selectedDealer;
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

  // Dealer Selection
  Dealer? _selectedDealer;
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
      _currentStep = 2; // Move to Create Invoice step
    });
  }
  //--- Dealer Selection

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

  void _saveinvoice() {
    setState(() {
      _currentStep = 2; // Move to the initial page
    });
    showSnackBar(
      context: context,
      message: "Invoice Saved !",
      type: MessageType.success,
    );
  }

  void _goBack() {
    if (_currentStep > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _currentStep--;
        });
      });
      // setState(() {
      //   _currentStep--;
      // });
    } else {
      Navigator.of(context).pop();
      // In a real app, you might use Navigator.of(context).pop();
      //print("Already at the first step.");
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget currentView;
    final selectedRegion = ref.watch(regionProvider).selectedRegion;
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
          //dealers: _dealers,
          selectedRegion: selectedRegion,
          selectedDealer: _selectedDealer,
          onDealerSelected: _onDealerSelected,
          onSubmit: _submitDealer, // Pass submit callback
          onRegionSelectionRequested: _onRegionSelectionRequested,
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
          //tins: _tins,
          selectedTin: _selectedTin,
          onTinNumberSelected: _onTinSelected,
          onSubmit: _submitTin,
        );
        break;
      case 3:
        currentView = CreateInvoiceView(
          dealer: _selectedDealer!,
          tindata: _selectedTin!,
          onSubmit: _saveinvoice,
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
        currentTitle = 'Invoice';
        break;
      default:
        currentTitle = 'Error';
    }

    return AppPage(
      title: currentTitle,
      onBack: _goBack, // Pass our custom back logic for the multi-step flow.
      // Since the child views likely manage their own padding,
      // we set the AppPage's contentPadding to zero to avoid double padding.
      contentPadding: EdgeInsets.zero,
      child: currentView,
    );
  }
}

class CreateInvoiceView extends StatefulWidget {
  final Dealer dealer;
  final TinData tindata;
  final VoidCallback onSubmit;

  const CreateInvoiceView({
    super.key,
    required this.dealer,
    required this.tindata,
    required this.onSubmit,
  });

  @override
  State<CreateInvoiceView> createState() => _CreateInvoiceViewState();
}

// 2. Create the State class. This is where all state and logic will live.
class _CreateInvoiceViewState extends State<CreateInvoiceView> {
  // --- STATE VARIABLES ---
  List<Part> _parts = [];
  bool _isLoading = true; // Flag to manage loading state
  String? _errorMessage; // To store any potential error message

  double get totalAmount {
    double total = 0.0;
    for (var part in _parts) {
      if (part.isSelected) {
        total += part.price * part.receivedQty;
      }
    }
    return total;
  }
  // -----------------------

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadParts());
    //_loadParts(); // API integration later
  }

  // --- LOGIC METHODS ---
  /// Fetches the list of returnable items using the reusable 'inquire' function.
  Future<void> _loadParts() async {
    // Set the initial loading state before making the API call
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Use the generic data loading function
    await inquire<Part>(
      context: context,
      dataUrl: 'api/parts/list', // The API endpoint for return items
      onSuccess: (List<Part> data) {
        // If the widget is still mounted, update the state with the fetched data.
        if (mounted) {
          setState(() {
            _parts = data;
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
          });
        }
        showSnackBar(
          context: context,
          message: _errorMessage!,
          type: MessageType.success,
        );
      },
    );
  }

  Widget _buildPartList() {
    // First, check if the data is still loading.
    if (_isLoading) {
      return const Center(child: Text("Loading parts..."));
    }

    // Next, check if an error has occurred.
    if (_errorMessage != null) {
      return const Center(child: Text("No data Found"));
    }

    // If there is no error and loading is complete, show the list.
    return FilterableListView<Part>(
      //items: _parts,
      searchHintText: 'Search by Part No or ID',
      onFilterPressed: () {},
      //dataUrl: 'api/parts/list',
      filterableFields: ['partNo', 'id'],
      columns: [
        DynamicColumn<Part>(
          label: 'Part No',
          flex: 3,
          cellBuilder:
              (context, part) => Text(
                part.partNo,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
        ),
        DynamicColumn<Part>(
          label: 'Request Qty',
          flex: 2,
          cellBuilder:
              (context, part) =>
                  Center(child: Text(part.requestQty.toString())),
        ),
        DynamicColumn<Part>(
          label: 'Select',
          flex: 2,
          cellBuilder:
              (context, part) => Center(
                child: Checkbox(
                  value: part.isSelected,
                  activeColor: AppColors.primary,
                  checkColor: Colors.white,
                  onChanged: (value) => _togglePartSelection(part.id),
                ),
              ),
        ),
        DynamicColumn<Part>(
          label: 'Receive Qty',
          flex: 3,
          cellBuilder:
              (context, part) => QuantitySelector(
                value: part.receivedQty,
                enabled: part.isSelected,
                dialogTitle: 'Delivered Quantity',
                maxQuantity: part.requestQty,
                onChanged: (newValue) {
                  setState(() => part.receivedQty = newValue);
                },
              ),
        ),
      ],
      items: _parts,
    );
  }
  // Simulates loading parts data.
  // void _loadParts() {
  //   _parts = [
  //     Part(id: 'p1', partNo: 'AC2000123230', requestQty: 2, price: 12000.00),
  //     Part(id: 'p2', partNo: 'AC2000123231', requestQty: 5, price: 5500.50),
  //     Part(id: 'p3', partNo: 'AC2000123232', requestQty: 1, price: 8000.00),
  //     Part(id: 'p4', partNo: 'AC2000123342', requestQty: 1, price: 1000.00),
  //     Part(id: 'p5', partNo: 'AC2000123932', requestQty: 6, price: 3000.00),
  //     Part(id: 'p6', partNo: 'AC2000123937', requestQty: 6, price: 300.00),
  //   ];
  // }

  Future<void> _showQuantityDialog(Part part) async {
    // Use your existing, separate QuantityEditDialog class
    final newQuantity = await showDialog<int>(
      context: context,
      builder:
          (context) => QuantityEditDialog(
            initialQuantity: part.receivedQty,
            title: 'Delivered Quantity',
            maxQuantity: part.requestQty, // Or any custom title
          ),
    );

    // If the dialog returned a new value, update the state.
    // The 'mounted' check is a best practice for async operations in stateful widgets.
    if (newQuantity != null && mounted) {
      setState(() {
        part.receivedQty = newQuantity;
      });
    }
  }
  // Toggles the selection of a part.
  // void _togglePartSelection(String partId) {
  //   setState(() {
  //     final part = _parts.firstWhere((p) => p.id == partId);
  //     part.isSelected = !part.isSelected;
  //     if (!part.isSelected) {
  //       part.receivedQty = 0;
  //     }
  //   });
  // }

  Future<void> _togglePartSelection(String partId) async {
    final part = _parts.firstWhere((p) => p.id == partId);

    setState(() {
      part.isSelected = !part.isSelected;
      if (!part.isSelected) {
        part.receivedQty = 0;
      } else {
        // Selected
        part.receivedQty = 1;
      }
    });
    if (part.isSelected) {
      await _showQuantityDialog(part);
    }
  }

  // ---------------------
  @override
  Widget build(BuildContext context) {
    // 1. The root is a Column to separate the body and the fixed footer.
    return Column(
      children: [
        // 2. The body is wrapped in Expanded so it takes up the available space.
        Expanded(
          // 3. A single ListView makes all the content scrollable.
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Your info cards at the top.
              DealerInfoCard(dealer: widget.dealer),
              const SizedBox(height: 12),
              TinInfoDisplay(tinData: widget.tindata),
              const SizedBox(height: 12),
              SizedBox(
                height: 300.0,
                child: _buildPartList(),
              ),
            ],
          ),
        ),

        // 5. The fixed footer section remains outside the Expanded widget.
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTotalAmountSection(totalAmount),
              const SizedBox(height: 16),
              ActionButton(
                icon: Icons.check_circle_outline,
                label: 'Save',
                disabled: totalAmount == 0,
                onPressed: widget.onSubmit,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTotalAmountSection(double totalAmount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Total Amount',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          totalAmount.toStringAsFixed(2),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
