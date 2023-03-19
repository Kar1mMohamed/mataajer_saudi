import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final void Function()? press;
  final Color? color, textColor;
  final Icon? icon;
  final double? width, height;
  final bool? isFilled;
  final double? radius;
  final double? verticalPadding;
  const RoundedButton(
      {final key,
      required this.text,
      this.isFilled = true,
      this.textStyle,
      required this.press,
      this.color = const Color(0xFFB786CA),
      this.textColor = Colors.white,
      this.icon,
      this.width,
      this.height,
      this.radius,
      this.verticalPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: height,
      width: width ?? size.width * 0.8,
      child: ElevatedButton(
        onPressed: press,
        style: ElevatedButton.styleFrom(
          // primary: color,
          backgroundColor: color ?? (isFilled! ? null : Colors.white),
          padding: EdgeInsets.symmetric(
              horizontal: 20, vertical: verticalPadding ?? 15),
          shape: RoundedRectangleBorder(
            side: isFilled!
                ? BorderSide.none
                : const BorderSide(
                    color: MataajerTheme.mainColor,
                    width: 1,
                  ),
            borderRadius: BorderRadius.circular(radius ?? 15.r),
          ),

          textStyle: TextStyle(
            fontFamily: 'Tajawal',
            color: isFilled!
                ? Colors.white
                : (textColor ?? MataajerTheme.mainColor),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? Container(),
            SizedBox(width: 5.w),
            Text(
              text,
              style: textStyle ??
                  TextStyle(
                    color: isFilled!
                        ? Colors.white
                        : (textColor ?? MataajerTheme.mainColor),
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
