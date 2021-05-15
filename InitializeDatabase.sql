CREATE DATABASE [ProjectDiva];

USE [ProjectDiva];

CREATE TABLE [diva](
	[id] numeric(18,0) PRIMARY KEY,
	[name] nvarchar(10),
	[num] int,
	[date] date
	);

INSERT INTO [diva] VALUES (0,'',0,null);

CREATE TABLE [user](
	[id] numeric(18,0) PRIMARY KEY,
	[name] nvarchar(10),
	[password] nvarchar(70),
	[permissions] nvarchar(200)
);