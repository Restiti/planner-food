import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../model/Plan.dart';

class PlanProvider with ChangeNotifier {
  List<Plan> _plans = [];

  List<Plan> get plans => _plans;

  PlanProvider() {
    fetchPlans();
  }

  Future<void> fetchPlans() async {
    try {
      final db = await DatabaseHelper().database;
      final List<Map<String, dynamic>> maps = await db.query('Planificateur');

      _plans = maps.map((map) => Plan.fromMap(map)).toList();
      _sortPlansByDateAndMoment(); // Tri par date et moment
      notifyListeners();
    } catch (e) {
      print("Erreur lors de la récupération des plans: $e");
    }
  }

  Future<void> addPlan(Plan plan) async {
    try {
      final db = await DatabaseHelper().database;
      await db.insert(
        'Planificateur',
        plan.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      _plans.add(plan);
      _sortPlansByDateAndMoment(); // Tri par date et moment
      notifyListeners();
    } catch (e) {
      print("Erreur lors de l'ajout du plan: $e");
    }
  }

  Future<void> updatePlan(Plan plan) async {
    try {
      final db = await DatabaseHelper().database;

      await db.update(
        'Planificateur',
        plan.toMap(),
        where: 'ID_Plan = ?',
        whereArgs: [plan.idPlan],
      );

      int index = _plans.indexWhere((item) => item.idPlan == plan.idPlan);
      if (index != -1) {
        _plans[index] = plan;
        _sortPlansByDateAndMoment(); // Tri par date et moment
        notifyListeners();
      }
    } catch (e) {
      print("Erreur lors de la mise à jour du plan: $e");
    }
  }

  Future<void> removePlan(Plan plan) async {
    try {
      final db = await DatabaseHelper().database;

      await db.delete(
        'Planificateur',
        where: 'ID_Plan = ?',
        whereArgs: [plan.idPlan],
      );

      _plans.removeWhere((item) => item.idPlan == plan.idPlan);
      _sortPlansByDateAndMoment(); // Tri par date et moment
      notifyListeners();
    } catch (e) {
      print("Erreur lors de la suppression du plan: $e");
    }
  }

  void _sortPlansByDateAndMoment() {
    const momentOrder = ['Petit-déjeuner', 'Déjeuner', 'Souper'];

    _plans.sort((a, b) {
      // Trier par date d'abord
      int dateComparison =
          DateTime.parse(a.date).compareTo(DateTime.parse(b.date));
      if (dateComparison != 0) {
        return dateComparison;
      }
      // Si les dates sont identiques, trier par moment en fonction de l'ordre spécifié
      int momentIndexA = momentOrder.indexOf(a.moment);
      int momentIndexB = momentOrder.indexOf(b.moment);
      return momentIndexA.compareTo(momentIndexB);
    });
  }
}
