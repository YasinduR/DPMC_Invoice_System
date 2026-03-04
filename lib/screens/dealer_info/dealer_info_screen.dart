import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/models/region_model.dart';
import 'package:myapp/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/providers/region_provider.dart';
import 'package:myapp/views/region_selection_view.dart';
import 'package:myapp/views/select_dealer_view.dart';
import 'package:myapp/widgets/app_page.dart';
import 'package:myapp/widgets/app_snack_bars.dart';

class DealerInfoScreen extends ConsumerStatefulWidget {
  const DealerInfoScreen({super.key});

  @override
  ConsumerState<DealerInfoScreen> createState() => _DealerInfoScreenState();
}

class _DealerInfoScreenState extends ConsumerState<DealerInfoScreen> {
  int _currentStep = 0;

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
        _currentStep = 0; // Move to the initial
      });
    }
  }

  void _onRegionSelectionRequested() {
    setState(() {
      _currentStep = -1; // Move to Region selection step
    });
  }

  // Dealer Selection
  Dealer? _selectedDealer;

  void _onDealerSelected(Dealer dealer) {
    setState(() {
      _selectedDealer = dealer;
      if (_selectedDealer != null) {
        _currentStep = 1; // Move to dealer info display
      }
    });
  }

  String? _capitalize(String? text) {
    if (text == null || text.isEmpty) return null;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
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
    final String currentTitle;

    switch (_currentStep) {
      case -1:
        currentTitle = 'Select Region';
        currentView = SelectRegionView(
          selectedRegion: selectedRegion,
          onRegionSelected: _onRegionSelected,
          onSubmit: _submitRegion,
        );
        break;
      case 0:
        currentTitle = 'Select Dealer';
        currentView = SelectDealerView(
          selectedRegion: selectedRegion,
          selectedDealer: null,
          onDealerSelected: _onDealerSelected,
          onRegionSelectionRequested: _onRegionSelectionRequested,
        );
        break;
      case 1:
        currentTitle = 'Dealer Info';
        currentView = _buildDealerInfo(selectedRegion);
        break;
      default:
        currentTitle = 'Error';
        currentView = const Center(child: Text('Error'));
    }

    return AppPage(
      title: currentTitle,
      onBack: _goBack,
      contentPadding: EdgeInsets.zero,
      child: currentView,
    );
  }

  Widget _buildDealerInfo(Region? selectedRegion) {
    final dealer = _selectedDealer;
    if (dealer == null) {
      return const Center(child: Text('No dealer selected.'));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoTile(
                      icon: Icons.store,
                      label: 'Dealer Name',
                      value: _capitalize(dealer.name) ?? 'N/A',
                    ),
                    const Divider(),
                    _buildInfoTile(
                      icon: Icons.person,
                      label: 'Surname',
                      value: _capitalize(dealer.surname) ?? 'N/A',
                    ),
                    const Divider(),
                    _buildInfoTile(
                      icon: Icons.badge,
                      label: 'Account Code',
                      value: dealer.accountCode,
                    ),
                    const Divider(),
                    _buildInfoTile(
                      icon: Icons.location_on,
                      label: 'Address',
                      value: '${dealer.address}, ${dealer.city}',
                      maxLinesValue: 2,
                    ),
                    const Divider(),
                    _buildInfoTile(
                      icon: Icons.map,
                      label: 'Region',
                      value: _capitalize(dealer.region) ?? 'N/A',
                    ),
                    const Divider(),
                    _buildInfoTile(
                      icon: Icons.receipt,
                      label: 'VAT No',
                      value: dealer.vatNo,
                    ),
                    const Divider(),
                    _buildInfoTile(
                      icon: Icons.account_balance,
                      label: 'Bank Guarantee',
                      value: dealer.hasBankGuarantee ? 'Yes' : 'No',
                    ),
                    if (selectedRegion != null) ... [
                      const Divider(),
                      _buildInfoTile(
                        icon: Icons.my_location,
                        label: 'Selected Region',
                        value: _capitalize(selectedRegion.region) ?? '',
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedDealer = null;
                    _currentStep = 0; // Go back to dealer selection
                  });
                },
                icon: const Icon(Icons.swap_horiz),
                label: const Text('Change Dealer'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    int? maxLinesValue,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.textFaded,
        ),
      ),
      subtitle: AutoSizeText(
        value,
        minFontSize: 8,
        maxLines: maxLinesValue ?? 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.text,
        ),
      ),
    );
  }
}



