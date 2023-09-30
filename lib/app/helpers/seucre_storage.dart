import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  SecureStorageHelper._();

  static const String LOGIN_EMAIL = 'LOGIN_EMAIL';
  static const String LOGIN_PASSWORD = 'LOGIN_PASSWORD';

  static final SecureStorageHelper instance = SecureStorageHelper._();

  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  static IOSOptions _getIOSOptions() => const IOSOptions(
        synchronizable: true,
        accountName: 'com.matajersaudi.app',
        groupId: 'com.matajersaudi.app',
      );

  final storage = FlutterSecureStorage(
      aOptions: _getAndroidOptions(), iOptions: _getIOSOptions());
}
