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