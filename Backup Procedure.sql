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
	
CREATE TABLE IngredientsOld LIKE Ingredient;
ALTER TABLE IngredientsOld 
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
	INSERT INTO RecipeOld SELECT *,NOW(6) FROM Recipe;
	INSERT INTO IngredientsOld SELECT *,NOW(6) FROM Ingredient;
	INSERT INTO IngredientsUsedOld SELECT *,NOW(6) FROM IngredientsUsed;
	IF vSQLSTATE = '00000' THEN COMMIT;
		ELSE ROLLBACK;
	END IF;
END;//
DELIMITER ;

-- Data before backup
SELECT * FROM Recipe;
SELECT * FROM RecipeOld;

CALL RecipeBackup;

-- Data after backup.
SELECT * FROM Recipe;
SELECT * FROM RecipeOld;


CREATE EVENT BackupEvent
ON SCHEDULE EVERY 1 MONTH
STARTS '2018-05-01 00:00:00'
DO CALL RecipeBackup();