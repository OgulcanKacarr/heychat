import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  Widget child;
  CustomCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      elevation: 25.0,
      margin: const EdgeInsets.all(10.5),
      clipBehavior: Clip.antiAlias,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
        side: const BorderSide(
          color: Colors.greenAccent,
          width: 2.0
        )
      ),
      child: child,

    );
  }
}
