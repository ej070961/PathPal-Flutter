import 'package:flutter/material.dart';

class BuildImage {
  static Widget buildImage(String path, {double width = 5}) {
    return Image(image: AssetImage(path), width: width);
  }
}