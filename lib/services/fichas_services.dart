import 'dart:convert';

import 'package:fichas/models/fichas_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FichasServices extends ChangeNotifier {
  final String _baseUrl = process.env.URL;
  final List<Ficha> fichas = [];
  late Ficha selectedFicha;

  bool isLoading = true;

  FichasServices() {
    loadFichas();
  }

  Future loadFichas() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, "Fichas.json");
    final resp = await http.get(url);

    final Map<String, dynamic> fichasMap = json.decode(resp.body);

    fichasMap.forEach((key, value) {
      final tempFicha = Ficha.fromMap(value);
      tempFicha.folio = key;
      fichas.add(tempFicha);
    });

    isLoading = false;
    notifyListeners();
    return fichas;
  }

  Future updateFicha(Ficha fichaSeleccionada, String funcion) async {
    final url = Uri.https(_baseUrl, 'Fichas/${fichaSeleccionada.folio}.json');
    await http.patch(url, body: jsonEncode({"status": funcion}));

    notifyListeners();
  }
}
