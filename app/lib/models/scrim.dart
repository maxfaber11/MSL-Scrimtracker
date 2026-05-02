import 'map_enum.dart';
import 'agent_enum.dart';
import 'dart:convert';

class Scrim {
  final String id;
  final DateTime date;
  final GameMap map;
  final List<Agent> ourComp; // 5 agents
  final List<Agent> theirComp; // 5 agents
  final String result; // 'win'|'loss'|'draw'
  final int roundsWonDefense;
  final int roundsPlayedDefense;
  final int roundsWonAttack;
  final int roundsPlayedAttack;
  final bool defPistolWin;
  final bool atkPistolWin;
  final String teamId; // reference to Team

  Scrim({
    required this.id,
    required this.date,
    required this.map,
    required this.ourComp,
    required this.theirComp,
    required this.result,
    required this.roundsWonDefense,
    required this.roundsPlayedDefense,
    required this.roundsWonAttack,
    required this.roundsPlayedAttack,
    required this.defPistolWin,
    required this.atkPistolWin,
    required this.teamId,
  });

  static List<Agent> _parseAgentList(dynamic raw) {
    if (raw is List) {
      return raw
          .map((e) => e.toString())
          .map((name) => Agent.values.firstWhere((a) => a.displayName == name, orElse: () => Agent.Astra))
          .toList();
    }

    if (raw is String && raw.trim().isNotEmpty) {
      try {
        final parsed = jsonDecode(raw);
        if (parsed is List) {
          return _parseAgentList(parsed);
        }
      } catch (_) {
        final normalized = raw.replaceAll(';', '|');
        return normalized
            .split('|')
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty)
            .map((name) => Agent.values.firstWhere((a) => a.displayName == name, orElse: () => Agent.Astra))
            .toList();
      }
    }

    return [];
  }

  factory Scrim.fromJson(Map<String, dynamic> json) {
    // handle DB rows where some fields may be stored as strings
    final mapStr = json['map'] as String;
    final ourCompList = _parseAgentList(json['ourComp']);
    final theirCompList = _parseAgentList(json['theirComp']);

    return Scrim(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      map: GameMap.values.firstWhere((m) => m.toString().split('.').last == mapStr),
      ourComp: ourCompList,
      theirComp: theirCompList,
      result: (json['result'] ?? 'draw') as String,
      roundsWonDefense: (json['roundsWonDefense'] ?? 0) as int,
      roundsPlayedDefense: (json['roundsPlayedDefense'] ?? 12) as int,
      roundsWonAttack: (json['roundsWonAttack'] ?? 0) as int,
      roundsPlayedAttack: (json['roundsPlayedAttack'] ?? 12) as int,
      defPistolWin: ((json['defPistolWin'] == 1) || (json['defPistolWin'] == true)) ,
      atkPistolWin: ((json['atkPistolWin'] == 1) || (json['atkPistolWin'] == true)) ,
      teamId: json['teamId'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'map': map.toString().split('.').last,
        'ourComp': ourComp.map((a) => a.displayName).toList(),
          'theirComp': theirComp.map((a) => a.displayName).toList(),
        'result': result,
        'roundsWonDefense': roundsWonDefense,
        'roundsPlayedDefense': roundsPlayedDefense,
        'roundsWonAttack': roundsWonAttack,
        'roundsPlayedAttack': roundsPlayedAttack,
        'defPistolWin': defPistolWin,
        'atkPistolWin': atkPistolWin,
        'teamId': teamId,
      };
}
