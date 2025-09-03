import 'dart:async';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart'; // FOR THERMAL PRINTER TEST PRINT
import 'package:esc_pos_utils_plus/src/capability_profile.dart';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/util/snack_bar.dart';
import 'package:myapp/widgets/action_button.dart';
//import 'package:myapp/widgets/app_footer.dart';
import 'package:myapp/widgets/app_page.dart';
import 'package:permission_handler/permission_handler.dart';

class SetupPrintScreen extends StatefulWidget {
  const SetupPrintScreen({super.key});

  @override
  State<SetupPrintScreen> createState() => _SetupPrintScreenState();
}

class _SetupPrintScreenState extends State<SetupPrintScreen> {
  // --- All of your existing state and logic remains exactly the same ---
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  List<ScanResult> _scanResults = [];
  bool _isSearching = false;

  BluetoothDevice? _connectedDevice;
  // ignore: unused_field
  StreamSubscription<BluetoothConnectionState>? _connectionStateSubscription;
  // This characteristic is the "pipe" we will write to
  BluetoothCharacteristic? _targetCharacteristic;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  @override
  void dispose() {
    _stopSearch();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.bluetooth,
      Permission.location,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();
  }

  Future<void> _startSearch() async {
    // ... (Your existing _startSearch logic is unchanged)
    var scanStatus = await Permission.bluetoothScan.status;
    var locationStatus = await Permission.location.status;

    if (!scanStatus.isGranted || !locationStatus.isGranted) {
      final statuses =
          await [Permission.bluetoothScan, Permission.location].request();
      if (!statuses[Permission.bluetoothScan]!.isGranted ||
          !statuses[Permission.location]!.isGranted) {
        if (mounted) {
          showSnackBar(
            context: context,
            message:
                'Bluetooth Scan and Location permissions are required to find devices.',
            type: MessageType.warning,
          );
        }
        return;
      }
    }
    if (await FlutterBluePlus.adapterState.first != BluetoothAdapterState.on) {
      if (mounted) {
        showSnackBar(
          context: context,
          message: 'Please turn on Bluetooth to scan for devices.',
          type: MessageType.warning,
        );
      }
      return;
    }
    setState(() {
      _isSearching = true;
      _scanResults.clear();
    });
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    } catch (e) {
      setState(() => _isSearching = false);
    }
    _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        final existingIds = _scanResults.map((r) => r.device.remoteId).toSet();
        _scanResults.addAll(
          results.where(
            (r) =>
                !existingIds.contains(r.device.remoteId) &&
                r.device.platformName.isNotEmpty,
          ),
        );
      });
    });
    _scanSubscription?.onDone(() => setState(() => _isSearching = false));
  }

  void _stopSearch() {
    // ... (Your existing _stopSearch logic is unchanged)
    FlutterBluePlus.stopScan();
    _scanSubscription?.cancel();
    setState(() {
      _isSearching = false;
    });
  }

  Future<void> _testPrint() async {
    if (_connectedDevice == null || _targetCharacteristic == null) {
      showSnackBar(
        context: context,
        message: 'No printer connected.',
        type: MessageType.warning,
      );
      return;
    }

    // Use the esc_pos_utils_plus package to generate commands
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    bytes += generator.text(
      'Test Print',
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.text(
      'Hello Flutter!',
      styles: const PosStyles(bold: true),
    );
    bytes += generator.text('This is a test from the app.');
    bytes += generator.feed(2);
    bytes += generator.cut();

    try {
      // Write the bytes to the characteristic
      await _targetCharacteristic!.write(bytes, withoutResponse: true);
      showSnackBar(
        context: context,
        message: 'Test print sent!',
        type: MessageType.success,
      );
    } catch (e) {
      showSnackBar(
        context: context,
        message: 'Error sending print data: ${e.toString()}',
        type: MessageType.error,
      );
    }
  }

  // Future<void> _connect(BluetoothDevice device) async {
  //   // ... (Your existing _connect logic is unchanged)
  //   _stopSearch();
  //   print('Connecting to ${device.platformName}');
  // }

  Future<void> _connect(BluetoothDevice device) async {
    _stopSearch();

    // Show a loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text("Connecting to ${device.platformName}..."),
                ],
              ),
            ),
          ),
    );

    // Listen to connection state changes
    _connectionStateSubscription = device.connectionState.listen((state) {
      if (state == BluetoothConnectionState.disconnected) {
        // If the device disconnects, clear our state
        setState(() {
          _connectedDevice = null;
          _targetCharacteristic = null;
        });
        showSnackBar(
          context: context,
          message: '${device.platformName} Disconnected',
          type: MessageType.warning,
        );
      }
    });

    try {
      // 1. Connect to the device
      await device.connect(timeout: const Duration(seconds: 15));

      // 2. Discover services
      List<BluetoothService> services = await device.discoverServices();

      // 3. Find the correct service and characteristic
      BluetoothCharacteristic? characteristic;
      for (BluetoothService service in services) {
        for (BluetoothCharacteristic c in service.characteristics) {
          // Most printers use a characteristic that supports "write without response"
          if (c.properties.writeWithoutResponse) {
            characteristic = c;
            break; // Found it, exit the inner loop
          }
        }
        if (characteristic != null) {
          break; // Found it, exit the outer loop
        }
      }

      // 4. Update state and UI
      Navigator.of(context).pop(); // Close the dialog

      if (characteristic != null) {
        setState(() {
          _connectedDevice = device;
          _targetCharacteristic = characteristic;
        });
        showSnackBar(
          context: context,
          message: 'Connected to ${device.platformName} successfully!',
          type: MessageType.success,
        );
      } else {
        await device.disconnect();
        showSnackBar(
          context: context,
          message: 'Printer service not found on this device.',
          type: MessageType.error,
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close the dialog on error
      showSnackBar(
        context: context,
        message: 'Error connecting: ${e.toString()}',
        type: MessageType.error,
      );
    }
  }

  // 2. The build method is now much simpler
  @override
  Widget build(BuildContext context) {
    // Replace the Scaffold, SafeArea, and manual layout with AppPage
    return AppPage(
      title: 'Bluetooth Devices',
      onBack: () => Navigator.of(context).pop(),
      child: Column(
        children: [
          // This section remains for the text field and its specific button
          // Row(
          //   children: [
          //     Expanded(
          //       child: TextField(
          //         decoration: InputDecoration(
          //           hintText: 'Enter Device ID',
          //           filled: true,
          //           fillColor: Colors.grey[200],
          //           border: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(30),
          //             borderSide: BorderSide.none,
          //           ),
          //           contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          //         ),
          //       ),
          //     ),
          //     const SizedBox(width: 8),
          //     ActionButton(label: 'Connect', onPressed: () {}),
          //   ],
          // ),
          if (_connectedDevice != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Connected to: ${_connectedDevice!.platformName}',
                style: TextStyle(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          const SizedBox(height: 16),

          ActionButton(
            icon: Icons.print,
            label: 'Test Print',
            color: AppColors.success,
            onPressed: _testPrint,
          ),
          const SizedBox(height: 12),
          _isSearching
              ? ActionButton(
                icon: Icons.stop_circle,
                label: 'Stop Searching',
                color: AppColors.danger,
                onPressed: _stopSearch,
              )
              : ActionButton(
                icon: Icons.bluetooth_searching,
                label: 'Search Bluetooth Devices',
                color: AppColors.primary,
                onPressed: _startSearch,
              ),
          const SizedBox(height: 16),
          const Divider(height: 1),

          // Discovered devices list
          Expanded(
            child:
                _scanResults.isEmpty && _isSearching
                    ? const Center(child: CircularProgressIndicator())
                    : _scanResults.isEmpty
                    ? const Center(child: Text('No devices found.'))
                    : ListView.builder(
                      itemCount: _scanResults.length,
                      itemBuilder: (context, index) {
                        final result = _scanResults[index];
                        return ListTile(
                          title: Text(result.device.platformName),
                          subtitle: Text(result.device.remoteId.toString()),
                          onTap: () => _connect(result.device),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
