import 'package:flutter/material.dart';

class B3RoutesPage extends StatelessWidget {
  const B3RoutesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stops = [
      'JPNCE',
      'Gajulapeta',
      'Moosapet ',
      'Adakal',
      'Veltor',
      'Kothakota Bus Stand',
      'Final Stop: Wanaparthy Bus Stand'
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
                  if (index != 0)
                    Container(
                      width: 2,
                      height: 20,
                      color: Colors.blue,
                    ),
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
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