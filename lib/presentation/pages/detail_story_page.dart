import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailStoryPage extends StatelessWidget {
  const DetailStoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final name = Get.parameters['name'];
    final imageUrl = Get.parameters['imageUrl'];
    final description = Get.parameters['description'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Detail'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl ?? ''),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name ?? 'user_name',
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                Text(description ?? ''),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
