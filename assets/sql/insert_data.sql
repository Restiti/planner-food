INSERT INTO Recette (Nom_Recette, Temps_Preparation, Catégorie, Description) VALUES
('Spaghetti Carbonara', 20, 'Plat Principal', 'Un classique italien avec des œufs, du fromage et du lard.'),
('Salade César', 15, 'Entrée', 'Salade verte avec poulet, croûtons et sauce César.'),
('Mousse au chocolat', 30, 'Dessert', 'Un dessert léger et aérien avec du chocolat et des œufs.');

INSERT INTO Ingredients (Nom_Ingredient, Quantite, Unité, Catégorie) VALUES
('Spaghetti', 500, 'g', 'Pâtes'),
('Lardons', 150, 'g', 'Viandes'),
('Parmesan', 100, 'g', 'Fromages'),
('Œufs', 4, 'pièce', 'Produits Laitiers'),
('Salade verte', 1, 'pièce', 'Légumes'),
('Poulet', 200, 'g', 'Viandes'),
('Croûtons', 50, 'g', 'Autres'),
('Chocolat noir', 200, 'g', 'Chocolats'),
('Œufssss', 4, 'pièce', 'Produits Laitiers'),
('Crème liquide', 150, 'ml', 'Produits Laitiers');

INSERT INTO Etapes (ID_Recette, Numero_Etape, Description) VALUES
(1, 1, 'Faire cuire les spaghetti dans une grande casserole d’eau salée.'),
(1, 2, 'Faire revenir les lardons dans une poêle jusqu’à ce qu’ils soient bien dorés.'),
(1, 3, 'Battre les œufs dans un bol avec le parmesan.'),
(1, 4, 'Égoutter les pâtes et les mélanger aux œufs et au parmesan. Ajouter les lardons.'),
(2, 1, 'Laver et découper la salade verte.'),
(2, 2, 'Faire griller le poulet puis le couper en morceaux.'),
(2, 3, 'Ajouter les croûtons et mélanger avec la sauce César.'),
(3, 1, 'Faire fondre le chocolat noir au bain-marie.'),
(3, 2, 'Séparer les blancs des jaunes d’œufs.'),
(3, 3, 'Mélanger les jaunes d’œufs au chocolat fondu.'),
(3, 4, 'Monter les blancs en neige et les incorporer délicatement au chocolat.');

INSERT INTO Planificateur (Date, Moment, ID_Recette) VALUES
('2024-11-06', 'Déjeuner', 1), 
('2024-11-06', 'Dîner', 2), 
('2024-11-06', 'Souper', 3); 