import 'package:flutter/material.dart';

class RoutesPage extends StatelessWidget {
  const RoutesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stops = [
      'JPNCE',
      'Pista House',
      'Mahabubnagar Bus Stand',
      'Railway Station',
      'Final Stop: Mahabubnagar'
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Route'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(32),
        itemCount: stops.length,
        itemBuilder: (context, index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  // Top line (except for first stop)
                  if (index != 0)
                    Container(
                      width: 2,
                      height: 20,
                      color: Colors.blue,
                    ),
                  // Stop circle
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                  // Bottom line (except for last stop)
                  if (index != stops.length - 1)
                    Container(
                      width: 2,
                      height: 20,
                      color: Colors.blue,
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  stops[index],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
} 