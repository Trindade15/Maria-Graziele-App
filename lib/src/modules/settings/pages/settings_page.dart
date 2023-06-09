// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:app_mari/src/helpers/size_extensions.dart';
import 'package:app_mari/src/modules/settings/settings_store.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage();

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final store = Modular.get<SettingsStore>();

  @override
  void initState() {
    store.getCartas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Letters'),
        centerTitle: true,
        elevation: 0,
      ),
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
          return Visibility(
            visible: state.cartas.isNotEmpty,
            replacement: CartaItem(
              carta: CartaInterface(carta: '', titulo: 'Sem nenhuma Carta'),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: state.cartas.length,
              itemBuilder: (context, index) {
                var cartas = state.cartas[index];
                var carta = CartaInterface(
                  carta: cartas['carta'],
                  titulo: cartas['titulo'],
                );
                return CartaItem(
                  carta: carta,
                  onTap: () {
                    Modular.to.pushNamed(
                      '/settings/letter-page',
                      arguments: carta,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class CartaItem extends StatelessWidget {
  final CartaInterface carta;
  final Function()? onTap;
  const CartaItem({required this.carta, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 0.5),
        gradient: LinearGradient(
          colors: [
            Colors.green.withOpacity(0.2),
            Colors.pink.withOpacity(0.1),
            Colors.blue.withOpacity(0.2)
          ],
        ),
      ),
      child: ListTile(
        dense: true,
        splashColor: Colors.green.withOpacity(0.5),
        onTap: onTap,
        title: Text(
          carta.titulo ?? 'new letter',
          style: GoogleFonts.aBeeZee(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.green,
          ),
        ),
        trailing: Icon(
          Icons.email_rounded,
          color: Colors.blue.withOpacity(0.3),
        ),
      ),
    );
  }
}

class CartaInterface {
  String carta;
  String? titulo;
  CartaInterface({required this.carta, required this.titulo});

  @override
  String toString() => 'CartaInterface(carta: $carta, titulo: $titulo)';
}
