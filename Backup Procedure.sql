USE databasesys;


-- CLEANUP
DROP TABLE IF EXISTS RecipeOld;
DROP PROCEDURE IF EXISTS RecipeBackup;


-- Backup Procedure example

-- Creating backup table.
CREATE TABLE RecipeOld LIKE Recipe;
ALTER TABLE RecipeOld 
	ADD BackupTime TIMESTAMP(6),
	DROP PRIMARY KEY,
	DROP INDEX RecipeId,
	ADD PRIMARY KEY(RecipeId, BackupTime),
	ADD UNIQUE (RecipeId, BackupTime);
	
	
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
	INSERT INTO RecipeOld SELECT *, NOW(6) FROM Recipe;
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