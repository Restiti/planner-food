class Ingredient {
  int? idIngredient;
  String nomIngredient;
  int quantite;
  String unite;
  String categorie;

  Ingredient({
    this.idIngredient,
    required this.nomIngredient,
    required this.quantite,
    required this.unite,
    required this.categorie,
  });

  // Convertir l'objet en Map pour SQLite
  Map<String, dynamic> toMap() {
    return {
      'ID_INGREDIENT': idIngredient,
      'Nom_Ingredient': nomIngredient,
      'Quantite': quantite,
      'Unité': unite,
      'Catégorie': categorie,
    };
  }

  // Créer un objet Ingredient à partir d'un Map
  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      idIngredient: map['ID_INGREDIENT'],
      nomIngredient: map['Nom_Ingredient'],
      quantite: map['Quantite'],
      unite: map['Unité'],
      categorie: map['Catégorie'],
    );
  }
}
