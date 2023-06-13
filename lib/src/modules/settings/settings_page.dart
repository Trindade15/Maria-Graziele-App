import 'dart:io';

import 'package:app_mari/src/helpers/size_extensions.dart';
import 'package:app_mari/src/modules/auth/auth_controller.dart';
import 'package:app_mari/src/modules/home/controller/home_controller.dart';
import 'package:app_mari/src/modules/settings/settings_controller.dart';
import 'package:app_mari/src/modules/settings/settings_store.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SettingsStore store;
  final authController = Modular.get<AuthController>();
  final homeController = Modular.get<HomeController>();
  final controller = Modular.get<SettingsController>();

  @override
  void initState() {
    store = Modular.get<SettingsStore>(defaultValue: SettingsStore(controller));
    store.buscarUsuario();
    super.initState();
    homeController.addListener(<HomeController>() {
      setState(() {});
    });
    controller.addListener(<SettingsController>() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedBuilder(
        store: store,
        onError: (context, error) {
          return AwesomeSnackbarContent(
            title: 'Erro',
            message: 'Ocorreu algum erro',
            contentType: ContentType.failure,
          );
        },
        onLoading: (context) {
          return SizedBox(
            height: context.screenHeight * .7,
            child: Center(
              child: LoadingAnimationWidget.threeArchedCircle(
                color: Colors.white,
                size: 50,
              ),
            ),
          );
        },
        onState: (context, SuccessSettingsState state) {
          var usuario = state.usuario;
          return ListView(
            children: [
              SizedBox(
                height: context.screenHeight * .3,
                width: double.infinity,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/background-nature.jpg',
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 55,
                      left: context.screenWidth * .4,
                      child: Row(
                        children: [
                          Visibility(
                            visible: controller.uploading,
                            child: Text(
                              '${controller.total.round()}% enviado',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                backgroundColor: Colors.black26,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Visibility(
                            visible: controller.uploading,
                            child: const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 100,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.green[200],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Visibility(
                                    visible:
                                        usuario['avatarUrl'] == 'not-found',
                                    replacement: Image.network(
                                      state.usuario['avatarUrl'],
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/image-found.jpg',
                                        );
                                      },
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.white70,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              TextButton(
                                onPressed: () async =>
                                    await controller.saveAvatar(),
                                child: Text(
                                  'Trocar avatar',
                                  style: GoogleFonts.aBeeZee(
                                      color: Colors.white,
                                      backgroundColor: Colors.black26,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.blue,
                                      decorationStyle:
                                          TextDecorationStyle.double),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            usuario['nome'] ?? 'Fulano',
                            style: GoogleFonts.aBeeZee(
                                color: Colors.white,
                                backgroundColor: Colors.black26),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            usuario['email'] ?? 'Fulano@gmail.com',
                            style: GoogleFonts.aBeeZee(
                                color: Colors.white,
                                fontSize: 12,
                                backgroundColor: Colors.black26),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.favorite),
                title: Text('Favorite images', style: GoogleFonts.aBeeZee()),
                onTap: () => Modular.to.navigate('/favorite-module'),
              ),
              ListTile(
                leading: const Icon(Icons.email_rounded),
                title: Text('Letter', style: GoogleFonts.aBeeZee()),
                onTap: () => Modular.to.navigate('/cartas-module/'),
              ),
              Divider(color: Colors.grey[400]),
              ListTile(
                leading: Icon(
                  Icons.exit_to_app_rounded,
                  color: Colors.red[200],
                ),
                title: Text('Exit',
                    style: GoogleFonts.aBeeZee(color: Colors.red[200])),
                onTap: () {
                  authController.logout();
                  homeController.images.clear();
                  homeController.refs.clear();
                },
              )
            ],
          );
        },
      ),
    );
  }
}
