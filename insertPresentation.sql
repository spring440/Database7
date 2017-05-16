ALTER PROCEDURE insertPresentation @personName VARCHAR(75)
	, @presentationName VARCHAR(100)
AS
/*
*	Auth: Martin Navarro
*	Desc: Inserts a new presenter and a class
		links the presenter with classPresenter link table
*	Mdfy: Modified 5/15/2017
*/
SET NOCOUNT ON

-- ID holders to store ID's in transaction for link table
DECLARE @personID INT
DECLARE @classID INT

BEGIN TRANSACTION

	-- Rollback if there is a blank value
	IF (@personName = '' 
		OR @personName IS NULL
		OR @presentationName = '' 
		OR @presentationName IS NULL)
	BEGIN
		ROLLBACK;
	END
	ELSE
	BEGIN
		-- Insert new presenter
		INSERT INTO person VALUES (@personName);
		-- Get there ID within tran after insert
		SELECT @personID = (SELECT TOP 1 personID FROM person ORDER BY personID DESC)

		-- If the class doesn't exist, add it
		IF NOT EXISTS (SELECT title FROM class WHERE title = @presentationName)
		BEGIN
			INSERT INTO class (title) VALUES (@presentationName);
		END

		-- Get the ID for the class, class name is unique
		SELECT @classID = (SELECT TOP 1 classID FROM class WHERE title = @presentationName)

		-- Insert the ID's into the link table
		INSERT INTO classPresenter VALUES (@classID,@personID)
		
		COMMIT TRAN;
	END