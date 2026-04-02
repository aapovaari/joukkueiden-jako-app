import 'package:flutter/material.dart';
import 'package:joukkueiden_jako/player.dart';

class PlayerlistScreen extends StatefulWidget {
  const PlayerlistScreen({super.key});

  @override
  State<PlayerlistScreen> createState() => _PlayerlistScreenState();
}

class _PlayerlistScreenState extends State<PlayerlistScreen> {
  List<Player> players = [];
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
    return Container();
  }
}
