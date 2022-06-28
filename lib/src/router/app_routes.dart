import 'package:flutter/material.dart';

import 'package:fichas/src/pages/pages.dart';

class AppRoutes {
  static const initialRoute = "home";

  static Map<String, Widget Function(BuildContext)> routes = {
    "home": (BuildContext context) => const HomePage(),
    "listadoFichas": (BuildContext context) => const ListadoFichas(),
    "detalles": (BuildContext context) => const Detalles(),
    "pdf": (BuildContext context) => const PdfScreen(),
    // "mapa": (BuildContext context) => const StaticMap(),
  };
}
