import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../controller/home_screen_controller.dart';

class HomeScreenDialog {
  static showDialogForRename(
      {required HomeScreenController controller,
      required String fileTemporaryPath}) {
    Get.dialog(AlertDialog(
      contentPadding: EdgeInsets.all(0),
      content: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.only(top: 1.h),
        height: 15.h,
        width: 100.w,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
              height: 6.h,
              width: 100.w,
              child: TextField(
                obscureText: false,
                controller: controller.fileNameToRename,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9)),
                    labelText: 'Enter New Record Name',
                    hintText: 'Enter New Record Name',
                    hintStyle: TextStyle(fontSize: 12.sp),
                    labelStyle: TextStyle(fontSize: 12.sp)),
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            TextButton(
                onPressed: () {
                  if (controller.fileNameToRename.text.trim().toString() ==
                          "" ||
                      controller.fileNameToRename.text.isEmpty) {
                    Get.back();
                    Get.snackbar("Message", "Name must not be empty");
                  } else {
                    controller.changeFileNameOnly(
                        newName: controller.fileNameToRename.text,
                        fileTemporaryPath: fileTemporaryPath);
                    Get.back();
                  }
                },
                child: Text(
                  "Confirm",
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                ))
          ],
        ),
      ),
    ));
  }

  static showDialogForDeleteFile(
      {required HomeScreenController controller,
      required String fileTemporaryPath}) {
    Get.dialog(AlertDialog(
      contentPadding: EdgeInsets.all(0),
      content: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.only(top: 1.h),
        height: 15.h,
        width: 100.w,
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                height: 6.h,
                width: 100.w,
                alignment: Alignment.center,
                child: Text(
                  "Are you sure you want to delete this audio?",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 13.sp),
                )),
            SizedBox(
              height: 1.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      controller.deleteFileFromDirectory(
                          fileTemporaryPath: fileTemporaryPath);
                      Get.back();
                    },
                    child: Text(
                      "Confirm",
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w500),
                    )),
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "Back",
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w500),
                    )),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
