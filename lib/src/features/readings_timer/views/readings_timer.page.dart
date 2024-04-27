import 'package:bookify/src/features/readings_timer/views/widgets/header.dart';
import 'package:bookify/src/shared/dtos/reading_dto.dart';
import 'package:bookify/src/shared/services/app_services/lock_screen_orientation_service/lock_screen_orientation_service.dart';
import 'package:bookify/src/shared/services/app_services/play_alarm_sound_service/play_alarm_sound_service.dart';
import 'package:bookify/src/shared/services/app_services/time_picker_dialog_service.dart/time_picker_dialog_service.dart';
import 'package:bookify/src/shared/services/app_services/wake_lock_screen_service/wake_lock_screen_service.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_elevated_button.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_outlined_button.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

class ReadingsTimerPage extends StatefulWidget {
  static const routeName = '/readings_timer';

  final ReadingDto readingDto;

  const ReadingsTimerPage({
    super.key,
    required this.readingDto,
  });

  @override
  State<ReadingsTimerPage> createState() => _ReadingsTimerPageState();
}

class _ReadingsTimerPageState extends State<ReadingsTimerPage> {
  late final CountDownController _countDownController;
  late int _timerDuration;
  late bool _timerIsStarted;
  late bool _timerIsStoped;

  @override
  void initState() {
    super.initState();
    LockScreenOrientationService.lockOrientationScreen(
      orientation: Orientation.portrait,
    );

    _countDownController = CountDownController();
    _timerIsStarted = false;
    _timerIsStoped = true;
    _timerDuration = 300;
  }

  @override
  void dispose() {
    LockScreenOrientationService.unLockOrientationScreen();
    WakeLockScreenService.unlockWakeScreen();
    super.dispose();
  }

  Future<void> _editTimer(BuildContext context) async {
    final timeDay = await TimePickerDialogService.showTimePickerDialog(context);

    if (timeDay != null) {
      final durationInSeconds = Duration(
        hours: timeDay.hour,
        minutes: timeDay.minute,
      ).inSeconds;

      if (durationInSeconds > 0) {
        setState(() {
          _timerDuration = durationInSeconds;
          _countDownController.restart(duration: _timerDuration);
          WakeLockScreenService.lockWakeScreen();
          _timerIsStarted = true;
          _timerIsStoped = false;
        });
      }
    }
  }

  void _startTimer() {
    _countDownController.start();
    setState(() {
      _timerIsStarted = true;
      _timerIsStoped = false;
      WakeLockScreenService.lockWakeScreen();
    });
  }

  Future<void> _stopTimer() async {
    _countDownController.reset();
    await PlayAlarmSoundService.stop();

    setState(() {
      _timerIsStoped = true;
      WakeLockScreenService.unlockWakeScreen();
    });
  }

  void _resumeTimer() {
    setState(() {
      _timerIsStarted = true;
    });
    _countDownController.resume();
  }

  void _pauseTimer() {
    setState(() {
      _timerIsStarted = false;
    });
    _countDownController.pause();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final book = widget.readingDto.book;
    final reading = widget.readingDto.reading;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Header(
                  bookTitle: book.title,
                  fistAuthorName: book.authors.first.name,
                  pagesReaded: reading.pagesReaded,
                  pageCount: book.pageCount,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  child: Text(
                    'Editar timer',
                    style: TextStyle(
                      color: colorScheme.secondary,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () async => await _editTimer(context),
                ),
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: CircularCountDownTimer(
                    controller: _countDownController,
                    duration: _timerDuration,
                    height: MediaQuery.sizeOf(context).height * .55,
                    width: MediaQuery.sizeOf(context).width * .85,
                    fillColor: colorScheme.secondary,
                    ringColor: Colors.grey[50]!,
                    backgroundColor: colorScheme.primary.withOpacity(.7),
                    strokeWidth: 20.0,
                    isReverse: true,
                    isReverseAnimation: true,
                    textFormat: CountdownTextFormat.HH_MM_SS,
                    strokeCap: StrokeCap.round,
                    autoStart: false,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    onComplete: () async {
                      WakeLockScreenService.unlockWakeScreen();
                      await PlayAlarmSoundService.playAlarm(1.0);
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _timerIsStoped
                      ? BookifyElevatedButton.expanded(
                          text: 'Começar o timer',
                          suffixIcon: Icons.timer_rounded,
                          onPressed: _startTimer,
                        )
                      : Row(
                          children: [
                            Flexible(
                              child: BookifyOutlinedButton.expanded(
                                text: 'Parar',
                                suffixIcon: Icons.stop_rounded,
                                onPressed: () async => await _stopTimer(),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: BookifyElevatedButton.expanded(
                                text: _timerIsStarted ? 'Pausar' : 'Continuar',
                                suffixIcon: _timerIsStarted
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                onPressed: _timerIsStarted
                                    ? _pauseTimer
                                    : _resumeTimer,
                              ),
                            ),
                          ],
                        ),
                ),
                if (_timerIsStoped)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: BookifyOutlinedButton.expanded(
                      text: 'Concluir e voltar',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}