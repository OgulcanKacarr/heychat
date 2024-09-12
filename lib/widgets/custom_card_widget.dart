import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  const CustomCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      elevation: 25.0, // Gölge derinliği
      clipBehavior: Clip.antiAlias,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0), // Köşe yuvarlama
        side: const BorderSide(
          color: Colors.greenAccent,
          width: 3.0, // Kenar çizgi kalınlığı
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(7.0), // Kart içi padding
        child: child,
      ),
    );
  }
}
