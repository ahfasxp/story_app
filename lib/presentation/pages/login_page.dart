import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app/data/remote/response/login_result.dart';
import 'package:story_app/presentation/controller/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController _loginController = Get.put(LoginController());
  final GetStorage _getStorage = GetStorage();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
                        // ignore: use_build_context_synchronously
                        context.go('/');
                      } else {
                        String errorMessage = dx.errorMessage.value;
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(errorMessage),
                        ));
                      }
                    },
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 10.0),
                  TextButton(
                    onPressed: () {
                      context.go('/login/register');
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
