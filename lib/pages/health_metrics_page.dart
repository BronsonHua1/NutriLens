import 'package:flutter/material.dart';

class HealthMetricsPage extends StatelessWidget {
  const HealthMetricsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Metrics'),
      ),
      body: const Center(
        child: Text('Details about Health Metrics'),
      ),
    );
  }
}
