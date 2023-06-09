import 'package:app_mari/src/ui/styles/colors_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class LayoutImage extends StatefulWidget {
  final List<Map> images;
  final Function(int index) onPressed;
  const LayoutImage({super.key, required this.images, required this.onPressed});

  @override
  State<LayoutImage> createState() => _LayoutImageState();
}

class _LayoutImageState extends State<LayoutImage> {
  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
      crossAxisSpacing: 8,
      mainAxisSpacing: 6,
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: widget.images.length,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => widget.onPressed(index),
          child: Hero(
            tag: index.toString(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  Image.network(
                    widget.images[index]['imagePath'],
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/image-found.jpg');
                    },
                    fit: BoxFit.cover,
                  ),
                  Visibility(
                    visible: widget.images[index]['isFavorite'] == '1',
                    child: Positioned(
                      left: 10,
                      top: 10,
                      child: Icon(
                        Icons.favorite_rounded,
                        color: context.colors.secondary,
                        size: 25,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
