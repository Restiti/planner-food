import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../model/Recette.dart';

class RecetteProvider with ChangeNotifier {
  List<Recette> _recettes = [];

  List<Recette> get recettes => _recettes;

  RecetteProvider() {
    fetchRecettes();
  }

  Future<void> fetchRecettes() async {
    try {
      final db = await DatabaseHelper().database;
      final List<Map<String, dynamic>> maps = await db.query('Recette');

      _recettes = maps.map((map) => Recette.fromMap(map)).toList();
      notifyListeners();
    } catch (e) {
      print("Erreur lors de la récupération des recettes: $e");
    }
  }

  Future<void> addRecette(Recette recette) async {
    try {
      final db = await DatabaseHelper().database;
      final id = await db.insert(
        'Recette',
        recette.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      recette.idRecette = id;
      _recettes.add(recette);
      notifyListeners();
    } catch (e) {
      print("Erreur lors de l'ajout de la recette: $e");
    }
  }

  Future<void> removeRecette(Recette recette) async {
    try {
      final db = await DatabaseHelper().database;

      await db.delete(
        'Recette',
        where: 'ID_RECETTE = ?',
        whereArgs: [recette.idRecette],
      );

      _recettes.removeWhere((item) => item.idRecette == recette.idRecette);
      notifyListeners();
    } catch (e) {
      print("Erreur lors de la suppression de la recette: $e");
    }
  }

  Future<void> updateRecette(Recette recette) async {
    try {
      final db = await DatabaseHelper().database;

      await db.update(
        'Recette',
        recette.toMap(),
        where: 'ID_RECETTE = ?',
        whereArgs: [recette.idRecette],
      );

      int index =
          _recettes.indexWhere((item) => item.idRecette == recette.idRecette);
      if (index != -1) {
        _recettes[index] = recette;
        notifyListeners();
      }
    } catch (e) {
      print("Erreur lors de la mise à jour de la recette: $e");
    }
  }
}
