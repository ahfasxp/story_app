import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_app/presentation/controller/home_controller.dart';
import 'package:story_app/presentation/pages/add_story_page.dart';
import 'package:story_app/presentation/pages/detail_story_page.dart';
import 'package:story_app/presentation/pages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                  Get.off(() => const LoginPage());
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
                    Get.to(() => DetailStoryPage(
                          name: dx.stories[index].name ?? '',
                          imageUrl: dx.stories[index].photoUrl ?? '',
                          description: dx.stories[index].description ?? '',
                        ));
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
            onPressed: () async {
              await Get.to(() => const AddStoryPage());
              dx.getStories();
            },
          );
        },
      ),
    );
  }
}
