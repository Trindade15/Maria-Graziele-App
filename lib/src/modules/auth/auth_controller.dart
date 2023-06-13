import 'package:app_mari/configs/app_setting.dart';
import 'package:app_mari/database/db_firestore.dart';
import 'package:app_mari/src/helpers/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthController extends ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  late FirebaseFirestore db;
  final name = TextEditingController();
  final email = TextEditingController();
  final senha = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? avatarUrl = 'not-found';

  startRepository() async {
    await _startFirestore();
  }

  _startFirestore() {
    db = DbFirestore.get();
  }

  login(BuildContext context) async {
    var senha = this.senha.text.trim();
    var email = this.email.text.trim();
    try {
      await signInWithEmail(email, senha);
    } on FirebaseAuthException catch (e) {
      this.email.clear();
      this.senha.clear();
      if (e.code == 'user-not-found') {
        context.showError('Usuario não encontrado', context);
      } else if (e.code == 'wrong-password') {
        context.showError('Senha incorreta', context);
      } else {
        context.showError('Ocorreu um erro ${e.code}', context);
      }
    }
    notifyListeners();
  }

  signInWithEmail(String email, String senha) async {
    UserCredential userCredential =
        await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: senha,
    );
    if (userCredential.user != null) {
      await Modular.get<AppSetting>().setUsuario(userCredential);
      Modular.to.pushNamed('/home-module/');
      this.email.clear();
      this.senha.clear();
    }
  }

  Future<void> registerUser(BuildContext context) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.text,
        password: senha.text,
      );

      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(name.text);
        await userCredential.user!.updatePhotoURL(avatarUrl);
        await db.collection('usuarios').doc().set(
          {
            'id': userCredential.user!.uid,
            'nome': name.text,
            'email': userCredential.user!.email,
            'avatarUrl': 'not-found',
          },
        );
        await _firebaseAuth
            .signInWithEmailAndPassword(email: email.text, password: senha.text)
            .then(
          (userCredential) async {
            await Modular.get<AppSetting>().setUsuario(userCredential);
            Modular.to.navigate('/auth-module/');
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        context.showInfo('Crie uma senha mais forte', context);
      } else if (e.code == 'email-already-in-use') {
        context.showError('Este email já está cadastrado', context);
      }
    }
  }

  logout() async {
    await _firebaseAuth
        .signOut()
        .then((user) => Modular.to.navigate('/auth-module/'));
    notifyListeners();
  }
}
