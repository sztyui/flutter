
import 'package:flutter/material.dart';

class ListTitleWidget extends StatelessWidget {
  const ListTitleWidget({super.key, required this.iconData, required this.titleText, required this.onSelectScreen});

  final IconData iconData;
  final String titleText;
  final void Function(String identifier) onSelectScreen;

  @override
  Widget build(BuildContext context) {
    return ListTile(
            leading: Icon(iconData, size: 26, color: Theme.of(context).colorScheme.onSurface),
            title: Text(titleText, style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 24,
            )),
            onTap: () {
              onSelectScreen(titleText.toLowerCase());
            },
          );
  }
}