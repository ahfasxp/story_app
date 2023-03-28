import 'package:get/get.dart';
import 'package:{{appName.snakeCase()}}/data/remote/remote_date_source.dart';
import 'package:{{appName.snakeCase()}}/data/remote/response/login_result.dart';

class LoginController extends GetxController {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();

  var isLoading = false.obs;
  var hasData = false.obs;
  var isError = false.obs;
  var errorMessage = ''.obs;
  var loginResult = const LoginResult().obs;

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      update();
      final result = await _remoteDataSource.login(email, password);
      loginResult.value = result;
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
