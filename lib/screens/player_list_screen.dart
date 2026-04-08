import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:joukkueiden_jako/session_logic.dart';

class PlayerlistScreen extends StatefulWidget {
  const PlayerlistScreen({super.key});

  @override
  State<PlayerlistScreen> createState() => _PlayerlistScreenState();
}

class _PlayerlistScreenState extends State<PlayerlistScreen> {
  TextEditingController nameController = TextEditingController();
  String? selectedGender;
  String? selectedLevel;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionLogic>();

    return Scaffold(appBar: AppBar(title: const Text("Pelaajat")));
  }
}
