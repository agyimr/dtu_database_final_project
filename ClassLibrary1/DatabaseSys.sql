-- -----------------------------------------------------------
-- Entity Designer DDL Script for MySQL Server 4.1 and higher
-- -----------------------------------------------------------
-- Date Created: 04/08/2018 14:50:29

-- Generated from EDMX file: C:\Users\alexa\Source\Repos\ConsoleApp2\ClassLibrary1\Model1.edmx
-- Target version: 3.0.0.0

-- --------------------------------------------------



-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- NOTE: if the constraint does not exist, an ignorable error will be reported.
-- --------------------------------------------------


--    ALTER TABLE `IngredientsUsedSet` DROP CONSTRAINT `FK_IngredientIngredientsUsed`;

--    ALTER TABLE `IngredientsUsedSet` DROP CONSTRAINT `FK_RecipeIngredientsUsed`;

--    ALTER TABLE `CategorySet` DROP CONSTRAINT `FK_RecipeCategory`;

--    ALTER TABLE `RecipesSubmittedSet` DROP CONSTRAINT `FK_UserRecipesSubmitted`;

--    ALTER TABLE `RatingSet` DROP CONSTRAINT `FK_RatingUser`;

--    ALTER TABLE `RatingSet` DROP CONSTRAINT `FK_RatingRecipe`;

--    ALTER TABLE `RecipesSubmittedSet` DROP CONSTRAINT `FK_RecipesSubmittedRecipe`;


-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------
SET foreign_key_checks = 0;

    DROP TABLE IF EXISTS `RecipeSet`;

    DROP TABLE IF EXISTS `IngredientsUsedSet`;

    DROP TABLE IF EXISTS `IngredientSet`;

    DROP TABLE IF EXISTS `CategorySet`;

    DROP TABLE IF EXISTS `UserSet`;

    DROP TABLE IF EXISTS `RecipesSubmittedSet`;

    DROP TABLE IF EXISTS `RatingSet`;

SET foreign_key_checks = 1;

-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------


CREATE TABLE `Recipe`(
	`RecipeId` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`Name` longtext NOT NULL, 
	`NumberOfPersons` int NOT NULL, 
	`PreparationTime` int NOT NULL);

ALTER TABLE `Recipe` ADD PRIMARY KEY (`RecipeId`);





CREATE TABLE `IngredientsUsed`(
	`Unit` longtext NOT NULL, 
	`Amount` int NOT NULL, 
	`IngredientId` int NOT NULL, 
	`RecipeId` int NOT NULL);

ALTER TABLE `IngredientsUsed` ADD PRIMARY KEY (`RecipeId`, `IngredientId`);





CREATE TABLE `Ingredient`(
	`IngredientId` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`Name` longtext NOT NULL, 
	`Price` int NOT NULL, 
	`Calories` int NOT NULL);

ALTER TABLE `Ingredient` ADD PRIMARY KEY (`IngredientId`);





CREATE TABLE `RecipeCategory`(
	`CategoryId` int NOT NULL, 
	`RecipeId` int NOT NULL);

ALTER TABLE `RecipeCategory` ADD PRIMARY KEY (`CategoryId`, `RecipeId`);





CREATE TABLE `User`(
	`UserId` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`FirstName` longtext NOT NULL, 
	`LastName` longtext NOT NULL, 
	`DateOfBirth` datetime NOT NULL);

ALTER TABLE `User` ADD PRIMARY KEY (`UserId`);





CREATE TABLE `RecipesSubmitted`(
	`UserId` int NOT NULL, 
	`RecipeId` int NOT NULL);

ALTER TABLE `RecipesSubmitted` ADD PRIMARY KEY (`UserId`, `RecipeId`);





CREATE TABLE `Rating`(
	`RatingNum` longtext NOT NULL, 
	`UserId` int NOT NULL, 
	`RecipeId` int NOT NULL);

ALTER TABLE `Rating` ADD PRIMARY KEY (`UserId`, `RecipeId`);





CREATE TABLE `Category`(
	`CategoryId` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`CategoryName` longtext NOT NULL);

ALTER TABLE `Category` ADD PRIMARY KEY (`CategoryId`);







-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------


-- Creating foreign key on `IngredientId` in table 'IngredientsUsed'

ALTER TABLE `IngredientsUsed`
ADD CONSTRAINT `FK_IngredientIngredientsUsed`
    FOREIGN KEY (`IngredientId`)
    REFERENCES `Ingredient`
        (`IngredientId`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;


-- Creating non-clustered index for FOREIGN KEY 'FK_IngredientIngredientsUsed'

CREATE INDEX `IX_FK_IngredientIngredientsUsed`
    ON `IngredientsUsed`
    (`IngredientId`);



-- Creating foreign key on `RecipeId` in table 'IngredientsUsed'

ALTER TABLE `IngredientsUsed`
ADD CONSTRAINT `FK_RecipeIngredientsUsed`
    FOREIGN KEY (`RecipeId`)
    REFERENCES `Recipe`
        (`RecipeId`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;



-- Creating foreign key on `UserId` in table 'RecipesSubmitted'

ALTER TABLE `RecipesSubmitted`
ADD CONSTRAINT `FK_UserRecipesSubmitted`
    FOREIGN KEY (`UserId`)
    REFERENCES `User`
        (`UserId`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;



-- Creating foreign key on `UserId` in table 'Rating'

ALTER TABLE `Rating`
ADD CONSTRAINT `FK_RatingUser`
    FOREIGN KEY (`UserId`)
    REFERENCES `User`
        (`UserId`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;



-- Creating foreign key on `RecipeId` in table 'Rating'

ALTER TABLE `Rating`
ADD CONSTRAINT `FK_RatingRecipe`
    FOREIGN KEY (`RecipeId`)
    REFERENCES `Recipe`
        (`RecipeId`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;


-- Creating non-clustered index for FOREIGN KEY 'FK_RatingRecipe'

CREATE INDEX `IX_FK_RatingRecipe`
    ON `Rating`
    (`RecipeId`);



-- Creating foreign key on `RecipeId` in table 'RecipesSubmitted'

ALTER TABLE `RecipesSubmitted`
ADD CONSTRAINT `FK_RecipesSubmittedRecipe`
    FOREIGN KEY (`RecipeId`)
    REFERENCES `Recipe`
        (`RecipeId`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;


-- Creating non-clustered index for FOREIGN KEY 'FK_RecipesSubmittedRecipe'

CREATE INDEX `IX_FK_RecipesSubmittedRecipe`
    ON `RecipesSubmitted`
    (`RecipeId`);



-- Creating foreign key on `CategoryId` in table 'RecipeCategory'

ALTER TABLE `RecipeCategory`
ADD CONSTRAINT `FK_CategoryRecipeCategory`
    FOREIGN KEY (`CategoryId`)
    REFERENCES `Category`
        (`CategoryId`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;



-- Creating foreign key on `RecipeId` in table 'RecipeCategory'

ALTER TABLE `RecipeCategory`
ADD CONSTRAINT `FK_RecipeCategoryRecipe`
    FOREIGN KEY (`RecipeId`)
    REFERENCES `Recipe`
        (`RecipeId`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;


-- Creating non-clustered index for FOREIGN KEY 'FK_RecipeCategoryRecipe'

CREATE INDEX `IX_FK_RecipeCategoryRecipe`
    ON `RecipeCategory`
    (`RecipeId`);



-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------
