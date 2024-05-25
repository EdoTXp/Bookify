import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimePickerDialogService {
  static Future<TimeOfDay?> showTimePickerDialog(
    BuildContext context, [
    TimeOfDay? initialTime,
  ]) async {
    TimeOfDay? selectedTime;

    if (Platform.isAndroid) {
      selectedTime = await showTimePicker(
        context: context,
        initialTime: initialTime ?? const TimeOfDay(hour: 0, minute: 0),
        helpText: 'Selecione Horas e Minutos',
        hourLabelText: 'Horas',
        minuteLabelText: 'Minutos',
        errorInvalidText: 'Impossível recuperar o tempo',
        cancelText: 'CANCELAR',
        confirmText: 'CONFIRMAR',
      );
    } else if (Platform.isIOS) {
      await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hm,
            onTimerDurationChanged: (duration) {
              selectedTime = TimeOfDay(
                hour: duration.inHours,
                minute: duration.inMinutes,
              );
            },
          );
        },
      );
    }

    return selectedTime;
  }
}
