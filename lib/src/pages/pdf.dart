import 'dart:typed_data';

import 'package:fichas/models/fichas_model.dart';
import 'package:fichas/services/services.dart';
import 'package:flutter/material.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class PdfScreen extends StatelessWidget {
  const PdfScreen({Key? key, this.fichaSeleccionada}) : super(key: key);

  final Ficha? fichaSeleccionada;

  @override
  Widget build(BuildContext context) {
    final fichasServices = Provider.of<FichasServices>(context);

    String latLong = fichasServices.selectedFicha.latLong;
    latLong = latLong.replaceAll("LatLng(", "").replaceAll(")", "");

    List<String> lat = latLong.split(",");

    StaticMapController _controller = StaticMapController(
      googleApiKey: process.env.apikeygoogle,
      width: 500,
      height: 1000,
      zoom: 17,
      center: Location(double.parse(lat[0]), double.parse(lat[1])),
      markers: <Marker>[
        Marker(
          locations: [
            Location(double.parse(lat[0]), double.parse(lat[1])),
          ],
        ),
      ],
    );

    Ficha fichaActual = fichasServices.selectedFicha;
    return MaterialApp(
      home: Scaffold(
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
                  child: Text("     GENERAR PDF"),
                ),
              ),
            ],
          ),
        ),
        body: PdfPreview(
          canChangePageFormat: false,
          canDebug: false,
          build: (format) =>
              _generatePdf(fichaActual.folio, fichaActual, _controller),
        ),
      ),
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
    );
  }

  Future<Uint8List> _generatePdf(
    String title,
    Ficha fichaActual,
    StaticMapController _controller,
  ) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final image = await networkImage(fichaActual.fotoUrl);
    final imageGoogleMaps = await networkImage(_controller.url.toString());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return [
            pw.SizedBox(
              width: double.infinity,
              child: pw.FittedBox(
                child: pw.Text(title, style: pw.TextStyle(font: font)),
              ),
            ),
            pw.SizedBox(height: 20),
            _seccionFolio(fichaActual),
            pw.SizedBox(height: 20),
            _seccionDatosColaborador(fichaActual),
            pw.SizedBox(height: 20),
            _seccionUbicacionSitio(fichaActual),
            pw.SizedBox(height: 20),
            _seccionDatosGenerales(fichaActual),
            pw.SizedBox(height: 20),
            _crearItems(fichaActual.generadores, "Distancia: ", " metros",
                "generador", "distancia", "Generadores"),
            if (fichaActual.competencias!.isNotEmpty)
              _crearItems(fichaActual.competencias, "Distancia: ", " metros",
                  "competidor", "distancia", "Competencias"),
            _crearItems(fichaActual.conteos, "Personas: ", "", "fecha",
                "personas", "Conteos"),
            _seccionFortalezasDebilidades(fichaActual)
          ];
        },
      ),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return _fotografia(image);
        },
      ),
    );
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return _imagenGoogleMaps(imageGoogleMaps);
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _seccionFortalezasDebilidades(Ficha fichaActual) {
    return pw.Container(
      width: double.infinity,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            child: pw.Text(
              "Fortalezas y Debilidades",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 30),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text("Fortalezas:",
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 25)),
          pw.Text(fichaActual.fortalezas,
              style: const pw.TextStyle(fontSize: 20)),
          pw.SizedBox(height: 20),
          pw.Text("Debilidades:",
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 25)),
          pw.Text(fichaActual.debilidades,
              style: const pw.TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  pw.Widget _fotografia(image) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            child: pw.Text(
              "Fotografia del inmueble",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 30),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Image(image),
        ],
      ),
    );
  }

  pw.Widget _imagenGoogleMaps(image) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            child: pw.Text(
              "Ubicación",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 30),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Image(image),
        ],
      ),
    );
  }

  pw.Widget _seccionFolio(Ficha fichaActual) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            child: pw.Text(
              "Datos sobre la ficha",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 30),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text("Folio:",
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 25)),
          pw.Text(fichaActual.folio, style: const pw.TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  pw.Widget _seccionDatosColaborador(Ficha fichaActual) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            child: pw.Text(
              "Datos del colaborador",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 30),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text("Número de empleado:",
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 25)),
          pw.Text(fichaActual.numEmpleado,
              style: const pw.TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  pw.Widget _seccionUbicacionSitio(Ficha fichaActual) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            child: pw.Text(
              "Ubicación del sitio",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 30),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text("Dirección:",
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 25)),
          pw.Text(fichaActual.direccion,
              style: const pw.TextStyle(fontSize: 20)),
          pw.SizedBox(height: 20),
          pw.Text("Delegación o municipio:",
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 25)),
          pw.Text(fichaActual.delegacion,
              style: const pw.TextStyle(fontSize: 20)),
          pw.SizedBox(height: 20),
          pw.Text("Colonia:",
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 25)),
          pw.Text(fichaActual.colonia, style: const pw.TextStyle(fontSize: 20)),
          pw.SizedBox(height: 20),
          pw.Text("Entre calles:",
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 25)),
          pw.Text("${fichaActual.calle1} y ${fichaActual.calle2}",
              style: const pw.TextStyle(fontSize: 20)),
          pw.SizedBox(height: 20),
          pw.Text("Nombre del sitio:",
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 25)),
          pw.Text(fichaActual.nombreSitio,
              style: const pw.TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  pw.Widget _seccionDatosGenerales(Ficha fichaActual) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            child: pw.Text(
              "Datos generales del local",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 30),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text("Propietario:",
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 25)),
          pw.Text(fichaActual.propietario,
              style: const pw.TextStyle(fontSize: 20)),
          pw.SizedBox(height: 20),
          pw.Text("Teléfono:",
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 25)),
          pw.Text(fichaActual.telefono,
              style: const pw.TextStyle(fontSize: 20)),
          pw.SizedBox(height: 20),
          pw.Text("Venta/renta:",
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 25)),
          pw.Text(fichaActual.ventaRenta,
              style: const pw.TextStyle(fontSize: 20)),
          pw.SizedBox(height: 20),
          pw.Text("Frente:",
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 25)),
          pw.Text("${fichaActual.frente} metros",
              style: const pw.TextStyle(fontSize: 20)),
          pw.SizedBox(height: 20),
          pw.Text("Fondo:",
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 25)),
          pw.Text("${fichaActual.fondo} metros",
              style: const pw.TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  pw.Widget _crearItems(arreglo, tipo, medida, titulo, subtitulo, nombre) {
    List temporal = [];

    for (Map<String, dynamic> elemento in arreglo) {
      pw.Widget item =
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Text("${elemento[titulo]}", style: const pw.TextStyle(fontSize: 20)),
        pw.Text((tipo + "${elemento[subtitulo]}" + medida),
            style: const pw.TextStyle(fontSize: 20)),
        pw.SizedBox(height: 20),
      ]);
      temporal.add(item);
    }
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            nombre,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 30),
          ),
          pw.SizedBox(height: 20),
          ...temporal
        ],
      ),
    );
  }
}
