import 'package:audioplayerrecorder/configs/color_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'features/splashscreen/view/splash_screen_view.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: AppColor.mainColors,
        ),
        home: SplashScreenView(),
      );
    });
  }
}
