import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _boton(),
      ),
    );
  }

  Widget _boton() {
    return Column(
      children: [
        _separador(),
        _logo(),
        _texto(),
        _imagenTienda(),
        Expanded(
          child: Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: Colors.red,
                shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3))),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "listadoFichas");
              },
              child: const Text("EVALUAR FICHAS"),
            ),
          ),
        ),
      ],
    );
  }

  Widget _separador() {
    return Container(
      height: 60,
    );
  }

  Widget _logo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Image.asset(
        "assets/Logo3B.png",
        height: 100.0,
        width: 100.0,
      ),
    );
  }

  Widget _texto() {
    return Column(
      children: [
        const Text("“Queremos llevar nuestros ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("precios bajos ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                    color: Colors.red)),
            Text("cerca de ti”",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
          ],
        )
      ],
    );
  }

  Widget _imagenTienda() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(
          "assets/tiendas-3B.jpg",
        ),
      ),
    );
  }
}
