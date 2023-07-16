import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../utils/log.dart';

class CryptoFunctions {
  CryptoFunctions._();

  static String? encryptMD5String(String string) {
    try {
      final content = utf8.encode(string);
      final digest = md5.convert(content);
      return digest.toString();
    } catch (e) {
      log(e);
      return null;
    }
  }

  // static String encryptSHA1String(String string) {
  //   try {
  //     final content = utf8.encode(string);
  //     final digest = sha1.convert(content);
  //     return hex.encode(digest.bytes);
  //   } catch (e) {
  //     log(e);
  //     return '';
  //   }
  // }

  // static String encryptSHA256String(String string) {
  //   try {
  //     final content = utf8.encode(string);
  //     final digest = sha256.convert(content);
  //     return hex.encode(digest.bytes);
  //   } catch (e) {
  //     log(e);
  //     return '';
  //   }
  // }

  // static String encryptSHA512String(String string) {
  //   try {
  //     final content = utf8.encode(string);
  //     final digest = sha512.convert(content);
  //     return hex.encode(digest.bytes);
  //   } catch (e) {
  //     log(e);
  //     return '';
  //   }
  // }

  // static String encryptSHA384String(String string) {
  //   try {
  //     final content = utf8.encode(string);
  //     final digest = sha384.convert(content);
  //     return hex.encode(digest.bytes);
  //   } catch (e) {
  //     log(e);
  //     return '';
  //   }
  // }

  // static String encryptSHA224String(String string) {
  //   try {
  //     final content = utf8.encode(string);
  //     final digest = sha224.convert(content);
  //     return hex.encode(digest.bytes);
  //   } catch (e) {
  //     log(e);
  //     return '';
  //   }
  // }

  // static String encryptSHA3_224String(String string) {
  //   try {
  //     final content = utf8.encode(string);
  //     final digest = sha3.SHA3(224, sha3.RAW, 0, 0).update(content).digest();
  //     return hex.encode(digest);
  //   } catch (e) {
  //     log(e);
  //     return '';
  //   }
  // }

  // static String encryptSHA3_256String(String string) {
  //   try {
  //     final content = utf8.encode(string);
  //     final digest = sha3.SHA3(256, sha3.RAW, 0, 0).update(content).digest();
  //     return hex.encode(digest);
  //   } catch (e) {
  //     log(e);
  //     return '';
  //   }
  // }
}
