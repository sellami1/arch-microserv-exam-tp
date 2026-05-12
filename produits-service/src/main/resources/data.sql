INSERT INTO categorie (nom)
VALUES ('Electronique');

INSERT INTO categorie (nom)
VALUES ('Livres');

INSERT INTO categorie (nom)
VALUES ('Maison');

INSERT INTO produit (nom, prix, stock, categorie_id)
VALUES ('Smartphone', 699.0, 12, (SELECT id FROM categorie WHERE nom = 'Electronique'));

INSERT INTO produit (nom, prix, stock, categorie_id)
VALUES ('Laptop', 1299.0, 8, (SELECT id FROM categorie WHERE nom = 'Electronique'));

INSERT INTO produit (nom, prix, stock, categorie_id)
VALUES ('Roman', 24.9, 40, (SELECT id FROM categorie WHERE nom = 'Livres'));

INSERT INTO produit (nom, prix, stock, categorie_id)
VALUES ('Cuisine Pro', 89.5, 25, (SELECT id FROM categorie WHERE nom = 'Maison'));

INSERT INTO produit (nom, prix, stock, categorie_id)
VALUES ('Tablette', 329.0, 16, (SELECT id FROM categorie WHERE nom = 'Electronique'));