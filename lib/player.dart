class Player {
  final String name;
  final String gender;
  final String level;

  Player({required this.name, required this.gender, required this.level});

  int get score {
    if (level == "1") return 3;
    if (level == "2") return 2;
    return 1;
  }

  @override
  String toString() => "$name ($gender), taso $level";
}
