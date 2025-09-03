import 'package:flutter/material.dart';
import 'package:myapp/models/region_model.dart';
import 'package:myapp/widgets/action_button.dart';
import 'package:myapp/widgets/app_help_text_field.dart';

class SelectRegionView extends StatefulWidget {
  //final List<Region> Regions;
  final Function(Region) onRegionSelected;
  final VoidCallback onSubmit;
  final Region? selectedRegion;

  const SelectRegionView({
    super.key,
    //required this.Regions,
    required this.onRegionSelected,
    required this.onSubmit,
    this.selectedRegion,
  });

  @override
  State<SelectRegionView> createState() => _SelectRegionViewState();
}

class _SelectRegionViewState extends State<SelectRegionView> {
  final TextEditingController _RegionController = TextEditingController();
  // 1. This is the only state we need to track now.
  bool _isRegionSelectionCommitted = false;

  @override
  void initState() {
    super.initState();
    // If a Region is pre-selected, the state is initially valid.
    if (widget.selectedRegion != null) {
      _RegionController.text = widget.selectedRegion!.region;
      _isRegionSelectionCommitted = true;
    }
  }

  @override
  void dispose() {
    _RegionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSelectionField<Region>(
            controller: _RegionController,
            labelText: 'Select Region',
            selectionSheetTitle: 'Select a Region',
            initialValue: widget.selectedRegion,

            //items: widget.Regions,
            onSelected: widget.onRegionSelected,
            //displayString: (Region) => Region.name,
            onCommitStateChanged: (isCommitted) {
              setState(() {
                _isRegionSelectionCommitted = isCommitted;
              });
            },
            displayNames: const ['Region'],
            valueFields: const ['region'],
            mainField: 'region',
            dataUrl: 'api/regions/list',
          ),
          const Spacer(),
          ActionButton(
            icon: Icons.check_circle_outline,
            label: 'Submit',
            onPressed: widget.onSubmit,
            disabled: !_isRegionSelectionCommitted,
          ),
        ],
      ),
    );
  }
}
