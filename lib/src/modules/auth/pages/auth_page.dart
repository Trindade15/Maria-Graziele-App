import 'package:app_mari/configs/app_setting.dart';
import 'package:app_mari/src/helpers/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth_controller.dart';

class AuthPage extends StatefulWidget {
  AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final controller = Modular.get<AuthController>();

  @override
  void initState() {
    controller.startRepository();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppSetting>().startSettings();
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/castelo-entrada.jpg',
              height: context.screenHeight,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 55,
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text(
                  'Bem vinda de volta',
                  style: GoogleFonts.aBeeZee(
                      backgroundColor: Colors.black38,
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            // Positioned(
            //   top: 135,
            //   child: Padding(
            //     padding: const EdgeInsets.only(left: 16),
            //     child: SizedBox(
            //       width: context.screenWidth,
            //       child: Text(
            //         GlobalText.tituloLogin.texto,
            //         style: GoogleFonts.aBeeZee(
            //           color: Colors.white,
            //           height: 1.5,
            //           fontSize: 16,
            //           fontWeight: FontWeight.w600,
            //           backgroundColor: Colors.black12,
            //         ),
            //         softWrap: true,
            //       ),
            //     ),
            //   ),
            // ),
            Center(
              child: Form(
                key: controller.formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: controller.email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            label: Text(
                              'Email',
                            ),
                            border: OutlineInputBorder(),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: controller.senha,
                          decoration: const InputDecoration(
                            label: Text('Senha'),
                            border: OutlineInputBorder(),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 35),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: const ButtonStyle().copyWith(
                              backgroundColor: const MaterialStatePropertyAll(
                                Color.fromARGB(255, 61, 180, 67),
                              ),
                            ),
                            onPressed: () async => await controller.login(context),
                            child: const Text(
                              'Entrar',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              Modular.to.pushNamed('./auth-register-page'),
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all(Colors.black),
                          ),
                          child: const Text(
                            'Cadastre-se',
                            style: TextStyle(
                                color: Colors.white,
                                backgroundColor: Colors.black26),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
