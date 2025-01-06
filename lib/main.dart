import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_recepi/controllers/home_controller.dart';
import 'package:food_recepi/controllers/recpei_controller.dart';
import 'package:food_recepi/theme.dart';
import 'package:food_recepi/views/recpei_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async{
  // Initialize controller
   await GetStorage.init();
  Get.put(RecipeController());
  Get.put(HomeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
       minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GetMaterialApp(
        title: 'Recipe App',
        theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
        home: const RecpeiView(),
        debugShowCheckedModeBanner: false,
      )
     
    );
  }
}
