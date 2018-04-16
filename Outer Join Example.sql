use databasesys;


-- Outer join examples
-- This example will get all recipies and their corresponding categories, or null if the recipe doesn't have a category.
SELECT Name, CategoryName from Recipe 
	left outer join RecipeCategory rc on Recipe.RecipeID = rc.RecipeId 
	left outer join Category c on rc.CategoryId = c.CategoryId;


-- Likewise We can get categories and the corresponding recipes while keeping the categories which has no Recipes yet.
SELECT CategoryName, Name FROM Category 
	LEFT OUTER JOIN RecipeCategory rc ON Category.CategoryId = rc.CategoryId
	LEFT OUTER JOIN Recipe r ON r.RecipeId = rc.RecipeId;



-- The next two queries will operate on the Recipe and Ingredient relation.
-- This will show that all Recipes have atleast one Ingredient, but some ingredients does not belong to a recipe.

-- Every Recipe has atleast one ingredient in our initial data.
SELECT i.Name as IngredientName, r.name as RecipeName FROM Recipe as r 
	LEFT OUTER JOIN ingredientsused as iu on r.RecipeId = iu.RecipeId
	LEFT OUTER JOIN ingredient as i on iu.IngredientId = i.IngredientId;

-- Not all ingredients are mapped to a Recipe.
SELECT r.Name as RecipeName, i.name as IngredientName FROM ingredient as i 
	LEFT OUTER JOIN ingredientsused as iu on i.IngredientId = iu.IngredientId
	LEFT OUTER JOIN recipe as r on iu.RecipeId = r.RecipeId;