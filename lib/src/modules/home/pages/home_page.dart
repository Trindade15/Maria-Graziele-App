import 'dart:ui';

import 'package:app_mari/src/components/app_bar_component.dart';
import 'package:app_mari/src/helpers/size_extensions.dart';
import 'package:app_mari/src/modules/auth/auth_controller.dart';
import 'package:app_mari/src/modules/home/components/home_image_detail.dart';
import 'package:app_mari/src/modules/home/components/layout_image.dart';
import 'package:app_mari/src/modules/home/controller/home_controller.dart';
import 'package:app_mari/src/modules/home/home_store.dart';
import 'package:app_mari/src/ui/styles/colors_app.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeStore homeStore;
  final controller = Modular.get<HomeController>();
  final authController = Modular.get<AuthController>();
  final scrollController = ScrollController();

  @override
  void initState() {
    homeStore = Modular.get<HomeStore>(defaultValue: HomeStore(controller));
    homeStore.getImages();
    super.initState();
    controller.addListener(<HomeController>() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: scrollController,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Visibility(
                  visible: controller.images.isEmpty,
                  child: Image.asset(
                    'assets/images/background-castelo.jpg',
                    fit: BoxFit.cover,
                    height: context.screenHeight - 60,
                    width: double.infinity,
                  ),
                ),
                ScopedBuilder(
                  store: homeStore,
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
                  onState: (context, SuccessHomeState state) {
                    return Stack(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Visibility(
                                visible: state.images.isNotEmpty,
                                replacement: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.yellow.withOpacity(0.1),
                                        Colors.amber.shade300.withOpacity(0.2),
                                        Colors.brown.shade400.withOpacity(0.1),
                                      ],
                                      begin: Alignment.topLeft,
                                      tileMode: TileMode.mirror,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          'Hey princesa 👑 Está na hora de dar à sua beleza o destaque que ela merece. Adicione suas fotos aqui e deixe o mundo 🌍 ver como você é maravilhosa! ✨',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.amber[200],
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async => await controller
                                            .pickAndUploadImage(),
                                        child: const Text(
                                          'Clique aqui',
                                          style: TextStyle(
                                            color: Colors.white,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                child: LayoutImage(
                                  images: state.images,
                                  onPressed: (int index) =>
                                      openImageItem(index, state.images[index]),
                                ),
                              ),
                            ),
                          ],
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
                      ],
                    );
                  },
                )
              ],
            );
          },
        ),
      ),
      floatingActionButton: Visibility(
        visible: controller.images.isNotEmpty,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'bnt1',
              backgroundColor: context.colors.primary,
              onPressed: () {
                Modular.to.pushNamed('/album-photos-module/');
              },
              
              child: Icon(
                Icons.photo_library,
                color: Colors.pink[200],
              ),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              heroTag: 'bnt2',
              backgroundColor: context.colors.primary,
              onPressed: () => controller.pickAndUploadImage(),
              child: Visibility(
                visible: !controller.uploading,
                replacement: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.pink[200],
                      ),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add_photo_alternate_rounded,
                  color: Colors.pink[200],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  openImageItem(int index, Map img) {
    final image = ImageDetailInterface(
      tag: index.toString(),
      imagePath: img['imagePath'],
      fullPath: img['fullPath'],
      isFavorite: img['isFavorite'].toString(),
      id: img['id'] ?? '',
      usuarioId: img['usuarioId'],
      date: img['date'],
      hour: img['hour'],
      controller: controller,
      comentario: img['comentario'],
    );
    Modular.to.pushNamed('/home/home-detail', arguments: image);
  }
}
