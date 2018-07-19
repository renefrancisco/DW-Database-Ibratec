CREATE TABLE [dbo].[dm_Time] (
	[Time_sk]			INT			 NOT NULL IDENTITY,
    [Time_pk]			INT			 NOT NULL, -- Ex. 15:03:37 - 150337
	[Time]				TIME(0)		 NOT NULL, -- 15:05:37
    [Hour24Number]		INT          NOT NULL, -- 15
    [Hour12Number]		INT          NOT NULL, -- 03
    [MinuteNumber]		INT          NOT NULL, -- 03
    [SecondNumber]		INT          NOT NULL, -- 37
    [ClockPeriodText]   VARCHAR (2)  NOT NULL, -- pm
    [H:M:S24Text]		VARCHAR (8)  NOT NULL, -- 15:03:37
    [H:M24Text]			VARCHAR (5)  NOT NULL, -- 15:03
    [H:M:S12Text]		VARCHAR (11) NOT NULL, -- 03:03:37
	[H:M12Text]			VARCHAR (8)	 NOT NULL, -- 03:03
    [DayPeriodText]		VARCHAR (15) NOT NULL, -- Ex. Manhã, Tarde, Noite, Madrugada
    CONSTRAINT [PK_dm_Time] PRIMARY KEY ([Time_pk])
);

