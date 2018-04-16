USE databasesys;


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