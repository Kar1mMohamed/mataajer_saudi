import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';

Widget textField({
  double? padding,
  Widget? icon,
  TextEditingController? controller,
  String? hint,
  bool? isPassword,
  TextAlign? textAlign,
  List<TextInputFormatter>? inputFormatters,
  Function(String)? onSubmitted,
  void Function(String)? onChanged,
}) =>
    Container(
      padding: EdgeInsets.all(padding ?? 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.white,
      ),
      child: TextField(
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        inputFormatters: inputFormatters,
        obscureText: isPassword ?? false,
        obscuringCharacter: '•',
        controller: controller,
        textAlign: textAlign ?? TextAlign.center,
        decoration: InputDecoration(
          icon: icon,
          hintText: hint,
          hintStyle: MataajerTheme.lightTextTheme.bodyMedium!
              .copyWith(color: Colors.grey, fontSize: 14),
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: MataajerTheme.yellowColor),
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
        ),
      ),
    );

Widget textFormField({
  double? padding,
  Widget? icon,
  TextEditingController? controller,
  String? hint,
  bool? isPassword,
  bool isEmail = false,
  bool expands = false,
  TextAlign? textAlign,
  bool readOnly = false,
  List<TextInputFormatter>? inputFormatters,
  void Function(String)? onChanged,
}) =>
    Container(
      padding: EdgeInsets.all(padding ?? 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.white,
      ),
      child: TextFormField(
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        readOnly: readOnly,
        obscureText: isPassword ?? false,
        obscuringCharacter: '•',
        controller: controller,
        expands: expands,
        minLines: null,
        maxLines: isPassword ?? false ? 1 : null,
        textAlign: textAlign ?? TextAlign.start,
        decoration: InputDecoration(
          icon: icon,
          hintText: hint,
          hintStyle: MataajerTheme.lightTextTheme.bodyText2!
              .copyWith(color: Colors.grey, fontSize: 14),
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: MataajerTheme.yellowColor),
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
        ),
        validator: (string) {
          if (string!.isEmpty) {
            return 'الرجاء ادخال البيانات';
          }
          if (string.length < 3) {
            return 'الرجاء ادخال البيانات بشكل صحيح';
          }
          if (isEmail && !string.contains('@')) {
            return 'الرجاء ادخال البيانات بشكل صحيح';
          }
          return null;
        },
      ),
    );
