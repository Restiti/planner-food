import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../model/Etape.dart';

class EtapeService {
  Future<List<Etape>> fetchEtapes(int idRecette) async {
    print("Je fetch avec l'id recette : ${idRecette}");
    try {
      final db = await DatabaseHelper().database;
      final List<Map<String, dynamic>> maps = await db.query(
        'Etapes',
        where: 'ID_Recette = ?',
        whereArgs: [idRecette],
        orderBy: 'Numero_Etape ASC',
      );
      return maps.map((map) => Etape.fromMap(map)).toList();
    } catch (e) {
      print("Erreur lors de la récupération des étapes: $e");
      return [];
    }
  }

  Future<void> addEtape(Etape etape) async {
    try {
      final db = await DatabaseHelper().database;
      await db.insert(
        'Etapes',
        etape.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("Erreur lors de l'ajout de l'étape: $e");
    }
  }
}
