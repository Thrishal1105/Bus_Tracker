import 'package:flutter/material.dart';
import 'b1/b1_map.dart';
import 'b2/b2_map.dart';
import 'b3/b3_map.dart';
import 'b4/b4_map.dart';

class BusListPage extends StatefulWidget {
  const BusListPage({super.key});

  @override
  State<BusListPage> createState() => _BusListPageState();
}

class _BusListPageState extends State<BusListPage> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _buses = [
    {
      'busId': 'B1',
      'busName': 'Mahabubnagar',
      'routeStops': ['JPNCE', 'Pista House'],
      'eta': '5 mins',
      'occupancy': 'High (32/45)',
      'location': 'JPNCE',
      'status': 'On Time',
      'statusColor': Colors.green,
      'features': [],
    },
    {
      'busId': 'B2',
      'busName': 'Jadcherla',
      'routeStops': ['JPNCE', 'JCL'],
      'eta': '10 mins',
      'occupancy': 'High (28/30)',
      'location': 'JPNCE',
      'status': 'Delayed',
      'statusColor': Colors.orange,
      'features': [],
    },
    {
      'busId': 'B3',
      'busName': 'Wanaparthy',
      'routeStops': ['JPNCE', 'Wanaparthy Bus Stand'],
      'eta': '7 mins',
      'occupancy': 'Medium (15/40)',
      'location': 'JPNCE',
      'status': 'On Time',
      'statusColor': Colors.green,
      'features': [],
    },
    {
      'busId': 'B4',
      'busName': 'Bhoothpur',
      'routeStops': ['JPNCE', 'Bhoothpur X Road', 'Bhoothpur Bus Stand'],
      'eta': '12 mins',
      'occupancy': 'Low (10/40)',
      'location': 'JPNCE',
      'status': 'On Time',
      'statusColor': Colors.green,
      'features': [],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredBuses = _buses.where((bus) {
      final query = _searchQuery.trim().toLowerCase();
      return bus['busId'].toString().toLowerCase().contains(query) ||
             bus['busName'].toString().toLowerCase().contains(query);
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Tracker', style: TextStyle(fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Notifications'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      ListTile(
                        leading: Icon(Icons.warning, color: Colors.orange),
                        title: Text('Bus3 is delayed'),
                      ),
                      ListTile(
                        leading: Icon(Icons.cancel, color: Colors.red),
                        title: Text('Bus4 was cancelled'),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final result = await showDialog<String>(
                context: context,
                builder: (context) {
                  String tempQuery = _searchQuery;
                  final controller = TextEditingController(text: _searchQuery);
                  return AlertDialog(
                    title: const Text('Search Bus'),
                    content: TextField(
                      autofocus: true,
                      decoration: const InputDecoration(hintText: 'Enter bus name or ID'),
                      controller: controller,
                      onChanged: (value) {
                        tempQuery = value;
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, null),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, controller.text),
                        child: const Text('Search'),
                      ),
                    ],
                  );
                },
              );
              setState(() {
                _searchQuery = result ?? '';
              });
            },
          ),
        ],
        toolbarHeight: 70,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: filteredBuses.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final bus = filteredBuses[index];
          if (bus['busId'] == 'B1') {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const B1MapPage()),
                );
              },
              child: BusCard(
                busId: bus['busId'],
                busName: bus['busName'],
                routeStops: List<String>.from(bus['routeStops']),
                eta: bus['eta'],
                occupancy: bus['occupancy'],
                location: bus['location'],
                status: bus['status'],
                statusColor: bus['statusColor'],
                features: const [],
              ),
            );
          }
          if (bus['busId'] == 'B2') {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const B2MapPage()),
                );
              },
              child: BusCard(
                busId: bus['busId'],
                busName: bus['busName'],
                routeStops: List<String>.from(bus['routeStops']),
                eta: bus['eta'],
                occupancy: bus['occupancy'],
                location: bus['location'],
                status: bus['status'],
                statusColor: bus['statusColor'],
                features: const [],
              ),
            );
          }
          if (bus['busId'] == 'B3') {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const B3MapPage()),
                );
              },
              child: BusCard(
                busId: bus['busId'],
                busName: bus['busName'],
                routeStops: List<String>.from(bus['routeStops']),
                eta: bus['eta'],
                occupancy: bus['occupancy'],
                location: bus['location'],
                status: bus['status'],
                statusColor: bus['statusColor'],
                features: const [],
              ),
            );
          }
          if (bus['busId'] == 'B4') {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const B4MapPage()),
                );
              },
              child: BusCard(
                busId: bus['busId'],
                busName: bus['busName'],
                routeStops: List<String>.from(bus['routeStops']),
                eta: bus['eta'],
                occupancy: bus['occupancy'],
                location: bus['location'],
                status: bus['status'],
                statusColor: bus['statusColor'],
                features: const [],
              ),
            );
          }
          return BusCard(
            busId: bus['busId'],
            busName: bus['busName'],
            routeStops: List<String>.from(bus['routeStops']),
            eta: bus['eta'],
            occupancy: bus['occupancy'],
            location: bus['location'],
            status: bus['status'],
            statusColor: bus['statusColor'],
            features: const [],
          );
        },
      ),
    );
  }
}

class BusCard extends StatelessWidget {
  final String busId;
  final String busName;
  final List<String> routeStops;
  final String eta;
  final String occupancy;
  final String location;
  final String status;
  final Color statusColor;
  final List<String> features;

  const BusCard({
    super.key,
    required this.busId,
    required this.busName,
    required this.routeStops,
    required this.eta,
    required this.occupancy,
    required this.location,
    required this.status,
    required this.statusColor,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(busId, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    busName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: List.generate(
                    routeStops.length,
                    (index) => Column(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                        if (index != routeStops.length - 1)
                          Container(
                            width: 2,
                            height: 16,
                            color: Colors.blue,
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: routeStops
                      .map((stop) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Text(stop, style: const TextStyle(fontSize: 15)),
                          ))
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 18),
                const SizedBox(width: 4),
                Text(eta),
                const SizedBox(width: 16),
                const Icon(Icons.people, size: 18),
                const SizedBox(width: 4),
                Text(occupancy),
                const SizedBox(width: 16),
                const Icon(Icons.location_on, size: 18),
                const SizedBox(width: 4),
                Text(location),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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