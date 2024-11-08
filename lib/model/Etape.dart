class Etape {
  final int? idEtape;
  final int idRecette;
  final int numeroEtape;
  final String description;

  Etape({
    this.idEtape,
    required this.idRecette,
    required this.numeroEtape,
    required this.description,
  });

  // Méthode pour convertir en Map (pour SQLite)
  Map<String, dynamic> toMap() {
    return {
      'ID_ETAPE': idEtape,
      'ID_RECETTE': idRecette,
      'Numero_Etape': numeroEtape,
      'Description': description,
    };
  }

  // Factory pour créer une instance à partir d'un Map
  factory Etape.fromMap(Map<String, dynamic> map) {
    return Etape(
      idEtape:
          map['ID_ETAPE'] as int?, // Autorise les valeurs nulles si nécessaire
      idRecette: map['ID_RECETTE'] is int
          ? map['ID_RECETTE'] as int
          : (map['ID_RECETTE'] != null
              ? int.tryParse(map['ID_RECETTE'].toString()) ?? 0
              : 0),
      numeroEtape: map['Numero_Etape'] is int
          ? map['Numero_Etape'] as int
          : (map['Numero_Etape'] != null
              ? int.tryParse(map['Numero_Etape'].toString()) ?? 0
              : 0),
      description:
          map['Description'] ?? '', // Fournit une valeur par défaut si `null`
    );
  }

  // Méthode copyWith
  Etape copyWith({
    int? idEtape,
    int? idRecette,
    int? numeroEtape,
    String? description,
  }) {
    return Etape(
      idEtape: idEtape ?? this.idEtape,
      idRecette: idRecette ?? this.idRecette,
      numeroEtape: numeroEtape ?? this.numeroEtape,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'Etape{idEtape: $idEtape, idRecette: $idRecette, numeroEtape: $numeroEtape, description: $description}';
  }
}
