import 'package:flutter/material.dart';
import 'package:sports_picker/features/games/ui/games_ui.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: GamesWidget());
  }
}
