// lib/database/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;

class DatabaseHelper {
  // Singleton pattern
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    print("j'initie0");
    // Initialize the database
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    return _initDatabase();
  }

  Future<Database> _initDatabase() async {
    // Définir le chemin de la base de données
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'my_database.db');

    // Vérifier si la base de données existe déjà
    // Si elle n'existe pas, la créer et exécuter les scripts SQL
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Charger et exécuter le script de création des tables
        String createTablesScript =
            await rootBundle.loadString('assets/sql/create_tables.sql');
        List<String> createTableCommands = createTablesScript.split(';');
        for (var command in createTableCommands) {
          if (command.trim().isNotEmpty) {
            await db.execute(command);
          }
        }

        // Charger et exécuter le script d'insertion des données
        String insertDataScript =
            await rootBundle.loadString('assets/sql/insert_data.sql');
        List<String> insertDataCommands = insertDataScript.split(';');
        for (var command in insertDataCommands) {
          if (command.trim().isNotEmpty) {
            await db.execute(command);
          }
        }
      },
    );
  }
}
