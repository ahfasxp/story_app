import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:story_app/main_biding.dart';
import 'package:story_app/presentation/pages/home_page.dart';
import 'package:story_app/presentation/pages/login_page.dart';

Future<void> main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GetStorage _getStorage = GetStorage();

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Story_App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialBinding: MainBinding(),
      home: (_getStorage.read('token') != null)
          ? const HomePage()
          : const LoginPage(),
    );
  }
}
