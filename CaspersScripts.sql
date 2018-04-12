USE databasesys;

-- Group by example
-- Count how many time each ingredient is used  in all recipes
SELECT i.Name, SUM(iu.Amount) as NumberOfTimesUsed
FROM Ingredient i INNER JOIN  IngredientsUsed iu INNER JOIN Recipe r
WHERE i.IngredientId = iu.IngredientId AND r.RecipeId = iu.RecipeId
GROUP BY i.Name;

-- Insert example
-- Going to add a new category called Vegetraian.  Category has the Schema (CategoryID INT, CategoryName VARCHAR(25)
-- But the ID does auto increment, so when inserting you only need to provide the CategoryName
INSERT INTO Category(CategoryName) VALUES ('Vegetarian');

-- Calorie calculation function
-- DROP FUNCTION CaloriesInRecipe;
DELIMITER //
CREATE FUNCTION CaloriesInRecipe(vRecipeName VARCHAR(255)) RETURNS INT
BEGIN
	DECLARE vCalories INT;
    SELECT SUM(i.Calories*iu.Amount) INTO vCalories
    FROM Recipe r INNER JOIN IngredientsUsed iu 
    INNER JOIN Ingredient i
    WHERE r.Name = vRecipeName AND r.RecipeID = iu.RecipeID 
    AND iu.IngredientId = i.IngredientID;
    RETURN vCalories;
END; //
DELIMITER ;

-- Testing that the function works
SELECT Name, CaloriesInRecipe(Name) AS Calories FROM Recipe ORDER BY Name;

-- Selecting Ingredients in recipe and amount to see if calculation is correct (it is)
SELECT r.Name, i.Name, iu.Amount, i.Calories AS CaloriesPrAmount
FROM Recipe r INNER JOIN IngredientsUsed iu ON r.RecipeId = iu.RecipeId
INNER JOIN Ingredient i ON i.IngredientId = iu.IngredientId
ORDER BY r.Name;