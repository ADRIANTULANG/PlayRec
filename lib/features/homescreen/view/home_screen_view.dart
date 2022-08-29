import 'package:audioplayerrecorder/configs/color_class.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../audioscreen/view/audio_view.dart';
import '../controller/home_screen_controller.dart';
import '../dialogs/home_screen_dialog.dart';

class HomeScreenView extends GetView<HomeScreenController> {
  const HomeScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HomeScreenController());
    return Scaffold(
      // backgroundColor: Colors.black,
      body: Container(
        height: 100.h,
        width: 100.w,
        child: Column(
          children: [
            SizedBox(
              height: 6.h,
            ),
            Container(
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
              height: 6.h,
              width: 100.w,
              child: TextField(
                controller: controller.search,
                obscureText: false,
                onChanged: (value) {
                  controller.searchFileName(word: controller.search.text);
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9)),
                    labelText: 'Search Record',
                    hintText: 'Record Name',
                    hintStyle: TextStyle(fontSize: 12.sp),
                    labelStyle: TextStyle(fontSize: 12.sp)),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Container(
              // color: Colors.red,
              child: Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        "Recordings",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 30.sp,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (controller.recorder.isRecording) {
                          await controller.stop();
                        } else {
                          await controller.record();
                        }
                      },
                      child: Obx(
                        () => controller.isCurrentlyRecording.value == false
                            ? Icon(
                                Icons.stop,
                                size: 30.sp,
                              )
                            : Icon(
                                Icons.mic,
                                size: 30.sp,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => controller.listBar.length == 0
                  ? SizedBox()
                  : Padding(
                      padding: EdgeInsets.only(left: 5.w, right: 5.w),
                      child: Container(
                        height: 25.h,
                        child: Obx(
                          () => ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.listBar.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: 2.w,
                                    top: controller.listBar[index].height),
                                child: Container(
                                  height: 25.h,
                                  width: 5.w,
                                  decoration: BoxDecoration(
                                      color: controller.listBar[index].color,
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
            ),
            Expanded(
                child: Container(
              // color: Colors.red,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 5.w,
                  right: 5.w,
                ),
                child: Obx(
                  () => controller.file_List.length == 0
                      ? Obx(
                          () => controller.isCurrentlyRecording.value == true
                              ? SizedBox()
                              : Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Sorry. No available Audio.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.sp),
                                  ),
                                ),
                        )
                      : Obx(
                          () => ListView.builder(
                            // shrinkWrap: true,
                            itemCount: controller.file_List.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
                                child: InkWell(
                                  onTap: () {
                                    Get.to(() => AudioScreenView(), arguments: {
                                      'filePath':
                                          controller.file_List[index].filePath,
                                      'fileName':
                                          controller.file_List[index].fileName,
                                    });
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: 1.w, top: 1.w),
                                    height: 8.h,
                                    width: 100.w,
                                    // decoration: BoxDecoration(
                                    //   borderRadius: BorderRadius.circular(10),
                                    //   color: AppColor.mainColors,
                                    // ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.play_circle,
                                              size: 15.sp,
                                              color: AppColor.mainColors,
                                            ),
                                            SizedBox(
                                              width: 1.w,
                                            ),
                                            Expanded(
                                              child: Text(
                                                controller
                                                    .file_List[index].fileName,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 11.sp,
                                                ),
                                              ),
                                            ),
                                            PopupMenuButton(
                                              child: Icon(
                                                Icons.more_vert_rounded,
                                                size: 15.sp,
                                              ),
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                    enabled: false,
                                                    value: 1,
                                                    // row with 2 children
                                                    child: InkWell(
                                                      onTap: () {
                                                        HomeScreenDialog
                                                            .showDialogForDeleteFile(
                                                                controller:
                                                                    controller,
                                                                fileTemporaryPath:
                                                                    controller
                                                                        .file_List[
                                                                            index]
                                                                        .filePath);
                                                      },
                                                      child: Text(
                                                        "Delete",
                                                        style: TextStyle(
                                                            fontSize: 11.sp,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    )),
                                                PopupMenuItem(
                                                    enabled: false,
                                                    value: 2,
                                                    child: InkWell(
                                                      onTap: () {
                                                        controller
                                                            .fileNameToRename
                                                            .clear();
                                                        HomeScreenDialog
                                                            .showDialogForRename(
                                                                controller:
                                                                    controller,
                                                                fileTemporaryPath:
                                                                    controller
                                                                        .file_List[
                                                                            index]
                                                                        .filePath);
                                                      },
                                                      child: Text(
                                                        "Rename",
                                                        style: TextStyle(
                                                            fontSize: 11.sp,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.folder_copy_sharp,
                                              size: 15.sp,
                                            ),
                                            SizedBox(
                                              width: 1.w,
                                            ),
                                            Expanded(
                                              child: Text(
                                                controller
                                                    .file_List[index].filePath,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 9.sp,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
