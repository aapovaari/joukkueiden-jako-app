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

    return Scaffold(
      appBar: AppBar(title: const Text("Pelaajat")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (session.players.isEmpty)
              const Center(
                child: Text(
                  "Ei pelaajia, lisää pelaajia alla olevalla painikkeella.",
                ),
              )
            else
              ListView.builder(
                itemCount: session.players.length,
                itemBuilder: (context, index) {
                  final player = session.players[index];
                  return ListTile(
                    title: Text(player.name),
                    subtitle: Text("${player.gender}, ${player.level}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {},
                    ),
                  );
                },
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
