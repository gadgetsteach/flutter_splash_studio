import 'dart:async';
import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import '../animations/animation_router.dart';
import '../models/splash_animation.dart';
import '../models/splash_template.dart';
import '../templates/hotstar_template.dart';
import '../templates/netflix_template.dart';

/// The core runtime splash screen widget for Flutter Splash Studio.
class SplashStudio extends StatefulWidget {
  /// Prebuilt template to use. If provided, overrides most custom styling.
  final SplashTemplate? template;

  /// The type of animation to play. Defaults to [SplashAnimation.fade].
  final SplashAnimation animation;

  /// Total duration of the splash screen before navigating (if [autoNavigate] is true).
  final Duration duration;

  /// The curve of the primary animation.
  final Curve curve;

  /// Whether to automatically navigate to [nextPage] after [duration].
  final bool autoNavigate;

  /// The next widget/page to navigate to after the splash screen finishes.
  final Widget? nextPage;

  /// An optional future to wait for before finishing the splash screen.
  /// If provided, the splash screen will wait for this future AND [duration].
  final Future<void> Function()? onInit;

  // Custom UI Configuration

  /// The logo image provider to display.
  final ImageProvider? logo;

  /// The title text to display below the logo.
  final String? title;

  /// TextStyle for the [title].
  final TextStyle? titleStyle;

  /// Custom background color. If null, uses the theme's background or template default.
  final Color? backgroundColor;

  /// Custom gradient background. Overrides [backgroundColor].
  final Gradient? backgroundGradient;

  /// Amount of background blur for glassmorphism effect.
  final double? blurAmount;

  /// Set to true to enable glassmorphism styling on the background.
  final bool enableGlassmorphism;

  /// Custom shadows to apply to the logo/title container.
  final List<BoxShadow>? containerShadows;

  /// Border radius for the logo/title container.
  final BorderRadiusGeometry? containerBorderRadius;

  /// A custom loading indicator widget.
  final Widget? loader;

  /// Whether to show the [loader].
  final bool showLoader;

  /// Optional bottom branding text (e.g., "Powered by Google").
  final String? bottomBranding;

  /// TextStyle for the [bottomBranding].
  final TextStyle? bottomBrandingStyle;

  const SplashStudio({
    super.key,
    this.template,
    this.animation = SplashAnimation.fade,
    this.duration = const Duration(seconds: 3),
    this.curve = Curves.easeInOutCubic,
    this.autoNavigate = false,
    this.nextPage,
    this.onInit,
    this.logo,
    this.title,
    this.titleStyle,
    this.backgroundColor,
    this.backgroundGradient,
    this.blurAmount,
    this.enableGlassmorphism = false,
    this.containerShadows,
    this.containerBorderRadius,
    this.loader,
    this.showLoader = false,
    this.bottomBranding,
    this.bottomBrandingStyle,
  });

  @override
  State<SplashStudio> createState() => _SplashStudioState();
}

class _SplashStudioState extends State<SplashStudio> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _startSplashSequence();
  }

  Future<void> _startSplashSequence() async {
    _controller.forward();

    final minDurationFuture = Future.delayed(widget.duration);
    final initFuture = widget.onInit?.call() ?? Future.value();

    await Future.wait([minDurationFuture, initFuture]);

    if (mounted) {
      setState(() {
      });

      if (widget.autoNavigate && widget.nextPage != null) {
        _navigateToNext();
      }
    }
  }

  void _navigateToNext() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => widget.nextPage!,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Resolve Template Overrides
    Color resolvedBgColor = widget.backgroundColor ?? theme.colorScheme.surface;
    SplashAnimation resolvedAnimation = widget.animation;
    Widget? resolvedLogoChild;
    
    if (widget.template != null) {
      switch (widget.template!) {
        case SplashTemplate.hotstar:
          resolvedBgColor = HotstarTemplate.backgroundColor;
          resolvedAnimation = HotstarTemplate.animation;
          resolvedLogoChild = HotstarTemplate.buildLogo();
          break;
        case SplashTemplate.netflix:
          resolvedBgColor = NetflixTemplate.backgroundColor;
          resolvedAnimation = NetflixTemplate.animation;
          resolvedLogoChild = NetflixTemplate.buildLogo();
          break;
        // Fallback for others unimplemented in this demo
        default:
          break;
      }
    }

    Widget bodyContent = Center(
      child: AnimationRouter(
        animationType: resolvedAnimation,
        controller: _controller,
        curve: widget.curve,
        child: resolvedLogoChild ?? Container(
          decoration: BoxDecoration(
            borderRadius: widget.containerBorderRadius,
            boxShadow: widget.containerShadows,
            color: widget.enableGlassmorphism ? Colors.white.withValues(alpha: 0.1) : null,
          ),
          padding: widget.enableGlassmorphism ? const EdgeInsets.all(32) : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.logo != null)
                Image(image: widget.logo!, width: 120, height: 120),
              if (widget.title != null) ...[
                const SizedBox(height: 24),
                Text(
                  widget.title!,
                  style: widget.titleStyle ?? theme.textTheme.headlineMedium,
                ),
              ],
              if (widget.showLoader) ...[
                const SizedBox(height: 48),
                widget.loader ?? const CircularProgressIndicator(),
              ],
            ],
          ),
        ),
      ),
    );

    // Apply Glassmorphism Background Blur if enabled
    if (widget.enableGlassmorphism && widget.blurAmount != null) {
      bodyContent = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: widget.blurAmount!, sigmaY: widget.blurAmount!),
        child: bodyContent,
      );
    }

    return Scaffold(
      backgroundColor: widget.backgroundGradient == null ? resolvedBgColor : null,
      body: Container(
        decoration: BoxDecoration(
          color: widget.backgroundGradient == null ? resolvedBgColor : null,
          gradient: widget.backgroundGradient,
        ),
        child: bodyContent,
      ),
    );
  }
}
