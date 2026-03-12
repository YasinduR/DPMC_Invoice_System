
//YYYY/MM/DD HH:mm
//Example: 2024/04/21 23:09
String formatDateTime(DateTime dateTime) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');

  return "${dateTime.year}/"
      "${twoDigits(dateTime.month)}/"
      "${twoDigits(dateTime.day)} "
      "${twoDigits(dateTime.hour)}:"
      "${twoDigits(dateTime.minute)}";
}

// Phone number masking
// 1234567890 -> 123****890
String maskPhoneNumber(String phone) {
  if (phone.length >= 3) {
    final lastThree = phone.substring(phone.length - 3);
    return '${phone.substring(0, 3)} ** **** $lastThree';
  }
  return phone;
}

// Email masking
// abcdefgh@example.com -> a***@example.com
String maskEmail(String email) {
  final atIndex = email.indexOf('@');
  if (atIndex > 1) {
    return '${email[0]}***${email.substring(atIndex)}';
  }
  return email;
}