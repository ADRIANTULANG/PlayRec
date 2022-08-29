import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../controller/audio_controller.dart';

class AudioScreenView extends GetView<AudioScreenController> {
  const AudioScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AudioScreenController());
    return Scaffold(
      body: Container(
        height: 100.h,
        width: 100.w,
        padding: EdgeInsets.only(left: 5.w, right: 5.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
              child: Container(
                height: 25.h,
                width: 100.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/imageMusic.jpg"))),
              ),
            ),
            Obx(
              () => controller.listBar.length == 0
                  ? SizedBox(
                      height: 5.h,
                    )
                  : Container(
                      height: 25.h,
                      // color: Colors.purple,
                      child: Obx(
                        () => ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
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
            SizedBox(
              height: 2.h,
            ),
            Text(
              "Recorded Audio",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
            Obx(
              () => Slider(
                  min: 0,
                  max: controller.durationRxValue.value,
                  value: controller.positionRxValue.value,
                  onChanged: (double value) async {
                    final position = Duration(seconds: value.toInt());
                    await controller.audioPlayer.seek(position);
                    await controller.audioPlayer.resume();
                    if (controller.isCurrentlyRecording.value == true) {
                      await controller.stop();
                    } else {
                      await controller.record();
                    }
                  }),
            ),
            Padding(
              padding: EdgeInsets.only(left: 6.w, right: 7.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(controller.formatTime(
                      duration: controller.position.value))),
                  Obx(
                    () => Text(controller.formatTime(
                        duration: controller.duration.value -
                            controller.position.value)),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 35,
              child: IconButton(
                onPressed: () async {
                  if (controller.isPlaying.value) {
                    await controller.audioPlayer.pause();
                    controller.stop();
                  } else {
                    await controller.audioPlayer.resume();
                    controller.record();
                  }
                },
                icon: Obx(() => controller.isPlaying.value == true
                    ? Icon(Icons.pause)
                    : Icon(Icons.play_arrow)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
