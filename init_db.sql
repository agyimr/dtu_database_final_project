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
