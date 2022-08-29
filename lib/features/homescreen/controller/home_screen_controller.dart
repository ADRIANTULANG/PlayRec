import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
// import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:sizer/sizer.dart';
import '../../../configs/color_class.dart';
import '../model/colorModel.dart';

class HomeScreenController extends GetxController {
  final recorder = FlutterSoundRecorder();
  RxBool recorderReady = false.obs;
  RxBool isCurrentlyRecording = false.obs;
  RxList<BarColor> listBar = <BarColor>[].obs;
  RxList<FileList> file_List = <FileList>[].obs;
  RxList<FileList> file_List_masterList = <FileList>[].obs;
  TextEditingController fileNameToRename = TextEditingController();
  TextEditingController search = TextEditingController();

  @override
  void onInit() async {
    await initRecord();
    listenEvent();
    listofFiles();
    super.onInit();
  }

  @override
  void onClose() {
    recorder.closeRecorder();
    super.onClose();
  }

  listofFiles() async {
    file_List.clear();
    var directory =
        (await getExternalStorageDirectories(type: StorageDirectory.music))!
            .first;

    RxList fileList = await Directory(directory.path).listSync().obs;
    // await fileList.reversed;

    for (var i = 0; i < fileList.length; i++) {
      print(fileList[i]);
      var splitFileName = fileList[i].toString().split('/');
      print(splitFileName[9]);
      file_List.add(FileList(
          filePath: fileList[i].toString(),
          fileName: splitFileName[9].toString()));
    }
    RxList<FileList> listTemp = new RxList<FileList>.from(file_List.reversed);
    file_List.assignAll(listTemp);
    file_List_masterList.assignAll(file_List);
    // await file_List.reversed.toList();
  }

  searchFileName({required String word}) {
    if (word.trim().toString() != "" || word.isNotEmpty) {
      file_List.assignAll(file_List_masterList
          .where((u) => (u.fileName
              .toString()
              .toLowerCase()
              .contains(word.toLowerCase())))
          .toList());
    } else {
      file_List.assignAll(file_List_masterList);
    }
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
      final path = await recorder.stopRecorder();

      File audioFile = File(path!);

      var directory =
          (await getExternalStorageDirectories(type: StorageDirectory.music))!
              .first;

      File newfile = File(
          await directory.path + "/" + "new_Recording ${DateTime.now()}.aac");
      Uint8List bytes = await audioFile.readAsBytes();
      newfile.writeAsBytes(bytes);

      isCurrentlyRecording.value = recorder.isRecording;
    } else {
      print(recorderReady.value);

      return;
    }
    isCurrentlyRecording.value = recorder.isRecording;
    listBar.clear();
    await listofFiles();
  }

  listenEvent() {
    recorder.onProgress!.listen((RecordingDisposition data) {
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

  changeFileNameOnly(
      {required String fileTemporaryPath, required String newName}) async {
    var filePath =
        fileTemporaryPath.split(": ")[1].replaceAll("'", " ").toString().trim();
    print(filePath);
    File newFile = await File(filePath);
    var path = newFile.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newName + ".aac";
    newFile.rename(newPath);
    await listofFiles();
    Get.snackbar("Message", "Successfully Renamed");
  }

  deleteFileFromDirectory({required String fileTemporaryPath}) async {
    var filePath =
        fileTemporaryPath.split(": ")[1].replaceAll("'", " ").toString().trim();
    print(filePath);
    File newFile = await File(filePath);
    var path = newFile.path;
    final dir = Directory(path);
    dir.deleteSync(recursive: true);
    await listofFiles();
    Get.snackbar("Message", "Successfully Deleted");
  }

  showDialogForRename({required String fileTemporaryPath}) {
    Get.dialog(AlertDialog(
      content: Container(
        color: AppColor.mainColors,
        height: 10.h,
        width: 100.w,
        child: Column(
          children: [Text("data")],
        ),
      ),
    ));
  }
}
