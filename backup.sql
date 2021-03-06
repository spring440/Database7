USE [s17guest07]
GO
/****** Object:  Table [dbo].[class]    Script Date: 5/15/2017 10:54:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
-- Class object containing class details and trackID for the track
-- Used 100 for the title because some of the titles for the classes were lengthly
-- Descriptions contained more than 255 characters sometimes so I made it a varchar max
CREATE TABLE [dbo].[class](
	[classID] [int] IDENTITY(1,1) NOT NULL,

	-- Title cannot be null
	[title] [varchar](100) NOT NULL,
	[classDescription] [varchar](max) NULL,
	[levelID] [int] NULL,
	[trackID] [int] NULL,
	[duration] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[classID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[classLevel]    Script Date: 5/15/2017 10:54:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
-- Table to hold class levels
CREATE TABLE [dbo].[classLevel](
	[levelID] [int] IDENTITY(1,1) NOT NULL,
	[levelName] [varchar](25) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[levelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[classPresenter]    Script Date: 5/15/2017 10:54:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- BCNF link table between class and person
-- definition: Person must be a presenter
CREATE TABLE [dbo].[classPresenter](
	[classID] [int] NOT NULL,
	[presenterID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[classID] ASC,
	[presenterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[classRoomSchedule]    Script Date: 5/15/2017 10:54:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- A sceduled class for an event
-- Sarrogate key [scheduleID] was given in order to easily link the class to students
-- sarrogate key doesnot form anti-pattern because the class time is not FD on the other two keys, this breaks BCNF but maintains 3NF
-- scheduled class will be held in a specific room
CREATE TABLE [dbo].[classRoomSchedule](
	[scheduleID] [int] IDENTITY(1,1) NOT NULL,
	[eventClassID] [int] NULL,
	[roomID] [int] NULL,
	[classTime] [time](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[scheduleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [ui_classRoomSchedule1] UNIQUE NONCLUSTERED 
(
	[eventClassID] ASC,
	[roomID] ASC,
	[classTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[classStatus]    Script Date: 5/15/2017 10:54:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
-- holds class statuses
-- this was made in order to keep track of potential classes that are pending acceptance into an event's schedule
CREATE TABLE [dbo].[classStatus](
	[statusID] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](15) NULL,
PRIMARY KEY CLUSTERED 
(
	[statusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [ui_classStatus1] UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[country]    Script Date: 5/15/2017 10:54:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
-- country table also makes reference to the region
CREATE TABLE [dbo].[country](
	[countryID] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
	[regionID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[countryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[eventClass]    Script Date: 5/15/2017 10:54:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- class event table for classes at events with a status
-- sarrogate key given to better link to scheduled classes in an event
-- sarrogate key doesn't form anti pattern because status is not FD to class and status
-- a class can only be uniquely submitted to an event even though it may be scheduled multiple times
CREATE TABLE [dbo].[eventClass](
	[eventClassID] [int] IDENTITY(1,1) NOT NULL,
	[eventID] [int] NULL,
	[classID] [int] NULL,
	[statusID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[eventClassID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [ui_eventClass1] UNIQUE NONCLUSTERED 
(
	[eventID] ASC,
	[classID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[person]    Script Date: 5/15/2017 10:54:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
-- Person table containing name
CREATE TABLE [dbo].[person](
	[personID] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](70) NULL,
PRIMARY KEY CLUSTERED 
(
	[personID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[personEmail]    Script Date: 5/15/2017 10:54:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
-- Holds an email linked to a person
-- Emails are unique
-- I chose 90 as the email limit because of a persons name being capped at 70
-- I assumed that if the person were to use their name on their email, which
-- tends to happen, they would have 20 characters for the domain
CREATE TABLE [dbo].[personEmail](
	[email] [varchar](90) NOT NULL,
	[personID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [ui_personEmail1] UNIQUE NONCLUSTERED 
(
	[personID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[personPhone]    Script Date: 5/15/2017 10:54:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
-- holds phone number linked to person
-- numbers are unique
-- The reason I chose varchar(15) is because the largest phone international phone number
-- accepted without extions is 15 characters long
CREATE TABLE [dbo].[personPhone](
	[phoneNumber] [varchar](15) NOT NULL,
	[personID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[phoneNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [ui_personPhone1] UNIQUE NONCLUSTERED 
(
	[personID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[personRole]    Script Date: 5/15/2017 10:54:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- BCNF table for a person's role
-- Person may have multiple roles
CREATE TABLE [dbo].[personRole](
	[personID] [int] NULL,
	[roleID] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[region]    Script Date: 5/15/2017 10:54:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
-- Table containing the regions for country boundaries
-- I took the largest region's length and round it a few  characters higher and chose the limit as 30
CREATE TABLE [dbo].[region](
	[regionID] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[regionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [ui_region1] UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[room]    Script Date: 5/15/2017 10:54:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
-- Room for a venue
-- I chose 25 as the limit because I noticed unique names for some events
-- Some venues have colors for example as their room names, not just room numbers
CREATE TABLE [dbo].[room](
	[roomID] [int] IDENTITY(1,1) NOT NULL,
	[venueID] [int] NULL,
	[name] [varchar](25) NOT NULL,
	[capacity] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[roomID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[saturdayEvent]    Script Date: 5/15/2017 10:54:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- A SQL Saturday event with a date and venue
CREATE TABLE [dbo].[saturdayEvent](
	[eventID] [int] IDENTITY(1,1) NOT NULL,
	[venueID] [int] NULL,
	[eventDate] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[eventID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [ui_saturdayEvent1] UNIQUE NONCLUSTERED 
(
	[venueID] ASC,
	[eventDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[studentClass]    Script Date: 5/15/2017 10:54:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Student enrolment BCNF table
CREATE TABLE [dbo].[studentClass](
	[scheduleID] [int] NOT NULL,
	[studentID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[scheduleID] ASC,
	[studentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[track]    Script Date: 5/15/2017 10:54:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
-- Track table
-- Chose 75 as the length by means of rounding the max length I saw on the SQL saturday site
CREATE TABLE [dbo].[track](
	[trackID] [int] IDENTITY(1,1) NOT NULL,
	[trackName] [varchar](75) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[trackID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[venue]    Script Date: 5/15/2017 10:54:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[venue](
	[venueID] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
	[address1] [varchar](75) NOT NULL,
	[address2] [varchar](75) NULL,
	[city] [varchar](50) NOT NULL,
	[state] [varchar](75) NOT NULL,
	[countryID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[venueID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[class]  WITH CHECK ADD FOREIGN KEY([levelID])
REFERENCES [dbo].[classLevel] ([levelID])
GO
ALTER TABLE [dbo].[class]  WITH CHECK ADD FOREIGN KEY([trackID])
REFERENCES [dbo].[track] ([trackID])
GO
ALTER TABLE [dbo].[classPresenter]  WITH CHECK ADD FOREIGN KEY([classID])
REFERENCES [dbo].[class] ([classID])
GO
ALTER TABLE [dbo].[classPresenter]  WITH CHECK ADD FOREIGN KEY([presenterID])
REFERENCES [dbo].[person] ([personID])
GO
ALTER TABLE [dbo].[classRoomSchedule]  WITH CHECK ADD FOREIGN KEY([eventClassID])
REFERENCES [dbo].[eventClass] ([eventClassID])
GO
ALTER TABLE [dbo].[classRoomSchedule]  WITH CHECK ADD FOREIGN KEY([roomID])
REFERENCES [dbo].[room] ([roomID])
GO
ALTER TABLE [dbo].[country]  WITH CHECK ADD FOREIGN KEY([regionID])
REFERENCES [dbo].[region] ([regionID])
GO
ALTER TABLE [dbo].[eventClass]  WITH CHECK ADD FOREIGN KEY([classID])
REFERENCES [dbo].[class] ([classID])
GO
ALTER TABLE [dbo].[eventClass]  WITH CHECK ADD FOREIGN KEY([eventID])
REFERENCES [dbo].[saturdayEvent] ([eventID])
GO
ALTER TABLE [dbo].[eventClass]  WITH CHECK ADD FOREIGN KEY([statusID])
REFERENCES [dbo].[classStatus] ([statusID])
GO
ALTER TABLE [dbo].[personEmail]  WITH CHECK ADD FOREIGN KEY([personID])
REFERENCES [dbo].[person] ([personID])
GO
ALTER TABLE [dbo].[personPhone]  WITH CHECK ADD FOREIGN KEY([personID])
REFERENCES [dbo].[person] ([personID])
GO
ALTER TABLE [dbo].[personRole]  WITH CHECK ADD FOREIGN KEY([personID])
REFERENCES [dbo].[person] ([personID])
GO
ALTER TABLE [dbo].[personRole]  WITH CHECK ADD FOREIGN KEY([roleID])
REFERENCES [dbo].[eventRole] ([roleID])
GO
ALTER TABLE [dbo].[room]  WITH CHECK ADD FOREIGN KEY([venueID])
REFERENCES [dbo].[venue] ([venueID])
GO
ALTER TABLE [dbo].[saturdayEvent]  WITH CHECK ADD FOREIGN KEY([venueID])
REFERENCES [dbo].[venue] ([venueID])
GO
ALTER TABLE [dbo].[studentClass]  WITH CHECK ADD FOREIGN KEY([scheduleID])
REFERENCES [dbo].[classRoomSchedule] ([scheduleID])
GO
ALTER TABLE [dbo].[studentClass]  WITH CHECK ADD FOREIGN KEY([studentID])
REFERENCES [dbo].[person] ([personID])
GO
ALTER TABLE [dbo].[venue]  WITH CHECK ADD FOREIGN KEY([countryID])
REFERENCES [dbo].[country] ([countryID])
GO
/****** Object:  StoredProcedure [dbo].[getBudapestClasses]    Script Date: 5/15/2017 10:54:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[getBudapestClasses]
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
GO
/****** Object:  StoredProcedure [dbo].[insertPresentation]    Script Date: 5/15/2017 10:54:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insertPresentation] @personName VARCHAR(75)
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
GO
