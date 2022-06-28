import 'package:fichas/services/services.dart';
import 'package:fichas/widgets/fichas_tarjetas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loading_screen.dart';

class ListadoFichas extends StatelessWidget {
  const ListadoFichas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fichasService = Provider.of<FichasServices>(context);

    if (fichasService.isLoading) return const LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.red,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              "assets/Logo3B.png",
              height: 50.0,
              width: 50.0,
            ),
            Container(
              width: 140,
            ),
            const Expanded(
              child: FittedBox(
                child: Text("            FICHAS"),
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          fichasService.fichas.clear();
          fichasService.loadFichas();
        },
        child: ListView.builder(
          itemCount: fichasService.fichas.length,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
            onTap: () {
              fichasService.selectedFicha = fichasService.fichas[index];
              Navigator.pushNamed(context, 'detalles');
            },
            child: FichasCard(
              ficha: fichasService.fichas[index],
            ),
          ),
        ),
      ),
    );
  }
}
