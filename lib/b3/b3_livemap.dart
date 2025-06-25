import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class B3LiveMapPage extends StatefulWidget {
  const B3LiveMapPage({super.key});

  @override
  State<B3LiveMapPage> createState() => _B3LiveMapPageState();
}

class _B3LiveMapPageState extends State<B3LiveMapPage> {
  LatLng? busLocation;
  bool isLoading = true;
  String? error;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchBusLocation();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      fetchBusLocation();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchBusLocation() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse('https://www.waveshare.cloud/api/sample-test/'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final value = data['value'] as String;
        final params = value.split('&').fold<Map<String, String>>({}, (map, pair) {
          final kv = pair.split('=');
          if (kv.length == 2) map[kv[0]] = kv[1];
          return map;
        });
        final lat = double.tryParse(params['lat'] ?? '');
        final lng = double.tryParse(params['lng'] ?? '');
        if (lat != null && lng != null) {
          setState(() {
            busLocation = LatLng(lat, lng);
            isLoading = false;
            error = null;
          });
        } else {
          setState(() {
            error = 'Invalid coordinates from server.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          error = 'Failed to fetch location (status: \\${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: \\${e.toString()}';
        isLoading = false;
      });
    }
  }

  void _openFullScreenMap() {
    if (busLocation != null) {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'Close',
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, anim1, anim2) {
          return Material(
            color: Colors.black.withOpacity(0.95),
            child: SafeArea(
              child: FullScreenMap(busLocation: busLocation!),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('B3 Live Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchBusLocation,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'B3 Wanaparthy',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Card(
              margin: const EdgeInsets.all(24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: SizedBox(
                width: 350,
                height: 400,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : (busLocation == null)
                              ? Center(child: Text(error ?? 'Unknown error'))
                              : FlutterMap(
                                  options: MapOptions(
                                    center: busLocation,
                                    zoom: 14.0,
                                    interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      subdomains: const ['a', 'b', 'c'],
                                    ),
                                    MarkerLayer(
                                      markers: [
                                        Marker(
                                          width: 40.0,
                                          height: 40.0,
                                          point: busLocation!,
                                          child: const Icon(
                                            Icons.directions_bus,
                                            color: Colors.red,
                                            size: 36,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: FloatingActionButton(
                          heroTag: 'fullscreenMapB3',
                          mini: true,
                          backgroundColor: Colors.white,
                          onPressed: _openFullScreenMap,
                          child: const Icon(Icons.fullscreen, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenMap extends StatefulWidget {
  final LatLng busLocation;
  const FullScreenMap({super.key, required this.busLocation});

  @override
  State<FullScreenMap> createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  late MapController _mapController;
  double _zoom = 14.0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  void _zoomIn() {
    setState(() {
      _zoom += 1;
      _mapController.move(widget.busLocation, _zoom);
    });
  }

  void _zoomOut() {
    setState(() {
      _zoom -= 1;
      _mapController.move(widget.busLocation, _zoom);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: widget.busLocation,
              zoom: _zoom,
              interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 40.0,
                    height: 40.0,
                    point: widget.busLocation,
                    child: const Icon(
                      Icons.directions_bus,
                      color: Colors.red,
                      size: 36,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 40,
          right: 20,
          child: Column(
            children: [
              FloatingActionButton(
                heroTag: 'zoomInB3',
                mini: true,
                onPressed: _zoomIn,
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 12),
              FloatingActionButton(
                heroTag: 'zoomOutB3',
                mini: true,
                onPressed: _zoomOut,
                child: const Icon(Icons.remove),
              ),
            ],
          ),
        ),
        Positioned(
          top: 40,
          left: 20,
          child: FloatingActionButton(
            heroTag: 'closeMapB3',
            mini: true,
            backgroundColor: Colors.white,
            onPressed: () => Navigator.of(context).pop(),
            child: const Icon(Icons.close, color: Colors.black),
          ),
        ),
      ],
    );
  }
} 