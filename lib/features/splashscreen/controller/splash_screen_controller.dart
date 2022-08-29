import 'dart:async';

import 'package:get/get.dart';

import '../../homescreen/view/home_screen_view.dart';

class SplashscreenController extends GetxController {
  @override
  void onInit() {
    splashScreenDelay();
    setTime();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  RxInt counter = 0.obs;

  Timer? time;

  setTime() {
    time = Timer.periodic(Duration(seconds: 1), (timer) {
      counter.value++;
      if (counter == 9) {
        print(counter);
        timer.cancel();
        time!.cancel();
      }
    });
  }

  splashScreenDelay() {
    Timer(Duration(seconds: 8), () {
      Get.offAll(() => HomeScreenView());
    });
  }
}
