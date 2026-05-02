import 'player.dart';

class Team {
  final String id;
  final String name;
  final List<Player> players;

  Team({required this.id, required this.name, List<Player>? players})
      : players = players ?? [];

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        id: json['id'] as String,
        name: json['name'] as String,
        players: (json['players'] as List<dynamic>?)
                ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'players': players.map((p) => p.toJson()).toList(),
      };
}
