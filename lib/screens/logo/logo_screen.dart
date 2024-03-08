import 'package:auth_ui/utils/logo_dimensions.dart';
import 'package:common/widget/images/svg_banner.dart';
import 'package:flutter/material.dart';

class LogoScreen extends StatelessWidget {
  final double size;
  final String logoPath;
  const LogoScreen({Key? key, this.size = 136, required this.logoPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logoDimensions = LogoDimensions(context);
    final logoWidth = logoDimensions.calculateLogoWidth();
    final logoHeight = logoDimensions.calculateLogoHeight();
    return Center(
      child: SVGBanner(
        path: logoPath,
        width: logoWidth,
        height: logoHeight,
      ),
    );
  }
}
