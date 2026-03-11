
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