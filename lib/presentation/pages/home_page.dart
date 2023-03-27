import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app/presentation/controller/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    _homeController.getStories();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homeController.getStories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          GetBuilder<HomeController>(builder: (dx) {
            return IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () async {
                if (await dx.logout()) {
                  // ignore: use_build_context_synchronously
                  context.go('/login');
                }
              },
            );
          })
        ],
      ),
      body: GetBuilder<HomeController>(
        builder: (dx) {
          if (dx.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (dx.isError.value) {
            return Center(
              child: Text(dx.errorMessage.value),
            );
          } else if (dx.hasData.value) {
            return ListView.builder(
              itemCount: dx.stories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    context.go('/detail-story', extra: dx.stories[index]);
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                dx.stories[index].photoUrl ?? '',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            dx.stories[index].name ?? '',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const SizedBox();
          }
        },
      ),
      floatingActionButton: GetBuilder<HomeController>(
        builder: (dx) {
          return FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              context.go('/add-story');
            },
          );
        },
      ),
    );
  }
}
