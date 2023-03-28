import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:{{appName.snakeCase()}}/presentation/controller/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _homeController = Get.put(HomeController());
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    /// todo-02-03:set the listener to listen the scroll behaviour
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        /// todo-02-04: run the getQuotes method to call the API request
        /// todo-04-02: run the getQuotes mehtod when pageItems is not null
        if (_homeController.pageItems != null) {
          _homeController.getStories();
        }
      }
    });

    _homeController.getStories();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homeController.pageItems = 1;
    _homeController.stories.clear();
    _homeController.update();

    _homeController.getStories();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
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
            final stories = dx.stories;
            return ListView.builder(
              controller: scrollController,
              itemCount: stories.length + (dx.pageItems != null ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == stories.length && dx.pageItems != null) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

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
                                stories[index].photoUrl ?? '',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            stories[index].name ?? '',
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
