/*
Created by: Mbaka bilal <mbakabilal.t@gmail.com>
Created on: 19,June,2025
Updated by: Mbaka bilal <mbakabilal.t@gmail.com>
Updated on: 19,June,2025
*/

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class GlobalTickerProvider implements TickerProvider {
  static final GlobalTickerProvider _instance =
      GlobalTickerProvider._internal();

  GlobalTickerProvider._internal();

  factory GlobalTickerProvider() => _instance;

  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}

class DialogHelpers<T> {
  static Future<T?> showAppBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = true,
  }) async {
    if (Platform.isIOS) {
      return showCupertinoModalPopup<T?>(
          context: context, builder: (context) => child);
    }

    return await showModalBottomSheet<T?>(
        context: context,
        isScrollControlled: isScrollControlled,
        transitionAnimationController: AnimationController(
            vsync: GlobalTickerProvider(),
            duration: Duration(milliseconds: 500)),
        builder: (context) => child);
  }

  static Future<T?> showAppDialog<T>(
      {required BuildContext context,
      required Widget child,
      bool dismissible = true}) async {
    return await showAdaptiveDialog<T?>(
        context: context,
        barrierDismissible: dismissible,
        builder: (context) => Dialog(
              child: child,
            ));
  }

  static Future<void> showAppDatePicker({
    required BuildContext context,
    required Function(DateTime newDate) onDateTimeChanged,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) async {
    if (Platform.isIOS) {
      await showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoDatePicker(
                initialDateTime: initialDate,
                minimumDate: firstDate,
                maximumDate: lastDate,
                mode: CupertinoDatePickerMode.date,
                use24hFormat: true,
                showDayOfWeek: false,
                onDateTimeChanged: onDateTimeChanged,
              ));
    } else {
      final date = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
          initialDatePickerMode: DatePickerMode.year);

      if (date != null) {
        onDateTimeChanged(date);
      }
    }
  }

  static Future<void> showAppTimePicker({
    required BuildContext context,
    required Function(TimeOfDay newTime) onTimeChanged,
    required TimeOfDay initialTime,
  }) async {
    if (Platform.isIOS) {
      await showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                use24hFormat: true,
                showDayOfWeek: false,
                onDateTimeChanged: (DateTime date) {
                  onTimeChanged(
                    TimeOfDay(hour: date.hour, minute: date.minute),
                  );
                },
              ));
    } else {
      final time = await showTimePicker(
        context: context,
        initialTime: initialTime,
      );

      if (time != null) {
        onTimeChanged(time);
      }
    }
  }
}
