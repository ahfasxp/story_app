import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_app/presentation/controller/add_story_controller.dart';

class AddStoryPage extends StatefulWidget {
  const AddStoryPage({super.key});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  final _picker = ImagePicker();

  final TextEditingController _descController = TextEditingController();

  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Story'),
      ),
      body: GetBuilder<AddStoryController>(
        builder: (dx) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.camera),
                              title: const Text('Take a photo'),
                              onTap: () {
                                Get.back();
                                _pickImage(ImageSource.camera);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.image),
                              title: const Text('Choose from gallery'),
                              onTap: () {
                                Get.back();
                                _pickImage(ImageSource.gallery);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: _image == null
                        ? const Center(child: Icon(Icons.camera_alt, size: 64))
                        : Image.file(_image!, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _descController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    String desc = _descController.text;
                    if (_image == null) {
                      Get.snackbar(
                        'Terjadi Kesalahan',
                        'Please select photo first',
                      );
                    } else if (desc == '') {
                      Get.snackbar(
                        'Terjadi Kesalahan',
                        'Please input description first',
                      );
                    } else {
                      await dx.addStory(
                        desc,
                        _image!,
                      );
                      if (dx.hasData.value) {
                        Get.back();
                      } else {
                        String errorMessage = dx.errorMessage.value;
                        Get.snackbar(
                          'Terjadi Kesalahan',
                          errorMessage,
                        );
                      }
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
