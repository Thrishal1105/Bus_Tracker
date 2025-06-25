import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './b4_routes.dart';
import './b4_driver_info.dart';
import 'dart:async';

class B4MapPage extends StatefulWidget {
  const B4MapPage({super.key});

  @override
  State<B4MapPage> createState() => _B4MapPageState();
}

class _B4MapPageState extends State<B4MapPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Location Map'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'B4 Bhoothpur',
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
                child: Center(
                  child: Text(
                    'Map is available later',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const B4RoutesPage()),
                    );
                  },
                  icon: const Icon(Icons.alt_route),
                  label: const Text('Routes'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(width: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const B4DriverInfoPage()),
                    );
                  },
                  icon: const Icon(Icons.person),
                  label: const Text('Driver Info'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
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
                heroTag: 'zoomInB4',
                mini: true,
                onPressed: _zoomIn,
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 12),
              FloatingActionButton(
                heroTag: 'zoomOutB4',
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
            heroTag: 'closeMapB4',
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