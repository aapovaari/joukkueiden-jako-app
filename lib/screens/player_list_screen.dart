import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:joukkueiden_jako/logic/session_logic.dart';
import 'package:joukkueiden_jako/logic/player.dart';

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
              Expanded(
                child: const Center(
                  child: Text(
                    "Ei pelaajia, lisää pelaajia alla olevalla painikkeella.",
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: session.players.length,
                  itemBuilder: (context, index) {
                    final player = session.players[index];
                    return ListTile(
                      title: Text(player.name),
                      subtitle: Text("${player.gender}, Taso ${player.level}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          session.removePlayer(player);
                        },
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Lisää pelaaja"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: "Nimi",
                            ),
                          ),
                          DropdownButtonFormField<String>(
                            initialValue: selectedGender,
                            items: const [
                              DropdownMenuItem(
                                value: "Mies",
                                child: Text("Mies"),
                              ),
                              DropdownMenuItem(
                                value: "Nainen",
                                child: Text("Nainen"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: "Sukupuoli",
                            ),
                          ),
                          DropdownButtonFormField<String>(
                            initialValue: selectedLevel,
                            items: const [
                              DropdownMenuItem(
                                value: "1",
                                child: Text("1 Edistynyt"),
                              ),
                              DropdownMenuItem(
                                value: "2",
                                child: Text("2 Keskitaso"),
                              ),
                              DropdownMenuItem(
                                value: "3",
                                child: Text("3 Aloittelija"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedLevel = value;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: "Taso",
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Peruuta"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (nameController.text.isNotEmpty &&
                                selectedGender != null &&
                                selectedLevel != null) {
                              session.addPlayer(
                                Player(
                                  name: nameController.text,
                                  gender: selectedGender!,
                                  level: selectedLevel!,
                                ),
                              );
                              nameController.clear();
                              setState(() {
                                selectedGender = null;
                                selectedLevel = null;
                              });
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text("Lisää"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text("Lisää pelaaja"),
            ),
          ],
        ),
      ),
    );
  }
}
