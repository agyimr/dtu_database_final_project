USE databasesys;
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



