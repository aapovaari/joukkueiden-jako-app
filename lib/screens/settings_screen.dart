import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:joukkueiden_jako/logic/session_logic.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionLogic>();
    return Scaffold(
      appBar: AppBar(title: const Text('Asetukset')),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Tasapainota sukupuolten mukaan'),
            value: session.balanceGender,
            onChanged: (value) {
              session.toggleGenderBalancing(value);
            },
          ),
          SwitchListTile(
            title: const Text('Tasapainota tasojen mukaan'),
            value: session.balanceLevel,
            onChanged: (value) {
              session.toggleLevelBalancing(value);
            },
          ),
          SwitchListTile(
            title: const Text('Huomio parit'),
            value: session.respectPairs,
            onChanged: (value) {
              session.toggleRespectPairs(value);
            },
          ),
        ],
      ),
    );
  }
}
