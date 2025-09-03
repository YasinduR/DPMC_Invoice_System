// Dummy API for Now

import 'dart:convert';

import 'package:myapp/contracts/mappable.dart';
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
}