import 'package:app_mari/src/helpers/size_extensions.dart';
import 'package:app_mari/src/modules/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthRegisterPage extends StatefulWidget {
  const AuthRegisterPage({super.key});

  @override
  State<AuthRegisterPage> createState() => _AuthRegisterPageState();
}

class _AuthRegisterPageState extends State<AuthRegisterPage> {
  final controller = Modular.get<AuthController>();

  @override
  void initState() {
    controller.startRepository();
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
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.name,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Nome'),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller.email,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Email'),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller.senha,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Senha'),
                    ),
                    style: const TextStyle(color: Colors.white),
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
                      onPressed: () async => await controller.registerUser(context),
                      child: const Text('Cadastrar'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
