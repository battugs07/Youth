import 'package:intl/intl.dart';

String getDate(DateTime date) {
  // DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  var formatter = new DateFormat('yyyy-MM-dd');

  // DateTime dateTime  = dateFormat.parse(date);

  return formatter.format(date);
}

String getDateTime(DateTime date) {
//  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  var formatter = new DateFormat('yyyy-MM-dd HH:mm');

  // DateTime dateTime  = dateFormat.parse(date);

  return formatter.format(date);
}

String getTime(DateTime date) {
  // DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  var formatter = new DateFormat('HH:mm');

//  DateTime dateTime  = dateFormat.parse(date);

  return formatter.format(date);
}

String getParseDate(String date) {
  if (date == null && date == "") {
    return "";
  }
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  var formatter = new DateFormat('yyyy-MM-dd');

  try {
    DateTime dateTime = dateFormat.parse(date);

    return formatter.format(dateTime);
  } catch (_) {
    return today();
  }
}

String getParseTime(String date) {
  if (date == null && date == "") {
    return "";
  }

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  var formatter = new DateFormat('HH:mm');

  try {
    DateTime dateTime = dateFormat.parse(date);

    return formatter.format(dateTime);
  } catch (_) {
    return todayTime();
  }
}

String today() {
  var date = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  return formatter.format(date);
}

String todayTime() {
  var date = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
  return formatter.format(date);
}
