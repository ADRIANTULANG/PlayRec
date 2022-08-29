import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_sound/flutter_sound.dart' as soundRecorder;
import 'package:get/get.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../homescreen/model/colorModel.dart';

class AudioScreenController extends GetxController {
  final audioPlayer = AudioPlayer();
  final recorder = soundRecorder.FlutterSoundRecorder();
  RxBool isPlaying = false.obs;
  RxBool recorderReady = false.obs;
  RxBool isCurrentlyRecording = false.obs;
  var duration = Duration.zero.obs;
  var position = Duration.zero.obs;

  RxDouble durationRxValue = 0.0.obs;
  RxDouble positionRxValue = 0.0.obs;
  RxString filePath = "".obs;
  RxString fileName = "".obs;

  RxList<BarColor> listBar = <BarColor>[].obs;

  @override
  void onInit() async {
    filePath.value = await Get.arguments['filePath'].toString();
    fileName.value = await Get.arguments['fileName'].toString();
    print(filePath.value.split(": ")[1].replaceAll("'", " ").toString().trim());
    var finalValue =
        filePath.value.split(": ")[1].replaceAll("'", " ").toString().trim();
    print(fileName.value);
    audioPlayer_listener_State();
    audioPlayer_listener_durationChanges();
    audioPlayer_listener_positioned();
    await initRecord();
    listenEvent();
    await setToPlayAudio(filePath: finalValue);
    super.onInit();
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    recorder.closeRecorder();
    super.onClose();
  }

  Future initRecord() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
    } else {
      await recorder.openRecorder();
      recorderReady.value = true;
      recorder.setSubscriptionDuration(Duration(milliseconds: 500));
    }
  }

  Future record() async {
    listBar.clear();
    if (recorderReady.value == true) {
      await recorder.startRecorder(toFile: 'audio.aac');
    } else {
      print(recorderReady.value);
      return;
    }
    isCurrentlyRecording.value = recorder.isRecording;
  }

  Future stop() async {
    if (recorderReady.value == true) {
      await recorder.stopRecorder();
      isCurrentlyRecording.value = recorder.isRecording;
    } else {
      print(recorderReady.value);
      return;
    }
    isCurrentlyRecording.value = recorder.isRecording;
    listBar.clear();
  }

  audioPlayer_listener_State() {
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.PLAYING) {
        isPlaying.value = true;
      } else {
        isPlaying.value = false;
        stop();
      }
    });
  }

  audioPlayer_listener_durationChanges() {
    audioPlayer.onDurationChanged.listen((Duration newduration) {
      duration.value = newduration;
      durationRxValue.value = duration.value.inSeconds.toDouble();
      print("duration: ${duration.value}");
    });
  }

  audioPlayer_listener_positioned() {
    audioPlayer.onAudioPositionChanged.listen((Duration newDurationPositioned) {
      position.value = newDurationPositioned;
      positionRxValue.value = position.value.inSeconds.toDouble();
    });
  }

  setToPlayAudio({required String filePath}) {
    audioPlayer.setReleaseMode(ReleaseMode.STOP);
    audioPlayer.setUrl(filePath, isLocal: true);
    record();
    audioPlayer.resume();
  }

  String formatTime({required Duration duration}) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(":");
  }

  listenEvent() {
    recorder.onProgress!.listen((soundRecorder.RecordingDisposition data) {
      Random rnd = new Random();
      int min = 0, max = 4;
      int r = min + rnd.nextInt(max - min);
      print("random number: $r");
      print("decibels: ${data.decibels}");
      double decibel = data.decibels!;
      var finalOutputHeight = 0.0;
      if (decibel < 20) {
        finalOutputHeight = 0;
      } else if (decibel > 20 && decibel < 30) {
        finalOutputHeight = 1;
      } else if (decibel > 30 && decibel < 40) {
        finalOutputHeight = 2;
      } else if (decibel > 40 && decibel < 50) {
        finalOutputHeight = 3;
      } else if (decibel > 50 && decibel < 60) {
        finalOutputHeight = 4;
      } else if (decibel > 70 && decibel < 80) {
        finalOutputHeight = 5;
      } else if (decibel > 80 && decibel < 90) {
        finalOutputHeight = 6;
      } else if (decibel > 90 && decibel < 100) {
        finalOutputHeight = 7;
      }
      willAddingBar(index: r, height: finalOutputHeight);
    });
  }

  willAddingBar({required int index, required double height}) {
    Color finalIndexColor = index == 0
        ? Colors.red
        : index == 1
            ? Colors.blue
            : index == 2
                ? Colors.black
                : index == 3
                    ? Colors.lightBlue
                    : index == 4
                        ? Colors.redAccent
                        : Colors.pink;
    double finalIndexHeight = height == 7
        ? 5.h
        : height == 6
            ? 7.h
            : height == 5
                ? 9.h
                : height == 4
                    ? 11.h
                    : height == 3
                        ? 13.h
                        : height == 2
                            ? 15.h
                            : height == 1
                                ? 17.h
                                : height == 0
                                    ? 18.h
                                    : 19.h;
    if (listBar.length == 13) {
      listBar.removeAt(0);
    }
    listBar.add(BarColor(color: finalIndexColor, height: finalIndexHeight));
  }
}
