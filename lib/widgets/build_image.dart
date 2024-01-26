import 'package:flutter/material.dart';

import '../utils/app_images.dart';

class BuildImage {
  static buildProfileImage(String? imagePath, {double width = 50}) {
    return imagePath != null
        ? Image.network(imagePath, width: width)
        : Image.asset(AppImages.basicProfileImagePath, width: width);
  }

  static buildImage(String? imagePath, {double width = 5}){
    return Image.asset(imagePath!, width: width);
  }
}