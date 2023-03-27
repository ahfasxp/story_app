import 'package:flutter/material.dart';
import 'package:story_app/data/remote/response/story_result.dart';

class DetailStoryPage extends StatelessWidget {
  final StoryResult storyResult;

  const DetailStoryPage({super.key, required this.storyResult});

  @override
  Widget build(BuildContext context) {
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
                image: NetworkImage(storyResult.photoUrl ?? ''),
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
                  storyResult.name ?? 'user_name',
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                Text(storyResult.description ?? ''),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
