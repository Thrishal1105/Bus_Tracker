import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'b3_driver_info.dart';
import 'b3_livemap.dart';
import 'package:flutter_map/flutter_map.dart';

class BusStop {
  final String stop;
  final String scheduledTime;
  final String actualTime;
  final double lat;
  final double lng;
  final bool isLeft;
  final bool isCurrent;

  BusStop({
    required this.stop,
    required this.scheduledTime,
    required this.actualTime,
    required this.lat,
    required this.lng,
    this.isLeft = false,
    this.isCurrent = false,
  });

  BusStop copyWith({bool? isLeft, bool? isCurrent}) {
    return BusStop(
      stop: stop,
      scheduledTime: scheduledTime,
      actualTime: actualTime,
      lat: lat,
      lng: lng,
      isLeft: isLeft ?? this.isLeft,
      isCurrent: isCurrent ?? this.isCurrent,
    );
  }
}



final List<BusStop> initialStops = [
  BusStop(stop: "Starting Bus Stop", scheduledTime: "08:00", actualTime: "08:05", lat: 16.361376, lng:78.055786),
  BusStop(stop: "Bus Stop", scheduledTime: "08:10", actualTime: "08:15", lat: 16.357906, lng: 78.060661),
  BusStop(stop: "Trends Shopping Mall", scheduledTime: "08:20", actualTime: "08:22", lat: 16.365681, lng:78.059219),
  BusStop(stop: "Nagavaram", scheduledTime: "08:27", actualTime: "08:30", lat: 16.364462, lng: 78.050026),
  BusStop(stop: "Rajapet", scheduledTime: "08:35", actualTime: "08:40", lat: 16.362213, lng: 78.044662),
  // BusStop(stop: "Kothakota", scheduledTime: "08:45", actualTime: "08:50", lat: 16.362213, lng: 78.044662),
  // BusStop(stop: "Veltor", scheduledTime: "08:55", actualTime: "09:00", lat: 16.362213, lng: 78.044662 ),
  // BusStop(stop: "Adakal", scheduledTime: "09:10", actualTime: "09:15", lat: 16.362213, lng: 78.044662  ),
  // BusStop(stop: "Shakapur", scheduledTime: "09:20", actualTime: "09:25", lat: 16.362213, lng: 78.044662 ),
  // BusStop(stop: "Moosapet", scheduledTime: "09:30", actualTime: "09:35", lat: 16.362213, lng: 78.044662 ),
  // BusStop(stop: "Janampet", scheduledTime: "09:40", actualTime: "09:45", lat:16.362213 , lng: 78.044662),
  // BusStop(stop: "Gajulapeta", scheduledTime: "09:40", actualTime: "09:45", lat: 16.440000, lng: 77.820000),
  // BusStop(stop: "JPNCE", scheduledTime: "09:50", actualTime: "10:00", lat: 16.440000, lng: 77.820000),
];

class B3MapPage extends StatefulWidget {
  const B3MapPage({super.key});

  @override
  State<B3MapPage> createState() => _B3MapPageState();
}

class _B3MapPageState extends State<B3MapPage> {
  final ScrollController _scrollController = ScrollController();
  List<BusStop> stops = List.from(initialStops);
  // LatLng? busLocation;
  // bool isLoading = true;
  // String? error;
  // Timer? _timer;

  @override
  void initState() {
    super.initState();
    // fetchBusLocation();
    // _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
    //   fetchBusLocation();
    // });
  }

  @override
  void dispose() {
    // _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  // Future<void> fetchBusLocation() async { ... }
  // void updateStopsWithBusLocation() { ... }
  // int get currentStopIndex => stops.indexWhere((s) => s.isCurrent);
  // void scrollToCurrentStop() { ... }
  // void onRefresh() { fetchBusLocation(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Details'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const B3LiveMapPage()),
                    );
                  },
                  child: Column(
                    children: [
                      const Text('MAP', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        height: 3,
                        width: 60,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text('FULL ROUTE', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      height: 3,
                      width: 60,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const B3DriverInfoPage()),
                    );
                  },
                  child: Column(
                    children: [
                      const Text('BUS INFO', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(stops[0].lat, stops[0].lng),
                    zoom: 14.0,
                    interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: stops.map((s) => LatLng(s.lat, s.lng)).toList(),
                          color: Colors.teal,
                          strokeWidth: 5.0,
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: [
                        for (final stop in stops)
                          Marker(
                            width: 30.0,
                            height: 30.0,
                            point: LatLng(stop.lat, stop.lng),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.teal,
                              size: 28,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: stops.length,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
              itemBuilder: (context, index) {
                final stop = stops[index];
                final isFirst = index == 0;
                final isLast = index == stops.length - 1;
                final isLeft = stop.isLeft;
                final isCurrent = stop.isCurrent;
                final isCompleted = isLeft;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline
                    Container(
                      width: 48,
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          if (!isFirst)
                            Container(
                              width: 4,
                              height: 32,
                              color: isCompleted || isCurrent ? Colors.teal : Colors.grey[300],
                            ),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isCurrent
                                  ? Colors.white
                                  : isCompleted
                                      ? Colors.teal
                                      : Colors.white,
                              border: Border.all(
                                color: isCurrent
                                    ? Colors.teal
                                    : isCompleted
                                        ? Colors.teal
                                        : Colors.grey,
                                width: 3,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: isCurrent
                                ? const Icon(Icons.directions_bus, color: Colors.teal, size: 20)
                                : isCompleted
                                    ? const Icon(Icons.directions_bus, color: Colors.white, size: 18)
                                    : null,
                          ),
                          if (!isLast)
                            Container(
                              width: 4,
                              height: 32,
                              color: isCurrent || isCompleted ? Colors.teal : Colors.grey[300],
                            ),
                        ],
                      ),
                    ),
                    // Stop card
                    Expanded(
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(stop.stop, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.arrow_right_alt, size: 18, color: Colors.teal),
                                      Text(stop.scheduledTime, style: const TextStyle(color: Colors.teal)),
                                      const SizedBox(width: 16),
                                      const Icon(Icons.arrow_right_alt, size: 18, color: Colors.teal),
                                      Text(stop.actualTime, style: const TextStyle(color: Colors.teal)),
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              if (isLeft)
                                const Text('Bus Left', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                              if (isCurrent)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text('Current Stop', style: TextStyle(color: Colors.white)),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 