// Dummy API for Now

import 'dart:convert';

import 'package:myapp/contracts/mappable.dart';
import 'package:myapp/models/reciept_model.dart';
import 'package:myapp/services/dummy_data.dart';

// class MockApiService {
//   static Future<List<T>> fetchData<T extends Mappable>(String url) async {
//     // Simulate network delay
//     await Future.delayed(const Duration(milliseconds: 2000));

//     List<T> data;

//     if (url == 'api/dealers/list') {
//       data = DummyData.dealers as List<T>;
//     } else if (url == 'api/references/list') {
//       data = DummyData.references as List<T>;
//     } else if (url == 'api/invoices/list') {
//       data = DummyData.invoices as List<T>;
//     } else if (url == 'api/tins/list') {
//       data = DummyData.tins as List<T>;
//     } else if (url == 'api/regions/list') {
//       data = DummyData.regions as List<T>;
//     } 
//     else if (url == 'api/parts/list') {
//       data = DummyData.parts as List<T>;
//     } else if (url == 'api/return-items/list') {
//       data = DummyData.returnItems as List<T>;
//     }
//     else {
//       // If the URL is not recognized, throw an exception
//       throw Exception('Invalid API URL: $url');
//     }

//     // If data is empty after checking all valid URLs, throw an exception
//     if (data.isEmpty) {
//       throw Exception('No data found for URL: $url');
//     }

//     return data;
//   }
// }
class MockApiService {
  static final List<Receipt> _sessionReceipts = [];

  static Future<void> postData<T extends Mappable>(String dataUrl, T data) async {
    
    await Future.delayed(const Duration(seconds: 1)); // Simulate network latency

    switch (dataUrl) {
      case 'api/receipts/save':
        // Specific logic for saving receipts
        if (data is Receipt) {
          final isDuplicate = _sessionReceipts.any((existingReceipt) =>
              existingReceipt.dealerCode == data.dealerCode &&
              existingReceipt.bankCode == data.bankCode &&
              existingReceipt.chequeNumber == data.chequeNumber);

          if (isDuplicate) {
            throw Exception(
                'This cheque number already exists for the selected dealer and bank.');
          } else {
            _sessionReceipts.add(data);
           // print('Receipt saved successfully to session. Total receipts: ${_sessionReceipts.length}');
          }
        } else {
          throw Exception('Data for receipts/save endpoint must be a Receipt type.');
        }
        break;
      default:
        // Default behavior for other URLs (e.g., just log and pretend to save)
        //print('Generic save for $dataUrl: ${data.toMap()}');
        // If you need to actually store other types generically, you'd need
        // more generic session storage (e.g., Map<String, List<Mappable>>)
        break;
    }
  }

  static Future<List<T>> fetchData<T extends Mappable>(String url) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    final uri = Uri.parse(url);
    final path = uri.path;
    final params = uri.queryParameters;

    List<Mappable> sourceData; // Use Mappable to access .toMap()

   switch (path) {
      case 'api/dealers/list':
        sourceData = DummyData.dealers;
        break;
      case 'api/references/list':
        sourceData = DummyData.references;
        break;
      case 'api/invoices/list':
        sourceData = DummyData.invoices;
        break;
      case 'api/tins/list':
        sourceData = DummyData.tins;
        break;
      case 'api/regions/list':
        sourceData = DummyData.regions;
        break;
      case 'api/parts/list':
        sourceData = DummyData.parts;
        break;
      case 'api/return-items/list':
        sourceData = DummyData.returnItems;
        break;
      case 'api/branch/list':
        sourceData = DummyData.branches;
        break;
      case 'api/bank/list':
        sourceData = DummyData.banks;
        break;
      // If the path doesn't match any known endpoint, throw an exception
      default:
        throw Exception('Invalid API URL Path: $path');
    }

    // --- NEW GENERIC FILTERING LOGIC ---
    if (params.containsKey('filters')) {
      final filterJson = params['filters']!;
      final conditions = (jsonDecode(filterJson) as List).cast<List<dynamic>>();

      sourceData = sourceData.where((item) {
        final itemMap = item.toMap();

        // The item must satisfy ALL conditions (.every)
        return conditions.every((condition) {
          if (condition.length != 3) return false; // Malformed condition

          final String field = condition[0];
          final String operator = condition[1];
          final dynamic value = condition[2];

          if (!itemMap.containsKey(field)) return false;

          final itemValue = itemMap[field];

          // Compare values as strings for simplicity and type safety
          switch (operator) {
            case '=':
              return itemValue.toString().toLowerCase() == value.toString().toLowerCase();
            case '!=':
              return itemValue.toString().toLowerCase() != value.toString().toLowerCase();
            // add more operators here 
            default:
              return false; // Unsupported operator
          }
        });
      }).toList();
    }

    if (sourceData.isEmpty) {
      throw Exception('No data found.');
    }
    return sourceData.cast<T>();
  }


  // THIS IS SIMILAR TO SP CALL 
  static Future<void> postReceipt(Receipt dataToSave) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network latency

    // 2. DUPLICATE CHECK
    final isDuplicate = _sessionReceipts.any((existingReceipt) =>
        existingReceipt.dealerCode == dataToSave.dealerCode &&
        existingReceipt.bankCode == dataToSave.bankCode &&
        existingReceipt.chequeNumber == dataToSave.chequeNumber);

    if (isDuplicate) {
      // 3. Deny the save and throw an error if a duplicate is found
      throw Exception(
          'Duplicate Error: This cheque number already exists for the selected dealer and bank.');
    } else {
      // 4. Otherwise, save the data to the session
      _sessionReceipts.add(dataToSave);
    }
  }

  
}