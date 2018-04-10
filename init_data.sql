USE databasesys;

-- Sample data for category
INSERT INTO category (CategoryName) VALUES 
	("Vegan"),
    ("Main"),
    ("Soup"),
    ("Dessert");

-- Sample data for user
INSERT INTO user (FirstName, LastName, DateOfBirth) VALUES 
	("Alexander", "Østergaard", TIMESTAMP('1996-06-01')),
    ("Casper", "Skjærris", TIMESTAMP('1996-12-14')),
    ("Imre", "Nagy", TIMESTAMP('1994-11-19'));

-- Sample data for ingredient
INSERT INTO ingredient (Name, Price, Calories) VALUES
    ("Potato", "100", "200"),
    ("Rice", "200", "210"),
    ("Pasta", "150", "170"),
    ("Cucumber", "130", "50"),
    ("Tomato", "140", "30"),
    ("Chicken breast", "400", "190"),
    ("Avocado", "250", "235");

-- Sample data for recipe
INSERT INTO recipe (Name, NumberOfPersons, PreparationTime) VALUES
    ("Cucumber chicken", 4, 60),
    ("Avocado stuffed potato", 2, 45),
    ("Pasta'la vista", 2, 25);
 
-- Sample data for recipesubmitted
INSERT INTO recipessubmitted (UserId, RecipeId) VALUES 
	(1, 1),
    (3, 2),
    (3, 3);

-- Sample data for ingrediendsused
INSERT INTO ingredientsused (RecipeId, IngredientId, Amount) VALUES 
	(1, 4, 4),
    (1, 6, 2),
    (2, 7, 3),
    (2, 1, 3),
    (3, 3, 2),
    (3, 5, 1);

-- Sample data for recipecategory
INSERT INTO recipecategory (CategoryId, RecipeId) VALUES
	(2, 1),
    (1, 2),
    (2, 2);

-- Sample data for rating
INSERT INTO rating (RatingNum, UserId, RecipeId) VALUES 
	(5, 1, 1),
    (4, 1, 2),
    (3, 2, 1),
    (3, 2, 2),
    (2, 2, 3);
    