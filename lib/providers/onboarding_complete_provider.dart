import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final onboardingCompleteProvider =
    StateNotifierProvider<OnboardingCompleteNotifier, bool>((ref) {
      return OnboardingCompleteNotifier();
    });

class OnboardingCompleteNotifier extends StateNotifier<bool> {
  OnboardingCompleteNotifier() : super(_getInitialValue());

  static bool _getInitialValue() {
    final settingsBox = Hive.box('settings');
    return settingsBox.get('onboardingComplete', defaultValue: false) == true;
  }

  void completeOnboarding() {
    final settingsBox = Hive.box('settings');
    settingsBox.put('onboardingComplete', true);
    state = true;
  }
}
