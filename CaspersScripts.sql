USE databasesys;

-- Group by example
-- Count how many time each ingredient is used  in all recipes
SELECT i.Name, SUM(iu.Amount) AS NumberOfTimesUsed
FROM Ingredient i INNER JOIN  IngredientsUsed iu INNER JOIN Recipe r
WHERE i.IngredientId = iu.IngredientId AND r.RecipeId = iu.RecipeId
GROUP BY i.Name;

-- Insert example
-- Going to add a new category called Vegetraian.  Category has the Schema (CategoryID INT, CategoryName VARCHAR(25)
-- But the ID does auto increment, so when inserting you only need to provide the CategoryName
INSERT INTO Category(CategoryName) VALUES ('Vegetarian');

-- Calorie calculation function
DROP FUNCTION IF EXISTS CaloriesInRecipe;
DELIMITER //
CREATE FUNCTION CaloriesInRecipe(vRecipeID INT) RETURNS INT
BEGIN
	DECLARE vCalories INT;
    SELECT SUM(i.Calories*iu.Amount) INTO vCalories
    FROM Recipe r INNER JOIN IngredientsUsed iu 
    INNER JOIN Ingredient i
    WHERE r.RecipeId = vRecipeID AND r.RecipeID = iu.RecipeID 
    AND iu.IngredientId = i.IngredientID;
    RETURN vCalories;
END; //
DELIMITER ;

-- Testing that the function works
SELECT Name, CaloriesInRecipe(RecipeId) AS Calories FROM Recipe ORDER BY Name;

-- Selecting Ingredients in recipe and amount to see if calculation is correct (it is)
SELECT r.Name, i.Name, iu.Amount, i.Calories AS CaloriesPrAmount
FROM Recipe r INNER JOIN IngredientsUsed iu ON r.RecipeId = iu.RecipeId
INNER JOIN Ingredient i ON i.IngredientId = iu.IngredientId
ORDER BY r.Name;

-- Using Calories function to only see recipes where total calories are less than 1000
-- Testing that the function works
SELECT Name, CaloriesInRecipe(RecipeId) AS Calories 
FROM Recipe 
WHERE CaloriesInRecipe(RecipeId) < 1000;

-- We only want to keep good recipes in our database, so every month we want to delete recipes
-- with a rating lower than 1 (we will keep recipes with no rating though)

-- First we need a function for calculating rating of a recipe
DROP FUNCTION IF EXISTS RecipeRating;
DELIMITER //
CREATE FUNCTION RecipeRating(vID INT) RETURNS INT
BEGIN
	DECLARE vRating INT;
    SELECT AVG(ra.RatingNum) INTO vRating
    FROM Recipe r INNER JOIN Rating ra ON r.RecipeId = ra.RecipeId
    WHERE r.RecipeId = vID;
    RETURN vRating;
END; //
DELIMITER ;

-- Checking that it work
SELECT Name, RecipeRating(RecipeId) AS Rating FROM Recipe ORDER BY Name;

-- Adding new recipe with no rating to test if function still works
INSERT INTO recipe (Name, NumberOfPersons, PreparationTime) VALUES ('Curry Chicken', 4, 90);
INSERT INTO ingredient (Name, Price, Calories) VALUES 
('Red curry paste', 10, 263),
('Coconut milk', 4, 230),
('Butternut squash',5, 45);
INSERT INTO recipessubmitted (UserId, RecipeId) VALUES (2,4);
INSERT INTO ingredientsused (RecipeId, IngredientId, Amount) VALUES 
(4,2,2),
(4,6,4),
(4,8,1),
(4,9,4),
(4,10,4);
INSERT INTO recipecategory (CategoryId, RecipeId) VALUES (2,4);

-- Butternutsquash now have every attribute but rating
SELECT Name, RecipeRating(RecipeId) AS Rating FROM Recipe ORDER BY Name;

-- writing th procedure the event will call
DROP PROCEDURE IF EXISTS DeleteBadRecipes;
DELIMITER //
CREATE PROCEDURE DeleteBadRecipes()
BEGIN
	SET @badRecipeIDs = (
    SELECT RecipeId 
    FROM Recipe
    WHERE RecipeRating(RecipeId) BETWEEN 0 AND 1);
    DELETE FROM RecipeCategory WHERE RecipeId IN (@badRecipeIDs);
    DELETE FROM RecipesSubmitted WHERE RecipeID IN (@badRecipeIDs);
    DELETE FROM IngredientsUsed WHERE RecipeID IN (@badRecipeIDs);
    DELETE FROM Rating WHERE RecipeId IN (@badRecipeIDs);
	DELETE FROM Recipe WHERE RecipeId IN (@badRecipeIDs);
END//
DELIMITER ;

-- Test nothing is deleted
CALL DeleteBadRecipes();
SELECT Name, RecipeRating(RecipeId) AS Rating FROM Recipe ORDER BY Name;

-- Adding a rating to curry chicken so it should be deleted
INSERT INTO rating (RatingNum, UserId, RecipeId) VALUES (1,2,4);
-- checking rating
SELECT Name, RecipeRating(RecipeId) AS Rating FROM Recipe ORDER BY Name;
-- check it gets deleted
CALL DeleteBadRecipes();
SELECT Name, RecipeRating(RecipeId) AS Rating FROM Recipe ORDER BY Name;
    
-- Binding the procedure to an event that runs the first of every month   
DROP EVENT IF EXISTS DeleteBadRecipesEvent; 
CREATE EVENT DeleteBadRecipesEvent
ON SCHEDULE EVERY 1 MONTH
STARTS '2018-05-01 00:00:01'
DO CALL DeleteBadRecipes();

-- Turn on events for this database
SET GLOBAL event_scheduler = 1;
-- checking it's turned on
SHOW VARIABLES LIKE 'event_scheduler';

-- Looking directly at the recipe table is not very user friendly. We don't want to have duplicate data though
-- So we are going to create a view for users which will use the data stored in Recipe, rating and ingredient
CREATE VIEW RecipeUserView AS 
SELECT r.Name, r.NumberOfPersons, r.PreparationTime, CaloriesInRecipe(r.RecipeId) AS 'Calories pr 100g', RecipeRating(r.RecipeId) AS Rating 
FROM Recipe r; 

-- Selecting the view to test it
SELECT * FROM RecipeUserView;