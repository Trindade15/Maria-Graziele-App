import 'dart:async';
import 'package:app_mari/src/helpers/size_extensions.dart';
import 'package:app_mari/src/ui/styles/colors_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';

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
          print('Usuario: $user');
      if (user == null) {
        print('Passou aqui no IF');
        Modular.to.navigate('./auth-page');
      } else {
        print('Passou aqui');
        permission();
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

  permission() async {
    await Permission.notification.request();
    var status = await Permission.notification.status;
    switch (status) {
      case PermissionStatus.denied:
        modalBotomShet();

        break;
      case PermissionStatus.permanentlyDenied:
        modalBotomShet();
        break;
      case PermissionStatus.restricted:
        modalBotomShet();
        break;
      default:
    }
  }

  modalBotomShet() {
    return showBarModalBottomSheet(
      barrierColor: Colors.transparent,
      topControl: const Text(''),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
          height: MediaQuery.of(context).size.height * 0.320,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Não temos a acesso as notificações',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.notifications_off_outlined,
                    color: Colors.black,
                  )
                ],
              ),
              Container(
                width: 320,
                alignment: Alignment.center,
                child: const Text(
                  'Você pode mudar o acesso à suas notificações nos Ajustes do seu aparelho.',
                  style:
                      TextStyle(color: Colors.black, fontSize: 13, height: 2),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.black54)),
                  onPressed: () => openAppSettings(),
                  child: const Text('Ir para Ajustes'),
                ),
              ),
              TextButton(
                onPressed: () => Modular.to.pop(),
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.red, height: 2),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
