import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    this.color = Colors.grey,
    this.fit = BoxFit.fill,
    this.height,
    this.path,
    this.url,
    this.width,
    this.filePath,
    this.iconColor,
    this.isFullScreen = false,
    this.borderRadius,
  });

  final String? path;
  final String? filePath;
  final String? url;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Color color;
  final Color? iconColor;
  final bool isFullScreen;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular((borderRadius ?? 0)),
      child: LayoutBuilder(
          builder: (context, constraints) => Container(
                constraints: BoxConstraints(
                    maxHeight: constraints.maxWidth * .7, maxWidth: constraints.maxWidth),
                child: _buildImage(context),
              )),
    );
  }

  Widget _buildImage(BuildContext context) {
    const fill = BoxFit.cover;
    // File image
    if (filePath != null) {
      final child = Image.file(
        File(filePath!),
        width: width,
        height: height,
        fit: fill,
        errorBuilder: (context, error, stackTrace) {
          log("Error loading file image: $error");
          return _errorPlaceholder();
        },
      );
      if (isFullScreen) {
        return GestureDetector(
          onTap: () {
            _showFullScreenImage(
              context,
              Image.file(
                File(filePath!),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  log("Error loading file image: $error");
                  return _errorPlaceholder();
                },
              ),
            );
          },
          child: child,
        );
      }
      return child;
    }

    // Network image
    if (url != null && url!.isNotEmpty && !url!.toLowerCase().contains("null")) {
      final child = NetworkImageWithRetry(
        key: ValueKey(url), // Ensures unique rebuild for each image URL
        imageUrl: url!,
        width: width,
        height: height,
        fit: fill,
      );
      if (isFullScreen) {
        return GestureDetector(
          onTap: () {
            _showFullScreenImage(
              context,
              NetworkImageWithRetry(
                key: ValueKey(url), // Ensures unique rebuild for each image URL
                imageUrl: url!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
              ),
            );
          },
          child: child,
        );
      }
      return child;
    }

    // Asset image
    if (path != null) {
      final child = Image.asset(
        path!,
        width: width,
        height: height,
        fit: fill,
        color: iconColor,
        errorBuilder: (context, error, stackTrace) {
          log("Error loading asset image: $error");
          return _errorPlaceholder();
        },
      );
      if (isFullScreen) {
        return GestureDetector(
          onTap: () {
            _showFullScreenImage(
              context,
              Image.asset(
                path!,
                width: width,
                height: height,
                fit: BoxFit.contain,
                color: iconColor,
                errorBuilder: (context, error, stackTrace) {
                  log("Error loading asset image: $error");
                  return _errorPlaceholder();
                },
              ),
            );
          },
          child: child,
        );
      }
      return child;
    }

    // Default placeholder
    return _errorPlaceholder();
  }

  Widget _errorPlaceholder() {
    double height = 80;
    if (width != null) {
      height = width! * .7;
    }
    return Container(
      width: width,
      height: height,
      color: Colors.black.withAlpha(70),
    );
  }

  void _showFullScreenImage(BuildContext context, Widget imageWidget) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer(image: imageWidget),
      ),
    );
  }
}

class FullScreenImageViewer extends StatefulWidget {
  final Widget image;

  const FullScreenImageViewer({super.key, required this.image});

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  Animation<Matrix4>? zoomAnimation;
  late TransformationController transformationController;
  TapDownDetails? doubleTapDetails;

  @override
  void initState() {
    super.initState();
    onAppInitial();
  }

  void onAppInitial() {
    try {
      transformationController = TransformationController();
      animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      )..addListener(() {
          transformationController.value = zoomAnimation!.value;
        });
    } catch (e) {
      log("onAppInitial $e");
    }
  }

  @override
  void dispose() {
    appClose();
    super.dispose();
  }

  void appClose() {
    try {
      transformationController.dispose();
      animationController.dispose();
    } catch (e) {
      log("appClose $e");
    }
  }

  void handleDoubleTapDown(TapDownDetails details) {
    doubleTapDetails = details;
  }

  void handleDoubleTap() {
    final newValue = transformationController.value.isIdentity() ? _applyZoom() : _revertZoom();

    zoomAnimation = Matrix4Tween(
      begin: transformationController.value,
      end: newValue,
    ).animate(CurveTween(curve: Curves.ease).animate(animationController));
    animationController.forward(from: 0);
  }

  Matrix4 _applyZoom() {
    final tapPosition = doubleTapDetails!.localPosition;
    const translationCorrection = 2 - 1;
    final zoomed = Matrix4.identity()
      ..translate(
        -tapPosition.dx * translationCorrection,
        -tapPosition.dy * translationCorrection,
      )
      ..scale(2.5); // Zoom factor (scale up)
    return zoomed;
  }

  Matrix4 _revertZoom() => Matrix4.identity();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: GestureDetector(
        onDoubleTapDown: handleDoubleTapDown,
        onDoubleTap: handleDoubleTap,
        child: InteractiveViewer(
          panAxis: PanAxis.aligned,
          transformationController: transformationController,
          maxScale: 10.0,
          minScale: 1,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.4,
                minWidth: MediaQuery.of(context).size.width,
              ),
              child: widget.image,
            ),
          ),
        ),
      ),
    );
  }
}

class NetworkImageWithRetry extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const NetworkImageWithRetry({
    super.key,
    required this.imageUrl,
    this.fit,
    this.height,
    this.width,
  });

  @override
  State<NetworkImageWithRetry> createState() => _NetworkImageWithRetryState();
}

class _NetworkImageWithRetryState extends State<NetworkImageWithRetry> {
  int retryCount = 0;
  final int maxRetries = 6;
  late String _image;

  @override
  void initState() {
    super.initState();
    _setImage();
  }

  @override
  void didUpdateWidget(covariant NetworkImageWithRetry oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      retryCount = 0; // Reset retries for the new URL
      _setImage();
      setState(() {});
    }
  }

  void _setImage() {
    try {
      final uri = Uri.tryParse(widget.imageUrl);
      if (uri != null && (uri.isScheme('http') || uri.isScheme('https'))) {
        _image = widget.imageUrl;
      } else {
        _image =
            "${widget.imageUrl.startsWith('http') ? widget.imageUrl : AppUrls.mainUrl}${widget.imageUrl}";
      }
    } catch (e) {
      log("Error setting image URL: $e");
      _image = widget.imageUrl;
    }
  }

  void _retry() async {
    try {
      if (retryCount < maxRetries) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          await Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                retryCount++;
              });
            }
          });
        });
      } else {
        log("Max retries reached for image: $_image");
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Image(
      image: CachedNetworkImageProvider(_image),
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      loadingBuilder: (context, child, loadingProgress) {
        bool isLoading =
            loadingProgress?.expectedTotalBytes != loadingProgress?.cumulativeBytesLoaded;
        return isLoading ? _loadingPlaceholder() : child;
      },
      errorBuilder: (context, error, stackTrace) {
        log("Network image error: $error");
        _retry();
        return _errorPlaceholder();
      },
    );
  }

  Widget _loadingPlaceholder() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: AppColors.blueDark,
      child: const Center(
          child: CupertinoActivityIndicator(
        color: Colors.white,
      )),
    );
  }

  Widget _errorPlaceholder() {
    double height = 80;
    if (widget.width != null) {
      height = widget.width! * .6;
    }
    return Container(
      width: widget.width,
      height: widget.height ?? height,
      color: AppColors.blueDark.withAlpha(50),
    );
  }
}
