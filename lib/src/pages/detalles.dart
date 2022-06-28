import 'package:cached_network_image/cached_network_image.dart';
import 'package:fichas/services/fichas_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class Detalles extends StatelessWidget {
  const Detalles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fichasService = Provider.of<FichasServices>(context);

    String latLong = fichasService.selectedFicha.latLong;
    latLong = latLong.replaceAll("LatLng(", "").replaceAll(")", "");

    List<String> lat = latLong.split(",");

    CameraPosition _puntoInicial = CameraPosition(
      target: LatLng(double.parse(lat[0]), double.parse(lat[1])),
      zoom: 17,
    );

    Set<Marker> markers = <Marker>{};

    markers.add(Marker(
        markerId: const MarkerId('ubicacionLocal'),
        position: LatLng(double.parse(lat[0]), double.parse(lat[1]))));

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.red,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: FittedBox(
                child: Text("Ficha: ${fichasService.selectedFicha.folio}"),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              _seccionFolio(fichasService),
              _seccionColaborador(fichasService),
              _seccionUbicacionSitio(fichasService),
              _seccionDatosLocal(fichasService),
              // _seccionGeneradores(fichasService),
              _crearItems(
                  fichasService.selectedFicha.generadores,
                  "Distancia: ",
                  " metros",
                  "generador",
                  "distancia",
                  "Generadores"),
              if (fichasService.selectedFicha.competencias!.isNotEmpty)
                _crearItems(
                    fichasService.selectedFicha.competencias,
                    "Distancia: ",
                    " metros",
                    "competidor",
                    "distancia",
                    "Competencias"),
              _crearItems(fichasService.selectedFicha.conteos, "Personas: ", "",
                  "fecha", "personas", "Conteos"),
              _seccionFortalezasDebilidades(fichasService),
              _BackgroundImage(fichasService.selectedFicha.fotoUrl),
              _construirCroquis(_puntoInicial, markers),
              _crearSepador(),
              fichasService.selectedFicha.status == null
                  ? _Botones(
                      funcionAprobar: displayDialogConfirmation,
                      funcionRechazar: displayDialogConfirmation,
                    )
                  : const _BotonGuardarPdf(),
              _crearSepador()
            ],
          ),
        ),
      ),
    );
  }

  void displayDialogConfirmation(
      context, contenido, funcionalidad, fichasService) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            title: const Center(child: Text('Confirmación')),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(15)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(contenido),
                const SizedBox(height: 30),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar')),
              TextButton(
                  onPressed: () async {
                    await funcionalidad(fichasService);
                    Navigator.pop(context);
                  },
                  child: const Text('Aceptar')),
            ],
          );
        });
  }

  Widget _crearSepador() {
    return const SizedBox(
      height: 30,
    );
  }

  Widget _seccionFolio(FichasServices fichasServices) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      decoration: _cardBorders(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: const Text(
              "Datos sobre la ficha",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          ListTile(
            title: const Text("Folio:"),
            subtitle: Text(fichasServices.selectedFicha.folio),
          ),
        ],
      ),
    );
  }

  Widget _seccionFortalezasDebilidades(FichasServices fichasServices) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      decoration: _cardBorders(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: const Text(
              "Fortalezas y Debilidades",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          ListTile(
            title: const Text("Fortalezas:"),
            subtitle: Text(fichasServices.selectedFicha.fortalezas),
          ),
          ListTile(
            title: const Text("Debilidades:"),
            subtitle: Text(fichasServices.selectedFicha.debilidades),
          ),
        ],
      ),
    );
  }

  Widget _seccionColaborador(FichasServices fichasServices) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      decoration: _cardBorders(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: const Text(
              "Datos del colaborador",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          ListTile(
            title: const Text("Número de empleado:"),
            subtitle: Text(fichasServices.selectedFicha.numEmpleado),
          ),
        ],
      ),
    );
  }

  Widget _crearItems(arreglo, tipo, medida, titulo, subtitulo, nombre) {
    List temporal = [];

    for (Map<String, dynamic> elemento in arreglo) {
      Widget item = ListTile(
        title: Text("${elemento[titulo]}"),
        subtitle: Text((tipo + "${elemento[subtitulo]}" + medida)),
      );
      temporal.add(item);
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      decoration: _cardBorders(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Text(
              nombre,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          ...temporal
        ],
      ),
    );
  }

  Widget _seccionUbicacionSitio(FichasServices fichasServices) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      decoration: _cardBorders(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: const Text(
              "Ubicación del sitio",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          ListTile(
            title: const Text("Dirección:"),
            subtitle: Text(fichasServices.selectedFicha.direccion),
          ),
          ListTile(
            title: const Text("Delegación o Municipio:"),
            subtitle: Text(fichasServices.selectedFicha.delegacion),
          ),
          ListTile(
            title: const Text("Colonia:"),
            subtitle: Text(fichasServices.selectedFicha.colonia),
          ),
          ListTile(
            title: const Text("Entre calles:"),
            subtitle: Row(
              children: [
                Text(fichasServices.selectedFicha.calle1),
                const Text(" y "),
                Text(fichasServices.selectedFicha.calle2),
              ],
            ),
          ),
          ListTile(
            title: const Text("Nombre del sitio:"),
            subtitle: Text(fichasServices.selectedFicha.nombreSitio),
          )
        ],
      ),
    );
  }

  Widget _construirCroquis(_puntoInicial, myMarker) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      decoration: _cardBorders(),
      height: 500,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _puntoInicial,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
        gestureRecognizers: Set()
          ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
        markers: myMarker,
      ),
    );
  }

  Widget _seccionDatosLocal(FichasServices fichasServices) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      decoration: _cardBorders(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: const Text(
              "Datos generales del local",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          ListTile(
            title: const Text("Propietario:"),
            subtitle: Text(fichasServices.selectedFicha.propietario),
          ),
          ListTile(
            title: const Text("Teléfono:"),
            subtitle: Text(fichasServices.selectedFicha.telefono),
          ),
          ListTile(
            title: const Text("Venta/renta:"),
            subtitle: Text(fichasServices.selectedFicha.ventaRenta),
          ),
          ListTile(
            title: const Text("Frente:"),
            subtitle: Text(fichasServices.selectedFicha.frente + " metros"),
          ),
          ListTile(
            title: const Text("Fondo:"),
            subtitle: Text(fichasServices.selectedFicha.fondo + " metros"),
          )
        ],
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
                color: Colors.black38, offset: Offset(0, 7), blurRadius: 10)
          ]);
}

class _BackgroundImage extends StatelessWidget {
  final String? url;

  const _BackgroundImage(this.url);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
                color: Colors.black38, offset: Offset(0, 7), blurRadius: 10)
          ]),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: SizedBox(
          width: double.infinity,
          height: 400,
          child: CachedNetworkImage(
            placeholder: (context, url) => Image.asset(
              'assets/loading.gif',
              fit: BoxFit.cover,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
            imageUrl: url!,
          ),
        ),
      ),
    );
  }
}

class _Botones extends StatelessWidget {
  final Function funcionAprobar;
  final Function funcionRechazar;

  aceptarFicha(FichasServices fichasService) async {
    fichasService.selectedFicha.status = "Aprobada";
    fichasService.updateFicha(fichasService.selectedFicha, "Aprobada");
  }

  rechazarFicha(FichasServices fichasService) {
    fichasService.selectedFicha.status = "Rechazada";
    fichasService.updateFicha(fichasService.selectedFicha, "Rechazada");
  }

  const _Botones({
    Key? key,
    required this.funcionAprobar,
    required this.funcionRechazar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fichasService = Provider.of<FichasServices>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton(
          heroTag: "btn1",
          elevation: 0,
          backgroundColor: Colors.green,
          child: const Icon(Icons.done),
          onPressed: () => funcionAprobar(
            context,
            "¿Está seguro de aprobar esta ficha?",
            aceptarFicha,
            fichasService,
          ),
        ),
        FloatingActionButton(
          heroTag: "btn2",
          backgroundColor: Colors.red,
          elevation: 0,
          child: const Icon(Icons.clear),
          onPressed: () => funcionRechazar(
            context,
            "¿Está seguro de rechazar esta ficha?",
            rechazarFicha,
            fichasService,
          ),
        )
      ],
    );
  }
}

class _BotonGuardarPdf extends StatelessWidget {
  const _BotonGuardarPdf({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton(
            heroTag: "btn3",
            elevation: 0,
            backgroundColor: Colors.red,
            child: const Icon(Icons.picture_as_pdf),
            onPressed: () => Navigator.pushNamed(context, "pdf")),
      ],
    );
  }
}
