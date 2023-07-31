import 'package:app_mari/src/helpers/size_extensions.dart';
import 'package:app_mari/src/modules/favorite/favorite_store.dart';
import 'package:app_mari/src/modules/home/components/home_image_detail.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../home/components/layout_image.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final store = Modular.get<FavoriteStore>();

  @override
  void initState() {
    store.getFavoritePhotos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My favorite photos'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: ScopedBuilder(
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
          store: store,
          onState: (context, SuccessFavoriteState state) {
            var favorites = state.favorites
                .where((image) => int.tryParse(image['isFavorite']) == 1)
                .toList();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Visibility(
                visible: favorites.isNotEmpty,
                replacement: Column(
                  children: [
                    Text(
                      'Amor, sei que você é linda e exuberante e maravilhosa, então tenho certeza de que tem muitas fotos incríveis✨ que você gostaria de marcar como favorita❤️ Fico ansioso para ver todas. Mas, se por acaso ainda não adicionou nenhuma, não tem problema - eu continuarei achando você a coisa mais maravilhosa deste mundo. Te amo 💗',
                      style: GoogleFonts.adamina(fontSize: 16, height: 1.4),
                    ),
                    const SizedBox(height: 10),
                    Image.asset('assets/images/icon-logo-remove-bg.png')
                  ],
                ),
                child: LayoutImage(
                  images: favorites,
                  onPressed: (index) {
                    var detail = ImageDetailInterface(
                      tag: index.toString(),
                      imagePath: favorites[index]['imagePath'],
                      fullPath: favorites[index]['fullPath'],
                      isFavorite: favorites[index]['isFavorite'].toString(),
                      id: favorites[index]['id'] ?? '',
                      usuarioId: favorites[index]['usuarioId'],
                      date: favorites[index]['date'],
                      hour: favorites[index]['hour'],
                      comentario: favorites[index]['comentario']
                    );
                    Modular.to.pushNamed('./favorite-detail', arguments: detail);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
