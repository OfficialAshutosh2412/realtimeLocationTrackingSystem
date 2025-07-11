CREATE TABLE signup(
	[userid] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[username] NVARCHAR(100)  NOT NULL,
	[password] NVARCHAR(50) NOT NULL,
	[gender] NVARCHAR(20) NOT NULL,
	[state] NVARCHAR(150) NOT NULL,
	[city] NVARCHAR(150) NOT NULL,
	[pincode] NVARCHAR(10) NOT NULL,
	[address] NVARCHAR(200) NOT NULL
);


CREATE TABLE UserLocationHistory(
	[id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[username] NVARCHAR(100)  NOT NULL,
	[latitude] FLOAT(53) NOT NULL,
	[longitude] FLOAT(53) NOT NULL,
	[recordedAt] DATETIME NOT NULL,
	[isOnline] BIT NOT NULL
);

SELECT * FROM signup;
--CREATE TABLE UserLocation(
--	[id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
--	[username] NVARCHAR(100)  NOT NULL,
--	[latitude] FLOAT(53) NOT NULL,
--	[longitude] FLOAT(53) NOT NULL,
--	[lastUpdated] DATETIME NOT NULL,
--);	