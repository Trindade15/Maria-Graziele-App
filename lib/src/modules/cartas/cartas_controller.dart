import 'package:app_mari/database/db_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartasController extends ChangeNotifier {
  List<dynamic> cartas = [];
  late FirebaseFirestore db;
  final firestore = FirebaseFirestore.instance;

  startRepository() async {
    await _startFirestore();
  }

  _startFirestore() {
    db = DbFirestore.get();
  }

  saveAll(String carta, String titulo) async {
    if (carta.isNotEmpty) {
      await db.collection('usuarios/maria/cartas').doc(titulo).set(
        {
          'carta': carta,
          'titulo': titulo,
        },
      );
    }
    notifyListeners();
  }

  Future<List<dynamic>> getCartas() async {
    var snapshot = await firestore.collection('cartas').get();
    for (var doc in snapshot.docs) {
      var carta = doc.data();
      carta['id'] = doc.id;
      cartas.add(carta);
    }
    notifyListeners();
    return cartas;
  }

  remove(Map carta) async {
    await db.collection('usuarios/maria/cartas').doc(carta['titulo']).delete();
    cartas.remove(carta);
    notifyListeners();
  }
}
