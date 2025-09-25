import 'package:flutter/material.dart';
import 'package:myapp/models/region_model.dart';
import 'package:myapp/widgets/app_action_button.dart';
import 'package:myapp/widgets/app_helper_field.dart';

// Region Selection View
class SelectRegionView extends StatefulWidget {
  final Function(Region) onRegionSelected;
  final VoidCallback onSubmit;
  final Region? selectedRegion;

  const SelectRegionView({
    super.key,
    required this.onRegionSelected,
    required this.onSubmit,
    this.selectedRegion,
  });

  @override
  State<SelectRegionView> createState() => _SelectRegionViewState();
}

class _SelectRegionViewState extends State<SelectRegionView> {
  final TextEditingController _RegionController = TextEditingController();
  bool _isRegionSelectionCommitted = false;

  @override
  void initState() {
    super.initState();
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
            onSelected: widget.onRegionSelected,
            onCommitStateChanged: (isCommitted) {
              setState(() {
                _isRegionSelectionCommitted = isCommitted;
              });
            },
            showHelperOnInitialization: true,
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
