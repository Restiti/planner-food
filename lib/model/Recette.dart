class Recette {
  int? idRecette;
  String nomRecette;
  int tempsPreparation;
  String categorie;
  String description;

  Recette({
    this.idRecette,
    required this.nomRecette,
    required this.tempsPreparation,
    required this.categorie,
    required this.description,
  });

  // Convertir l'objet en Map pour SQLite
  Map<String, dynamic> toMap() {
    return {
      'ID_RECETTE': idRecette,
      'Nom_Recette': nomRecette,
      'Temps_Preparation': tempsPreparation,
      'Catégorie': categorie,
      'Description': description,
    };
  }

  // Créer un objet Recette à partir d'un Map
  factory Recette.fromMap(Map<String, dynamic> map) {
    return Recette(
      idRecette: map['ID_RECETTE'],
      nomRecette: map['Nom_Recette'],
      tempsPreparation: map['Temps_Preparation'],
      categorie: map['Catégorie'],
      description: map['Description'],
    );
  }
}
