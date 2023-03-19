import 'package:get/get.dart';
import 'package:story_app/presentation/controller/add_story_controller.dart';
import 'package:story_app/presentation/controller/home_controller.dart';
import 'package:story_app/presentation/controller/login_controller.dart';
import 'package:story_app/presentation/controller/register_controller.dart';

class MainBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
    Get.put(RegisterController());
    Get.put(HomeController());
    Get.put(AddStoryController());
  }
}
