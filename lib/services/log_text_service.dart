import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:myapp/widgets/app_snack_bars.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// Message type enum for snackbar styling

class LogTextService {
  // Singleton pattern
  static final LogTextService _instance = LogTextService._internal();
  factory LogTextService() => _instance;
  LogTextService._internal();

  // Track if storage is available
  static bool _isStorageAvailable = false;
  static String? _dpmcFolderPath;

  // Initialize storage (call this once when app starts)
  static Future<bool> initialize() async {
    // First, request permissions based on Android version
    final bool hasPermission = await _requestStoragePermissions();

    if (hasPermission) {
      _isStorageAvailable = true;
      // Create dpmc folder if it doesn't exist
      await _createDpmcFolder();
      return true;
    } else {
      _isStorageAvailable = false;
      return false;
    }
  }

  // Request appropriate storage permissions based on Android version
  static Future<bool> _requestStoragePermissions() async {
    //if (Platform.isAndroid) {
    //final androidInfo = await _getAndroidVersion();

    // For Android 11+ (API 30+), we need MANAGE_EXTERNAL_STORAGE for root access
    //if (androidInfo.version.sdkInt >= 30) {
    // Check if we already have permission
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    }

    // Request MANAGE_EXTERNAL_STORAGE permission
    final status = await Permission.manageExternalStorage.request();
    return status.isGranted;
    //}
    // For Android 10 and below (API 29-)
    // else {
    //   // Check if we already have permission
    //   if (await Permission.storage.isGranted) {
    //     return true;
    //   }

    //   // Request WRITE_EXTERNAL_STORAGE permission
    //   final status = await Permission.storage.request();
    //   return status.isGranted;
    // }
    //}
    //return false; // Non-Android platforms
  }

  // Create dpmc folder at root
  static Future<void> _createDpmcFolder() async {
    try {
      // Root path for internal storage
      const rootPath = '/storage/emulated/0';
      _dpmcFolderPath = '$rootPath/DPMC';

      final dpmcFolder = Directory(_dpmcFolderPath!);

      if (!await dpmcFolder.exists()) {
        await dpmcFolder.create(recursive: true);
      }
    } catch (e) {
      _isStorageAvailable = false;
    }
  }

  // Check if storage is available
  static bool get isStorageAvailable => _isStorageAvailable;

  // Get dpmc folder path
  static String? get dpmcFolderPath => _dpmcFolderPath;

  // Save file to dpmc folder with SnackBar feedback
  static Future<void> saveFile({
    required String fileName,
    required String content,
    required BuildContext context,
  }) async {
    try {
      // Show loading indicator
      // Check if storage is initialized
      if (!_isStorageAvailable) {
        // Try to initialize again
        final initialized = await initialize();
        if (!initialized) {
          String errorPerm = 'Storage permission denied';
          showSnackBar(
            context: context,
            message: errorPerm,
            type: MessageType.error,
          );
          return;
        }
      }

      // Check if folder path exists
      if (_dpmcFolderPath == null) {
        await _createDpmcFolder();
        if (_dpmcFolderPath == null) {
          showSnackBar(
            context: context,
            message: 'Could not create dpmc folder',
            type: MessageType.error,
          );
          return;
        }
      }

      // Create full file path
      final String path = '$_dpmcFolderPath/$fileName';
      final File file = File(path);

      // Write content
      await file.writeAsString(content);

      // Verify file
      if (await file.exists()) {
        // final fileSize = await file.length();

        showSnackBar(
          context: context,
          message: 'File saved to /dpmc/$fileName',
          type: MessageType.success,
        );
      } else {
        showSnackBar(
          context: context,
          message: 'File verification failed',
          type: MessageType.error,
        );
      }
    } catch (e) {
      showSnackBar(
        context: context,
        message: 'Error: ${_getUserFriendlyError(e)}',
        type: MessageType.error,
      );
    }
  }

  // Save file with custom options
  static Future<void> saveFileWithOptions({
    required String fileName,
    required String content,
    required BuildContext context,
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) async {
    try {
      // Check storage
      if (!_isStorageAvailable) {
        final initialized = await initialize();
        if (!initialized) {
          showSnackBar(
            context: context,
            message: 'Storage permission denied',
            type: MessageType.error,
          );
          onError?.call();
          return;
        }
      }

      // Ensure folder exists
      if (_dpmcFolderPath == null) {
        await _createDpmcFolder();
        if (_dpmcFolderPath == null) {
          showSnackBar(
            context: context,
            message: 'Could not create dpmc folder',
            type: MessageType.error,
          );
          onError?.call();
          return;
        }
      }

      // Save file
      final path = '$_dpmcFolderPath/$fileName';
      final file = File(path);
      await file.writeAsString(content);

      // Verify
      if (await file.exists()) {
        final size = await file.length();

        showSnackBar(
          context: context,
          message: '✅ Saved to /dpmc/',
          type: MessageType.success,
        );
        onSuccess?.call();
      } else {
        showSnackBar(
          context: context,
          message: 'Save failed',
          type: MessageType.error,
        );
        onError?.call();
      }
    } catch (e) {
      showSnackBar(
        context: context,
        message: '${_getUserFriendlyError(e)}',
        type: MessageType.error,
      );
      onError?.call();
    }
  }

  // Check if dpmc folder exists and is accessible
  static Future<bool> checkDpmcFolder() async {
    try {
      if (_dpmcFolderPath == null) return false;

      final folder = Directory(_dpmcFolderPath!);
      return await folder.exists();
    } catch (e) {
      return false;
    }
  }

  // List all files in dpmc folder
  static Future<List<FileSystemEntity>> listFiles() async {
    try {
      if (_dpmcFolderPath == null) return [];

      final folder = Directory(_dpmcFolderPath!);
      if (!await folder.exists()) return [];

      return await folder.list().toList();
    } catch (e) {
      print('Error listing files: $e');
      return [];
    }
  }

  // Delete a file from dpmc folder
  static Future<void> deleteFile({
    required String fileName,
    required BuildContext context,
  }) async {
    try {
      if (_dpmcFolderPath == null) {
        showSnackBar(
          context: context,
          message: 'dpmc folder not found',
          type: MessageType.error,
        );
        return;
      }

      final file = File('$_dpmcFolderPath/$fileName');
      if (await file.exists()) {
        await file.delete();
        showSnackBar(
          context: context,
          message: 'Deleted: $fileName',
          type: MessageType.success,
        );
      } else {
        showSnackBar(
          context: context,
          message: 'File not found: $fileName',
          type: MessageType.warning,
        );
      }
    } catch (e) {
      showSnackBar(
        context: context,
        message: 'Error deleting: ${_getUserFriendlyError(e)}',
        type: MessageType.error,
      );
    }
  }

  // Get user-friendly error message
  static String _getUserFriendlyError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    String errorPerm =
        'Storage permission denied. Please grant "Allow all files access" in settings.';
    if (errorString.contains('permission') || errorString.contains('denied')) {
      return errorPerm;
    } else if (errorString.contains('space') || errorString.contains('full')) {
      return 'Insufficient storage space';
    } else if (errorString.contains('not found') ||
        errorString.contains('no such')) {
      return 'File or folder not found';
    } else {
      return error.toString();
    }
  }

  // Open app settings
  static Future<void> openSettings() async {
    await openAppSettings();
  }
}


// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// class LogTextService {
//   // Singleton pattern
//   static final LogTextService _instance = LogTextService._internal();
//   factory LogTextService() => _instance;
//   LogTextService._internal();

//   // Track if storage is available
//   static bool _isStorageAvailable = false;
//   static String? _dpmcFolderPath;

//   // Initialize storage (call this once when app starts)
//   static Future<bool> initialize() async {
//     // First, request permissions based on Android version
//     final bool hasPermission = await _requestStoragePermissions();

//     if (hasPermission) {
//       _isStorageAvailable = true;
//       // Create dpmc folder if it doesn't exist
//       await _createDpmcFolder();
//       return true;
//     } else {
//       _isStorageAvailable = false;
//       return false;
//     }
//   }

//   // Request appropriate storage permissions based on Android version
//   static Future<bool> _requestStoragePermissions() async {
//     if (Platform.isAndroid) {
//       final androidInfo = await _getAndroidVersion();
      
//       // For Android 11+ (API 30+), we need MANAGE_EXTERNAL_STORAGE for root access
//       if (androidInfo.version.sdkInt >= 30) {
//         // Check if we already have permission
//         if (await Permission.manageExternalStorage.isGranted) {
//           return true;
//         }
        
//         // Request MANAGE_EXTERNAL_STORAGE permission
//         final status = await Permission.manageExternalStorage.request();
//         return status.isGranted;
//       } 
//       // For Android 10 and below (API 29-)
//       else {
//         // Check if we already have permission
//         if (await Permission.storage.isGranted) {
//           return true;
//         }
        
//         // Request WRITE_EXTERNAL_STORAGE permission
//         final status = await Permission.storage.request();
//         return status.isGranted;
//       }
//     }
//     return false; // Non-Android platforms
//   }

//   // Create dpmc folder at root
//   static Future<void> _createDpmcFolder() async {
//     try {
//       // Root path for internal storage
//       const rootPath = '/storage/emulated/0';
//       _dpmcFolderPath = '$rootPath/dpmc';
      
//       final dpmcFolder = Directory(_dpmcFolderPath!);
      
//       if (!await dpmcFolder.exists()) {
//         await dpmcFolder.create(recursive: true);
//         print('📁 Created dpmc folder at: $_dpmcFolderPath');
//       } else {
//         print('📁 dpmc folder already exists at: $_dpmcFolderPath');
//       }
//     } catch (e) {
//       print('❌ Error creating dpmc folder: $e');
//       _isStorageAvailable = false;
//     }
//   }

//   // Check if storage is available
//   static bool get isStorageAvailable => _isStorageAvailable;

//   // Get dpmc folder path
//   static String? get dpmcFolderPath => _dpmcFolderPath;

//   // Save file to dpmc folder (with permission check)
//   static Future<SaveResult> saveFile({
//     required String fileName,
//     required String content,
//     BuildContext? context,
//   }) async {
//     try {
//       // Check if storage is initialized
//       if (!_isStorageAvailable) {
//         // Try to initialize again
//         final initialized = await initialize();
//         if (!initialized) {
//           return SaveResult(
//             success: false,
//             message: 'Storage permission not granted',
//             errorType: SaveErrorType.permissionDenied,
//           );
//         }
//       }

//       // Check if folder path exists
//       if (_dpmcFolderPath == null) {
//         await _createDpmcFolder();
//         if (_dpmcFolderPath == null) {
//           return SaveResult(
//             success: false,
//             message: 'Could not create dpmc folder',
//             errorType: SaveErrorType.folderCreationFailed,
//           );
//         }
//       }

//       // Create full file path
//       final String path = '$_dpmcFolderPath/$fileName';
//       final File file = File(path);

//       // Write content
//       await file.writeAsString(content);

//       // Verify file
//       if (await file.exists()) {
//         final fileSize = await file.length();
        
//         return SaveResult(
//           success: true,
//           message: 'File saved successfully',
//           filePath: path,
//           fileSize: fileSize,
//           errorType: null,
//         );
//       } else {
//         return SaveResult(
//           success: false,
//           message: 'File verification failed',
//           errorType: SaveErrorType.writeFailed,
//         );
//       }
//     } catch (e) {
//       return SaveResult(
//         success: false,
//         message: 'Error saving file: $e',
//         errorType: SaveErrorType.unknown,
//         exception: e,
//       );
//     }
//   }

//   // Check if dpmc folder exists and is accessible
//   static Future<bool> checkDpmcFolder() async {
//     try {
//       if (_dpmcFolderPath == null) return false;
      
//       final folder = Directory(_dpmcFolderPath!);
//       return await folder.exists();
//     } catch (e) {
//       return false;
//     }
//   }

//   // List all files in dpmc folder
//   static Future<List<FileSystemEntity>> listFiles() async {
//     try {
//       if (_dpmcFolderPath == null) return [];
      
//       final folder = Directory(_dpmcFolderPath!);
//       if (!await folder.exists()) return [];
      
//       return await folder.list().toList();
//     } catch (e) {
//       print('Error listing files: $e');
//       return [];
//     }
//   }

//   // Delete a file from dpmc folder
//   static Future<bool> deleteFile(String fileName) async {
//     try {
//       if (_dpmcFolderPath == null) return false;
      
//       final file = File('$_dpmcFolderPath/$fileName');
//       if (await file.exists()) {
//         await file.delete();
//         return true;
//       }
//       return false;
//     } catch (e) {
//       print('Error deleting file: $e');
//       return false;
//     }
//   }

//   // Helper to get Android version
//   static Future<AndroidDeviceInfo> _getAndroidVersion() async {
//     // You need to add device_info_plus package
//     final deviceInfo = DeviceInfoPlugin();
//     return await deviceInfo.androidInfo;
//   }
// }

// // Result class for save operations
// class SaveResult {
//   final bool success;
//   final String message;
//   final String? filePath;
//   final int? fileSize;
//   final SaveErrorType? errorType;
//   final dynamic exception;

//   SaveResult({
//     required this.success,
//     required this.message,
//     this.filePath,
//     this.fileSize,
//     this.errorType,
//     this.exception,
//   });

//   @override
//   String toString() {
//     return 'SaveResult(success: $success, message: $message, path: $filePath)';
//   }
// }

// // Error types for better handling
// enum SaveErrorType {
//   permissionDenied,
//   folderCreationFailed,
//   writeFailed,
//   unknown,
// }

// // Extension for user-friendly messages
// extension SaveErrorTypeExtension on SaveErrorType {
//   String get userFriendlyMessage {
//     switch (this) {
//       case SaveErrorType.permissionDenied:
//         return 'Storage permission denied. Please grant permission to save files.';
//       case SaveErrorType.folderCreationFailed:
//         return 'Could not create dpmc folder. Please check storage access.';
//       case SaveErrorType.writeFailed:
//         return 'Failed to write file. Please check available storage space.';
//       case SaveErrorType.unknown:
//         return 'An unexpected error occurred while saving.';
//     }
//   }
// }














// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:myapp/widgets/app_snack_bars.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:file_picker/file_picker.dart';

// class LogTextService {
//   // Function to save a text file
//   // Future<void> saveFileToAppPrivateDir(String fileName, String content) async {
//   //   try {
//   //     // Get the app's documents directory (private to the app)
//   //     final Directory appDocsDir = await getApplicationDocumentsDirectory();

//   //     // Create a reference to the file
//   //     final File file = File('${appDocsDir.path}/$fileName');

//   //     // Write the content to the file
//   //     await file.writeAsString(content);

//   //     print('File saved to ${file.path}');
//   //   } catch (e) {
//   //     print('Error saving file: $e');
//   //   }
//   // }

//   // Future<void> saveFile(String fileName, String content) async {
//   //   // Let user pick save location
//   //   String? outputFile = await FilePicker.platform.saveFile(
//   //     dialogTitle: 'Save your file',
//   //     fileName: fileName,
//   //     bytes: Uint8List.fromList(content.codeUnits),
//   //   );
//   //   if (outputFile != null) {
//   //     print('File saved to: $outputFile');

//   //   }else{
//   //         showSnackBar(
//   //         context: context,
//   //         message: 'Failed to save',
//   //         type: MessageType.warning,
//   //       );
//   // }
//   // }

//   // Function to save a text file with user picker
//   // Future<void> saveFile({
//   //   required String fileName,
//   //   required String content,
//   //   required BuildContext context,
//   // }) async {
//   //   try {
//   //     // Show loading indicator

//   //     // Let user pick save location
//   //     String? outputFile = await FilePicker.platform.saveFile(
//   //       dialogTitle: 'Save your file',
//   //       fileName: fileName,
//   //       bytes: Uint8List.fromList(content.codeUnits),
//   //       allowedExtensions: ['txt', 'log'],
//   //       type: FileType.custom,
//   //     );

//   //     // Check if file was saved successfully
//   //     if (outputFile != null) {
//   //       // Verify file was actually written
//   //       final File savedFile = File(outputFile);
//   //       if (await savedFile.exists()) {
//   //         final fileSize = await savedFile.length();

//   //         print('File saved successfully to: $outputFile');
//   //         print('File size: $fileSize bytes');

//   //         // Show success message
//   //         showSnackBar(
//   //           context: context,
//   //           message: 'File saved successfully!',
//   //           type: MessageType.success,
//   //         );

//   //       } else {
//   //                   showSnackBar(
//   //           context: context,
//   //           message: 'File saving failed!',
//   //           type: MessageType.error,
//   //         );
//   //       }
//   //     } else {

//   //       showSnackBar(
//   //         context: context,
//   //         message: 'Save cancelled',
//   //         type: MessageType.warning,
//   //       );
//   //     }
//   //   } catch (e) {
//   //     // Handle any errors that occurred during the process
//   //     print('Error saving file: $e');

//   //     // Show error message to user
//   //     showSnackBar(
//   //       context: context,
//   //       message: 'Error saving file: ${_getUserFriendlyError(e)}',
//   //       type: MessageType.error,
//   //     );
//   //   }
//   // }

//   Future<void> saveFile({
//     required String fileName,
//     required String content,
//     required BuildContext context,
//   }) async {
//     try {
//       // Get external storage directory
//       final directory = await getExternalStorageDirectory();

//       if (directory == null) {
//         showSnackBar(
//           context: context,
//           message: 'Error locating the folder',
//           type: MessageType.error,
//         );
//       } else {
//         // Create full file path
//         final String path = "${directory.path}/$fileName";

//         // Write file
//         final File file = File(path);
//         await file.writeAsString(content);

//         // Verify file
//         if (await file.exists()) {
//           showSnackBar(
//             context: context,
//             message: 'File saved successfully!',
//             type: MessageType.success,
//           );
//         } else {
//           showSnackBar(
//             context: context,
//             message: 'File saving failed!',
//             type: MessageType.error,
//           );
//         }
//       }
//     } catch (e) {
//       showSnackBar(
//         context: context,
//         message: 'Error saving file: ${_getUserFriendlyError(e)}',
//         type: MessageType.error,
//       );
//     }
//   }

//   // Convert technical errors to user-friendly messages
//   String _getUserFriendlyError(dynamic error) {
//     if (error.toString().contains('permission')) {
//       return 'Storage permission denied';
//     } else if (error.toString().contains('space')) {
//       return 'Insufficient storage space';
//     } else if (error.toString().contains('not found')) {
//       return 'Save location not accessible';
//     } else {
//       return 'Error: ${error.toString()}';
//     }
//   }
// }

// Example usage:
// await saveFileToAppPrivateDir('my_notes.txt', 'This is the text for my file.');
