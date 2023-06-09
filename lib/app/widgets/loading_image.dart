import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mataajer_saudi/app/utils/log.dart';

class LoadingImage extends StatelessWidget {
  const LoadingImage({
    super.key,
    required this.src,
    this.height = double.infinity,
    this.width = double.infinity,
    this.fit = BoxFit.cover,
  });

  final String? src;

  final double? height;
  final double? width;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    log("LoadingImage: $src");
    if (src == null) {
      return Image.asset('assets/images/no_img_av.jpg');
    }
    return FadeInImage(
      placeholderErrorBuilder: ((context, error, stackTrace) {
        return const LoadingImage(src: "assets/images/spinner.gif");
      }),
      placeholder: const AssetImage(
        "assets/images/spinner.gif",
      ),
      image: CachedNetworkImageProvider(src!),
      placeholderFit: BoxFit.cover,
      fit: fit ?? BoxFit.cover,
      imageErrorBuilder: (context, obj, stack) {
        return const LoadingImage(src: "assets/images/spinner.gif");
      },
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 300),
      height: height,
      width: width,
    );
  }
}
