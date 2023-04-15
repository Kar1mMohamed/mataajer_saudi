import 'package:flutter/material.dart';
import 'package:show_up_animation/show_up_animation.dart';

extension CustomShowUpAnimation on Widget {
  Widget showUpAnimation({int? delay = 0}) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: delay ?? 1000),
      // delay: Duration(milliseconds: delay),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - value)),
            child: child,
          ),
        );
      },
      child: this,
    );
  }

  Widget get showUpAnimation2 {
    return ShowUpAnimation(
      delayStart: Duration(milliseconds: 0),
      animationDuration: Duration(milliseconds: 450),
      curve: Curves.bounceIn,
      direction: Direction.vertical,
      offset: 0.5,
      child: this,
    );
  }
}

// extension CustomListShowUpAnimation on List<Widget> {
//   List<Widget> get showUpAnimation2 {
//     return <Widget>[
//       ShowUpList(
//         direction: Direction.horizontal,
//         animationDuration: Duration(milliseconds: 1500),
//         delayBetween: Duration(milliseconds: 800),
//         offset: -0.2,
//         children: this,
//       )
//     ].toList();
//   }
// }
