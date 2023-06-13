import 'package:app_mari/configs/app_setting.dart';
import 'package:app_mari/src/helpers/messages.dart';
import 'package:app_mari/src/helpers/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:validatorless/validatorless.dart';
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
                          validator: Validatorless.multiple([
                            Validatorless.email('E-mail Inválido'),
                            Validatorless.required('E-mail Obrigatório'),
                          ]),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: controller.senha,
                          decoration: const InputDecoration(
                            label: Text('Senha'),
                            border: OutlineInputBorder(),
                          ),
                          style: const TextStyle(color: Colors.white),
                          validator: Validatorless.multiple([
                            Validatorless.required('Senha Obrigatória'),
                            Validatorless.min(
                              6,
                              'Senha precisa ter pelo menos 6 caracteres',
                            )
                          ]),
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
                            onPressed: () {
                              var formValid =
                                  controller.formKey.currentState?.validate() ??
                                      false;
                              if (formValid) {
                                controller.login(context);
                              } else {
                                context.showWarning('Formulário Inválido', context);
                              }
                            },
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
