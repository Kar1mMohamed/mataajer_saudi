import 'package:flutter/services.dart';

List<TextInputFormatter> get enOnlyInputFormat => <TextInputFormatter>[
      FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]'))
    ];

List<TextInputFormatter> get numbersOnlyInputFormat =>
    <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp('[0-9]'))];

List<TextInputFormatter> get numbersOnlyWithPrecisionInputFormat =>
    <TextInputFormatter>[
      FilteringTextInputFormatter.allow(RegExp(r"^\d+(\.\d{0,2})?$"))
    ];
