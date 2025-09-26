import 'package:intl/intl.dart';

extension DateExtensions on DateTime {
  String get dayShortMonthYear => DateFormat("dd MMM yyyy").format(this);
  String get dayShortMonthYearWithTime => DateFormat("dd MMM yyyy (HH:mm)").format(this);

}