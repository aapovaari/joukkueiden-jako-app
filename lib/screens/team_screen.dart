import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:joukkueiden_jako/session_logic.dart';
import 'package:joukkueiden_jako/player.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionLogic>();
    return Scaffold(
      appBar: AppBar(title: const Text('Joukkueet')),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTeamColumn('Mustat', session.teamBlack),
              _buildTeamColumn('Valkoiset', session.teamWhite),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              bool success = session.generateTeams();
              if (!success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Joukkueiden generointi epäonnistui. Yritä uudestaan.',
                    ),
                  ),
                );
              }
            },
            child: const Text('Jaa joukkueet'),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamColumn(String title, List<Player> team) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...team.map((player) => Text(player.name)),
        ],
      ),
    );
  }
}
