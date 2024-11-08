import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/PlanProvider.dart';
import '../Provider/RecetteProvider.dart';
import '../model/Plan.dart';
import '../model/Recette.dart';

class PlanificateurPage extends StatelessWidget {
  const PlanificateurPage({Key? key}) : super(key: key);

  void _showAddPlanDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    DateTime? selectedDate;
    String? selectedMoment;
    Recette? selectedRecette;
    final recetteProvider =
        Provider.of<RecetteProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter un plan de repas'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        selectedDate = picked;
                      }
                    },
                    child: Text(
                      selectedDate == null
                          ? 'Choisir une date'
                          : 'Date : ${selectedDate!.toLocal()}'.split(' ')[0],
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Moment'),
                    items:
                        ['Petit-déjeuner', 'Déjeuner', 'Souper'].map((moment) {
                      return DropdownMenuItem(
                        value: moment,
                        child: Text(moment),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedMoment = value;
                    },
                    validator: (value) =>
                        value == null ? 'Veuillez choisir un moment' : null,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<Recette>(
                    decoration: const InputDecoration(labelText: 'Recette'),
                    items: recetteProvider.recettes.map((recette) {
                      return DropdownMenuItem(
                        value: recette,
                        child: Text(recette.nomRecette),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedRecette = value;
                    },
                    validator: (value) =>
                        value == null ? 'Veuillez choisir une recette' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final plan = Plan(
                    date: selectedDate!.toLocal().toString().split(' ')[0],
                    moment: selectedMoment!,
                    idRecette: selectedRecette!.idRecette!,
                  );

                  final planProvider =
                      Provider.of<PlanProvider>(context, listen: false);
                  await planProvider.addPlan(plan);

                  Navigator.of(context).pop();
                }
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final planProvider = Provider.of<PlanProvider>(context);

    return Stack(
      children: [
        planProvider.plans.isEmpty
            ? const Center(
                child: Text(
                  'Rien de planifié pour le moment',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : Consumer<RecetteProvider>(
                builder: (context, recetteProvider, child) {
                  return ListView.builder(
                    itemCount: planProvider.plans.length,
                    itemBuilder: (context, index) {
                      final plan = planProvider.plans[index];
                      // Recherche du nom de la recette correspondant
                      Recette? recette = recetteProvider.recettes
                          .firstWhere((rec) => rec.idRecette == plan.idRecette,
                              orElse: () => Recette(
                                    idRecette: -1, // Fallback values
                                    nomRecette: "Recette inconnue",
                                    tempsPreparation: 0,
                                    categorie: "",
                                    description: "",
                                  ));

                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(
                            '${plan.moment} ${recette.nomRecette}',
                          ),
                          subtitle: Text('Date : ${plan.date}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              planProvider.removePlan(plan);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () => _showAddPlanDialog(context),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
