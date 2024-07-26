import 'package:careflix/core/configuration/assets.dart';
import 'package:careflix/core/services/assets_loader.dart';
import 'package:careflix/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class DayNightButton extends StatefulWidget {
  const DayNightButton({super.key});

  @override
  State<DayNightButton> createState() => _DayNightButtonState();
}

class _DayNightButtonState extends State<DayNightButton> {
  late SMIInput<bool> _isPressed;
  Artboard? _bearArtboard;

  switchThemeMode() {
    _isPressed.change(!_isPressed.value);
    Provider.of<ThemeProvider>(context, listen: false)
        .changeThemeMode(_isPressed.value ? ThemeMode.dark : ThemeMode.light);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final file = RiveFile.import(AssetsLoader.dayNightButton);
    final artboard = file.mainArtboard;
    var controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (controller != null) {
      artboard.addController(controller);
      _isPressed = controller.findInput('IsPressed')!;
    }
    _isPressed.change(
        Provider.of<ThemeProvider>(context, listen: false).themeMode ==
            ThemeMode.dark);

    setState(() {
      _bearArtboard = artboard;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _bearArtboard != null
        ? GestureDetector(
            onTap: () => switchThemeMode(),
            child: SizedBox(
                width: 70,
                height: 40,
                child: Rive(
                  artboard: _bearArtboard!,
                  fit: BoxFit.fitWidth,
                )),
          )
        : SizedBox();
  }
}
