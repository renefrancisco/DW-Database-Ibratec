CREATE TABLE [dbo].[dm_Date] (
    [Date_sk]               INT			  NOT NULL IDENTITY,
    [Date_pk]               INT			  NOT NULL, --YYYYMMDD
    [Date]					DATE	      NOT NULL, 
    [DateInFullText]		VARCHAR (25)  NOT NULL, --Date in Full - Ex. 27 de julho de 2017
    [YearNumber]			CHAR(4)       NOT NULL, --YYYY
    [Year3MPText]		    VARCHAR (10)  NOT NULL, --YYYYQQ - Ex. 2017Q3
    [HalfOfYearNumber]		INT           NOT NULL, --Half Year Number - Ex. 20170707 - 2
    [HalfOfYearText]		CHAR(2)		  NOT NULL, --Half Year Text - Ex. S2
    [4MPOfYearNumber]		INT           NOT NULL, --4 Month Period Number - Ex. 20170707 - 2
    [4MPOfYearText]			CHAR(2)		  NOT NULL, --4 Month Period Text - Q2
    [3MPOfYearNumber]	    INT           NOT NULL, --3 Month Period Number - Ex. 20170707 - 3
    [3MPOfYearText]			CHAR(2)		  NOT NULL, --3 Month Period Text - Ex. T3
    [2MPOfYearNumber]	    INT           NOT NULL, --2 Month Period Number - Ex. 20170707 - 4
    [2MPOfYearText]		    CHAR(2)		  NOT NULL, --2 Month Period Text - Ex. B4
    [MonthNumber]			INT			  NOT NULL, --Month Number - Ex. 20170707 - 7
    [MonthText]				VARCHAR (10)  NOT NULL, --Month Name - Ex. Janeiro, Fevereiro ...
    [MonthShortText]		CHAR (3)	  NOT NULL, --Month Short Name - Ex. Jan, Fev, Mar ...
	[FirstDayOfMonth]		DATE		  NOT NULL, --First day of month - Ex. 2017/07/01	
	[LastDayOfMonth]		DATE		  NOT NULL, --Last day of month - Ex. 2017/07/31	
    [WeekOfYearNumber]		INT           NOT NULL, --Week Number - Ex. 20170707 - 27
    [WeekOfYearText]		VARCHAR (10)  NOT NULL, --Week Text	  - Ex. Semana 27
    [WeekOfHalfYearNumber]	INT           NOT NULL, --Week Of Half Year Number - Ex. 20170707 - 1
    [WeekOfHalfYearText]	VARCHAR (10)  NOT NULL, --Week Of Half Year Text - Ex. Semana 1
    [WeekOf4MPYearNumber]	INT           NOT NULL, --Week Of 4 month period of Year Number - Ex. 20170707 - 10
    [WeekOf4MPYearText]		VARCHAR (10)  NOT NULL, --Week Of 4 month period of Year Text - Ex. Semana 10
    [WeekOf3MPYearNumber]	INT           NOT NULL, --Week Of 3 month period of Year Number - Ex. 20170707 - 1
    [WeekOf3MPYearText]		VARCHAR (10)  NOT NULL, --Week Of 3 month period of Year Text - Ex. Semana 1
    [WeekOf2MPYearNumber]	INT           NOT NULL, --Week Of 2 month period of Year Number - Ex. 20170707 - 6
    [WeekOf2MPYearText]		VARCHAR (10)  NOT NULL, --Week Of 2 month period of Year Text - Ex. Semana 6
    [WeekOfMonthNumber]		INT           NOT NULL, --Week of month Number - Ex. 20170707 - 1
    [WeekOfMonthText]		VARCHAR (10)  NOT NULL, --Week of month Text - Ex. 20170707 - Semana 1
    [WeeksInYearQTY]		INT           NOT NULL, --Quantity of weeks in year - Ex. 53
	[WeeksInHalfYearQTY]	INT           NOT NULL, --Quantity of weeks in the current half year - Ex. 20170707 - 27
    [WeeksIn4MPYearQTY]		INT           NOT NULL, --Quantity of weeks in the current 4 month period of year - Ex. 20170707 - 18
    [WeeksIn3MPQTY]			INT           NOT NULL, --Quantity of weeks in the current 3 month period of year - Ex. 20170707 - 14
    [WeeksIn2MPQTY]			INT           NOT NULL, --Quantity of weeks in the current 2 month period of year - Ex. 20170707 - 9
    [WeeksInMonthQTY]		INT           NOT NULL, --Quantity of weeks in the current month  - Ex. 20170707 - 5
    [DayOfYearNumber]		INT           NOT NULL, --Number of days since the begin of year - Ex. 20170707 - 188
    [DayOfHalfYearNumber]	INT           NOT NULL, --Number of days since the begin of the current half year period - Ex. 20170707 - 37
    [DayOf4MPNumber]		INT           NOT NULL, --Number of days since the begin of the current 4 month period - Ex. 20170707 - 68
    [DayOf3MPNumber]		INT           NOT NULL, --Number of days since the begin of the current 3 month period - Ex. 20170707 - 7
    [DayOf2MPNumber]		INT           NOT NULL, --Number of days since the begin of the current 2 month period - Ex. 20170707 - 7
    [DayOfMonthNumber]		INT           NOT NULL, --Number of days since the begin of the current month period - Ex. 20170707 - 7
    [DayOfWeekNumber]		INT           NOT NULL, --Day of current week (1 - sunday ... 7 - saturday) - Ex. 20170707 - 6
    [DayOfWeekText]			VARCHAR (20)  NOT NULL, --Week Day Full Text - Ex. segunda-feira, terça-feira, quarta-feira, quinta-feira, sexta-feira, sabado, domingo
    [DayOfWeekShortText]	VARCHAR (10)  NOT NULL, --Week Day Short Text - Ex. segunda, terça, quarta, quinta, sexta, sabado, domingo
    [DayOfWeekShort2Text]	CHAR (3)	  NOT NULL, --Week Day Short 2 Text - Ex. seg, ter, qua, qui, sex, sab, dom 
    [DaysInYearQTY]			INT           NOT NULL, --Quantity of days in the current year - Ex. 365
    [DaysInHalfYearQTY]		INT           NOT NULL, --Quantity of days in the current half year - Ex. 20170707 - 184
    [DaysIn4MPYearQTY]		INT           NOT NULL, --Quantity of days in the current 4MP year - Ex. 20170707 - 123
    [DaysIn3MPYearQTY]		INT           NOT NULL, --Quantity of days in the current 3MP year - Ex. 20170707 - 92
    [DaysIn2MPYearQTY]		INT           NOT NULL, --Quantity of days in the current 2MP year - Ex. 20170707 - 61
    [DaysInMonthQTY]		INT           NOT NULL, --Quantity of days in the current month - Ex. 20170707 - 31
    [DayIsWeekendText]      VARCHAR	(20)  NOT NULL, --If is weekend "é fim de semana" else "não é fim de semana"
    [DayIsWeekendBoolean]   INT			  NOT NULL, --If is weekend "1" else "0"
    [DayIsHolidayText]      VARCHAR	(20)  NOT NULL, --If is holiday "é feriado" else "não é feriado"
    [DayIsHolidayBoolean]   INT			  NOT NULL, --If is holiday "1" else "0"
    CONSTRAINT [PK_dm_Date] PRIMARY KEY ([Date_pk])
);


GO


