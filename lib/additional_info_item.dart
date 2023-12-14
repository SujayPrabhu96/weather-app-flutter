import 'package:flutter/material.dart';

class AdditionalInfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const AdditionalInfoItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(
          Icons.water_drop,
          size: 32,
        ),
        SizedBox(height: 8),
        Text('Humidity'),
        SizedBox(height: 8),
        Text(
          '91',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      ],
    );
  }
}