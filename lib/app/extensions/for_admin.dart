import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

extension ForAdmin on Widget {
  Widget get forAdmin {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Scaffold(
          body: Center(child: Text('ليس لديك صلاحية للوصول هنا')));
    }
    if (currentUser.uid == '0zapKo4rAjhMxC9GFwChmYxKOP23' ||
        currentUser.uid == 't8scmFWTBjhk4srk3bcTTRfw4fM2') {
      return this;
    }

    return const Scaffold(
        body: Center(child: Text('ليس لديك صلاحية للوصول هنا')));
  }
}
