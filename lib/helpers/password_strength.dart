// Added by Darshan R on 19/03/2026  // Modified By Yasindu Ganegoda
//import 'package:flutter/material.dart';

class PasswordStrength {
  // Define as constants
  static const int MIN_PASSWORD_LENGTH = 8;
  static const int GOOD_PASSWORD_LENGTH = 12;
  static const int STRONG_PASSWORD_LENGTH = 16;
  static const String SPECIAL_CHARS = r'[!@#$%^&*(),.?":{}|<>]';
  
  /// Calculates password strength based on various criteria
  /// 
  /// Returns a map containing:
  /// - 'strength': double (0-7) - overall strength score
  /// - 'label': String - strength level label (Weak, Fair, Good, Strong)
  /// - 'color': Color - visual indicator color
  /// - 'checks': List<String> - list of criteria met
  static Map<String, dynamic> calculate(String password) {
    if (password.isEmpty) {
      return {
        'strength': 0,
        'label': '',
        //'color': Colors.grey,
        'checks': [],
      };
    }

    int strength = 0;
    List<String> checks = [];

    // Length check
    if (password.length >= MIN_PASSWORD_LENGTH) strength += 1;
    if (password.length >= GOOD_PASSWORD_LENGTH) strength += 1;
    if (password.length >= STRONG_PASSWORD_LENGTH) strength += 1;

    // Uppercase check
    if (RegExp(r'[A-Z]').hasMatch(password)) {
      strength += 1;
      checks.add('Uppercase');
    }

    // Lowercase check
    if (RegExp(r'[a-z]').hasMatch(password)) {
      strength += 1;
      checks.add('Lowercase');
    }

    // Number check
    if (RegExp(r'[0-9]').hasMatch(password)) {
      strength += 1;
      checks.add('Numbers');
    }

    // Special character check
    if (RegExp(SPECIAL_CHARS).hasMatch(password)) {
      strength += 1;
      checks.add('Special chars');
    }

    String label = '';
   // Color color = Colors.red;

    if (strength < 3) {
      label = 'Weak';
     // color = Colors.red;
    } else if (strength < 5) {
      label = 'Fair';
     // color = Colors.orange;
    } else if (strength < 7) {
      label = 'Good';
     // color = Colors.amber;
    } else {
      label = 'Strong';
     // color = Colors.green;
    }

    return {
      'strength': strength.toDouble(),
      'label': label,
     // 'color': color,
      'checks': checks,
    };
  }

  /// Validates if password meets minimum strength requirements
  /// Requires: 8+ chars, uppercase, lowercase, number, and special character
  static bool isSuffient(String password) {
    if (password.length < MIN_PASSWORD_LENGTH) return false;
    
    bool hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    bool hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    bool hasNumber = RegExp(r'[0-9]').hasMatch(password);
    bool hasSpecialChar = RegExp(SPECIAL_CHARS).hasMatch(password);
    
    return hasUppercase && hasLowercase && hasNumber && hasSpecialChar;
  }

// Added By Yasindu Ganegoda on 20/03/2026 
    static String? getValidationMessage(String password) {
    List<String> missing = [];
    if (password.length < MIN_PASSWORD_LENGTH) {
      missing.add('$MIN_PASSWORD_LENGTH+ characters');
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      missing.add('uppercase');
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      missing.add('lowercase');
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      missing.add('number');
    }
    if (!RegExp(SPECIAL_CHARS).hasMatch(password)) {
      missing.add('special character');
    }
    if (missing.isEmpty) return null;
    return 'Password requires: ${missing.join(", ")}';
  }

  /// Get strength percentage (0-100)
  static double getPercentage(String password) {
    final result = calculate(password);
    return (result['strength'] as double) / 7 * 100;
  }
}
