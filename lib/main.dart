import 'package:flutter/material.dart';
import 'package:joukkueiden_jako/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:joukkueiden_jako/logic/session_logic.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SessionLogic(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}
