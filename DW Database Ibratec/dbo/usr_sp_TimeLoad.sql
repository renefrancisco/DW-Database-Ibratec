CREATE PROCEDURE [dbo].[usr_sp_TimeLoad]
AS
DECLARE	@Time_sk		INT			 ,
    @Time_pk			INT			 , -- Ex. 15:03:37 - 150337
	@Time				TIME(0)		 , -- 15:05:37
    @Hour24Number		INT          , -- 15
    @Hour12Number		INT          , -- 03
    @MinuteNumber		INT          , -- 03
    @SecondNumber		INT          , -- 37
    @ClockPeriodText	VARCHAR (2)  , -- pm
    @HMS24Text			VARCHAR (8)  , -- 15:03:37
    @HM24Text			VARCHAR (5)  , -- 15:03
    @HMS12Text			VARCHAR (11) , -- 03:03:37
	@HM12Text			VARCHAR (8)	 , -- 03:03
    @DayPeriodText		VARCHAR (15) -- Ex. Manhã, Tarde, Noite, Madrugada

DECLARE @HOUR INT=0, @MINUTE INT=0, @SECOND INT=0

WHILE @HOUR <24
	BEGIN
		WHILE @MINUTE <60
			BEGIN
				WHILE @SECOND <60
					BEGIN
						SET @Time_pk = RIGHT('00' + CONVERT(VARCHAR(2), @HOUR),2) + RIGHT('00' + CONVERT(VARCHAR(2), @MINUTE),2) + RIGHT('00' + CONVERT(VARCHAR(2), @SECOND),2)
						SET @Time = TIMEFROMPARTS(@HOUR, @MINUTE, @SECOND, 0, 0)
						SET @Hour24Number = DATEPART(HOUR,@Time)
						SET @Hour12Number = DATEPART(HOUR,@Time)
						SET @MinuteNumber = DATEPART(MINUTE,@Time)
						SET @SecondNumber = DATEPART(SECOND,@Time)
						SET @ClockPeriodText = RIGHT(RTRIM(CONVERT(VARCHAR(10), @Time, 109)), 2)
						SET @HMS24Text = CONVERT(VARCHAR(8), @Time, 108)
						SET @HM24Text = CONVERT(VARCHAR(5), @Time, 108)
						SET @HMS12Text = RTRIM(CONVERT(VARCHAR(10), @Time, 109))
						SET @HM12Text = LTRIM(RIGHT(CONVERT(VARCHAR(20), @Time, 100), 7))
						SET @DayPeriodText = CASE WHEN @Hour24Number >=0 AND @Hour24Number <6 THEN 'Madrugada'
												WHEN @Hour24Number >=6 AND @Hour24Number <12 THEN 'Manhã'
												WHEN @Hour24Number >=12 AND @Hour24Number <18 THEN 'Tarde'
												WHEN @Hour24Number >=18 AND @Hour24Number <24 THEN 'Noite' END

						INSERT INTO [dbo].[dm_Time] 
									(
									[Time_pk],
									[Time],
									[Hour24Number],
									[Hour12Number],
									[MinuteNumber],
									[SecondNumber],
									[ClockPeriodText],
									[H:M:S24Text],
									[H:M24Text],
									[H:M:S12Text],
									[H:M12Text],
									[DayPeriodText]
									)
								VALUES
									(
									@Time_pk,
									@Time,
									@Hour24Number,
									@Hour12Number,
									@MinuteNumber,
									@SecondNumber,
									@ClockPeriodText,
									@HMS24Text,
									@HM24Text,
									@HMS12Text,
									@HM12Text,
									@DayPeriodText
									)

						SET @SECOND +=1
					END
				SET @SECOND = 0
				SET @MINUTE +=1
			END
		SET @MINUTE = 0
		SET @HOUR += 1
	END
 
RETURN 0
