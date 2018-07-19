CREATE PROCEDURE [dbo].[usr_sp_DateLoad]
AS

/********************************************************************************************/
--Specify Start Date and End date here
--Value of Start Date Must be Less than Your End Date 
DECLARE @StartDate DATE = CONVERT(DATE,'1987-01-01') --Starting value of Date Range
DECLARE @EndDate DATE = CONVERT(DATE,'2050-12-31') --End Value of Date Range

--Variables to fill table dm_Date
DECLARE
@Date_pk				INT	,			--YYYYMMDD
@Date					DATE,
@DateInFullText			VARCHAR (25)  , --Date in Full - Ex. 27 de julho de 2017
@YearNumber				CHAR(4)       , --YYYY
@Year3MPText		    VARCHAR (10)  , --YYYYQQ - Ex. 2017Q3
@HalfOfYearNumber		INT           , --Half Year Number - Ex. 20170707 - 2
@HalfOfYearText			CHAR(2)		  , --Half Year Text - Ex. 2S
@4MPOfYearNumber		INT           , --4 Month Period Number - Ex. 20170707 - 2
@4MPOfYearText			CHAR(2)		  , --4 Month Period Text - 2Q
@3MPOfYearNumber	    INT           , --3 Month Period Number - Ex. 20170707 - 3
@3MPOfYearText			CHAR(2)		  , --3 Month Period Text - Ex. 3T
@2MPOfYearNumber	    INT           , --2 Month Period Number - Ex. 20170707 - 4
@2MPOfYearText		    CHAR(2)		  , --2 Month Period Text - Ex. 4B
@MonthNumber			VARCHAR(2)    , --Month Number - Ex. 20170707 - 7
@MonthText				VARCHAR (10)  , --Month Name - Ex. Janeiro, Fevereiro ...
@MonthShortText			CHAR (3)	  , --Month Short Name - Ex. Jan, Fev, Mar ...
@FirstDayOfMonth		DATE	  , --First day of month - Ex. 2017/07/01	
@LastDayOfMonth			DATE	  , --Last day of month - Ex. 2017/07/31	
@WeekOfYearNumber		INT           , --Week Number - Ex. 20170707 - 27
@WeekOfYearText			VARCHAR (10)  , --Week Text	  - Ex. Semana 27
@WeekOfHalfYearNumber	INT           , --Week Of Half Year Number - Ex. 20170707 - 1
@WeekOfHalfYearText		VARCHAR (10)  , --Week Of Half Year Text - Ex. Semana 1
@WeekOf4MPYearNumber	INT           , --Week Of 4 month period of Year Number - Ex. 20170707 - 10
@WeekOf4MPYearText		VARCHAR (10)  , --Week Of 4 month period of Year Text - Ex. Semana 10
@WeekOf3MPYearNumber	INT           , --Week Of 3 month period of Year Number - Ex. 20170707 - 1
@WeekOf3MPYearText		VARCHAR (10)  , --Week Of 3 month period of Year Text - Ex. Semana 1
@WeekOf2MPYearNumber	INT           , --Week Of 2 month period of Year Number - Ex. 20170707 - 6
@WeekOf2MPYearText		VARCHAR (10)  , --Week Of 2 month period of Year Text - Ex. Semana 6
@WeekOfMonthNumber		INT           , --Week of month Number - Ex. 20170707 - 1
@WeekOfMonthText		VARCHAR (10)  , --Week of month Text - Ex. 20170707 - Semana 1
@WeeksInYearQTY			INT           , --Quantity of weeks in year - Ex. 53
@WeeksInHalfYearQTY		INT           , --Quantity of weeks in the current half year - Ex. 20170707 - 27
@WeeksIn4MPYearQTY		INT           , --Quantity of weeks in the current 4 month period of year - Ex. 20170707 - 18
@WeeksIn3MPQTY			INT           , --Quantity of weeks in the current 3 month period of year - Ex. 20170707 - 14
@WeeksIn2MPQTY			INT           , --Quantity of weeks in the current 2 month period of year - Ex. 20170707 - 9
@WeeksInMonthQTY		INT           , --Quantity of weeks in the current month  - Ex. 20170707 - 5
@DayOfYearNumber		INT           , --Number of days since the begin of year - Ex. 20170707 - 188
@DayOfHalfYearNumber	INT           , --Number of days since the begin of the current half year period - Ex. 20170707 - 37
@DayOf4MPNumber			INT           , --Number of days since the begin of the current 4 month period - Ex. 20170707 - 68
@DayOf3MPNumber			INT           , --Number of days since the begin of the current 3 month period - Ex. 20170707 - 7
@DayOf2MPNumber			INT           , --Number of days since the begin of the current 2 month period - Ex. 20170707 - 7
@DayOfMonthNumber		INT           , --Number of days since the begin of the current month period - Ex. 20170707 - 7
@DayOfWeekNumber		INT           , --Day of current week (1 - monday ... 7 - sunday) - Ex. 20170707 - 5
@DayOfWeekText			VARCHAR (20)  , --Week Day Full Text - Ex. segunda-feira, terça-feira, quarta-feira, quinta-feira, sexta-feira, sabado, domingo
@DayOfWeekShortText		VARCHAR (10)  , --Week Day Short Text - Ex. segunda, terça, quarta, quinta, sexta, sabado, domingo
@DayOfWeekShort2Text	CHAR (3)	  , --Week Day Short 2 Text - Ex. seg, ter, qua, qui, sex, sab, dom 
@DaysInYearQTY			INT           , --Quantity of days in the current year - Ex. 365
@DaysInHalfYearQTY		INT           , --Quantity of days in the current half year - Ex. 20170707 - 184
@DaysIn4MPYearQTY		INT           , --Quantity of days in the current 4MP year - Ex. 20170707 - 123
@DaysIn3MPYearQTY		INT           , --Quantity of days in the current 3MP year - Ex. 20170707 - 92
@DaysIn2MPYearQTY		INT           , --Quantity of days in the current 2MP year - Ex. 20170707 - 61
@DaysInMonthQTY			INT           , --Quantity of days in the current month - Ex. 20170707 - 31
@DayIsWeekendText		VARCHAR	(20)  , --If is weekend "é fim de semana" else "não é fim de semana"
@DayIsWeekendBoolean	INT			  , --If is weekend "1" else "0"
@DayIsHolidayText		VARCHAR	(20)  , --If is holiday "é feriado" else "não é feriado"
@DayIsHolidayBoolean	INT			   --If is holiday "1" else "0"



--Temporary Variables To Hold the Values During Processing of Each Date of Year
DECLARE
@MinDateTable DATE,
@MaxDateTable DATE


/*Table Data type to store the months*/
DECLARE @MonthTable TABLE (MonthNumber int, Month## char(2), MonthName VARCHAR(10), MonthShortName VARCHAR(3), 
							_2MPNumber char(2), _2MPText CHAR(2), _2MPS char(2), _2MPE char(2), 
							_3MPNumber char(2), _3MPText CHAR(2), _3MPS char(2), _3MPE char(2),  
							_4MPNumber char(2), _4MPText CHAR(2), _4MPS char(2), _4MPE char(2),  
							_6MPNumber char(2), _6MPText CHAR(2), _6MPS char(2), _6MPE char(2) )

INSERT INTO @MonthTable VALUES (1,	'01', 'Janeiro',	'Jan', '1', 'B1', '01',	'02', '01', 'T1', '01', '03', '01', 'Q1', '01', '04', '01', 'S1', '01', '06')
INSERT INTO @MonthTable VALUES (2,	'02', 'Fevereiro',	'Fev', '1', 'B1', '01',	'02', '01', 'T1', '01', '03', '01', 'Q1', '01', '04', '01', 'S1', '01', '06')
INSERT INTO @MonthTable VALUES (3,	'03', 'Março',		'Mar', '2', 'B2', '03',	'04', '01', 'T1', '01', '03', '01', 'Q1', '01', '04', '01', 'S1', '01', '06')
INSERT INTO @MonthTable VALUES (4,	'04', 'Abril',		'Abr', '2', 'B2', '03',	'04', '02', 'T2', '04', '06', '01', 'Q1', '01', '04', '01', 'S1', '01', '06')
INSERT INTO @MonthTable VALUES (5,	'05', 'Maio',		'Mai', '3', 'B3', '05',	'06', '02', 'T2', '04', '06', '02', 'Q2', '05', '08', '01', 'S1', '01', '06')
INSERT INTO @MonthTable VALUES (6,	'06', 'Junho',		'Jun', '3', 'B3', '05',	'06', '02', 'T2', '04', '06', '02', 'Q2', '05', '08', '01', 'S1', '01', '06')
INSERT INTO @MonthTable VALUES (7,	'07', 'Julho',		'Jul', '4', 'B4', '07',	'08', '03', 'T3', '07', '09', '02', 'Q2', '05', '08', '02', 'S2', '07', '12')
INSERT INTO @MonthTable VALUES (8,	'08', 'Agosto',		'Ago', '4', 'B4', '07',	'08', '03', 'T3', '07', '09', '02', 'Q2', '05', '08', '02', 'S2', '07', '12')
INSERT INTO @MonthTable VALUES (9,	'09', 'Setembro',	'Set', '5', 'B5', '09',	'10', '03', 'T3', '07', '09', '03', 'Q3', '09', '12', '02', 'S2', '07', '12')
INSERT INTO @MonthTable VALUES (10, '10', 'Outubro',	'Out', '5', 'B5', '09',	'10', '04', 'T4', '10', '12', '03', 'Q3', '09', '12', '02', 'S2', '07', '12')
INSERT INTO @MonthTable VALUES (11, '11', 'Novembro',	'Nov', '6', 'B6', '11', '12', '04', 'T4', '10', '12', '03', 'Q3', '09', '12', '02', 'S2', '07', '12')
INSERT INTO @MonthTable VALUES (12, '12', 'Dezembro',	'Dez', '6', 'B6', '11', '12', '04', 'T4', '10', '12', '03', 'Q3', '09', '12', '02', 'S2', '07', '12')

SET @Date=@StartDate
SET @MinDateTable = ISNULL((SELECT min(Date) from dm_Date),(CONVERT(DATE,'1900-01-01')))
SET @MaxDateTable = ISNULL((SELECT max(Date) from dm_Date),(CONVERT(DATE,'1900-01-01')))

WHILE @Date <= @EndDate
	BEGIN
	IF @Date >= @MinDateTable AND @Date <= @MaxDateTable 
		BEGIN
			GOTO fim
		END
	SET @YearNumber = DATEPART(YYYY, @Date)
    SET @MonthNumber = DATEPART(m,@Date)

	SET @DayOfMonthNumber = DATEPART(d, @Date)
	SET @Date_pk = CONVERT(CHAR(4),@YearNumber) + RIGHT('00' + CONVERT(VARCHAR(2),@MonthNumber),2) + RIGHT('00' + CONVERT(VARCHAR(2),@DayOfMonthNumber),2)
	SET @FirstDayOfMonth = DATEFROMPARTS(@YearNumber,@MonthNumber,'01')
	SET @LastDayOfMonth = EOMONTH(@Date)

	SET @WeekOfYearNumber = DATEPART(WW, @Date)
	SET @WeekOfYearText = 'Semana ' + convert(varchar(2), @WeekOfYearNumber)
	SET @WeekOfHalfYearNumber = 1 + DATEDIFF(ww, DATEFROMPARTS(@YearNumber,(SELECT _6MPS FROM @MonthTable WHERE MonthNumber=@MonthNumber),1), @Date)
	SET @WeekOfHalfYearText = 'Semana ' + convert(varchar(2),@WeekOfHalfYearNumber)
	SET @WeekOf4MPYearNumber = 1 + DATEDIFF(ww, CONVERT(DATE, @YearNumber + '-' + (SELECT _4MPS FROM @MonthTable WHERE MonthNumber=@MonthNumber) + '-01'), @Date)
	SET @WeekOf4MPYearText = 'Semana ' + convert(varchar(2), @WeekOf4MPYearNumber)
	SET @WeekOf3MPYearNumber = 1 + DATEDIFF(ww, CONVERT(DATE, @YearNumber + '-' + (SELECT _3MPS FROM @MonthTable WHERE MonthNumber=@MonthNumber) + '-01'), @Date)
	SET @WeekOf3MPYearText = 'Semana ' + convert(varchar(2), @WeekOf3MPYearNumber)
	SET @WeekOf2MPYearNumber = 1 + DATEDIFF(ww, CONVERT(DATE, @YearNumber + '-' + (SELECT _2MPS FROM @MonthTable WHERE MonthNumber=@MonthNumber) + '-01'), @Date)
	SET @WeekOf2MPYearText = 'Semana ' + convert(varchar(2), @WeekOf2MPYearNumber)
	SET @WeekOfMonthNumber = 1 + DATEDIFF(ww, CONVERT(DATE, @YearNumber + '-' + @MonthNumber + '-01'), @Date)
	SET @WeekOfMonthText = 'Semana ' + convert(varchar(2), @WeekOfMonthNumber)
	SET @WeeksInYearQTY = 1 + DATEDIFF(ww, CONVERT(DATE, @YearNumber + '-01-01'), CONVERT(DATE, @YearNumber + '-12-31'))
	SET @WeeksInHalfYearQTY = 1 + DATEDIFF(ww, CONVERT(DATE, @YearNumber + '-' + (SELECT _6MPS FROM @MonthTable WHERE MonthNumber=@MonthNumber) + '-01'), EOMONTH(CONVERT(DATE, @YearNumber + '-' + (SELECT _6MPE FROM @MonthTable WHERE MonthNumber=@MonthNumber) + '-01')))
	SET @WeeksIn4MPYearQTY = 1 + DATEDIFF(ww, CONVERT(DATE, @YearNumber + '-' + (SELECT _4MPS FROM @MonthTable WHERE MonthNumber=@MonthNumber) + '-01'), EOMONTH(CONVERT(DATE, @YearNumber + '-' + (SELECT _4MPE FROM @MonthTable WHERE MonthNumber=@MonthNumber) + '-01')))
	SET @WeeksIn3MPQTY = 1 + DATEDIFF(ww, CONVERT(DATE, @YearNumber + '-' + (SELECT _3MPS FROM @MonthTable WHERE MonthNumber=@MonthNumber) + '-01'), EOMONTH(CONVERT(DATE, @YearNumber + '-' + (SELECT _3MPE FROM @MonthTable WHERE MonthNumber=@MonthNumber) + '-01')))
	SET @WeeksIn2MPQTY = 1 + DATEDIFF(ww, CONVERT(DATE, @YearNumber + '-' + (SELECT _2MPS FROM @MonthTable WHERE MonthNumber=@MonthNumber) + '-01'), EOMONTH(CONVERT(DATE, @YearNumber + '-' + (SELECT _2MPE FROM @MonthTable WHERE MonthNumber=@MonthNumber) + '-01')))
	SET @WeeksInMonthQTY = 1 + DATEDIFF(ww, CONVERT(DATE, @YearNumber + '-' + @MonthNumber + '-01'), EOMONTH(CONVERT(DATE, @YearNumber + '-' + @MonthNumber + '-01')))
	SET @DayOfYearNumber = DATEPART(y, @Date)
	SET @DayOfHalfYearNumber = 1 + DATEDIFF(D, CONVERT(DATE, @YearNumber + '-' + (SELECT _6MPS FROM @MonthTable WHERE MonthNumber=@MonthNumber) + '-01'), @Date)
	SET @DayOf4MPNumber = 1 + DATEDIFF(D, CONVERT(DATE, @YearNumber + '-' + (SELECT _4MPS FROM @MonthTable WHERE MonthNumber=@MonthNumber) + '-01'), @Date)
	SET @DayOf3MPNumber = 1 + DATEDIFF(D, CONVERT(DATE, @YearNumber + '-' + (SELECT _3MPS FROM @MonthTable WHERE MonthNumber=@MonthNumber) + '-01'), @Date)
	SET @DayOf2MPNumber = 1 + DATEDIFF(D, CONVERT(DATE, @YearNumber + '-' + (SELECT _2MPS FROM @MonthTable WHERE MonthNumber=@MonthNumber) + '-01'), @Date)
	SET @DayOfMonthNumber = DAY(@Date)
	SET @DayOfWeekNumber = DATEPART(DW,@Date)
	SET @DayOfWeekText = CASE WHEN @DayOfWeekNumber=1 THEN 'Domingo'
							WHEN @DayOfWeekNumber=2 THEN 'Segunda-Feira'
							WHEN @DayOfWeekNumber=3 THEN 'Terça-Feira'
							WHEN @DayOfWeekNumber=4 THEN 'Quarta-Feira'
							WHEN @DayOfWeekNumber=5 THEN 'Quinta-Feira'
							WHEN @DayOfWeekNumber=6 THEN 'Sexta-Feira'
							WHEN @DayOfWeekNumber=7 THEN 'Sábado' END
	SET @DayOfWeekShortText = CASE WHEN @DayOfWeekNumber=1 THEN 'Domingo'
							WHEN @DayOfWeekNumber=2 THEN 'Segunda'
							WHEN @DayOfWeekNumber=3 THEN 'Terça'
							WHEN @DayOfWeekNumber=4 THEN 'Quarta'
							WHEN @DayOfWeekNumber=5 THEN 'Quinta'
							WHEN @DayOfWeekNumber=6 THEN 'Sexta'
							WHEN @DayOfWeekNumber=7 THEN 'Sábado' END
	SET @DayOfWeekShort2Text = CASE WHEN @DayOfWeekNumber=1 THEN 'Dom'
							WHEN @DayOfWeekNumber=2 THEN 'Seg'
							WHEN @DayOfWeekNumber=3 THEN 'Ter'
							WHEN @DayOfWeekNumber=4 THEN 'Qua'
							WHEN @DayOfWeekNumber=5 THEN 'Qui'
							WHEN @DayOfWeekNumber=6 THEN 'Sex'
							WHEN @DayOfWeekNumber=7 THEN 'Sab' END
	SET @DaysInYearQTY = DATEPART(y, @YearNumber + '-12-31')
	SET @DaysInHalfYearQTY = 1 + DATEDIFF(D, CONVERT(DATE, @YearNumber + '-' + (SELECT _6MPS FROM @MonthTable WHERE MonthNumber=@MonthNumber) + '-01'), EOMONTH(CONVERT(DATE, @YearNumber + '-' + (SELECT _6MPE FROM @MonthTable WHERE MonthNumber=@MonthNumber) + '-01')))
	SET @DaysIn4MPYearQTY = 1 + DATEDIFF(D, CONVERT(DATE, @YearNumber + '-' + (SELECT _4MPS FROM @MonthTable WHERE MonthNumber=@MonthNumber) + '-01'), EOMONTH(CONVERT(DATE, @YearNumber + '-' + (SELECT _4MPE FROM @MonthTable WHERE MonthNumber=@MonthNumber) + '-01')))
	SET @DaysIn3MPYearQTY = 1 + DATEDIFF(D, CONVERT(DATE, @YearNumber + '-' + (SELECT _3MPS FROM @MonthTable WHERE MonthNumber=@MonthNumber) + '-01'), EOMONTH(CONVERT(DATE, @YearNumber + '-' + (SELECT _3MPE FROM @MonthTable WHERE MonthNumber=@MonthNumber) + '-01')))
	SET @DaysIn2MPYearQTY = 1 + DATEDIFF(D, CONVERT(DATE, @YearNumber + '-' + (SELECT _2MPS FROM @MonthTable WHERE MonthNumber=@MonthNumber) + '-01'), EOMONTH(CONVERT(DATE, @YearNumber + '-' + (SELECT _2MPE FROM @MonthTable WHERE MonthNumber=@MonthNumber) + '-01')))
	SET @DaysInMonthQTY = DAY(EOMONTH(CONVERT(DATE, @YearNumber + '-' + @MonthNumber + '-01')))
	SET @DayIsWeekendText = CASE WHEN @DayOfWeekNumber = 1 OR @DayOfWeekNumber=7 THEN 'é fm de semana'
							ELSE 'não é fim de semana' END
	SET @DayIsWeekendBoolean = CASE WHEN @DayOfWeekNumber = 1 OR @DayOfWeekNumber=7 THEN 1
							ELSE 0 END
	SET @DayIsHolidayText = 'não é feriado'
	SET @DayIsHolidayBoolean = 0


	SET @MonthText = (SELECT MonthName FROM @MonthTable WHERE MonthNumber=@MonthNumber)
	SET @MonthShortText = (SELECT MonthShortName FROM @MonthTable WHERE MonthNumber=@MonthNumber)

	SET @HalfOfYearNumber = (SELECT _6MPNumber FROM @MonthTable WHERE MonthNumber=@MonthNumber)
	SET @HalfOfYearText = (SELECT _6MPText FROM @MonthTable WHERE MonthNumber=@MonthNumber)
	SET @4MPOfYearNumber = (SELECT _4MPNumber FROM @MonthTable WHERE MonthNumber=@MonthNumber)
	SET @4MPOfYearText = (SELECT _4MPText FROM @MonthTable WHERE MonthNumber=@MonthNumber)
	SET @3MPOfYearNumber = (SELECT _3MPNumber FROM @MonthTable WHERE MonthNumber=@MonthNumber)
	SET @3MPOfYearText = (SELECT _3MPText FROM @MonthTable WHERE MonthNumber=@MonthNumber)
	SET @2MPOfYearNumber = (SELECT _2MPNumber FROM @MonthTable WHERE MonthNumber=@MonthNumber)
	SET @2MPOfYearText = (SELECT _2MPText FROM @MonthTable WHERE MonthNumber=@MonthNumber)
	SET @Year3MPText = CONVERT(CHAR(4), @YearNumber) + @3MPOfYearText
	SET @DateInFullText = CONVERT(VARCHAR(2), @DayOfMonthNumber) + ' de ' + (SELECT MonthName FROM @MonthTable WHERE MonthNumber=@MonthNumber) + ' de ' + CONVERT(VARCHAR(4), @YearNumber)
	

	--INSERT
INSERT into [dbo].[dm_Date]
           ([Date_pk]
           ,[Date]
           ,[DateInFullText]
           ,[YearNumber]
           ,[Year3MPText]
           ,[HalfOfYearNumber]
           ,[HalfOfYearText]
           ,[4MPOfYearNumber]
           ,[4MPOfYearText]
           ,[3MPOfYearNumber]
           ,[3MPOfYearText]
           ,[2MPOfYearNumber]
           ,[2MPOfYearText]
           ,[MonthNumber]
           ,[MonthText]
           ,[MonthShortText]
           ,[FirstDayOfMonth]
           ,[LastDayOfMonth]
           ,[WeekOfYearNumber]
           ,[WeekOfYearText]
           ,[WeekOfHalfYearNumber]
           ,[WeekOfHalfYearText]
           ,[WeekOf4MPYearNumber]
           ,[WeekOf4MPYearText]
           ,[WeekOf3MPYearNumber]
           ,[WeekOf3MPYearText]
           ,[WeekOf2MPYearNumber]
           ,[WeekOf2MPYearText]
           ,[WeekOfMonthNumber]
           ,[WeekOfMonthText]
           ,[WeeksInYearQTY]
           ,[WeeksInHalfYearQTY]
           ,[WeeksIn4MPYearQTY]
           ,[WeeksIn3MPQTY]
           ,[WeeksIn2MPQTY]
           ,[WeeksInMonthQTY]
           ,[DayOfYearNumber]
           ,[DayOfHalfYearNumber]
           ,[DayOf4MPNumber]
           ,[DayOf3MPNumber]
           ,[DayOf2MPNumber]
           ,[DayOfMonthNumber]
           ,[DayOfWeekNumber]
           ,[DayOfWeekText]
           ,[DayOfWeekShortText]
           ,[DayOfWeekShort2Text]
           ,[DaysInYearQTY]
           ,[DaysInHalfYearQTY]
           ,[DaysIn4MPYearQTY]
           ,[DaysIn3MPYearQTY]
           ,[DaysIn2MPYearQTY]
           ,[DaysInMonthQTY]
           ,[DayIsWeekendText]
           ,[DayIsWeekendBoolean]
           ,[DayIsHolidayText]
           ,[DayIsHolidayBoolean])
	VALUES
			(@Date_pk,				--YYYYMMDD
			@Date,
			@DateInFullText,		--Date in Full - Ex. 27 de julho de 2017
			@YearNumber,			--YYYY
			@Year3MPText,			--YYYYQQ - Ex. 2017Q3
			@HalfOfYearNumber,		--Half Year Number - Ex. 20170707 - 2
			@HalfOfYearText,		--Half Year Text - Ex. 2S
			@4MPOfYearNumber,		--4 Month Period Number - Ex. 20170707 - 2
			@4MPOfYearText,			--4 Month Period Text - 2Q
			@3MPOfYearNumber,		--3 Month Period Number - Ex. 20170707 - 3
			@3MPOfYearText,			--3 Month Period Text - Ex. 3T
			@2MPOfYearNumber,		--2 Month Period Number - Ex. 20170707 - 4
			@2MPOfYearText,			--2 Month Period Text - Ex. 4B
			@MonthNumber,			--Month Number - Ex. 20170707 - 7
			@MonthText,				--Month Name - Ex. Janeiro, Fevereiro ...
			@MonthShortText,		--Month Short Name - Ex. Jan, Fev, Mar ...
			@FirstDayOfMonth,		--First day of month - Ex. 2017/07/01	
			@LastDayOfMonth,		--Last day of month - Ex. 2017/07/31	
			@WeekOfYearNumber,		--Week Number - Ex. 20170707 - 27
			@WeekOfYearText,		--Week Text	  - Ex. Semana 27
			@WeekOfHalfYearNumber,	--Week Of Half Year Number - Ex. 20170707 - 1
			@WeekOfHalfYearText,	--Week Of Half Year Text - Ex. Semana 1
			@WeekOf4MPYearNumber,	--Week Of 4 month period of Year Number - Ex. 20170707 - 10
			@WeekOf4MPYearText,		--Week Of 4 month period of Year Text - Ex. Semana 10
			@WeekOf3MPYearNumber,	--Week Of 3 month period of Year Number - Ex. 20170707 - 1
			@WeekOf3MPYearText,		--Week Of 3 month period of Year Text - Ex. Semana 1
			@WeekOf2MPYearNumber,	--Week Of 2 month period of Year Number - Ex. 20170707 - 6
			@WeekOf2MPYearText,		--Week Of 2 month period of Year Text - Ex. Semana 6
			@WeekOfMonthNumber,		--Week of month Number - Ex. 20170707 - 1
			@WeekOfMonthText,		--Week of month Text - Ex. 20170707 - Semana 1
			@WeeksInYearQTY,		--Quantity of weeks in year - Ex. 53
			@WeeksInHalfYearQTY,	--Quantity of weeks in the current half year - Ex. 20170707 - 27
			@WeeksIn4MPYearQTY,		--Quantity of weeks in the current 4 month period of year - Ex. 20170707 - 18
			@WeeksIn3MPQTY,			--Quantity of weeks in the current 3 month period of year - Ex. 20170707 - 14
			@WeeksIn2MPQTY,			--Quantity of weeks in the current 2 month period of year - Ex. 20170707 - 9
			@WeeksInMonthQTY,		--Quantity of weeks in the current month  - Ex. 20170707 - 5
			@DayOfYearNumber,		--Number of days since the begin of year - Ex. 20170707 - 188
			@DayOfHalfYearNumber,	--Number of days since the begin of the current half year period - Ex. 20170707 - 37
			@DayOf4MPNumber,		--Number of days since the begin of the current 4 month period - Ex. 20170707 - 68
			@DayOf3MPNumber,		--Number of days since the begin of the current 3 month period - Ex. 20170707 - 7
			@DayOf2MPNumber,		--Number of days since the begin of the current 2 month period - Ex. 20170707 - 7
			@DayOfMonthNumber,		--Number of days since the begin of the current month period - Ex. 20170707 - 7
			@DayOfWeekNumber,		--Day of current week (1 - monday ... 7 - sunday) - Ex. 20170707 - 5
			@DayOfWeekText,			--Week Day Full Text - Ex. segunda-feira, terça-feira, quarta-feira, quinta-feira, sexta-feira, sabado, domingo
			@DayOfWeekShortText,	--Week Day Short Text - Ex. segunda, terça, quarta, quinta, sexta, sabado, domingo
			@DayOfWeekShort2Text,	--Week Day Short 2 Text - Ex. seg, ter, qua, qui, sex, sab, dom 
			@DaysInYearQTY,			--Quantity of days in the current year - Ex. 365
			@DaysInHalfYearQTY,		--Quantity of days in the current half year - Ex. 20170707 - 184
			@DaysIn4MPYearQTY,		--Quantity of days in the current 4MP year - Ex. 20170707 - 123
			@DaysIn3MPYearQTY,		--Quantity of days in the current 3MP year - Ex. 20170707 - 92
			@DaysIn2MPYearQTY,		--Quantity of days in the current 2MP year - Ex. 20170707 - 61
			@DaysInMonthQTY,		--Quantity of days in the current month - Ex. 20170707 - 31
			@DayIsWeekendText,		--If is weekend "é fim de semana" else "não é fim de semana"
			@DayIsWeekendBoolean,	--If is weekend "1" else "0"
			@DayIsHolidayText,		--If is holiday "é feriado" else "não é feriado"
			@DayIsHolidayBoolean)	--If is holiday "1" else "0"
	fim:
	SET @Date = DATEADD(D,1,@Date)
	END

/********************************************************************************************
 
Step 3.
Update Values of Holiday as per UK Government Declaration for National Holiday.

Update HOLIDAY fields of UK as per Govt. Declaration of National Holiday*/
	
-- Confraternização Universal  1º de janeiro
	UPDATE [dbo].[dm_Date]
		SET DayIsHolidayText = 'é feriado',
		DayIsHolidayBoolean = 1
	WHERE [MonthNumber] = 1 AND [DayOfMonthNumber]  = 1

-- Tiradentes  21 de abril
	UPDATE [dbo].[dm_Date]
		SET DayIsHolidayText = 'é feriado',
		DayIsHolidayBoolean = 1
	WHERE [MonthNumber] = 4 AND [DayOfMonthNumber]  = 21

-- Dia do Trabalhador  1º de maio
	UPDATE [dbo].[dm_Date]
		SET DayIsHolidayText = 'é feriado',
		DayIsHolidayBoolean = 1
	WHERE [MonthNumber] = 5 AND [DayOfMonthNumber]  = 1

-- Dia da Pátria  7 de setembro
	UPDATE [dbo].[dm_Date]
		SET DayIsHolidayText = 'é feriado',
		DayIsHolidayBoolean = 1
	WHERE [MonthNumber] = 9 AND [DayOfMonthNumber]  = 7

-- Nossa Senhora Aparecida 12 de outubro
	UPDATE [dbo].[dm_Date]
		SET DayIsHolidayText = 'é feriado',
		DayIsHolidayBoolean = 1
	WHERE [MonthNumber] = 10 AND [DayOfMonthNumber]  = 12

-- Finados 2 de novembro
	UPDATE [dbo].[dm_Date]
		SET DayIsHolidayText = 'é feriado',
		DayIsHolidayBoolean = 1
	WHERE [MonthNumber] = 11 AND [DayOfMonthNumber]  = 2

-- Proclamação da República 15 de novembro
	UPDATE [dbo].[dm_Date]
		SET DayIsHolidayText = 'é feriado',
		DayIsHolidayBoolean = 1
	WHERE [MonthNumber] = 11 AND [DayOfMonthNumber]  = 15

-- Natal 25 de dezembro
	UPDATE [dbo].[dm_Date]
		SET DayIsHolidayText = 'é feriado',
		DayIsHolidayBoolean = 1
	WHERE [MonthNumber] = 12 AND [DayOfMonthNumber]  = 25


RETURN 0
