import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:mataajer_saudi/app/data/assets.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';

typedef ValueChanged = void Function(bool value);

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Container(
        height: 40,
        width: 20,
        decoration: BoxDecoration(
          color: value
              ? MataajerTheme.mainColor
              : const Color(0xFFB786CA).withOpacity(0.40),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (value)
              Flexible(
                child: Image.asset(
                  Assets.eyePNG,
                  width: 20,
                  filterQuality: FilterQuality.high,
                ).paddingSymmetric(vertical: 3.0),
              ),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: MataajerTheme.mainColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            if (!value)
              Flexible(
                child: Image.asset(
                  Assets.closedEypePNG,
                  width: 20,
                  filterQuality: FilterQuality.high,
                ).paddingSymmetric(vertical: 3.0),
              ),
          ],
        ),
      ),
    );
  }

  // Widget inactive() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Container(
  //         padding: const EdgeInsets.all(5),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         child: Container(
  //           width: 12,
  //           height: 12,
  //           decoration: const BoxDecoration(
  //             color: MataajerTheme.mainColor,
  //             shape: BoxShape.circle,
  //           ),
  //         ),
  //       ),
  //       Flexible(
  //         child: Image.asset(
  //           Assets.closedEypePNG,
  //           width: 20,
  //           filterQuality: FilterQuality.high,
  //         ).paddingSymmetric(vertical: 3.0),
  //       ),
  //     ],
  //   );
  // }
}
