// ignore_for_file: constant_identifier_names

class Timer {
  static const Duration CONNECT_TIMEOUT = Duration(seconds: 20);
  static const Duration RECEIVE_TIMEOUT = Duration(seconds: 10);
  static const List<String> day = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN', 'OFF'];
  static const List<String> timeList = ['0', '5', '10', '15', '20', '25', '30'];
  static List<String> minute = List.generate(6, (index) => '${index}0');
  static List<String> hour = List.generate(24, (index) => '${index <= 9 ? '0' : ''}$index');
}