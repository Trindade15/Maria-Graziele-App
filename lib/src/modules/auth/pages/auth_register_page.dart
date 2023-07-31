import 'dart:io';

import 'package:app_mari/src/helpers/messages.dart';
import 'package:app_mari/src/helpers/size_extensions.dart';
import 'package:app_mari/src/modules/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:validatorless/validatorless.dart';

class AuthRegisterPage extends StatefulWidget {
  const AuthRegisterPage({super.key});

  @override
  State<AuthRegisterPage> createState() => _AuthRegisterPageState();
}

class _AuthRegisterPageState extends State<AuthRegisterPage> {
  final formKey = GlobalKey<FormState>();
  final controller = Modular.get<AuthController>();

  @override
  void initState() {
    controller.startRepository();
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.name,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Nome'),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: Validatorless.multiple([
                        Validatorless.required('Nome Obrigatória'),
                        Validatorless.min(
                          4,
                          'Senha precisa ter pelo menos 6 caracteres',
                        )
                      ]),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: controller.email,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Email'),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: Validatorless.multiple([
                        Validatorless.email('E-mail Inválido'),
                        Validatorless.required('E-mail Obrigatório'),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: controller.senha,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Senha'),
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
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 61, 180, 67),
                          ),
                        ),
                        onPressed: () async {
                          var formValid = formKey.currentState?.validate() ?? false;
                          if (formValid) {
                            await controller.registerUser(context);
                          } else {
                            context.showWarning('Formulário Inválido', context);
                          }
                        },
                        child: Visibility(
                          visible: !controller.loading,
                          replacement: const SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(color: Colors.white),
                          ),
                          child: const Text('Cadastrar'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
