import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/widgets/image_widget/common_image.dart';
import 'package:the_leaderboard/widgets/text_widget/text_widgets.dart';

class _EagleWingPainter extends CustomPainter {
  final Color color;
  final double progress;
  final double avatarSize;
  final double flapPhase; // For staggered animation of wing layers

  // Get a smoothly transitioning color based on time
  Color get _pulseColor {
    // Choose from a set of elegant color palettes that work well on dark backgrounds
    final palettes = [
      // Teal & Purple
      [const Color.fromARGB(255, 0, 40, 216), const Color(0xFF7209B7)],
      // Gold & Deep Blue
      [const Color(0xFFFFD700), const Color(0xFF7209B7)],
      // Coral & Deep Purple
      [const Color(0xFFFF6B6B), const Color(0xFF6A0DAD)],
      // Mint & Dark Blue
      [const Color.fromARGB(255, 0, 255, 183), const Color(0xFF7209B7)],
      // Rose Gold & Navy
      [const Color.fromARGB(255, 255, 12, 49), const Color(0xFF7209B7)]
    ];

    // Select a consistent palette based on the base color's hash code
    final palette = palettes[color.value % palettes.length];

    // Calculate a smooth transition between colors based on time
    final time = DateTime.now().millisecondsSinceEpoch / 2000.0; // Slower transition
    final progress = (time % 2.0) / 2.0; // 0.0 to 1.0 over 2 seconds

    // Use a smooth curve for the transition
    final curvedProgress = Curves.easeInOutSine.transform(progress);

    // Only change colors after completing a full cycle
    final colorIndex = (time / 4.0).floor() % 2; // Change color every 4 seconds
    final nextColorIndex = (colorIndex + 1) % 2;

    return Color.lerp(
      palette[colorIndex],
      palette[nextColorIndex],
      curvedProgress,
    )!;
  }

  _EagleWingPainter({
    required this.color,
    required this.progress,
    required this.avatarSize,
    this.flapPhase = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    // Position the wings slightly above the rank label
    final center = Offset(size.width / 2, size.height * 0.85);
    final maxWingWidth = size.width * 1.5;
    final maxWingHeight = size.height * 0.9;

    // Base wing dimensions
    final wingWidth = maxWingWidth * progress;
    final wingHeight = maxWingHeight * progress;

    // Calculate color interpolation based on pulse phase with smoother transitions
    final pulseValue =
        (math.sin(flapPhase * math.pi * 1.5) + 1) / 2; // 0 to 1 with slower transition
    final currentPulseColor = _pulseColor;

    // Blend the pulse color with the base color for a more subtle effect
    final currentColor = Color.lerp(
      color.withOpacity(0.7),
      currentPulseColor.withOpacity(0.9),
      pulseValue * 0.7 + 0.3, // Keep some base color visible
    )!;

    // Create three layers of feathers for each wing
    for (int layer = 0; layer < 3; layer++) {
      final layerProgress = progress * (1.0 - (layer * 0.15));
      final layerWidth = wingWidth * (1.0 - (layer * 0.15));
      final layerHeight = wingHeight * (1.0 - (layer * 0.1));
      final layerPhase = (flapPhase + (layer * 0.2)) % 1.0;

      // Staggered flapping effect
      final flapAmount = math.sin(layerPhase * math.pi * 2) * 0.1;
      final currentProgress = layerProgress * (0.9 + (flapAmount * 0.5));

      // Adjust opacity based on layer
      final layerOpacity = 0.7 - (layer * 0.3);

      // Draw left wing
      _drawWingLayer(
        canvas: canvas,
        center: center,
        width: layerWidth * 0.8,
        height: layerHeight,
        isLeft: true,
        progress: currentProgress,
        layer: layer,
        color: currentColor.withOpacity(layerOpacity),
      );

      // Draw right wing
      _drawWingLayer(
        canvas: canvas,
        center: center,
        width: layerWidth * 0.8,
        height: layerHeight,
        isLeft: false,
        progress: currentProgress,
        layer: layer,
        color: currentColor.withOpacity(layerOpacity),
      );
    }
  }

  void _drawWingLayer({
    required Canvas canvas,
    required Offset center,
    required double width,
    required double height,
    required bool isLeft,
    required double progress,
    required int layer,
    required Color color,
  }) {
    final direction = isLeft ? -1.0 : 1.0;

    // Create a path for the wing
    Path createWingPath() {
      final path = Path();
      // Start from the center bottom
      path.moveTo(center.dx, center.dy);

      // Draw the main curve of the wing
      path.quadraticBezierTo(
        center.dx + (direction * width * 0.3 * progress),
        center.dy - (height * 0.2 * progress),
        center.dx + (direction * width * 0.8 * progress),
        center.dy - (height * 0.9 * progress),
      );

      // Draw the wing tip
      path.quadraticBezierTo(
        center.dx + (direction * width * 0.7 * progress),
        center.dy - (height * 0.6 * progress),
        center.dx + (direction * width * 0.4 * progress),
        center.dy - (height * 0.2 * progress),
      );

      // Complete the wing shape
      path.quadraticBezierTo(
        center.dx + (direction * width * 0.2 * progress),
        center.dy - (height * 0.1 * progress),
        center.dx,
        center.dy,
      );
      return path;
    }

    final wingPath = createWingPath();

    // Create gradient for the wing
    final gradient = LinearGradient(
      colors: [
        color.withOpacity(0.8 - (layer * 0.2)),
        color.withOpacity(0.3 - (layer * 0.1)),
      ],
      begin: isLeft ? Alignment.centerRight : Alignment.centerLeft,
      end: isLeft ? Alignment.centerLeft : Alignment.centerRight,
    ).createShader(Offset.zero & Size(width * 2, height * 2));

    canvas.save();
    canvas.translate(0, layer * 2.0); // Slight vertical offset for layers

    // Draw glow effect (multiple layers with increasing blur)
    if (layer == 0) {
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..color = color.withOpacity(0.5)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8.0);

      // Draw multiple glow layers for more intensity
      for (var i = 1; i <= 3; i++) {
        final glowPath = createWingPath();
        canvas.drawPath(glowPath, glowPaint..strokeWidth = i.toDouble() * 1.5);
      }
    }

    // Draw the main wing fill
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = gradient
      ..maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        (3.0 - layer).clamp(1.0, 3.0),
      );

    canvas.drawPath(wingPath, paint);

    // Add feather details
    if (layer == 0) {
      _drawFeatherDetails(canvas, wingPath, isLeft, color);
    }

    canvas.restore();
  }

  void _drawFeatherDetails(Canvas canvas, Path wingPath, bool isLeft, Color baseColor) {
    // Create a subtle highlight that works well on dark backgrounds
    final highlightColor = HSLColor.fromColor(baseColor)
        .withLightness((HSLColor.fromColor(baseColor).lightness + 0.2).clamp(0.0, 1.0))
        .withSaturation(0.7)
        .toColor();
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = highlightColor.withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.0);

    // Draw feather separations
    final path = Path();
    final metrics = wingPath.computeMetrics().first;

    for (double t = 0.1; t < 0.9; t += 0.2) {
      final offset = metrics.getTangentForOffset(metrics.length * t)?.position;
      if (offset != null) {
        path.moveTo(offset.dx, offset.dy);
        path.lineTo(offset.dx + (isLeft ? -10.0 : 10.0) * (1.0 - t * 0.7),
            offset.dy - 15.0 * (1.0 - t * 0.5));
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_EagleWingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.avatarSize != avatarSize ||
        oldDelegate.color != color ||
        oldDelegate.flapPhase != flapPhase;
  }
}

class AuraGlowWrapper extends StatefulWidget {
  final Color auraColor;
  final double intensity;
  final Duration duration;
  final String rankLabel;
  final double avatarSize;
  final bool fromOnline;
  final String image;
  const AuraGlowWrapper({
    Key? key,
    required this.auraColor,
    this.intensity = 0.25,
    this.duration = const Duration(seconds: 5),
    required this.rankLabel,
    required this.avatarSize,
    required this.fromOnline,
    required this.image,
  }) : super(key: key);

  @override
  _AuraGlowWrapperState createState() => _AuraGlowWrapperState();
}

class _AuraGlowWrapperState extends State<AuraGlowWrapper> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _pulse = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.avatarSize * 2,
        height: widget.avatarSize * 2,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Avatar
            Positioned.fill(
              child: CircleAvatar(
                radius: widget.avatarSize,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: CommonImage(
                    imageSrc: "${AppUrls.mainUrl}${widget.image}",
                    width: widget.avatarSize * 2,
                    height: widget.avatarSize * 2,
                  ),
                ),
              ),
            ),
            // Eagle wing animation behind avatar
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  // Flapping wing effect with multiple layers
                  final progress = 0.5 + (0.3 * (1 + math.sin(_pulse.value * math.pi * 1.2)) / 2);

                  return Transform.translate(
                    offset: const Offset(0, 20), // Slight vertical adjustment
                    child: CustomPaint(
                      painter: _EagleWingPainter(
                        color: widget.auraColor,
                        progress: progress,
                        avatarSize: widget.avatarSize,
                        flapPhase: _pulse.value,
                      ),
                    ),
                  );
                },
              ),
            ),

            Positioned(
              bottom: -10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.auraColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextWidget(
                  text: widget.rankLabel,
                  fontColor: AppColors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            )
// The actual content
          ],
        ));
  }
}
