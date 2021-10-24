import 'package:intl/intl.dart';

class Dtime {
  static String formatYMED(timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
    String formattedDate = DateFormat('d MMM, hh:mm a').format(date);
    return formattedDate;
  }
}
