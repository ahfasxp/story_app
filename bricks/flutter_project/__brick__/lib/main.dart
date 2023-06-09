import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:{{appName.snakeCase()}}/data/remote/response/story_result.dart';
import 'package:{{appName.snakeCase()}}/presentation/pages/add_story_page.dart';
import 'package:{{appName.snakeCase()}}/presentation/pages/detail_story_page.dart';
import 'package:{{appName.snakeCase()}}/presentation/pages/home_page.dart';
import 'package:{{appName.snakeCase()}}/presentation/pages/login_page.dart';
import 'package:{{appName.snakeCase()}}/presentation/pages/picker_map_page.dart';
import 'package:{{appName.snakeCase()}}/presentation/pages/register_page.dart';

Future<void> main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  /// The route configuration.
  final GoRouter _router = GoRouter(
    initialLocation: (GetStorage().read('token') != null) ? '/' : '/login',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
        routes: [
          GoRoute(
            path: 'detail-story',
            builder: (BuildContext context, GoRouterState state) =>
                DetailStoryPage(storyResult: state.extra! as StoryResult),
          ),
          GoRoute(
            path: 'add-story',
            builder: (BuildContext context, GoRouterState state) {
              return const AddStoryPage();
            },
            routes: [
              GoRoute(
                path: 'picker-map',
                builder: (BuildContext context, GoRouterState state) {
                  return const PickerMapPage();
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
        routes: [
          GoRoute(
            path: 'register',
            builder: (BuildContext context, GoRouterState state) {
              return const RegisterPage();
            },
          ),
        ],
      ),
    ],
  );

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '{{appName.titleCase()}}',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
    );
  }
}
