import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:story_app/data/remote/remote_date_source.dart';

class AddStoryController extends GetxController {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();

  var isLoading = false.obs;
  var hasData = false.obs;
  var isError = false.obs;
  var errorMessage = ''.obs;

  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

  setLatLong(double lat, double long) {
    latitude.value = lat;
    longitude.value = long;
    update();
  }

  Future<void> addStory(
    String description,
    File photo,
    double? lat,
    double? lon,
  ) async {
    try {
      isLoading.value = true;
      update();
      File? compressPhoto = await compressImage(photo);
      await _remoteDataSource.addNewStory(
        description,
        compressPhoto!,
        lat,
        lon,
      );
      hasData.value = true;
      update();
    } catch (e) {
      errorMessage.value = e.toString();
      isError.value = true;
      update();
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<File?> compressImage(File? imageFile) async {
    if (imageFile == null) return null;

    // get original image file size
    final originalSize = await imageFile.length();

    // compress image if original size > 1 MB
    if (originalSize > 1000000) {
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        '${imageFile.parent.path}/compressed_${imageFile.path.split('/').last}',
        quality: 70, // adjust quality to get desired file size
      );
      return compressedFile;
    } else {
      return imageFile;
    }
  }
}
