// lib/providers/region_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/region_model.dart'; // Make sure you have this model

// --- Part 1: Define the immutable state class ---
class RegionState {
  final Region? selectedRegion;

  const RegionState({this.selectedRegion});

  // Helper method to create a copy of the state with new values
  RegionState copyWith({
    Region? selectedRegion,
  }) {
    return RegionState(
      selectedRegion: selectedRegion ?? this.selectedRegion,
    );
  }
}

// --- Part 2: Create the StateNotifier ---
class RegionNotifier extends StateNotifier<RegionState> {
  RegionNotifier() : super(const RegionState());

  void setRegion(Region region) {
    state = state.copyWith(selectedRegion: region);
  }

  void clearRegion() {
    state = const RegionState();
  }
}

// --- Part 3: Create the Provider ---
final regionProvider = StateNotifierProvider<RegionNotifier, RegionState>((ref) {
  return RegionNotifier();
});