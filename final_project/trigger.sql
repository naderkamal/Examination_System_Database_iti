-------------------manager only can insert and update on branch,intaka,track,student------------------------
create or alter trigger branch_by_manager
on [dbo].[branch]
after insert, update
as 
	if(SYSTEM_USER != 'Manager')
	begin
		rollback;
		RAISERROR('Only managers are allowed to add or edit branches.', 16, 1);
	end
	else
    begin
        print('Operation allowed for manager')
    end

create or alter trigger intaka_by_manager
on [dbo].[intaka]
after insert, update
as 
	if(SYSTEM_USER != 'Manager')
	begin
		rollback;
		RAISERROR('Only managers are allowed to add or edit intaka.', 16, 1);
	end
	else
    begin
        print('Operation allowed for manager')
    end

create or alter trigger track_by_manager
on [dbo].[track]
after insert, update
as 
	if(SYSTEM_USER != 'Manager')
	begin
		rollback;
		RAISERROR('Only managers are allowed to add or edit track.', 16, 1);
	end
	else
    begin
        print('Operation allowed for manager')
    end

create or alter trigger student_by_manager
on [dbo].[student]
after insert, update
as 
	if(SYSTEM_USER != 'Manager')
	begin
		rollback;
		RAISERROR('Only managers are allowed to add or edit track.', 16, 1);
	end
	else
    begin
        print('Operation allowed for manager')
    end

----------------------Prevents the student from taking an exam except at the specified time-----------------
create or alter TRIGGER ExaminsertTrigger
ON exam_question
instead of insert
AS
BEGIN
    DECLARE @StartTime TIME;
    DECLARE @EndTime TIME;
	DECLARE @ExamYear DATE;

    -- Retrieve start_time and end_time from the Exam table
    SELECT @StartTime = start_time, @EndTime = end_time ,@ExamYear = [year]
    FROM Exam
    WHERE exam_id IN (SELECT exam_id FROM INSERTED);

    -- Check if the current time is between start_time and end_time
    IF @StartTime IS NOT NULL AND @EndTime IS NOT NULL AND  CAST(GETDATE() AS TIME) BETWEEN @StartTime  AND @EndTime
			AND YEAR(GETDATE()) = YEAR(@ExamYear)
    BEGIN
        -- insert the data
        INSERT INTO [dbo].[exam_question] ([exam_id],[question_id])
        SELECT [exam_id] ,[question_id] FROM INSERTED;
        PRINT 'Insertion allowed within the specified time range and year.';
    END
    ELSE
    BEGIN
        -- Print a message if the condition is not met
        PRINT 'The selected exam is not currently available.';
		rollback;
    END
END;

insert into exam_question
values(1001,1)