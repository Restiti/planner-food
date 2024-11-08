import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/IngredientProvider.dart';
import '../model/Ingredients.dart';

class IngredientPage extends StatelessWidget {
  const IngredientPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ingredientProvider = Provider.of<IngredientProvider>(context);

    return Stack(
      children: [
        ingredientProvider.ingredients.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: ingredientProvider.ingredients.length,
                itemBuilder: (context, index) {
                  final ingredient = ingredientProvider.ingredients[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      leading: Icon(Icons.local_dining, color: Colors.orange),
                      title: Text(
                        ingredient.nomIngredient,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Text(
                        'Quantité: ${ingredient.quantite} ${ingredient.unite}',
                        style: TextStyle(color: Colors.brown[700]),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            color: Colors.blue,
                            onPressed: () {
                              _showEditIngredientDialog(context, ingredient);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              _showDeleteConfirmationDialog(
                                  context, ingredient);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () => _showAddIngredientDialog(context),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  void _showAddIngredientDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String? name;
    int? quantity;
    String? unit;
    String? category;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Ajouter un ingrédient',
            style: TextStyle(color: Colors.orange),
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Nom de l\'ingrédient',
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
                      labelText: 'Quantité',
                      labelStyle: TextStyle(color: Colors.brown[700]),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          int.tryParse(value) == null) {
                        return 'Veuillez entrer une quantité valide';
                      }
                      return null;
                    },
                    onSaved: (value) => quantity = int.parse(value!),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Unité',
                      labelStyle: TextStyle(color: Colors.brown[700]),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer une unité';
                      }
                      return null;
                    },
                    onSaved: (value) => unit = value,
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
                  backgroundColor: Colors.orange),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final newIngredient = Ingredient(
                    nomIngredient: name!,
                    quantite: quantity!,
                    unite: unit!,
                    categorie: category!,
                  );
                  Provider.of<IngredientProvider>(context, listen: false)
                      .addIngredient(newIngredient);
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

  void _showEditIngredientDialog(BuildContext context, Ingredient ingredient) {
    final _formKey = GlobalKey<FormState>();
    String? name = ingredient.nomIngredient;
    int? quantity = ingredient.quantite;
    String? unit = ingredient.unite;
    String? category = ingredient.categorie;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Modifier un ingrédient',
            style: TextStyle(color: Colors.blue),
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: name,
                    decoration: InputDecoration(
                      labelText: 'Nom de l\'ingrédient',
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
                    initialValue: quantity.toString(),
                    decoration: InputDecoration(
                      labelText: 'Quantité',
                      labelStyle: TextStyle(color: Colors.brown[700]),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          int.tryParse(value) == null) {
                        return 'Veuillez entrer une quantité valide';
                      }
                      return null;
                    },
                    onSaved: (value) => quantity = int.parse(value!),
                  ),
                  TextFormField(
                    initialValue: unit,
                    decoration: InputDecoration(
                      labelText: 'Unité',
                      labelStyle: TextStyle(color: Colors.brown[700]),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer une unité';
                      }
                      return null;
                    },
                    onSaved: (value) => unit = value,
                  ),
                  TextFormField(
                    initialValue: category,
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
                  foregroundColor: Colors.white, backgroundColor: Colors.blue),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final updatedIngredient = Ingredient(
                    idIngredient: ingredient.idIngredient,
                    nomIngredient: name!,
                    quantite: quantity!,
                    unite: unit!,
                    categorie: category!,
                  );
                  Provider.of<IngredientProvider>(context, listen: false)
                      .updateIngredient(updatedIngredient);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, Ingredient ingredient) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer l\'ingrédient'),
          content:
              const Text('Êtes-vous sûr de vouloir supprimer cet ingrédient ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red),
              onPressed: () {
                Provider.of<IngredientProvider>(context, listen: false)
                    .removeIngredient(ingredient);
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
