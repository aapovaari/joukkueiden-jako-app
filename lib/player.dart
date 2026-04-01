/// A simple class representing a player in the game.
class Player {
  final String name;
  final String gender;
  final String level;

  /// Creates a new player with the given name, gender, and level.
  Player({required this.name, required this.gender, required this.level});

  /// Returns the score of the player based on their level.
  ///
  /// Level 1 gives 3 points, level 2 gives 2 points, and level 3 gives 1 point.
  int get score {
    if (level == "1") return 3;
    if (level == "2") return 2;
    return 1;
  }

  /// Returns a string representation of the player.
  @override
  String toString() => "$name ($gender), taso $level";
}
