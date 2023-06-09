import 'dart:async';
import 'package:app_mari/src/helpers/size_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CheckAuth extends StatefulWidget {
  @override
  State<CheckAuth> createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  StreamSubscription? streamSubscription;

  @override
  void initState() {
    streamSubscription =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Modular.to.navigate('./auth-page');
      } else {
        Modular.to.navigate('/home-module/');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    streamSubscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: context.screenHeight * .7,
          child: Center(
            child: LoadingAnimationWidget.threeArchedCircle(
              color: Colors.white,
              size: 50,
            ),
          ),
        ),
      ),
    );
  }
}
