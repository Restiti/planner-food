CREATE TABLE "Ingredients" (
	"ID_INGREDIENT"	INTEGER PRIMARY KEY AUTOINCREMENT,
	"Nom_Ingredient"	TEXT NOT NULL,
	"Quantite"	INTEGER,
	"Unité"	TEXT,
	"Catégorie"	TEXT
);

CREATE TABLE "Recette" (
	"ID_RECETTE"	INTEGER PRIMARY KEY AUTOINCREMENT,
	"Nom_Recette"	TEXT NOT NULL,
	"Temps_Preparation"	INTEGER,
	"Catégorie"	TEXT,
	"Description"	TEXT
);

CREATE TABLE "Etapes" (
	"ID_Etape"	INTEGER PRIMARY KEY AUTOINCREMENT,
	"ID_Recette"	INTEGER,
	"Numero_Etape"	INTEGER NOT NULL,
	"Description"	TEXT NOT NULL,
	FOREIGN KEY("ID_Recette") REFERENCES "Recette"("ID_RECETTE")
);

CREATE TABLE "Planificateur" (
    "ID_Plan" INTEGER PRIMARY KEY AUTOINCREMENT,
    "Date" TEXT NOT NULL,
    "Moment" TEXT NOT NULL,
    "ID_Recette" INTEGER,
    FOREIGN KEY("ID_Recette") REFERENCES "Recette"("ID_RECETTE")
);
