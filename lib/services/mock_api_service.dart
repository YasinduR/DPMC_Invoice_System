import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:myapp/contracts/mappable.dart';
import 'package:myapp/exceptions/app_exceptions.dart';
import 'package:myapp/models/attendance_model.dart';
import 'package:myapp/models/reciept_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/services/dummy_data.dart';

import 'package:bcrypt/bcrypt.dart';

//// IMPORTANT :  This works as the Back-End remove later

class MockApiService {
  static Future<List<T>> get<T extends Mappable>(String url) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final uri = Uri.parse(url);
    if (!uri.path.endsWith('/list')) {
      throw Exception('Invalid GET URL. Must end with "/list".');
    }

    List<Mappable> sourceData;

    switch (uri.path) {
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
      case 'api/tin-invoices/list':
        sourceData = DummyData.tinInvoices;
        break;
      case 'api/roles/list':
        sourceData = DummyData.roles;
      case 'api/screens/list':
        sourceData = DummyData.screens;
        break;
      default:
        throw Exception('Invalid API URL Path: $uri.path');
    }

    if (uri.queryParameters.containsKey('filters')) {
      final filterJson = uri.queryParameters['filters']!;
      final conditions = (jsonDecode(filterJson) as List).cast<List<dynamic>>();

      sourceData =
          sourceData.where((item) {
            final itemMap = item.toMap();

            return conditions.every((condition) {
              if (condition.length != 3) return false;

              final String field = condition[0];
              final String operator = condition[1];
              final dynamic value = condition[2];

              if (!itemMap.containsKey(field)) return false;

              final itemValue = itemMap[field];

              switch (operator) {
                case '=':
                  return itemValue.toString().toLowerCase() ==
                      value.toString().toLowerCase();
                case '!=':
                  return itemValue.toString().toLowerCase() !=
                      value.toString().toLowerCase();
                default:
                  return false;
              }
            });
          }).toList();
    }

    if (sourceData.isEmpty) {
      throw Exception('No data found.');
    }
    return sourceData.cast<T>();
  }

  static Future<dynamic> post(String url, {dynamic body}) async {
    await Future.delayed(const Duration(seconds: 1));

    switch (url) {
      case 'api/permission/check':
        final String screenId = body['screenId'] as String;
        final List<String> roleIds = (body['roleIds'] as List).cast<String>();
        final hasPermission = DummyData.perms.any((perm) {
          final isScreenMatch = perm.ScreenId == screenId;
          final isRoleMatch = roleIds.contains(perm.RoleId);
          return isScreenMatch && isRoleMatch;
        });
        return hasPermission;

      case 'api/dealer/login':
        if (body is! Map<String, dynamic>) {
          throw Exception('Invalid payload for dealer login.');
        }
        final dealerCode = body['dealerCode'];
        final pin = body['pin'];

        final dealer = DummyData.dealers.firstWhereOrNull(
          (d) => d.accountCode == dealerCode,
        );

        if (dealer == null) {
          throw UnauthorisedException('Invalid Dealer Code or PIN.');
        }
        if (dealer.isLocked) {
          throw AccountLockedException(
            'Dealer account is locked. Please contact support.',
          );
        }

        if (dealer.pin == pin) {
          dealer.incPins = 0;
          dealer.isLocked = false;
          return true;
        } else {
          dealer.incPins++;

          if (dealer.incPins >= 3) {
            dealer.isLocked = true;
            throw AccountLockedException(
              'Invalid Dealer Code or PIN. Account has been locked due to too many incorrect attempts.',
            );
          } else {
            throw UnauthorisedException(
              'Invalid Dealer Code or PIN. You have ${3 - dealer.incPins} attempt(s) remaining before your account is locked.',
            ); // Use specific exception
          }
        }
      case 'api/user/login':
        if (body is! Map<String, dynamic>) {
          throw Exception('Invalid body type for login.');
        }
        final username = (body['username'] as String?)?.toLowerCase();
        final password = body['password'];
        try {
          final user = DummyData.users.firstWhere(
            (u) => u.username == username,
          );
          final isPasswordCorrect = BCrypt.checkpw(password, user.password);

          // if (isPasswordCorrect) {
          //   return user;

          if (isPasswordCorrect) {
            // Step 1: Get the user's roles
            final userRoles = user.roles;

            // Step 2: Find all permitted ScreenIds for the user's roles
            // We use a Set to automatically handle duplicate ScreenIds
            final permittedScreenIds =
                DummyData.perms
                    .where((perm) => userRoles.contains(perm.RoleId))
                    .map((perm) => perm.ScreenId)
                    .toSet();

            // Step 3: Filter the master list of screens to get the accessible ones
            final accessibleScreens =
                DummyData.screens
                    .where(
                      (screen) => permittedScreenIds.contains(screen.screenId),
                    )
                    .toList();

            // Step 2: Find the corresponding role names from the master list
            final userRoleNames =
                DummyData.roles
                    .where(
                      (role) => userRoles.contains(role.roleId),
                    ) // Filter by ID
                    .map((role) => role.roleName) // Extract just the name
                    .toList(); // Convert to a List<String>

            // Step 4 & 5: Create a new User object with the accessible screens and return it
            return user.copyWith(
              accessibleScreen: accessibleScreens,
              rolenames: userRoleNames,
            );
          } else {
            throw UnauthorisedException('Invalid username or password.');
          }
        } catch (e) {
          throw UnauthorisedException('Invalid username or password.');
        }
      
      case 'api/user/set-password':
        if (body is! Map<String, dynamic>) {
          throw Exception('Invalid body type for password update.');
        }
        final username = (body['username'] as String?)?.toLowerCase();
       // final oldPassword = body['oldPassword'];
        final newPassword = body['newPassword'];
        try {
          final userIndex = DummyData.users.indexWhere(
            (u) => u.username == username,
          );
          if (userIndex == -1) {
            throw UnauthorisedException('User not found.');
          }
          final userToUpdate = DummyData.users[userIndex];
          //final isPasswordCorrect = BCrypt.checkpw(oldPassword, userToUpdate.password);
            final hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
            final updatedUser = userToUpdate.copyWith(
              password: hashedPassword,
              isTemporaryPassword: false, // Mark as no longer temporary
              passwordUpdatedAt: DateTime.now(), // Update the date
            );
            DummyData.users[userIndex] = updatedUser;

                        // Step 1: Get the user's roles
            final userRoles = updatedUser.roles;

            // Step 2: Find all permitted ScreenIds for the user's roles
            // We use a Set to automatically handle duplicate ScreenIds
            final permittedScreenIds =
                DummyData.perms
                    .where((perm) => userRoles.contains(perm.RoleId))
                    .map((perm) => perm.ScreenId)
                    .toSet();

            // Step 3: Filter the master list of screens to get the accessible ones
            final accessibleScreens =
                DummyData.screens
                    .where(
                      (screen) => permittedScreenIds.contains(screen.screenId),
                    )
                    .toList();

            // Step 2: Find the corresponding role names from the master list
            final userRoleNames =
                DummyData.roles
                    .where(
                      (role) => userRoles.contains(role.roleId),
                    ) // Filter by ID
                    .map((role) => role.roleName) // Extract just the name
                    .toList(); // Convert to a List<String>

            // Step 4 & 5: Create a new User object with the accessible screens and return it
            return updatedUser.copyWith(
              accessibleScreen: accessibleScreens,
              rolenames: userRoleNames,
            );
        } catch (e) {
          rethrow;
        }

      case 'api/user/changepassword':
        if (body is! Map<String, dynamic>) {
          throw Exception(
            'Invalid body type for changePassword. Expected a Map.',
          );
        }
        final username = (body['username'] as String?)?.toLowerCase();
        final oldPassword = body['oldPassword'];
        final newPassword = body['newPassword'];

        User oldUser;
        try {
          oldUser = DummyData.users.firstWhere((u) => u.username == username);
        } catch (e) {
          throw UnauthorisedException('Could not find a user to update.');
        }
        if (!BCrypt.checkpw(oldPassword, oldUser.password)) {
          throw UnauthorisedException(
            'The old password you entered is incorrect.',
          );
        }
        final String newHashedPassword = BCrypt.hashpw(
          newPassword,
          BCrypt.gensalt(),
        );
        try {
          final userIndex = DummyData.users.indexOf(oldUser);
          final updatedUser = User(
            id: oldUser.id,
            username: oldUser.username,
            email: oldUser.email,
            password: newHashedPassword,
            roles: oldUser.roles,
          );
          DummyData.users[userIndex] = updatedUser;
          return true;
        } catch (e) {
          throw UnauthorisedException('Could update the user.'); // chnage later
        }

      case 'api/user/request-password-reset':
        if (body is! Map<String, dynamic>) {
          throw Exception('Invalid body type for password reset request.');
        }
        final username = (body['username'] as String?)?.toLowerCase();
        final email = (body['email'] as String?)?.toLowerCase();
        try {
          DummyData.users.firstWhere(
            (u) => u.username == username && u.email == email,
          );
          return '12345';
        } catch (e) {
          throw Exception('User not found or email does not match.');
        }

      case 'api/user/reset-password':
        if (body is! Map<String, dynamic>) {
          throw Exception('Invalid body type for password reset.');
        }
        final username = (body['username'] as String?)?.toLowerCase();
        final token = body['token'];
        final newPassword = body['newPassword'];
        if (token != '12345') {
          throw Exception('Invalid or expired password reset token.');
        }

        try {
          final oldUser = DummyData.users.firstWhere(
            (u) => u.username == username,
          );

          final String newHashedPassword = BCrypt.hashpw(
            newPassword,
            BCrypt.gensalt(),
          );
          final userIndex = DummyData.users.indexOf(oldUser);
          final updatedUser = User(
            id: oldUser.id,
            username: oldUser.username,
            email: oldUser.email,
            password: newHashedPassword,
            roles: oldUser.roles,
          );
          DummyData.users[userIndex] = updatedUser;
          return true;
        } catch (e) {
          throw Exception('User not found.');
        }

      case 'api/receipts/save':
        if (body is! Receipt) {
          throw Exception(
            'Invalid type for saving a receipt. Expected a Receipt object.',
          );
        }

        final receipt = body;

        final isDuplicate = DummyData.receipts.any(
          (existingReceipt) =>
              existingReceipt.dealerCode == receipt.dealerCode &&
              existingReceipt.bankCode == receipt.bankCode &&
              existingReceipt.chequeNumber == receipt.chequeNumber,
        );

        if (isDuplicate) {
          throw Exception(
            'This cheque number already exists for the selected dealer and bank.',
          );
        }

        DummyData.receipts.add(receipt);
        return true;

      case 'api/invoice/save':
        if (body is! Receipt) {
          throw Exception(
            'Invalid type for saving a receipt. Expected a Receipt object.',
          );
        }

        final receipt = body;

        final isDuplicate = DummyData.receipts.any(
          (existingReceipt) =>
              existingReceipt.dealerCode == receipt.dealerCode &&
              existingReceipt.bankCode == receipt.bankCode &&
              existingReceipt.chequeNumber == receipt.chequeNumber,
        );

        if (isDuplicate) {
          throw Exception(
            'This cheque number already exists for the selected dealer and bank.',
          );
        }

        DummyData.receipts.add(receipt);
        return true;

      case 'api/attendance/save':
        if (body is! Attendance) {
          throw Exception(
            'Invalid type for saving attendance. Expected an Attendance object.',
          );
        }

        final newAttendance = body;

        int existingIndex = DummyData.attendances.indexWhere(
          (existingAttendance) =>
              existingAttendance.userID == newAttendance.userID &&
              existingAttendance.date.year == newAttendance.date.year &&
              existingAttendance.date.month == newAttendance.date.month &&
              existingAttendance.date.day == newAttendance.date.day,
        );

        if (existingIndex != -1) {
          // Record exists, replace it
          DummyData.attendances[existingIndex] = newAttendance;
        } else {
          // No existing record, add as new
          DummyData.attendances.add(newAttendance);
        }
        return true;

      default:
        throw FetchDataException('Invalid POST API URL: $url');
    }
  }
}
