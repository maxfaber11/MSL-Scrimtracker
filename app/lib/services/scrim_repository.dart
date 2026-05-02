import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../models/player.dart';
import '../models/team.dart';
import '../models/scrim.dart';
import '../models/agent_enum.dart';
import 'db_provider.dart';

class ScrimRepository {
  final DBProvider _dbProvider = DBProvider();

  Future<void> insertPlayer(Player p) async {
    final db = await _dbProvider.database;
    await db.insert('players', p.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertTeam(Team t) async {
    final db = await _dbProvider.database;
    await db.insert('teams', {'id': t.id, 'name': t.name}, conflictAlgorithm: ConflictAlgorithm.replace);
    // link players
    for (final p in t.players) {
      await db.insert('team_players', {'team_id': t.id, 'player_id': p.id}, conflictAlgorithm: ConflictAlgorithm.replace);
      await insertPlayer(p);
    }
  }

  Future<void> insertScrim(Scrim s) async {
    final db = await _dbProvider.database;
    // SQLite doesn't accept List values directly; serialize `ourComp` to JSON string for storage
    final map = Map<String, dynamic>.from(s.toJson());
    map['ourComp'] = jsonEncode(map['ourComp']);
    map['theirComp'] = jsonEncode(map['theirComp']);
    // booleans to integers
    map['defPistolWin'] = s.defPistolWin ? 1 : 0;
    map['atkPistolWin'] = s.atkPistolWin ? 1 : 0;
    try {
      final id = await db.insert('scrims', map, conflictAlgorithm: ConflictAlgorithm.replace);
      // debug
      // ignore: avoid_print
      print('Inserted scrim row id: $id');
    } catch (e, st) {
      // If error is about missing columns, try without the new columns
      if (e.toString().contains('startingSide') || e.toString().contains('enemyTier')) {
        // ignore: avoid_print
        print('Retrying insert without startingSide/enemyTier columns...');
        map.remove('startingSide');
        map.remove('enemyTier');
        try {
          final id = await db.insert('scrims', map, conflictAlgorithm: ConflictAlgorithm.replace);
          // ignore: avoid_print
          print('Inserted scrim row id (without new columns): $id');
          return;
        } catch (retryError) {
          // ignore: avoid_print
          print('Retry failed: $retryError');
        }
      }
      // ignore: avoid_print
      print('Error inserting scrim: $e\n$st');
      rethrow;
    }
  }

  Future<void> deleteScrim(String id) async {
    final db = await _dbProvider.database;
    await db.delete('scrims', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Scrim>> getAllScrims() async {
    final db = await _dbProvider.database;
    // order by date desc if available
    final rows = await db.query('scrims', orderBy: 'date DESC');
    // ignore: avoid_print
    print('getAllScrims fetched ${rows.length} rows');
    return rows.map((r) => Scrim.fromJson(r)).toList();
  }

  Future<List<Team>> getAllTeams() async {
    final db = await _dbProvider.database;
    final teamRows = await db.query('teams');
    final List<Team> teams = [];
    for (final tr in teamRows) {
      final playerLinks = await db.query('team_players', where: 'team_id = ?', whereArgs: [tr['id']]);
      final players = <Player>[];
      for (final pl in playerLinks) {
        final pr = await db.query('players', where: 'id = ?', whereArgs: [pl['player_id']]);
        if (pr.isNotEmpty) players.add(Player.fromJson(pr.first));
      }
      teams.add(Team(id: tr['id'] as String, name: tr['name'] as String, players: players));
    }
    return teams;
  }

  Future<String> exportAllAsJson() async {
    final scrims = await getAllScrims();
    final teams = await getAllTeams();
    final data = {
      'scrims': scrims.map((s) => s.toJson()).toList(),
      'teams': teams.map((t) => t.toJson()).toList(),
    };
    return jsonEncode(data);
  }

  Future<String> exportAllAsCsv() async {
    final scrims = await getAllScrims();
    // CSV with detailed fields
    final lines = <String>[];
    lines.add('id,date,map,result,teamId,roundsWonDef,roundsPlayedDef,roundsWonAtk,roundsPlayedAtk,defPistolWin,atkPistolWin,ourComp,theirComp');
    for (final s in scrims) {
      final ourCompStr = s.ourComp.map((a) => a.displayName).join('|');
      final theirCompStr = s.theirComp.map((a) => a.displayName).join('|');
      lines.add('${s.id},${s.date.toIso8601String()},${s.map.toString().split('.').last},${s.result},${s.teamId},${s.roundsWonDefense},${s.roundsPlayedDefense},${s.roundsWonAttack},${s.roundsPlayedAttack},${s.defPistolWin ? 1 : 0},${s.atkPistolWin ? 1 : 0},"$ourCompStr","$theirCompStr"');
    }
    return lines.join('\n');
  }

  Future<void> importFromJsonString(String jsonString) async {
    final Map<String, dynamic> data = jsonDecode(jsonString) as Map<String, dynamic>;
    final List<dynamic> scrimList = data['scrims'] as List<dynamic>? ?? [];
    final List<dynamic> teamList = data['teams'] as List<dynamic>? ?? [];

    for (final t in teamList) {
      await insertTeam(Team.fromJson(t as Map<String, dynamic>));
    }

    for (final s in scrimList) {
      await insertScrim(Scrim.fromJson(s as Map<String, dynamic>));
    }
  }
}
