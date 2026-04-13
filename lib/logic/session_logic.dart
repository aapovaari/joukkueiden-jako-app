import 'package:flutter/material.dart';
import 'dart:math';
import 'player.dart';

/// A class representing a floorball session, which manages players and teams
class SessionLogic extends ChangeNotifier {
  List<Player> players = [];
  List<Player> teamBlack = [];
  List<Player> teamWhite = [];
  List<List<Player>> pairs = [];
  bool balanceGender = true;
  bool balanceLevel = true;
  bool respectPairs = true;

  /// Generate teams based on the player's levels and genders,
  /// while ensuring that pairs are in the same team.
  /// The method will attempt to generate balanced teams up to 1000 times.
  ///
  /// Return:
  /// - `true` if teams were successfully generated
  /// - `false` if team could not be generated after 1000 attempts
  bool generateTeams() {
    int attempts = 0;

    List<Player> remainingPlayers = [];
    if (respectPairs) {
      remainingPlayers = players
          .where((p) => !pairs.any((pair) => pair.contains(p)))
          .toList();
    } else {
      remainingPlayers = List.from(players);
    }

    var buckets = _createBuckets(remainingPlayers, balanceGender, balanceLevel);

    while (attempts < 1000) {
      attempts++;

      teamBlack.clear();
      teamWhite.clear();

      if (respectPairs) {
        for (var pair in pairs) {
          if (teamBlack.length <= teamWhite.length) {
            teamBlack.addAll(pair);
          } else {
            teamWhite.addAll(pair);
          }
        }
      }

      var bucketKeys = buckets.keys.toList()..shuffle(Random());
      for (var key in bucketKeys) {
        var bucketPlayers = buckets[key]!;
        bucketPlayers.shuffle(Random());
        for (var player in bucketPlayers) {
          _assignToSmallerTeam(player);
        }
      }

      bool isLevelOk = !balanceLevel || _checkScoreDifference();
      bool isGenderOk = !balanceGender || _checkGenderBalance();

      if (isLevelOk && isGenderOk) {
        teamBlack.shuffle(Random());
        teamWhite.shuffle(Random());

        notifyListeners();
        return true;
      }
    }
    return false;
  }

  /// Add a player to the session
  ///
  /// Attributes:
  /// - [Player] player: The player to be added
  void addPlayer(Player player) {
    players.add(player);
    notifyListeners();
  }

  /// Remove a player from the session
  ///
  /// Attributes:
  /// - [Player] player: The player to be removed
  void removePlayer(Player player) {
    players.remove(player);
    notifyListeners();
  }

  /// Create a new pair of players based on their names
  /// and add the pair to the list of pairs
  ///
  /// Attributes:
  /// - [String] player1Name: The name of the first player in the pair
  /// - [String] player2Name: The name of the second player in the pair
  ///
  /// Return:
  /// - `true` if the pair was successfully created and added
  /// - `false` if either player was not found in the session
  bool createNewPair(String player1Name, String player2Name) {
    try {
      Player player1 = players.firstWhere((p) => p.name == player1Name);
      Player player2 = players.firstWhere((p) => p.name == player2Name);

      if (player1 == player2) {
        return false; // Cannot pair a player with themselves
      }

      if (pairs.any(
        (pair) => pair.contains(player1) || pair.contains(player2),
      )) {
        return false; // One of the players is already in a pair
      }

      pairs.add([player1, player2]);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get a string representation of all players in the session
  String get playerData => players.map((p) => p.toString()).join("\n");

  /// Calculate the total score of the black team
  int get teamScoreBlack =>
      teamBlack.fold(0, (sum, player) => sum + player.score);

  /// Calculate the total score of the white team
  int get teamScoreWhite =>
      teamWhite.fold(0, (sum, player) => sum + player.score);

  /// Change the balanceGender setting and notify listeners
  ///
  /// Attributes:
  /// - [bool] value: The new value for balanceGender
  void toggleGenderBalancing(bool value) {
    balanceGender = value;
    notifyListeners();
  }

  /// Change the balanceLevel setting and notify listeners
  ///
  /// Attributes:
  /// - [bool] value: The new value for balanceLevel
  void toggleLevelBalancing(bool value) {
    balanceLevel = value;
    notifyListeners();
  }

  /// Change the respectPairs setting and notify listeners
  ///
  /// Attributes:
  /// /// - [bool] value: The new value for respectPairs
  void toggleRespectPairs(bool value) {
    respectPairs = value;
    notifyListeners();
  }

  /// Check if the score difference between the two teams
  /// is within the allowed limit
  ///
  /// Return:
  /// - `true` if the score difference is 1 or less
  /// - `false` otherwise
  bool _checkScoreDifference() {
    int scoreDiff = (teamScoreBlack - teamScoreWhite).abs();
    return scoreDiff <= 1;
  }

  /// Check if the gender balance between the two teams
  /// is within the allowed limit
  ///
  /// Return:
  /// - `true` if the gender difference is 1 or less
  /// - `false` otherwise
  bool _checkGenderBalance() {
    int blackMale = teamBlack.where((p) => p.gender == "M").length;
    int whiteMale = teamWhite.where((p) => p.gender == "M").length;

    int genderDiff = (blackMale - whiteMale).abs();

    return genderDiff <= 1;
  }

  /// Assign a player to the team with fewer players
  ///
  /// Attributes:
  /// - [Player] player: The player to be assigned
  void _assignToSmallerTeam(Player player) {
    if (teamBlack.length <= teamWhite.length) {
      teamBlack.add(player);
    } else {
      teamWhite.add(player);
    }
  }

  /// Split a list of players into a map based on their genders and levels
  ///
  /// Attributes:
  /// - [List<Player>] players: The list of players to be split
  /// - [bool] balanceGender: Whether to split by gender
  /// - [bool] balanceLevel: Whether to split by level
  ///
  /// Return:
  /// - A map where the keys are the combinations of gender
  /// and level (e.g. "M_1") and the values are lists of players
  /// with that combination
  Map<String, List<Player>> _createBuckets(
    List<Player> players,
    bool balanceGender,
    bool balanceLevel,
  ) {
    Map<String, List<Player>> buckets = {};

    for (var player in players) {
      String key = "";
      if (balanceGender) key += "${player.gender}_";
      if (balanceLevel) key += player.level;

      if (key.isEmpty) key = "all";

      if (!buckets.containsKey(key)) {
        buckets[key] = [];
      }
      buckets[key]!.add(player);
    }

    return buckets;
  }
}
