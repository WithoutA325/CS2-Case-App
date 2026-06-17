import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Cs2Image extends StatelessWidget {
  const Cs2Image({
    super.key,
    required this.url,
    this.fit = BoxFit.contain,
    this.padding = const EdgeInsets.all(12),
  });

  final String url;
  final BoxFit fit;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return const Center(child: Icon(Icons.image_not_supported_outlined));
    }

    return Padding(
      padding: padding,
      child: CachedNetworkImage(
        imageUrl: url,
        fit: fit,
        placeholder: (context, url) => const Center(
          child: SizedBox.square(
            dimension: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) =>
            const Center(child: Icon(Icons.broken_image_outlined)),
      ),
    );
  }
}
