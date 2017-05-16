CREATE PROCEDURE getBudapestClasses
AS
SET NOCOUNT ON;
/*
*	Auth: Martin Navarro
*	Desc: Selects classes and presenters per track 
*		for events at Budapest
*	Mdfy: Modified 5/15/2017
*/
BEGIN
	SELECT t.trackName AS TrackName
		, c.title AS ClassName
		, p.name AS PresenterName
	FROM eventClass ec
		INNER JOIN saturdayEvent se ON ec.eventID = se.eventID
		INNER JOIN venue v ON se.venueID = v.venueID
		-- Get the class presenters for the event
		INNER JOIN classPresenter cp ON cp.classID = ec.classID
		INNER JOIN person p ON cp.presenterID = p.personID
		-- Get the classes for an event
		INNER JOIN class c ON ec.classID = c.classID
		-- Join on track to get track names per class
		INNER JOIN track t ON t.trackID = c.trackID
	-- City for the venue must be Budapest
	WHERE v.city = 'Budapest'
END