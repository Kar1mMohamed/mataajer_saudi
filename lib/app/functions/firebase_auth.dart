import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mataajer_saudi/app/data/app/firebase_auth_register_temp.dart';
import 'package:mataajer_saudi/app/utils/log.dart';

class FirebaseAuthFuntions {
  FirebaseAuthFuntions._();

  static Future<FirebaseAuthRegisterTempModule?> createUserWithoutLogin(
      {required String email, required String password}) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'registerTemp', options: Firebase.app().options);

    try {
      UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);

      return FirebaseAuthRegisterTempModule(
          app: app, userCredential: userCredential);
    } on FirebaseAuthException catch (e) {
      // Do something with exception. This try/catch is here to make sure
      // that even if the user creation fails, app.delete() runs, if is not,
      // next time Firebase.initializeApp() will fail as the previous one was
      // not deleted.
      log('createUserWithoutLogin FirebaseAuthException error: $e');

      return null;
    } catch (e) {
      log('createUserWithoutLogin error: $e');

      return null;
    }
  }

  static Future<void> deleteUsersWithoutLogin(
      {String? token, List<String>? tokens}) async {
    bool isOnlyOne = token != null && tokens == null;

    FirebaseApp app = await Firebase.initializeApp(
        name: 'registerTemp', options: Firebase.app().options);

    try {
      if (isOnlyOne) {
        final user = await FirebaseAuth.instance.signInWithCustomToken(token);
        await user.user!.delete();
      } else {
        for (String token in tokens!) {
          final user = await FirebaseAuth.instance.signInWithCustomToken(token);
          await user.user!.delete();
        }
      }
    } catch (e) {
      log('deleteUserWithoutLogin error: $e');
    } finally {
      await app.delete();
    }
  }
}
