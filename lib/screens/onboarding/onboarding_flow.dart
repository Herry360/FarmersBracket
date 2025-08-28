import 'package:flutter/material.dart';
import '../location_permission_screen.dart';
import '../zip_code_entry_screen.dart';

class OnboardingFlow extends StatefulWidget {
  final VoidCallback onComplete;
  const OnboardingFlow({Key? key, required this.onComplete}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _step = 0;

  void _nextStep() {
    setState(() {
      _step++;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_step) {
      case 0:
        return LocationPermissionScreen(onNext: _nextStep);
      case 1:
        return ZipCodeEntryScreen(onNext: widget.onComplete);
      default:
        return Container();
    }
  }
}
