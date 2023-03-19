import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:story_app/data/remote/response/login_result.dart';
import 'package:story_app/presentation/controller/login_controller.dart';
import 'package:story_app/presentation/pages/home_page.dart';
import 'package:story_app/presentation/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GetStorage _getStorage = GetStorage();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: GetBuilder<LoginController>(
        builder: (dx) {
          if (dx.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      String email = _emailController.text;
                      String password = _passwordController.text;
                      await dx.login(email, password);
                      if (dx.hasData.value) {
                        LoginResult loginResult = dx.loginResult.value;
                        _getStorage.write('token', loginResult.token);
                        Get.off(() => const HomePage());
                      } else {
                        String errorMessage = dx.errorMessage.value;
                        Get.snackbar(
                          'Terjadi Kesalahan',
                          errorMessage,
                        );
                      }
                    },
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 10.0),
                  TextButton(
                    onPressed: () {
                      Get.to(() => const RegisterPage());
                    },
                    child: const Text('Don\'t have an account? Register here'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
