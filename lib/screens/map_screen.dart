import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:latlong2/latlong.dart' as latlng;
import '../models/place.dart';

class MapScreen extends StatefulWidget {
  // recebe lat e long padrão a ser mostrada inicialmente, se não estiver setada mostra a padrão
  final PlaceLocation initialLocation;
  final bool isSelecting;
  MapScreen(
      {this.initialLocation =
          const PlaceLocation(latitude: -23.569953, longitude: -46.635863),
      this.isSelecting = true});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  latlng.LatLng? _pickedLocation;

  void _retPositionMap(dynamic positio, latlng.LatLng direct) {
    setState(() {
      _pickedLocation = direct;
      //print(_pickedLocation!.latitude);
    });
    //print(positio.runtimeType);
    // print(direct.latitude);
    // print(direct.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick a place'),
        actions: [
          // so mostra botao se não for null
          if (widget.isSelecting)
            IconButton(
              onPressed: _pickedLocation == null
                  ? null
                  : () {
                      // devolve o local escolhido para a pagina add_place_screen
                      Navigator.of(context).pop(_pickedLocation);
                    },
              icon: Icon(Icons.check),
            ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          //center: latlng.LatLng(-23.569953, -46.635863),
          center: latlng.LatLng(widget.initialLocation.latitude!,
              widget.initialLocation.longitude!),
          zoom: 14.0,
          //onTap: _handleTap,
          onTap: true ? _retPositionMap : null,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate:
                "https://api.mapbox.com/styles/v1/dxxxxx021/ckwii7q6b284d14s0jrauou3d/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZxxxxxxxxxxxxxxIsImEiOiJja3dpOGc2cHgxNXZoMnB1dGVvOWViaWs1In0.2x2m7ka-KZwzBR5XXgYkXQ",
            // subdomains: ['a', 'b', 'c'],
            additionalOptions: {
              'accessToken':
                  'pk.eyJ1IjoiZGVtaWFuMjAyMSIsImEiOiJja3dpOGc2cHgxNXZoMnBxxxxxxxxxxxxxxxxn0.2x2m7ka-KZwzBR5XXgYkXQ',
              'id': 'mapbox.mapbox-streets-v8',
            },
            attributionBuilder: (_) {
              return Text("© Done by demianescobar@gmail.com");
            },
          ),
          MarkerLayerOptions(
            markers: _pickedLocation == null
                ? [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: latlng.LatLng(widget.initialLocation.latitude!,
                          widget.initialLocation.longitude!),

                      builder: (ctx) => Container(
                        child: Icon(Icons.add_location),
                      ),
                    ),
                  ]
                : [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: latlng.LatLng(_pickedLocation!.latitude,
                          _pickedLocation!.longitude),
                      //point:  latlng.LatLng(-23.5732052, -46.6331934),

                      builder: (ctx) => Container(
                        child: Icon(Icons.add_location),
                      ),
                    ),
                  ],
          ),
        ],
      ),
    );
  }
}
