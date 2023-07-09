import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseAuthRegisterTempModule {
  FirebaseApp? app;
  UserCredential? userCredential;

  FirebaseAuthRegisterTempModule({this.app, this.userCredential});
}
