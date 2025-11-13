import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:descarte_bem/controllers/map_controller.dart' as mc;
import 'package:provider/provider.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';

import '../controllers/user_controller.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.controller});

  final mc.MapController controller;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  final MapController mapController = MapController();
  List<Marker> markers = [];

  late final animatedMapController = AnimatedMapController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
      mapController: mapController
  );

  @override
  Widget build(BuildContext context) {
    if (widget.controller.loading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    _getMarkersList(context);
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(
          icon: Icon(Icons.logout),
          color: Colors.white,
          onPressed: () {
            context.read<UserController>().logout();
          },
        ),
        backgroundColor: const Color.fromRGBO(43, 75, 140, 1),
        elevation: 0,
        toolbarHeight: 60,
        title: const Text("Descarte Bem", style: TextStyle(color: Colors.white)),
        titleTextStyle: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w400, fontSize: 22),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.question_mark),
            color: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, '/FAQ');
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFD9D9D9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: FlutterMap(
                mapController: animatedMapController.mapController,
                options: MapOptions(
                  center: widget.controller.position,
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
                            Icons.pin_drop_sharp,
                            size: 50,
                          );
                        },
                      ),
                    ],
                  ),
                  MarkerLayer(markers: markers),
                ],
              ),
            ),
          ],
        ),
      ),
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
          icon: const Icon(Icons.medication_rounded, color: Colors.red),
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
