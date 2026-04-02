import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:myapp/contracts/mappable.dart';
import 'package:myapp/exceptions/app_exceptions.dart';
import 'package:myapp/models/attendance_model.dart';
import 'package:myapp/models/dispatch_note_model.dart';
import 'package:myapp/models/tin_model.dart';
import 'package:myapp/models/invoice_model.dart';
import 'package:myapp/models/receipt_model.dart';
import 'package:myapp/models/return_request_model.dart';
import 'package:myapp/models/return_save_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/services/dummy_data.dart';
import 'package:myapp/models/part_model.dart';

import 'package:bcrypt/bcrypt.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

//// IMPORTANT :  This works as the Back-End remove later

class MockApiService {
  static const Uuid _uuid = Uuid(); // For generating unique tokens
  static const String _jwtSecretKey = 'DPMC-INV-SYSTEM'; // Change The Key Later
  // static String _pendingOtp = '';
  static final Map<String, Map<String, dynamic>> _otpStore = {};
  static String devOtp = ''; // DEV ONLY

  static const List<String> _publicEndpoints = [
    // Where We dont need access token
    'api/user/login',
    'api/user/request-password-reset',
    'api/user/verify-otp',
    'api/user/reset-password',
    'api/user/set-password',
    'api/user/renew-password',
    'api/user/changepassword',
    'api/refreshToken',
  ];

  static Future<void> _validateAccessToken(String? accessToken) async {
    if (accessToken == null || accessToken.isEmpty) {
      print('DEBUG: No access token provided with the request.');
      throw UnauthorisedException('No access token provided. Please log in.');
    }

    try {
      // Verify the JWT with the secret key
      final JWT jwt = JWT.verify(accessToken, SecretKey(_jwtSecretKey));
      // Optionally, you could also check 'iss', 'sub', or other claims here
    } on JWTExpiredException {
      //print('DEBUG: Access token expired.');
      throw UnauthorisedException(
        'Access token has expired. Please log in again.',
      );
    } on JWTInvalidException {
      //print('DEBUG: Invalid access token signature/structure.');
      throw UnauthorisedException('Invalid access token. Please log in again.');
    } on JWTNotActiveException {
      //print('DEBUG: Access token not yet active.');
      throw UnauthorisedException(
        'Access token is not yet active. Please log in again.',
      );
    } catch (e) {
      //print('DEBUG: Unexpected error validating access token: $e');
      throw UnauthorisedException(
        'Authentication failed: Could not verify token. Please log in again.',
      );
    }
  }

  static Future<String> _generateAccessToken(User user) async {
    final DateTime tokenIssuedAt = DateTime.now();
    final DateTime tokenExpiresAt = tokenIssuedAt.add(
      const Duration(seconds: 100),
    );

    final jwt = JWT(
      {
        'userId': user.id,
        'username': user.username,
        'roles': user.roles,
        'iat': tokenIssuedAt.millisecondsSinceEpoch ~/ 1000,
        'exp': tokenExpiresAt.millisecondsSinceEpoch ~/ 1000,
      },
      issuer: 'mock_api_service',
      subject: user.id,
    );

    return jwt.sign(SecretKey(_jwtSecretKey));
  }

  static Future<String> _generateRefreshToken(User user) async {
    final DateTime tokenIssuedAt = DateTime.now();
    final DateTime tokenExpiresAt = tokenIssuedAt.add(
      const Duration(days: 7), // Refresh token longer-lived
    );

    final jwt = JWT(
      {
        'userId': user.id,
        'username': user.username,
        'roles': user.roles,
        'iat': tokenIssuedAt.millisecondsSinceEpoch ~/ 1000,
        'exp': tokenExpiresAt.millisecondsSinceEpoch ~/ 1000,
      },
      issuer: 'mock_api_service',
      subject: user.id,
    );

    return jwt.sign(SecretKey(_jwtSecretKey));
  }

  /// verify both token authenticity and user ownership before allowing a reset.
  static Future<String> _generateResetToken(String username) async {
    final DateTime issuedAt = DateTime.now();
    final DateTime expiresAt = issuedAt.add(const Duration(minutes: 15));

    final jwt = JWT(
      {
        'type': 'password_reset',
        'iat': issuedAt.millisecondsSinceEpoch ~/ 1000,
        'exp': expiresAt.millisecondsSinceEpoch ~/ 1000,
      },
      issuer: 'mock_api_service',
      subject: username,
    );

    return jwt.sign(SecretKey(_jwtSecretKey));
  }

  static Future<List<T>> get<T extends Mappable>(
    String url, {
    String? authToken, // Token is now passed as a parameter
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final uri = Uri.parse(url);
    if (!uri.path.endsWith('/list')) {
      throw Exception('Invalid GET URL. Must end with "/list".');
    }

    try {
      if (uri.path != 'api/screens/list') {
        await _validateAccessToken(authToken); // Validate the passed token
      }
    } catch (e) {
      rethrow;
    }

    // final uri = Uri.parse(url);
    // if (!uri.path.endsWith('/list')) {
    //   throw Exception('Invalid GET URL. Must end with "/list".');
    // }

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
      case 'api/invoices-saved/list':
        sourceData = DummyData.savedInvoices;
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
      case 'api/dispatch-notes/list': // Added by Darshan R on 23/03/2026
        sourceData = DummyData.savedDispatchNotes;
        break;
      case 'api/attendance/list':
        sourceData = DummyData.attendances;
      case 'api/return-request/list':
        sourceData = DummyData.returnRequests;
      case 'api/employee/list':
        sourceData = DummyData.employees;
      case 'api/receipts/list':
        sourceData = DummyData.receipts;
      case 'api/assignee/list':
        sourceData = DummyData.assignees;

        // final filtersJson = uri.queryParameters['filters'];
        // if (filtersJson == null) {
        //   sourceData = [];
        //   break;
        // }

        // final filters = jsonDecode(filtersJson) as List;
        // // Assuming the filter is always ['supervisorId', '=', value]
        // final supervisorFilter = filters.firstWhere(
        //   (f) => f[0] == 'supervisorId',
        //   orElse: () => null,
        // );

        // if (supervisorFilter == null) {
        //   sourceData = [];
        //   break;
        // }

        // final supervisorId = supervisorFilter[2]; // the value

        // final assigneeIds =
        //     DummyData.assignees
        //         .where((a) => a.supervisorId == supervisorId)
        //         .map((a) => a.assigneeId)
        //         .toList();

        // sourceData =
        //     DummyData.users.where((u) => assigneeIds.contains(u.id)).toList();
        // break;

      //   final assigneeIds = DummyData.assignees
      //       .where((a) => a.supervisorId == supervisorId)
      //       .map((a) => a.assigneeId)
      //       .toList();

      // sourceData = DummyData.users
      //     .where((u) => assigneeIds.contains(u.id)) // 👈 fix
      //     .toList();

      //   break;
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
              // Prepare values for comparison, especially for 'date'
              dynamic comparableItemValue = itemValue;
              dynamic comparableValue = value;

              // Parse dates if the field is 'date'
              if (field == 'date' && itemValue is String && value is String) {
                try {
                  comparableItemValue = DateTime.parse(itemValue);
                  comparableValue = DateTime.parse(value);
                } catch (e) {
                  // If date parsing fails, comparison will be false or handled by default
                  print('Error parsing date for filter: $e');
                  return false;
                }
              }

              switch (operator) {
                case '=':
                  return comparableItemValue.toString().toLowerCase() ==
                      comparableValue.toString().toLowerCase();
                case '!=':
                  return comparableItemValue.toString().toLowerCase() !=
                      comparableValue.toString().toLowerCase();
                case '>=':
                  // Only compare if values are comparable (like DateTime, num, String)
                  if (comparableItemValue is Comparable &&
                      comparableValue is Comparable &&
                      comparableItemValue.runtimeType ==
                          comparableValue.runtimeType) {
                    return comparableItemValue.compareTo(comparableValue) >= 0;
                  }
                  return false;
                case '<=':
                  if (comparableItemValue is Comparable &&
                      comparableValue is Comparable &&
                      comparableItemValue.runtimeType ==
                          comparableValue.runtimeType) {
                    return comparableItemValue.compareTo(comparableValue) <= 0;
                  }
                  return false;

                case 'in':
              if (value is List) {
                return value.any((v) =>
                  comparableItemValue.toString().toLowerCase() == v.toString().toLowerCase());
                }
              return false;

                default:
                  return false; // Unknown operator
              }
            });
          }).toList();
    }

    if (sourceData.isEmpty && uri.path != 'api/attendance/list') {
      throw Exception('No data found.');
    }
    return sourceData.cast<T>();
  }

  static Future<dynamic> post(
    String url, {
    dynamic body,
    String? accessToken,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (!_publicEndpoints.contains(url)) {
      await _validateAccessToken(accessToken);
    }

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
        final mode = body['mode']; // BioMetric

        try {
          final user = DummyData.users.firstWhere(
            (u) => u.username == username,
            orElse: () => throw UnauthorisedException('User not found.'),
          );

          if (user.isLocked) {
            throw AccountLockedException(
              'Your account is locked. Please contact support.',
            );
          }
          final isPasswordCorrect = BCrypt.checkpw(password, user.password);

          if (isPasswordCorrect) {
            user.incPins = 0;
            bool passwordIsExpired = false;
            const Duration passwordExpiryDuration = Duration(
              seconds: 1000,
            ); // For Testing Tme GAP IS 30 SEC

            if (user.passwordUpdatedAt != null) {
              final Duration timeSinceLastUpdate = DateTime.now().difference(
                user.passwordUpdatedAt!,
              );
              if (timeSinceLastUpdate > passwordExpiryDuration) {
                passwordIsExpired = true;
                print(
                  'DEBUG: Password for ${user.username} has expired (last updated: ${user.passwordUpdatedAt}, expired after $passwordExpiryDuration).',
                );
              } else {
                print(
                  'DEBUG: Password for ${user.username} is NOT expired (last updated: ${user.passwordUpdatedAt}, still valid for ${(passwordExpiryDuration - timeSinceLastUpdate).inSeconds} seconds).',
                );
              }
            } else {
              passwordIsExpired = true;
              print(
                'DEBUG: Password for ${user.username} has no update date, treating as expired.',
              );
            }

            final userRoles = user.roles;

            final permittedScreenIds =
                DummyData.perms
                    .where((perm) => userRoles.contains(perm.RoleId))
                    .map((perm) => perm.ScreenId)
                    .toSet();

            final accessibleScreens =
                DummyData.screens
                    .where(
                      (screen) => permittedScreenIds.contains(screen.screenId),
                    )
                    .toList();

            final userRoleNames =
                DummyData.roles
                    .where(
                      (role) => userRoles.contains(role.roleId),
                    ) // Filter by ID
                    .map((role) => role.roleName) // Extract just the name
                    .toList(); // Convert to a List<String>

            // Return a Map containing user data and tokens
            // Generate mock tokens
            // final DateTime tokenIssuedAt = DateTime.now();
            // final DateTime tokenExpiresAt = tokenIssuedAt.add(
            //   const Duration(seconds: 1000),
            // );

            // final jwt = JWT(
            //   {
            //     'userId': user.id,
            //     'username': user.username,
            //     'roles': user.roles,
            //     'iat': tokenIssuedAt.millisecondsSinceEpoch ~/ 1000,
            //     'exp': tokenExpiresAt.millisecondsSinceEpoch ~/ 1000,
            //   },
            //   issuer: 'mock_api_service',
            //   subject: user.id,
            // );

            // final String accessToken = jwt.sign(SecretKey(_jwtSecretKey));
            // final String refreshToken = 'refresh-${_uuid.v4()}';

            // final DateTime accessTokenExpiry = tokenExpiresAt;

            final String accessToken = await _generateAccessToken(user);
            final String refreshToken = await _generateRefreshToken(user);

            // final DateTime accessTokenExpiry = tokenExpiresAt;

            return {
              'user':
                  user
                      .copyWith(
                        accessibleScreen: accessibleScreens,
                        rolenames: userRoleNames,
                        isPasswordExpired: passwordIsExpired,
                      )
                      .toMap(),
              'accessToken': accessToken,
              'refreshToken': refreshToken,
              // 'accessTokenExpiry': accessTokenExpiry.toIso8601String(),
            };

            // final String accessToken = 'access-${_uuid.v4()}';
            // final String refreshToken = 'refresh-${_uuid.v4()}';
            // // Set access token expiry to 1 hour from now for example
            // final DateTime accessTokenExpiry = DateTime.now().add(
            //   const Duration(hours: 1),
            // );
            // return {
            //   'user': user.copyWith(
            //     accessibleScreen: accessibleScreens,
            //     rolenames: userRoleNames,
            //     isPasswordExpired: passwordIsExpired,
            //   ).toMap(), // Convert user object to map
            //   'accessToken': accessToken,
            //   'refreshToken': refreshToken,
            //   'accessTokenExpiry': accessTokenExpiry.toIso8601String(),
            // };
            // return user.copyWith(
            //   accessibleScreen: accessibleScreens,
            //   rolenames: userRoleNames,
            //   isPasswordExpired: passwordIsExpired,
            // );
          } else {
            if (mode == 'BioMetric') {
              throw UnauthorisedException(
                'Biometric login failed. Please login using an another way.',
              );
            } else {
              user.incPins++;
              if (user.incPins >= 3) {
                user.isLocked = true;
                throw AccountLockedException(
                  'Your Account has been locked due to too many incorrect attempts.',
                );
              } else {
                throw UnauthorisedException(
                  'Invalid Password. You have ${3 - user.incPins} attempt(s) remaining before your account is locked.',
                ); // Use specific exception
              }
            }
          }
        } catch (e) {
          //throw UnauthorisedException('Invalid username or password.');
          rethrow;
        }

      case 'api/user/set-password':
        if (body is! Map<String, dynamic>) {
          throw Exception('Invalid body type for password update.');
        }
        final username = (body['username'] as String?)?.toLowerCase();

        // final oldPassword = body['oldPassword'];
        final newPassword = body['newPassword'];

        final securityQuestion = body['securityQuestion'] as String?;
        final securityAnswer = body['securityAnswer'] as String?;

        if (securityQuestion == null || securityQuestion.isEmpty) {
          throw Exception('Security question is required.');
        }
        if (securityAnswer == null || securityAnswer.isEmpty) {
          throw Exception('Security answer is required.');
        }

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

      case 'api/user/renew-password':
        if (body is! Map<String, dynamic>) {
          throw Exception('Invalid body type for password update.');
        }
        final username = (body['username'] as String?)?.toLowerCase();
        final newPassword = body['newPassword'];

        try {
          final userIndex = DummyData.users.indexWhere(
            (u) => u.username == username,
          );
          if (userIndex == -1) {
            throw UnauthorisedException('User not found.');
          }
          final userToUpdate = DummyData.users[userIndex];
          final hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
          final updatedUser = userToUpdate.copyWith(
            password: hashedPassword,
            isTemporaryPassword: false, // Mark as no longer temporary
            isPasswordExpired:
                false, // IMPORTANT: Password is no longer expired
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

          final updatedUser = oldUser.copyWith(
            // Use copyWith
            password: newHashedPassword,
            passwordUpdatedAt: DateTime.now(),
            isTemporaryPassword: false, // No longer a temporary password
            isPasswordExpired: false, // Password is now current and not expired
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
        //final email = (body['email'] as String?)?.toLowerCase();
        try {
          final user = DummyData.users.firstWhere(
            (u) => u.username == username,
            orElse: () => throw UnauthorisedException('User not found.'),
          );
          if (user.isLocked) {
            throw AccountLockedException(
              'Your account is locked. Please contact support.',
            );
          }
          if (user.telephone.isEmpty) {
            throw UnauthorisedException(
              'User\'s telephone number not available for password reset.',
            );
          }

          // Get the last three digits of the telephone number
          final String phoneNumber = user.telephone;
          String lastThreeDigits = '';
          if (phoneNumber.length >= 3) {
            lastThreeDigits = phoneNumber.substring(phoneNumber.length - 3);
          } else {
            // Handle cases where phone number is less than 3 digits
            lastThreeDigits = phoneNumber;
          }

          // generate pending OTP - Added By Darshan R on 12/03/2026
          final String otp = (Random().nextInt(900000) + 100000).toString();
          _otpStore[username!] = {
            'otp': otp,
            'expiry': DateTime.now().add(const Duration(minutes: 5)),
            'used': false,
            'failedAttempts': 0,
          };
          devOtp = otp; // DEV ONLY

          // Construct the message
          return 'Password reset code sent to the mobile ending with ***$lastThreeDigits';
        } catch (e) {
          rethrow;
        }

      case 'api/user/verify-otp':
        if (body is! Map<String, dynamic>) {
          throw Exception('Invalid body for OTP verification.');
        }
        final otpUsername = (body['username'] as String?)?.toLowerCase();
        final otpToken = body['token'] as String?;
        if (otpUsername == null || otpToken == null) {
          throw Exception('Username and token are required.');
        }
        final otpRecord = _otpStore[otpUsername];
        if (otpRecord == null) {
          throw UnauthorisedException(
            'No OTP request found. Please try again.',
          );
        }
        if (otpRecord['used'] as bool) {
          throw UnauthorisedException('OTP has already been used.');
        }
        if (DateTime.now().isAfter(otpRecord['expiry'] as DateTime)) {
          _otpStore.remove(otpUsername);
          throw UnauthorisedException(
            'OTP has expired. Please request a new one.',
          );
        }
        if (otpRecord['otp'] as String != otpToken) {
          final int attempts = (otpRecord['failedAttempts'] as int) + 1;
          _otpStore[otpUsername]!['failedAttempts'] = attempts;

          if (attempts >= 3) {
            _otpStore.remove(otpUsername);
            throw UnauthorisedException(
              'OTP is no longer valid due to too many incorrect attempts. Please request a new one.',
            );
          }

          final int remaining = 3 - attempts;
          throw UnauthorisedException(
            'Invalid OTP. You have $remaining attempt${remaining == 1 ? '' : 's'} remaining.',
          );
        }
        _otpStore[otpUsername]!['used'] = true;
        return await _generateResetToken(otpUsername);

      case 'api/user/reset-password':
        if (body is! Map<String, dynamic>) {
          throw Exception('Invalid body type for password reset.');
        }
        final username = (body['username'] as String?)?.toLowerCase();
        final token = body['token'];
        final newPassword = body['newPassword'];

        try {
          final JWT resetJwt = JWT.verify(token, SecretKey(_jwtSecretKey));
          final payload = resetJwt.payload as Map<String, dynamic>;
          if (payload['type'] != 'password_reset') {
            throw UnauthorisedException('Invalid reset token.');
          }
          if (resetJwt.subject != username) {
            throw UnauthorisedException('Reset token does not match the user.');
          }
        } on JWTExpiredException {
          throw UnauthorisedException(
            'Reset token has expired. Please start over.',
          );
        } on UnauthorisedException {
          rethrow;
        } on AccountLockedException {
          rethrow;
        } catch (_) {
          throw UnauthorisedException(
            'Invalid reset token. Please start over.',
          );
        }

        try {
          final oldUser = DummyData.users.firstWhere(
            (u) => u.username == username,
            orElse: () => throw UnauthorisedException('User not found.'),
          );

          if (oldUser.isLocked) {
            throw AccountLockedException(
              'Your account is locked. Please contact support.',
            );
          }

          final String newHashedPassword = BCrypt.hashpw(
            newPassword,
            BCrypt.gensalt(),
          );

          final userIndex = DummyData.users.indexOf(oldUser);
          final updatedUser = oldUser.copyWith(
            // Use copyWith
            password: newHashedPassword,
            passwordUpdatedAt: DateTime.now(),
            isTemporaryPassword: false, // No longer a temporary password
            isPasswordExpired: false, // Password is now current and not expired
          );
          DummyData.users[userIndex] = updatedUser;
          return true;
        } catch (e) {
          rethrow;
        }

      case 'api/receipts/save':
        if (body is! Receipt) {
          throw Exception(
            'Invalid type for saving a receipt. Expected a Receipt object.',
          );
        }

        final receipt = body;

        // final updatedreceipt = receipt.copyWith(
        //     // Use copyWith
        //     receiptNo: generateRecNumber(),
        //   );

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

        final updatedreceipt = receipt.copyWith(
          // Use copyWith
          receiptNo: generateRecNumber(),
        );

        DummyData.receipts.add(updatedreceipt);
        return updatedreceipt;

      case 'api/invoice/save':
        if (body is! InvoiceSave) {
          throw Exception(
            'Invalid type for saving a Invoice. Expected an Invoice object.',
          );
        }

        final invoice = body;

        final updatedInvoice = invoice.copyWith(
          // Use copyWith
          invoiceNumber: generateInvoiceNumber(),
        );
        //invoice.invoiceNumber = generateInvoiceNumber();
        final isDuplicate = DummyData.savedInvoices.any(
          (existingInvoice) =>
              existingInvoice.invoiceNumber == updatedInvoice.invoiceNumber,
        );

        if (isDuplicate) {
          throw Exception(
            'This cheque number already exists for the selected dealer and bank.',
          );
        }

        DummyData.savedInvoices.add(updatedInvoice);

        final tinIndex = DummyData.tins.indexWhere(
          (t) =>
              t.tinNumber == updatedInvoice.tinNo ||
              t.orderNumber == updatedInvoice.orderNo,
        );
        if (tinIndex != -1) {
          final existingTin = DummyData.tins[tinIndex];

          // Map existing parts by partNo for quick lookup
          final Map<String, Part> existingByPartNo = {
            for (var p in existingTin.parts) p.partNo: p,
          };

          // Subtract submitted quantities from master parts
          for (final subPart in updatedInvoice.parts) {
            final key = subPart.partNo;
            final existingPart = existingByPartNo[key];
            if (existingPart == null) continue;

            final newQty = existingPart.requestQty - subPart.requestQty;

            if (newQty > 0) {
              existingByPartNo[key] = existingPart.copyWith(requestQty: newQty);
            } else if (newQty == 0) {
              // exactly fulfilled — remove the part
              existingByPartNo.remove(key);
            } else {
              throw Exception(
                'Submitted quantity (${subPart.requestQty}) exceeds available (${existingPart.requestQty}) for part $key',
              );
            }
          }

          // Rebuild parts list and compute remaining total qty
          final List<Part> remainingParts = existingByPartNo.values.toList();
          final int remainingTotalQty = remainingParts.fold<int>(
            0,
            (int sum, Part p) => sum + p.requestQty,
          );
          // New status: 'PR' = proceeded when no parts remain, otherwise keep current (typically 'A')
          final String newStatus =
              (remainingTotalQty == 0) ? 'I' : existingTin.paymentStatus;

          // Replace the master tin with updated parts and status
          final updatedMasterTin = TinData(
            tinNumber: existingTin.tinNumber,
            orderNumber: existingTin.orderNumber,
            totalValue: existingTin.totalValue,
            paymentStatus: newStatus,
            dealercode: existingTin.dealercode,
            payOnDel: existingTin.payOnDel,
            parts: remainingParts,
            bagCount: existingTin.bagCount,
            tagCount: existingTin.tagCount,
            plasticBCount: existingTin.plasticBCount,
            remark: existingTin.remark,
          );

          DummyData.tins[tinIndex] = updatedMasterTin;
        }
        return updatedInvoice;

      case 'api/dispatchNote/save':
        if (body is! DispatchNoteSave) {
          throw Exception(
            'Invalid type for saving a Dispatch Note. Expected a DispatchNoteSave object.',
          );
        }
        final dispatchNote = body;
        final updatedDispatchNote = dispatchNote.copyWith(
          dispatchNumber: generateDispatchNumber(),
          tins: List<TinData>.from(dispatchNote.tins),
        );
        final isDuplicate = DummyData.savedDispatchNotes.any(
          (existing) =>
              existing.dispatchNumber == updatedDispatchNote.dispatchNumber,
        );
        if (isDuplicate) {
          throw Exception('Dispatch note number already exists.');
        }
        DummyData.savedDispatchNotes.add(updatedDispatchNote);
        return updatedDispatchNote;

      // Add other cases...

      case 'api/return/save':
        if (body is! Return) {
          throw Exception(
            'Invalid type for saving a Invoice. Expected an Invoice object.',
          );
        }

        final ret = body;

        final updatedReturn = ret.copyWith(
          // Use copyWith
          returnId: generateRetNumber(),
        );

        // support Mappable payloads (ReturnPayload etc.) by normalizing to Map
        // dynamic incoming = body;
        // if (incoming is Mappable) incoming = incoming.toMap();

        final String tinNo = ret.tinNo;

        final List<Part> incomingItems = ret.returnItems;


        final tinIndex = DummyData.tins.indexWhere((t) => t.tinNumber == tinNo);
        if (tinIndex != -1) {
          final existingTin = DummyData.tins[tinIndex];

          final Map<String, Part> existingByPartNo = {
            for (var p in existingTin.parts) p.partNo: p,
          };

          // iterate incoming items (each item may be Part instance, Map or minimal object)
          for (final Part retItem in incomingItems) {
            if (retItem == null) continue;

            String? key;
            int qty = 0;

 
              key = retItem.partNo;
              qty = retItem.requestQty;
            
            if (key == null) continue;

            final existingPart = existingByPartNo[key];
            if (existingPart == null) continue;

            // Subtract logic: mirror invoice/save behaviour:
            final int newQty = existingPart.requestQty - qty;
            if (newQty > 0) {
              existingByPartNo[key] = existingPart.copyWith(requestQty: newQty);
            } else if (newQty == 0) {
              existingByPartNo.remove(key);
            } else {
              // incoming return exceeds available -> keep behaviour consistent with invoice flow
              throw Exception(
                'Returned quantity ($qty) exceeds available (${existingPart.requestQty}) for part $key',
              );
            }
          }

          // Rebuild parts list and update master tin (remove parts fully returned)
          final List<Part> updatedParts = existingByPartNo.values.toList();
          

          final updatedMasterTin = TinData(
            tinNumber: existingTin.tinNumber,
            orderNumber: existingTin.orderNumber,
            totalValue: existingTin.totalValue,
            paymentStatus: updatedParts.isNotEmpty? existingTin.paymentStatus : 'I',
            dealercode: existingTin.dealercode,
            payOnDel: existingTin.payOnDel,
            parts: updatedParts,
            bagCount: existingTin.bagCount,
            tagCount: existingTin.tagCount,
            plasticBCount: existingTin.plasticBCount,
            remark: existingTin.remark,
          );
          DummyData.tins[tinIndex] = updatedMasterTin;
        }

        return updatedReturn;

      case 'api/return-request/update':
        if (body is! ReturnRequest) {
          throw Exception(
            'Invalid type for updating a return request. Expected a ReturnRequest object.',
          );
        }

        final ReturnRequest incomingReturnRequest =
            body; // This body contains the new returnItems

        // Find the index of the existing return request in the DummyData list
        final int index = DummyData.returnRequests.indexWhere(
          (existingReturn) =>
              existingReturn.returnId == incomingReturnRequest.returnId,
        );

        if (index == -1) {
          // If no existing return request is found with the given ID
          throw Exception(
            'No return request found with ID ${incomingReturnRequest.returnId} for update.',
          );
        } else {
          // Get the existing return request
          final ReturnRequest existingReturn = DummyData.returnRequests[index];

          // Create a new ReturnRequest object by copying the existing one,
          // but updating only the 'returnItems' with the new ones from the incoming body.
          // This assumes your ReturnRequest class has a copyWith method.
          final ReturnRequest updatedReturn = existingReturn.copyWith(
            returnItems:
                incomingReturnRequest.returnItems, // Only update returnItems
          );

          // Replace the old ReturnRequest object with the new, partially updated one
          DummyData.returnRequests[index] = updatedReturn;

          // Optionally, you might want to return the updated request
          // return updatedReturn;
        }
      // case 'api/return-request/update':
      //   if (body is! ReturnRequest) {
      //     throw Exception(
      //       'Invalid type for saving a return. Expected a Receipt object.',
      //     );
      //   }

      //   final returnReqboby = body;

      //   final ReturnRequest? existingReturn = DummyData
      //       .returnRequests
      //       .firstOrNull!(
      //     (existingReturn) => existingReturn.returnId == returnReqboby.returnId,
      //   );

      //   //invoice.invoiceNumber = generateInvoiceNumber();
      //   // final isDuplicate = DummyData.returns.any(
      //   //   (existingReturn) => existingReturn.returnId == updatedReturn.returnId,
      //   // );
      //   if (existingReturn == null) {
      //     throw Exception('This no return request  found id already exists.');
      //   } else {
      //     final updatedReturn = existingReturn.copyWith(
      //       returnItems: returnReqboby.returnItems,
      //     );
      //     DummyData.returnRequests.add(updatedReturn);
      //     //return updatedReturn;
      //   }
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
          DummyData.attendances[existingIndex] = newAttendance;
        } else {
          DummyData.attendances.add(newAttendance);
        }
        return true;

      case 'api/refreshToken':
        if (body is! Map<String, dynamic> ||
            !body.containsKey('refreshToken')) {
          throw Exception('Invalid refresh token request body.');
        }

        final String refreshToken = body['refreshToken'] as String;

        try {
          final JWT decodedJwt = JWT.verify(
            refreshToken,
            SecretKey(_jwtSecretKey),
          );
          final String userId = decodedJwt.payload['userId'] as String;

          final user = DummyData.users.firstWhere(
            (u) => u.id == userId,
            orElse:
                () =>
                    throw UnauthorisedException(
                      'User not found for refresh token.',
                    ),
          );

          final newAccessToken = await _generateAccessToken(user);
          // Optionally, generate a new refresh token as well for rolling refresh tokens
          final newRefreshToken = await _generateRefreshToken(user);

          return {
            'accessToken': newAccessToken,
            'refreshToken':
                newRefreshToken, // Include if you want rolling refresh tokens
          };
        } on JWTExpiredException {
          throw UnauthorisedException('Refresh token has expired.');
        } on JWTInvalidException {
          throw UnauthorisedException('Invalid refresh token.');
        } on JWTException catch (e) {
          throw UnauthorisedException(
            'Failed to process refresh token: ${e.message}',
          );
        }

      default:
        throw FetchDataException('Invalid POST API URL: $url');
    }
  }
}

String generateInvoiceNumber() {
  final now = DateTime.now();

  // Format date as YYYYMMDD
  String year = now.year.toString();
  String month = now.month.toString().padLeft(2, '0');
  String day = now.day.toString().padLeft(2, '0');
  String formattedDate = year + month + day;

  // Format time as HHMMSS
  String hour = now.hour.toString().padLeft(2, '0');
  String minute = now.minute.toString().padLeft(2, '0');
  String second = now.second.toString().padLeft(2, '0');
  String formattedTime = hour + minute + second;

  // Combine to create the invoice number
  return 'MIN' + formattedDate + formattedTime;
}

String generateDispatchNumber() {
  final now = DateTime.now();

  // Format date as YYYYMMDD
  String year = now.year.toString();
  String month = now.month.toString().padLeft(2, '0');
  String day = now.day.toString().padLeft(2, '0');
  String formattedDate = year + month + day;

  // Format time as HHMMSS
  String hour = now.hour.toString().padLeft(2, '0');
  String minute = now.minute.toString().padLeft(2, '0');
  String second = now.second.toString().padLeft(2, '0');
  String formattedTime = hour + minute + second;

  // Combine to create the DIS
  return 'ADN' + formattedDate + formattedTime;
}

String generateRetNumber() {
  final now = DateTime.now();

  // Format date as YYYYMMDD
  String year = now.year.toString();
  String month = now.month.toString().padLeft(2, '0');
  String day = now.day.toString().padLeft(2, '0');
  String formattedDate = year + month + day;

  // Format time as HHMMSS
  String hour = now.hour.toString().padLeft(2, '0');
  String minute = now.minute.toString().padLeft(2, '0');
  String second = now.second.toString().padLeft(2, '0');
  String formattedTime = hour + minute + second;

  // Combine to create the invoice number
  return 'RET' + formattedDate + formattedTime;
}

String generateRecNumber() {
  final now = DateTime.now();

  // Format date as YYYYMMDD
  String year = now.year.toString();
  String month = now.month.toString().padLeft(2, '0');
  String day = now.day.toString().padLeft(2, '0');
  String formattedDate = year + month + day;

  // Format time as HHMMSS
  String hour = now.hour.toString().padLeft(2, '0');
  String minute = now.minute.toString().padLeft(2, '0');
  String second = now.second.toString().padLeft(2, '0');
  String formattedTime = hour + minute + second;

  // Combine to create the invoice number
  return 'REC' + formattedDate + formattedTime;
}
