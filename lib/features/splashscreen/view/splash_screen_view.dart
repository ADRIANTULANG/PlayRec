import 'package:audioplayerrecorder/configs/color_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../controller/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashscreenController> {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SplashscreenController());
    return Scaffold(
        body: Padding(
      padding:
          EdgeInsets.only(left: 25.w, right: 25.w, top: 40.h, bottom: 40.h),
      child: Center(
        child: Container(
          height: 30.h,
          width: 70.w,
          decoration: BoxDecoration(
              color: AppColor.mainColors,
              borderRadius: BorderRadius.circular(10)),
          child: Obx(
            () => controller.counter.value.isEven
                ? Icon(
                    Icons.play_circle_fill_rounded,
                    size: 80.sp,
                  )
                : Icon(
                    Icons.pause_circle_filled_rounded,
                    size: 80.sp,
                  ),
          ),
        ),
      ),
    )
        // Container(
        //   height: 100.h,
        //   width: 100.w,
        //   child: Center(child: Image.asset("assets/images/splashscreen.png")),
        // ),
        );
  }
}
