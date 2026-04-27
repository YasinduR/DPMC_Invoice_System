// lib/services/secure_storage_service.dart

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/errors/app_exceptions.dart';
import 'package:myapp/services/api_service.dart';
//import 'package:myapp/services/mock_api_service.dart';

// Flutter Secure Storage For Saving Tokens
class SecureStorageService {  
  static const _kAccessToken = 'accessToken';
  static const _kRefreshToken = 'refreshToken';
 // static const _kAccessTokenExpiry = 'accessTokenExpiry'; // Store as ISO 8601 String

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    //required DateTime accessTokenExpiry,
  }) async {
    await _storage.write(key: _kAccessToken, value: accessToken);
    await _storage.write(key: _kRefreshToken, value: refreshToken);
   // await _storage.write(key: _kAccessTokenExpiry, value: accessTokenExpiry.toIso8601String());
   // print('SecureStorageService: Tokens saved securely. Expiry: ${accessTokenExpiry.toIso8601String()}');
  }

  // Future<String?> getAccessToken() async {
  //   return await _storage.read(key: _kAccessToken);
  // }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _kRefreshToken);
  }


    /// Returns the valid access token or null if no valid token can be obtained.
  Future<String?> getAccessToken() async {
    String? accessToken = await _storage.read(key: _kAccessToken);
    String? refreshToken = await _storage.read(key: _kRefreshToken);

    if (accessToken == null) {
      print('SecureStorageService: No access token found.');
      return null;
    }

    

    try {
      final JWT jwt = JWT.decode(accessToken);
      final int? expiryTimestamp = jwt.payload['exp'] as int?;

      if (expiryTimestamp == null) {
        print('SecureStorageService: Access token has no expiry claim. Treating as invalid.');
        await clearTokens(); 
        return null;
      }

      final DateTime expiryDate = DateTime.fromMillisecondsSinceEpoch(expiryTimestamp * 1000);
      final DateTime now = DateTime.now();

      if (now.isBefore(expiryDate)) {
        print('SecureStorageService: Access token is still valid. Returning it.');
        return accessToken;
      } else {
        print('SecureStorageService: Access token expired. Attempting to refresh...');

        if (refreshToken == null) {
          print('SecureStorageService: No refresh token available. Cannot refresh.');
          await clearTokens(); // Clear the expired access token
          return null;
        }

        try {

            final apiService = ApiService(); // or get it from dependency injection
            final tokens = await apiService.refreshToken(refreshToken);
            final String newAccessToken = tokens['accessToken']!;
            final String newRefreshToken = tokens['refreshToken']!; // use returned refresh token



          // final Map<String, dynamic> refreshResponse = await MockApiService.post(
          //   'api/refreshToken',
          //   body: {'refreshToken': refreshToken},
          // );

          // final String newAccessToken = refreshResponse['accessToken'] as String;
          // final String newRefreshToken = refreshResponse['refreshToken'] as String; // Assuming rolling refresh tokens

          // Save the newly obtained tokens
          await saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
          );
          print('SecureStorageService: Tokens refreshed and saved.');
          return newAccessToken;
        } on UnauthorisedException catch (e) {
          print('SecureStorageService: Refresh token failed: ${e.toString()}. Logging out user by clearing tokens.');
          await clearTokens(); // Clear all tokens
          return null;
        } on Exception catch (e) {
          print('SecureStorageService: Error during token refresh: $e. Clearing tokens.');
          await clearTokens();
          return null;
        }
      }
    } on JWTException catch (e) {
      print('SecureStorageService: Error decoding access token: ${e.message}. Clearing tokens.');
      await clearTokens();
      return null;
    } catch (e) {
      print('SecureStorageService: Unexpected error in getAccessToken: $e. Clearing tokens.');
      await clearTokens();
      return null;
    }
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _kAccessToken);
    await _storage.delete(key: _kRefreshToken);
  //  await _storage.delete(key: _kAccessTokenExpiry);
    print('SecureStorageService: All tokens cleared securely.');
  }


}