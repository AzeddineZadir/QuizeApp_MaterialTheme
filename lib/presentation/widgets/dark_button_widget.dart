import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_app_quize/data/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class DarkThemeButton extends StatelessWidget {
  const DarkThemeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Switch.adaptive(
      value: themeProvider.isDarkMode,
      onChanged: (value) {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.toggleTheme(value);
      },
    );
  }
}
