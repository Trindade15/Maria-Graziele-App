import 'package:app_mari/src/helpers/size_extensions.dart';
import 'package:app_mari/src/modules/album_photos/abum_photos_store.dart';
import 'package:app_mari/src/modules/album_photos/controller/album_photos_controller.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../home/components/layout_image.dart';

class AlbumPhotosPage extends StatefulWidget {
  const AlbumPhotosPage({super.key});

  @override
  State<AlbumPhotosPage> createState() => _AlbumPhotosPageState();
}

class _AlbumPhotosPageState extends State<AlbumPhotosPage> {
  late final AlbumStore store;
  final controller = Modular.get<AlbumController>();

  @override
  void initState() {
    store = Modular.get<AlbumStore>(defaultValue: AlbumStore(controller));
    store.buscarimages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = GoogleFonts.gentiumBookBasic(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 16),
          child: SafeArea(
            child: Row(
              children: [
                Image.asset(
                  'assets/images/coroa.png',
                  height: 32,
                  width: 32,
                ),
                const SizedBox(width: 8),
                Text('I and he', style: textStyle),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        height: context.screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(0, 44, 118, 1),
              Colors.blue,
              Colors.black,
            ],
          ),
        ),
        child: ScopedBuilder(
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
          onState: (context, SuccessAlbumState state) {
            print('State: ${state.images.length}');
            return Visibility(
              visible: state.images.isNotEmpty,
              replacement: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text(
                          'Olá Majestade 👑',
                          style: textStyle.copyWith(
                            fontSize: 18,
                            color: const Color.fromRGBO(249, 184, 79, 1),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Chegou o momento de elevar toda a sua beleza a um novo patamar de glamour. Adicione suas fotos aqui e permita que o mundo 🌏 aprecie toda a sua estonteante e radiante presença! Desperte o brilho que está dentro de você e ilumine a todos com o seu esplendor!✨',
                          style: textStyle.copyWith(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        // TextButton(
                        //   onPressed: () {},
                        //   child: Text(
                        //     'Clique aqui',
                        //     style: textStyle.copyWith(
                        //       fontSize: 14,
                        //       color: Colors.blue.shade700,
                        //     ),
                        //   ),
                        // ),
                        ElevatedButton(
                          onPressed: () => controller.pickAndUploadImage(),
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.indigo)),
                          child: Text(
                            'Clique aqui',
                            style: textStyle.copyWith(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LayoutImage(
                  images: state.images,
                  onPressed: (index) {},
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
