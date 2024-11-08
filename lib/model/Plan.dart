class Plan {
  int? idPlan;
  String date;
  String moment;
  int idRecette;

  Plan({
    this.idPlan,
    required this.date,
    required this.moment,
    required this.idRecette,
  });

  // Convertir l'objet en Map pour SQLite
  Map<String, dynamic> toMap() {
    return {
      'ID_Plan': idPlan,
      'Date': date,
      'Moment': moment,
      'ID_Recette': idRecette,
    };
  }

  // Créer un objet Plan à partir d'un Map
  factory Plan.fromMap(Map<String, dynamic> map) {
    return Plan(
      idPlan: map['ID_Plan'],
      date: map['Date'],
      moment: map['Moment'],
      idRecette: map['ID_Recette'],
    );
  }
}
