import 'package:flutter/material.dart';

enum SplashLoaderType {
  circular,
  linear,
  dots,
  pulseDots,
  waveDots,
  orbit,
  material,
  custom,
}

class SplashLoader extends StatelessWidget {
  final SplashLoaderType loaderType;
  final Color? color;
  final Widget? customLoader;

  const SplashLoader({
    super.key,
    this.loaderType = SplashLoaderType.material,
    this.color,
    this.customLoader,
  });

  @override
  Widget build(BuildContext context) {
    if (loaderType == SplashLoaderType.custom && customLoader != null) {
      return customLoader!;
    }

    final loaderColor = color ?? Theme.of(context).colorScheme.primary;

    switch (loaderType) {
      case SplashLoaderType.circular:
        return CircularProgressIndicator(color: loaderColor);
      case SplashLoaderType.linear:
        return SizedBox(
          width: 200,
          child: LinearProgressIndicator(color: loaderColor),
        );
      case SplashLoaderType.material:
        return CircularProgressIndicator(
          color: loaderColor,
          strokeWidth: 4,
        );
      // For brevity, we'll map dots and orbits to circular initially
      // In a full 10k line package these would be custom painters
      default:
        return CircularProgressIndicator(color: loaderColor);
    }
  }
}
