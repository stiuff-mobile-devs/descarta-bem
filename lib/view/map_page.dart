import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:descarte_bem/controllers/map_controller.dart' as mc;
import 'package:flutter_map_animations/flutter_map_animations.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.controller});

  final mc.MapController controller;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.controller.init(),
      builder: (context, snapshot) {
        _getMarkersList(context);
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height*0.778,
                child: FlutterMap(
                  options: MapOptions(
                    center: widget.controller.position!,
                    zoom: 17.0,
                    minZoom: 5.0,
                    maxZoom: 18.0,
                    interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'br.uff.descarte_bem',
                    ),
                    AnimatedMarkerLayer(
                      markers: [
                        AnimatedMarker(
                          duration: const Duration(milliseconds: 500),
                          point: widget.controller.position!,
                          builder: (_, __) {
                            return const Icon(
                              Icons.person,
                              size: 30,
                            );
                          },
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: markers,
                    )
                  ],
                ),
              )
            ],
          )
        );
      },
    );
  }

  _getMarkersList(BuildContext context) {
    if (widget.controller.pharmacies.isNotEmpty) {
      for (var p in widget.controller.pharmacies) {
        double distance = widget.controller.getDistance(p);
        markers.add(
          customMarker(
            distance.round(),
            p.position.latitude,
            p.position.longitude,
            p.name,
            context
          )
        );
      }
    }
  }

  Marker customMarker(int distance,
      double lat, double long, String nome, BuildContext context) {
    return Marker(
      point: LatLng(lat, long),
      width: 80,
      height: 80,
      builder: (_){
        return IconButton(
          iconSize: 50,
          padding: const EdgeInsets.all(50),
          icon: const Icon(Icons.medication_rounded, color: Colors.green),
          onPressed: () {
            debugPrint("AAAAAaaaAAAA");
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    '$nome \n${distance}m',
                    textAlign: TextAlign.center,
                  ),
                );
              }
            );
          },
        );
      },
    );
  }
}
