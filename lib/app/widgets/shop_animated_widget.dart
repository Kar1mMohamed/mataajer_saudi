import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../data/assets.dart';

class ShopAnimatedWidget extends StatefulWidget {
  const ShopAnimatedWidget({super.key});

  @override
  State<ShopAnimatedWidget> createState() => _ShopAnimatedWidgetState();
}

class _ShopAnimatedWidgetState extends State<ShopAnimatedWidget> {
// Controller for playback
  late RiveAnimationController _controller;

  // // Toggles between play and pause animation states
  // void _togglePlay() =>
  //     setState(() => _controller.isActive = !_controller.isActive);

  /// Tracks if the animation is playing by whether controller is running
  bool get isPlaying => _controller.isActive;

  @override
  void initState() {
    super.initState();
    _controller = SimpleAnimation('Loop');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        // height: context.height * 0.5,
        // width: context.width * 0.5,
        child: RiveAnimation.asset(
          Assets.riveLoadingShop,
          controllers: [_controller],
          // Update the play state when the widget's initialized
          onInit: (_) => setState(() {}),
        ),
      ),
    );
  }
}
