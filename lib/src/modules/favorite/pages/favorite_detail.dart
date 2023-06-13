import 'package:app_mari/src/components/open_image_component.dart';
import 'package:app_mari/src/modules/home/components/home_image_detail.dart';
import 'package:flutter/material.dart';

class FavoriteDetail extends StatelessWidget {
  final ImageDetailInterface detail;
  const FavoriteDetail({required this.detail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OpenImageComponent(detail: detail),
    );
  }
}
