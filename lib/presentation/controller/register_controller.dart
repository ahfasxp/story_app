import 'package:get/get.dart';
import 'package:story_app/data/remote/remote_date_source.dart';

class RegisterController extends GetxController {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();

  var isLoading = false.obs;
  var hasData = false.obs;
  var isError = false.obs;
  var errorMessage = ''.obs;

  Future<void> register(String name, String email, String password) async {
    try {
      isLoading.value = true;
      update();
      await _remoteDataSource.register(name, email, password);
      hasData.value = true;
      update();
    } catch (e) {
      errorMessage.value = e.toString();
      isError.value = true;
      update();
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
