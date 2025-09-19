import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/region_model.dart';
import 'package:myapp/providers/region_provider.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:myapp/views/region_selection_view.dart';
import 'package:myapp/widgets/app_page.dart';

class RouteSelectionScreen extends ConsumerStatefulWidget {
  const RouteSelectionScreen({super.key});

  @override
  ConsumerState<RouteSelectionScreen> createState() =>
      _RouteSelectionScreenState();
}

class _RouteSelectionScreenState extends ConsumerState<RouteSelectionScreen> {
  int _currentStep = 0;
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
      // Example: Navigate back after selection
      Navigator.of(context).pop();
    }
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
    final prevSelectedRegion = ref.watch(regionProvider).selectedRegion;
    Widget currentView;
    switch (_currentStep) {
      case 0:
        currentView = SelectRegionView(
          //Regions: _Regions,
          selectedRegion: _selectedRegion ?? prevSelectedRegion,
          onRegionSelected: _onRegionSelected,
          onSubmit: _submitRegion, // Pass submit callback
        );
        break;
      default:
        currentView = const Center(child: Text('Error'));
    }
    final String currentTitle;
    switch (_currentStep) {
      case 0:
        currentTitle = 'Select Region';
        break;
      default:
        currentTitle = 'Error';
    }

    return AppPage(
      title: currentTitle,
      onBack: _goBack, // Pass our custom back logic for the multi-step flow.
      contentPadding: EdgeInsets.zero,
      child: currentView,
    );
  }

  
}
