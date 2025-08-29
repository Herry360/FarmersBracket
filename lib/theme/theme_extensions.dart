import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color success;
  final Color warning;
  final Color organicLabel;
  final Color localProduce;
  final Color seasonalHighlight;

  const AppColors({
    required this.success,
    required this.warning,
    required this.organicLabel,
    required this.localProduce,
    required this.seasonalHighlight,
  });

  @override
  AppColors copyWith({
    Color? success,
    Color? warning,
    Color? organicLabel,
    Color? localProduce,
    Color? seasonalHighlight,
  }) {
    return AppColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      organicLabel: organicLabel ?? this.organicLabel,
      localProduce: localProduce ?? this.localProduce,
      seasonalHighlight: seasonalHighlight ?? this.seasonalHighlight,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      organicLabel: Color.lerp(organicLabel, other.organicLabel, t)!,
      localProduce: Color.lerp(localProduce, other.localProduce, t)!,
      seasonalHighlight: Color.lerp(
        seasonalHighlight,
        other.seasonalHighlight,
        t,
      )!,
    );
  }
}
