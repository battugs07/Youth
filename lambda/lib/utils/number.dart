import 'package:intl/intl.dart';

final formatter = new NumberFormat("#,###");

String number(int value) {
  return formatter.format(value);
}
