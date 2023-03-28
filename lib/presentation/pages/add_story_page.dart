import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_app/presentation/controller/add_story_controller.dart';

class AddStoryPage extends StatefulWidget {
  final LatLng? latLng;
  const AddStoryPage({super.key, this.latLng});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  final AddStoryController _addStoryController = Get.put(AddStoryController());
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lonController = TextEditingController();

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
  void initState() {
    super.initState();
    debugPrint(widget.latLng.toString());
    if (widget.latLng != null) {
      _latController.text = widget.latLng!.latitude.toString();
      _lonController.text = widget.latLng!.longitude.toString();
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    _latController.dispose();
    _lonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Story'),
      ),
      body: GetBuilder<AddStoryController>(
        builder: (dx) {
          return SingleChildScrollView(
            child: Padding(
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
                                  context.pop();
                                  _pickImage(ImageSource.camera);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.image),
                                title: const Text('Choose from gallery'),
                                onTap: () {
                                  context.pop();
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
                          ? const Center(
                              child: Icon(Icons.camera_alt, size: 64))
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
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _latController,
                          decoration: const InputDecoration(
                            labelText: 'Latitude (optional)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _lonController,
                          decoration: const InputDecoration(
                            labelText: 'Longitude (optional)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  TextButton(
                    child: const Text('Gunakan Peta'),
                    onPressed: () {
                      context.go('/picker-map');
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      String desc = _descController.text;
                      double? lat = double.tryParse(_latController.text);
                      double? lon = double.tryParse(_lonController.text);
                      if (_image == null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Please select photo first'),
                        ));
                      } else if (desc == '') {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Please input description first'),
                        ));
                      } else {
                        await dx.addStory(
                          desc,
                          _image!,
                          lat,
                          lon,
                        );
                        if (dx.hasData.value) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Add Story Successfully'),
                          ));
                          // ignore: use_build_context_synchronously
                          context.go('/');
                        } else {
                          String errorMessage = dx.errorMessage.value;
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(errorMessage),
                          ));
                        }
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
