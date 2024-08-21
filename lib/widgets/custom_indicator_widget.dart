import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heychat/constants/AppSizes.dart';

class CustomIndicatorWidget extends StatelessWidget {
  const CustomIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: AppSizes.screenWidth(context),
      height: 3,
      color: theme.colorScheme.secondary
    );
  }
}
