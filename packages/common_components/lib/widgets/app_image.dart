part of '../common_components.dart';

/// A common image widget that can display network images, asset images,
/// and SVG images (both from network and assets).
///
/// It intelligently decides which widget to use based on the image path.
class CommonImage extends StatelessWidget {
  /// The path to the image. Can be a network URL or a local asset path.
  final String imagePath;

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
  final BoxFit fit;

  final Color? color;

  final String? label;

  final int? cacheHeight;
  final int? cacheWidth;

  /// A builder function that is called if an error occurs during image loading.
  final Widget Function(BuildContext, Object, StackTrace?)? errorWidget;

  const CommonImage({
    super.key,
    required this.imagePath,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.errorWidget,
    this.color,
    this.label="Image",
    this.cacheHeight,
    this.cacheWidth,
  });


  bool get _isSvg => imagePath.toLowerCase().endsWith('.svg');
  bool get _isNetworkImage =>
      imagePath.toLowerCase().startsWith('http://') ||
      imagePath.toLowerCase().startsWith('https://');

  Widget _buildShimmerPlaceholder() {
    return CommonShimmer(
      child: Container(
        width: width,
        height: height,
        color: Colors.white, // The shimmer needs a solid color to animate on.
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) {
      return const CommonImage(
          cacheWidth: 400,
          cacheHeight: 400,
          imagePath: "https://m.media-amazon.com/images/I/41TLQ1ODRJL.__AC_SX300_SY300_QL70_ML2_.jpg");
    }

    defaultErrorWidget(
      BuildContext context,
      Object error,
      StackTrace? stackTrace,
    ) => _buildShimmerPlaceholder();

    if (_isSvg) {
      if (_isNetworkImage) {
        return SvgPicture.network(
          imagePath,
          height: height,
          width: width,
          fit: fit,
          placeholderBuilder: (context) => _buildShimmerPlaceholder(),
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
          semanticsLabel: label,
        );
      } else {
        return SvgPicture.asset(
          imagePath,
          height: height,
          width: width,
          fit: fit,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
          semanticsLabel: label,
        );
      }
    } else if (_isNetworkImage) {
      return Semantics(
        label: label,
        child: CachedNetworkImage(
          imageUrl: imagePath,
          height: height,
          width: width,
          fit: fit,
          memCacheHeight: cacheHeight,
          memCacheWidth: cacheWidth,
          progressIndicatorBuilder: (context, child, loadingProgress) {
            return _buildShimmerPlaceholder();
          },
          errorWidget: (_, __, ___) => const CommonIcon( icon:Icons.broken_image),
        ),
      );
    } else {
      return Image.asset(
        imagePath,
        height: height,
        width: width,
        fit: fit,
        gaplessPlayback: true,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        color: color,
        errorBuilder: errorWidget ?? defaultErrorWidget,
        semanticLabel: label,
      );
    }
  }
}
