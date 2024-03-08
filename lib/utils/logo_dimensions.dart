import 'package:auth_common/constants/dimens.dart';
import 'package:flutter/widgets.dart';

class LogoDimensions {
  final BuildContext context;

  LogoDimensions(this.context);

  double calculateLogoWidth() {
    final width = MediaQuery.of(context).size.width;
    double logoPercentage = DimensAuthUi.tenPercent;

    if (width < DimensAuthUi.maxWidth) {
      logoPercentage = DimensAuthUi.thirtyPercent;
    }

    return width * logoPercentage;
  }

  double calculateLogoHeight() {
    final height = MediaQuery.of(context).size.height;
    double logoPercentage = DimensAuthUi.tenPercent;

    if (height < DimensAuthUi.maxWidth) {
      logoPercentage = DimensAuthUi.thirtyPercent;
    }

    return height * logoPercentage;
  }
}
