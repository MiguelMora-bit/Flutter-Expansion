import 'package:fichas/services/services.dart';
import 'package:flutter/material.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart';
import 'package:provider/provider.dart';

class StaticMap extends StatefulWidget {
  const StaticMap({Key? key}) : super(key: key);

  @override
  State<StaticMap> createState() => _StaticMapState();
}

class _StaticMapState extends State<StaticMap> {
  @override
  Widget build(BuildContext context) {
    /// Declare static map controller
    ///  Set<Marker> markers = <Marker>{};

    final fichasService = Provider.of<FichasServices>(context);

    String latLong = fichasService.selectedFicha.latLong;
    latLong = latLong.replaceAll("LatLng(", "").replaceAll(")", "");

    List<String> lat = latLong.split(",");

    StaticMapController _controller = StaticMapController(
      googleApiKey: process.env.apikeygoogle,
      width: 500,
      height: 900,
      zoom: 10,
      center: Location(double.parse(lat[0]), double.parse(lat[1])),
      markers: <Marker>[
        Marker(
          color: Colors.lightBlue,
          label: "A",
          locations: [
            Location(double.parse(lat[0]), double.parse(lat[1])),
          ],
        ),
      ],
    );

    /// Get map image provider from controller.
    /// You can also get image url by accessing
    /// `_controller.url` property.
    ImageProvider image = _controller.image;

    return Scaffold(
      body: Center(
        /// Display as a normal network image
        child: Image(image: image),
      ),
    );
  }
}
