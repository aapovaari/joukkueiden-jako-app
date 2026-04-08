import 'package:flutter/material.dart';
import 'dart:math';
import 'player.dart';

/// A class representing a floorball session, which manages players and teams
class SessionLogic extends ChangeNotifier {
  List<Player> players = [];
  List<Player> teamBlack = [];
  List<Player> teamWhite = [];
  List<List<Player>> pairs = [];

  /// Generate teams based on the player's levels and genders,
  /// while ensuring that pairs are in the same team.
  /// The method will attempt to generate balanced teams up to 1000 times.
  ///
  /// Return:
  /// - `true` if balanced teams were successfully generated
  /// - `false` if a balanced team could not be generated after 1000 attempts
  bool generateTeams() {
    int attempts = 0;

    while (attempts < 1000) {
      attempts++;

      teamBlack.clear();
      teamWhite.clear();

      // Put the pairs in the same team
      for (var pair in pairs) {
        if (teamBlack.length <= teamWhite.length) {
          teamBlack.addAll(pair);
        } else {
          teamWhite.addAll(pair);
        }
      }
      //Get the remaining players who are not in pairs
      List<Player> remainingPlayers = players
          .where((p) => !teamBlack.contains(p) && !teamWhite.contains(p))
          .toList();

      // Get players with level 1, shuffle them and add them to teams
      List<Player> level1Players =
          remainingPlayers.where((p) => p.level == "1").toList()
            ..shuffle(Random());

      for (var player in level1Players) {
        if (teamBlack.length <= teamWhite.length) {
          teamBlack.add(player);
        } else {
          teamWhite.add(player);
        }
      }

      // Get players with level 2, shuffle them and add them to teams
      List<Player> level2Players =
          remainingPlayers.where((p) => p.level == "2").toList()
            ..shuffle(Random());

      for (var player in level2Players) {
        if (teamBlack.length <= teamWhite.length) {
          teamBlack.add(player);
        } else {
          teamWhite.add(player);
        }
      }

      // Get players with level 3, shuffle them and add them to teams
      List<Player> level3Players =
          remainingPlayers.where((p) => p.level == "3").toList()
            ..shuffle(Random());

      for (var player in level3Players) {
        if (teamBlack.length <= teamWhite.length) {
          teamBlack.add(player);
        } else {
          teamWhite.add(player);
        }
      }

      if (checkScoreDifference() && checkGenderBalance()) {
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

  /// Remove a player from the session by name
  ///
  /// Attributes:
  /// - [String] name: The name of the player to be removed
  void removePlayer(String name) {
    players.removeWhere((player) => player.name == name);
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

  /// Check if the score difference between the two teams
  /// is within the allowed limit
  ///
  /// Return:
  /// - `true` if the score difference is 1 or less
  /// - `false` otherwise
  bool checkScoreDifference() {
    int scoreDiff = (teamScoreBlack - teamScoreWhite).abs();
    return scoreDiff <= 1;
  }

  /// Get a list of players in the session with a specific level
  ///
  /// Attributes:
  /// - [String] level: The level to filter players by
  List<Player> playersWithLevel(String level) =>
      players.where((p) => p.level == level).toList();

  /// Get a list of players in the session with a specific gender
  ///
  /// Attributes:
  /// - [String] gender: The gender to filter players by
  List<Player> playersWithGender(String gender) =>
      players.where((p) => p.gender == gender).toList();

  /// Check if the gender balance between the two teams
  /// is within the allowed limit
  ///
  /// Return:
  /// - `true` if the gender difference is 1 or less
  /// - `false` otherwise
  bool checkGenderBalance() {
    int blackMale = teamBlack.where((p) => p.gender == "M").length;
    int whiteMale = teamWhite.where((p) => p.gender == "M").length;

    int genderDiff = (blackMale - whiteMale).abs();

    return genderDiff <= 1;
  }
}
