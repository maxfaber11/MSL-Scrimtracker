import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// For desktop (Windows/macOS/Linux) initialize sqflite_common_ffi
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBProvider {
  static final DBProvider _instance = DBProvider._();
  static Database? _database;

  DBProvider._();
  factory DBProvider() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('msl_scrimtracker.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    // Initialize ffi for desktop platforms so sqflite works on Windows/Linux/macOS
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, fileName);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE players (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE teams (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE team_players (
        team_id TEXT NOT NULL,
        player_id TEXT NOT NULL,
        PRIMARY KEY (team_id, player_id)
      );
    ''');

    await db.execute('''
      CREATE TABLE scrims (
        id TEXT PRIMARY KEY,
        date TEXT NOT NULL,
        map TEXT NOT NULL,
        ourComp TEXT,
        theirComp TEXT,
        result TEXT,
        roundsWonDefense INTEGER,
        roundsPlayedDefense INTEGER,
        roundsWonAttack INTEGER,
        roundsPlayedAttack INTEGER,
        defPistolWin INTEGER,
        atkPistolWin INTEGER,
        teamId TEXT NOT NULL,
        startingSide TEXT,
        enemyTier TEXT
      );
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add missing columns to scrims table
      await db.execute('ALTER TABLE scrims ADD COLUMN startingSide TEXT');
      await db.execute('ALTER TABLE scrims ADD COLUMN enemyTier TEXT');
    }
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
