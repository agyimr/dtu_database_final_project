/* 
#######################################
########## CREATING DATABASE ##########
####################################### 
*/

DROP DATABASE IF EXISTS databasesys;
CREATE DATABASE databasesys;
USE databasesys;

-- Dropping existing tables
SET foreign_key_checks = 0;

    DROP TABLE IF EXISTS `Recipe`;

    DROP TABLE IF EXISTS `IngredientsUsed`;

    DROP TABLE IF EXISTS `Ingredient`;
    
    DROP TABLE IF EXISTS `RecipeCategory`;

    DROP TABLE IF EXISTS `Category`;

    DROP TABLE IF EXISTS `User`;

    DROP TABLE IF EXISTS `RecipesSubmitted`;

    DROP TABLE IF EXISTS `Rating`;

SET foreign_key_checks = 1;

-- Creating all tables
CREATE TABLE `Recipe`(
	`RecipeId` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`Name` varchar(255) NOT NULL, 
	`NumberOfPersons` int NOT NULL, 
	`PreparationTime` int NOT NULL);

ALTER TABLE `Recipe` ADD PRIMARY KEY (`RecipeId`);

CREATE TABLE `IngredientsUsed`(
	`Amount` int NOT NULL, 
	`IngredientId` int NOT NULL, 
	`RecipeId` int NOT NULL);

ALTER TABLE `IngredientsUsed` ADD PRIMARY KEY (`RecipeId`, `IngredientId`);

CREATE TABLE `Ingredient`(
	`IngredientId` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`Name` varchar(255) NOT NULL, 
	`Price` int NOT NULL, 
	`Calories` int NOT NULL);

ALTER TABLE `Ingredient` ADD PRIMARY KEY (`IngredientId`);

CREATE TABLE `RecipeCategory`(
	`CategoryId` int NOT NULL, 
	`RecipeId` int NOT NULL);

ALTER TABLE `RecipeCategory` ADD PRIMARY KEY (`CategoryId`, `RecipeId`);

CREATE TABLE `User`(
	`UserId` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`FirstName` varchar(255) NOT NULL, 
	`LastName` varchar(255) NOT NULL, 
	`DateOfBirth` datetime NOT NULL);

ALTER TABLE `User` ADD PRIMARY KEY (`UserId`);

CREATE TABLE `RecipesSubmitted`(
	`UserId` int NOT NULL, 
	`RecipeId` int NOT NULL);

ALTER TABLE `RecipesSubmitted` ADD PRIMARY KEY (`UserId`, `RecipeId`);

CREATE TABLE `Rating`(
	`RatingNum` int NOT NULL, 
	`UserId` int NOT NULL, 
	`RecipeId` int NOT NULL);

ALTER TABLE `Rating` ADD PRIMARY KEY (`UserId`, `RecipeId`);

CREATE TABLE `Category`(
	`CategoryId` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`CategoryName` varchar(255) NOT NULL);

ALTER TABLE `Category` ADD PRIMARY KEY (`CategoryId`,`CategoryName`);


-- Creating all FOREIGN KEY constraints
ALTER TABLE `IngredientsUsed`
ADD CONSTRAINT `FK_IngredientIngredientsUsed`
    FOREIGN KEY (`IngredientId`)
    REFERENCES `Ingredient`
        (`IngredientId`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX `IX_FK_IngredientIngredientsUsed`
    ON `IngredientsUsed`
    (`IngredientId`);

ALTER TABLE `IngredientsUsed`
ADD CONSTRAINT `FK_RecipeIngredientsUsed`
    FOREIGN KEY (`RecipeId`)
    REFERENCES `Recipe`
        (`RecipeId`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `RecipesSubmitted`
ADD CONSTRAINT `FK_UserRecipesSubmitted`
    FOREIGN KEY (`UserId`)
    REFERENCES `User`
        (`UserId`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `Rating`
ADD CONSTRAINT `FK_RatingUser`
    FOREIGN KEY (`UserId`)
    REFERENCES `User`
        (`UserId`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `Rating`
ADD CONSTRAINT `FK_RatingRecipe`
    FOREIGN KEY (`RecipeId`)
    REFERENCES `Recipe`
        (`RecipeId`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX `IX_FK_RatingRecipe`
    ON `Rating`
    (`RecipeId`);

ALTER TABLE `RecipesSubmitted`
ADD CONSTRAINT `FK_RecipesSubmittedRecipe`
    FOREIGN KEY (`RecipeId`)
    REFERENCES `Recipe`
        (`RecipeId`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX `IX_FK_RecipesSubmittedRecipe`
    ON `RecipesSubmitted`
    (`RecipeId`);

ALTER TABLE `RecipeCategory`
ADD CONSTRAINT `FK_CategoryRecipeCategory`
    FOREIGN KEY (`CategoryId`)
    REFERENCES `Category`
        (`CategoryId`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `RecipeCategory`
ADD CONSTRAINT `FK_RecipeCategoryRecipe`
    FOREIGN KEY (`RecipeId`)
    REFERENCES `Recipe`
        (`RecipeId`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX `IX_FK_RecipeCategoryRecipe`
    ON `RecipeCategory`
    (`RecipeId`);

/* 
#######################################
######## FILLING IT WITH DATA #########
####################################### 
*/

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
    
/* 
#######################################
############# OPERATIONS ##############
####################################### 
*/

SET SQL_SAFE_UPDATES = 0;

-- ORDER BY
-- Imagine a scenario when one of our users enter the search area with
-- no filtering applied. Our default listing would display all the recipes
-- in alphabetic order. Therefore our task is to query all the recipes
-- ordered by the alphabet:
SELECT * FROM recipe ORDER BY Name ASC;

-- UPDATE
-- Another scenario would be when someone decides to change his rate on 
-- a specific recipe. Maybe at first it wasn't that delicious, but on a
-- second try it ended up being really good. So the user decides to adjust
-- his or her rate on the recipe. Maybe from 3 to 5. 
SELECT * FROM rating WHERE UserId = 2 AND RecipeId = 2;
UPDATE rating SET RatingNum = 5 WHERE UserId = 2 AND RecipeId = 2;
SELECT * FROM rating WHERE UserId = 2 AND RecipeId = 2;

-- TRANSACTIONS
-- Imagine a scenario where the management decides that our current rating
-- system is too restrictive. Our users are begging for a finer scale. The
-- solution would be to, instead of a 1 to 5 scale, we allow users to rate
-- on a scale of 1 to 10. But for that to take effect, we first have to 
-- convert all of our existing rates by multiplying them with 2. It is 
-- really important that these changes should be applied once to all of the
-- database because afterwards there is no way of determining which ones we
-- did not change. In this case a transaction could ensure the state of the
-- database
SELECT * FROM rating;
START TRANSACTION;
UPDATE rating SET RatingNum = RatingNum * 2;
COMMIT;
SELECT * FROM rating;

-- TRIGGERS
-- Imagine that every time a user adds a new recipe we would like to check
-- whether there already exists a recipe with the same name:
DROP TRIGGER IF EXISTS exists_aready;

delimiter $$
CREATE TRIGGER exists_aready BEFORE INSERT ON recipe
FOR EACH ROW
BEGIN
	DECLARE c INT;
    SET c = (SELECT COUNT(*) FROM recipe WHERE Name LIKE CONCAT(NEW.Name, '%'));
	IF c >= 0 THEN SET NEW.Name = CONCAT(NEW.Name, c); END IF;
END$$
delimiter ;

INSERT INTO recipe (Name, NumberOfPersons, PreparationTime) VALUES ("Cucumber chicken", 8, 120);
INSERT INTO recipe (Name, NumberOfPersons, PreparationTime) VALUES ("Cucumber chicken", 12, 180);
SELECT * FROM recipe; 

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


-- CLEANUP
DROP TABLE IF EXISTS RecipeOld;
DROP TABLE IF EXISTS IngredientsOld;
DROP TABLE IF EXISTS IngredientsUsedOld;
DROP PROCEDURE IF EXISTS RecipeBackup;
DROP EVENT IF EXISTS BackupEvent; 

-- Backup Procedure example

-- Creating backup table.
CREATE TABLE RecipeOld LIKE Recipe;
ALTER TABLE RecipeOld 
	ADD BackupTime TIMESTAMP(6),
	DROP PRIMARY KEY,
	DROP INDEX RecipeId,
	ADD PRIMARY KEY(RecipeId, BackupTime),
	ADD UNIQUE (RecipeId, BackupTime);
	
CREATE TABLE IngredientOld LIKE Ingredient;
ALTER TABLE IngredientOld 
	ADD BackupTime TIMESTAMP(6),
	DROP PRIMARY KEY,
	DROP INDEX IngredientId,
	ADD PRIMARY KEY(IngredientId, BackupTime),
	ADD UNIQUE (IngredientId, BackupTime);
	
CREATE TABLE IngredientsUsedOld LIKE IngredientsUsed;
ALTER TABLE IngredientsUsedOld 
	ADD BackupTime TIMESTAMP(6),
	DROP PRIMARY KEY,
	ADD PRIMARY KEY(RecipeId, IngredientId, BackupTime),
	ADD UNIQUE (RecipeId,IngredientId, BackupTime);
	
	
-- Creating backup procedure for RecipeTable 
DELIMITER //
CREATE PROCEDURE RecipeBackup()
BEGIN
	DECLARE vSQLSTATE CHAR(5) DEFAULT '00000';
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
			GET DIAGNOSTICS CONDITION 1
			vSQLSTATE = RETURNED_SQLSTATE;
		END;
	START TRANSACTION;
	SET @t = NOW(6);
	INSERT INTO RecipeOld SELECT *,@t FROM Recipe;
	INSERT INTO IngredientOld SELECT *,@t FROM Ingredient;
	INSERT INTO IngredientsUsedOld SELECT *,@t FROM IngredientsUsed;
	IF vSQLSTATE = '00000' THEN COMMIT;
		ELSE ROLLBACK;
	END IF;
END;//
DELIMITER ;

CREATE EVENT BackupEvent
ON SCHEDULE EVERY 1 MONTH
STARTS '2018-05-01 00:00:00'
DO CALL RecipeBackup();


