part of flutter_nav2_oop;

class ImageFile extends StatelessWidget {

  final File imageFile;
  final double missingImageIconSize;
  final String? waitText;
  final bool waitCursorCentered;
  final Size? boxSize;

  final double scale;
  final ImageFrameBuilder? frameBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final String? semanticLabel;
  final bool excludeFromSemantics;
  final double? width;
  final double? height;
  final Color? color;
  final Animation<double>? opacity;
  final BlendMode? colorBlendMode;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final ImageRepeat repeat;
  final Rect? centerSlice;
  final bool matchTextDirection;
  final bool gaplessPlayback;
  final bool isAntiAlias;
  final FilterQuality filterQuality;

  const ImageFile(this.imageFile, {
    this.waitText = "Loading image...",
    this.missingImageIconSize = 25,
    this.waitCursorCentered = true,
    this.boxSize,

    this.scale = 1.0,
    this.frameBuilder,
    this.errorBuilder,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.width,
    this.height,
    this.color,
    this.opacity,
    this.colorBlendMode,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.isAntiAlias = false,
    this.filterQuality = FilterQuality.low,
    super.key
  });

  @override
  Widget build(BuildContext context) {

    final Size box = boxSize ?? MediaQuery.of(context).size;
    final int? cacheWidth = box.width > box.height ? box.width.toInt() : null;
    final int? cacheHeight = cacheWidth == null ? box.height.toInt() : null;

    return BetterFutureBuilder<Uint8List?>(
        future: _readImageBytes(),
        waitText: waitText,
        waitCursorCentered: waitCursorCentered,
        builder: (imageBytes, ctx) =>
        imageBytes == null ?
        Icon(
            Icons.broken_image_outlined,
            size: missingImageIconSize,
            semanticLabel: "Image not found"
        )
            : Image.memory(imageBytes,
            scale: scale,
            frameBuilder: frameBuilder,
            errorBuilder: errorBuilder,
            semanticLabel: semanticLabel,
            excludeFromSemantics: excludeFromSemantics,
            width: width,
            height: height,
            color: color,
            opacity: opacity,
            colorBlendMode: colorBlendMode,
            fit: fit,
            alignment: alignment,
            repeat: repeat,
            centerSlice: centerSlice,
            matchTextDirection: matchTextDirection,
            gaplessPlayback: gaplessPlayback,
            isAntiAlias: isAntiAlias,
            filterQuality: filterQuality,
            cacheWidth: cacheWidth,
            cacheHeight: cacheHeight
        )
    );
  }

  Future<Uint8List?> _readImageBytes() async {
    //await Future.delayed(const Duration(seconds: 2));
    if(await imageFile.exists()) return await imageFile.readAsBytes();
    return null;
  }
}