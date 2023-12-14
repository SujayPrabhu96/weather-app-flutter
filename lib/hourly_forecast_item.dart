import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  const HourlyForecastItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: SizedBox(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          width: 100,
          padding: const EdgeInsets.all(8.0),
          child: const Column(
            children: [
              Text(
                '03:00',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 8),
              Icon(
                Icons.cloud,
                size: 32,
              ),
              SizedBox(height: 8),
              Text('320'),
            ],
          ),
        ),
      ),
    );
  }
}