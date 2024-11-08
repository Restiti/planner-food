import 'package:flutter/material.dart';
import 'package:myapp/Page/RecetteDetailPage.dart';
import 'package:myapp/service/EtapeService.dart';
import 'package:provider/provider.dart';
import '../Provider/RecetteProvider.dart';
import '../model/Recette.dart';
import '../model/Etape.dart';

class RecettePage extends StatelessWidget {
  const RecettePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recetteProvider = Provider.of<RecetteProvider>(context);

    return Stack(
      children: [
        recetteProvider.recettes.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: recetteProvider.recettes.length,
                itemBuilder: (context, index) {
                  final recette = recetteProvider.recettes[index];
                  return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        leading: Icon(Icons.food_bank, color: Colors.green),
                        title: Text(
                          recette.nomRecette,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Text(
                          'Temps de préparation: ${recette.tempsPreparation} minutes',
                          style: TextStyle(color: Colors.brown[700]),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {
                                _showDeleteConfirmationDialog(context, recette);
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecetteDetailPage(recette: recette),
                            ),
                          );
                        },
                      ));
                },
              ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: () => _showAddRecetteDialog(context),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  void _showAddRecetteDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String? name;
    int? prepTime;
    String? category;
    String? description;
    List<String?> etapes = [null]; // Initialement une étape vide

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'Ajouter une recette',
                style: TextStyle(color: Colors.green),
              ),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Nom de la recette',
                          labelStyle: TextStyle(color: Colors.brown[700]),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un nom';
                          }
                          return null;
                        },
                        onSaved: (value) => name = value,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Temps de préparation (minutes)',
                          labelStyle: TextStyle(color: Colors.brown[700]),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null) {
                            return 'Veuillez entrer un temps de préparation valide';
                          }
                          return null;
                        },
                        onSaved: (value) => prepTime = int.parse(value!),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Catégorie',
                          labelStyle: TextStyle(color: Colors.brown[700]),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer une catégorie';
                          }
                          return null;
                        },
                        onSaved: (value) => category = value,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(color: Colors.brown[700]),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer une description';
                          }
                          return null;
                        },
                        onSaved: (value) => description = value,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Étapes',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...etapes.asMap().entries.map((entry) {
                        int index = entry.key;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Étape ${index + 1}',
                              labelStyle: TextStyle(color: Colors.brown[700]),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer une étape';
                              }
                              return null;
                            },
                            onSaved: (value) => etapes[index] = value,
                          ),
                        );
                      }).toList(),
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.green),
                        onPressed: () {
                          setState(() {
                            etapes.add(null); // Ajouter une nouvelle étape
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      final newRecette = Recette(
                        nomRecette: name!,
                        tempsPreparation: prepTime!,
                        categorie: category!,
                        description: description!,
                      );

                      final recetteProvider =
                          Provider.of<RecetteProvider>(context, listen: false);

                      await recetteProvider.addRecette(newRecette);

                      final idRecette =
                          newRecette.idRecette!; // ID non null ici

                      final etapeService = EtapeService();

                      for (int i = 0; i < etapes.length; i++) {
                        if (etapes[i] != null && etapes[i]!.isNotEmpty) {
                          await etapeService.addEtape(
                            Etape(
                              idRecette: idRecette,
                              numeroEtape: i + 1,
                              description: etapes[i]!,
                            ),
                          );
                        }
                      }

                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Ajouter'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Recette recette) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer la recette'),
          content:
              const Text('Êtes-vous sûr de vouloir supprimer cette recette ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red),
              onPressed: () {
                Provider.of<RecetteProvider>(context, listen: false)
                    .removeRecette(recette);
                Navigator.of(context).pop();
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
}
