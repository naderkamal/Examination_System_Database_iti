-----------------------------generate question exam random------------------------------------------
CREATE OR ALTER PROCEDURE Random_question
    @ins_id INT,
    @course_id INT,
    @num_MCQ INT,
    @num_TF INT,
    @num_Tq INT,
    @exam_id INT
AS
BEGIN TRY
    DECLARE @question_id INT;
    DECLARE @question_type NVARCHAR(50);
    DECLARE @cursor CURSOR;

    -- Create a cursor to iterate through question types
    SET @cursor = CURSOR FOR
        SELECT DISTINCT [type]
        FROM [dbo].[question]
        WHERE [course_id] = @course_id
              AND [instructor_id] = @ins_id;

    OPEN @cursor;
    FETCH NEXT FROM @cursor INTO @question_type;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @counter INT;
        SET @counter = 1;

        -- Use a loop to insert the required number of questions for each type
        WHILE @counter <= 
            CASE
                WHEN @question_type = 'CHOICE' THEN @num_MCQ
                WHEN @question_type = 'TRUE&FALSE' THEN @num_TF
                WHEN @question_type = 'TEXTQuESTION' THEN @num_Tq
                ELSE 0
            END
        BEGIN
            SET @question_id = (SELECT TOP 1 [question_id]
                                FROM [dbo].[question]
                                WHERE [type] = @question_type
                                      AND [course_id] = @course_id
                                      AND [instructor_id] = @ins_id
                                      AND [question_id] NOT IN (SELECT question_id FROM [dbo].[exam_question] WHERE exam_id = @exam_id)
                                );

            IF @question_id IS NOT NULL
            BEGIN
                INSERT INTO [dbo].[exam_question] (exam_id, question_id)
                VALUES (@exam_id, @question_id);
            END

            SET @counter = @counter + 1;
        END

        FETCH NEXT FROM @cursor INTO @question_type;
    END

    CLOSE @cursor;
    DEALLOCATE @cursor;
END TRY
BEGIN CATCH
    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH;

execute Random_question 1,1,2,3,1,1009;

-----------------------------add question for specific exam------------------------------------------
create or alter procedure pickQuestion_proc
	@exam_id int,
	@question_id int,
	@course_id int ,
	@inst_id int
AS
begin try
	if EXISTS (select question from [dbo].[question]
		where (course_id=@course_id) And   (instructor_id=@inst_id))

	begin 
		insert into [dbo].[exam_question]
		(exam_id,question_id)
		values(@exam_id,@question_id)
	end
	else
	begin
		select 'This question Not Found ';
	end
end try
begin catch
SELECT   
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_MESSAGE() AS ErrorMessage; 	
end catch

execute pickQuestion_proc 1003,5,1,1;

-----------------------------add question for pool question------------------------------------------
create or alter procedure add_question_proc
	@ques_id int,
	@degree_ques int ,
	@type nvarchar(20),
	@question nvarchar(max),
	@answer nvarchar(max),
	@correct_answer nvarchar(max),
	@course_id int,
	@instructor_id int
As
begin try 
	if(@degree_ques) > 0 and
	(@type ='TRUE&FALSE' or @type='CHOICE' or @type='TEXTQuESTION')
	and (@answer LIKE '%' + @correct_answer + '%' )

	begin
	insert into [dbo].[question](question_id,degree,type,Question,answer,correct_answer,
	course_id,instructor_id)
	values (@ques_id,@degree_ques,@type,@question,@answer,@correct_answer,
	@course_id,@instructor_id);
	end 
	else
	begin 
		select 'Ensure data that correct';
	end
end try
begin catch 
SELECT   
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_MESSAGE() AS ErrorMessage;  
		
end catch

execute add_question_proc 11,5,'CHOICE','how to make for loop','a-A,b-B,c-C,d-D','b-B',1,1;

-----------------------------generate exam by instructor------------------------------------------
create or alter procedure modelexam_proc
	@exam_id int,
	@degree int,
	@type nvarchar(20),
	@st_time time ,
	@end_time time,
	@ins_id int ,
	@year date ,
	@course_id int
AS
begin try 
	if(@degree)  > 0 and 
	(@type='FirstTime' or @type='corrective') and 
	 cast(@end_time as time) >cast( @st_time as time) 
	begin
		insert into [dbo].[exam] (exam_id,degree, [type] ,start_time,end_time,instructor_id,[year],course_id)
		values(@exam_id,@degree ,@type,@st_time,@end_time,@ins_id,@year,@course_id);
	end
	else
	begin
		select 'Can Not make exam model Beacause your data Error';
	end
end try
begin catch
  SELECT   
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_MESSAGE() AS ErrorMessage;  	
end catch 

execute modelexam_proc 1013,50,'FirstTime','10:00','12:00',1 ,'2024',1;

-----------------------------delete question from pool question and exam question---------------------------------
create or alter procedure delete_question
	@question_id int 
as
begin try
	delete from  [dbo].[exam_question]
	where [question_id]=@question_id;

	delete from  [dbo].[question]
	where [question_id]=@question_id;
end try
begin catch
  SELECT   
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_MESSAGE() AS ErrorMessage; 
end catch

execute delete_question 11

-----------------------------delete exam from exam and exam question---------------------------------
create or alter procedure delete_exam_proc
	@exam_id int 
AS
begin try
	delete from [dbo].[exam_question]
	where exam_id=@exam_id;

	delete from [dbo].[exam]
	where exam_id=@exam_id;
end try
begin catch
  SELECT   
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_MESSAGE() AS ErrorMessage; 
end catch

execute delete_exam_proc 1013;

-----------------------------correct the exam question------------------------------------------

CREATE OR ALTER PROC correct_exam @S_ID INT, @Exam_ID INT
AS
BEGIN TRY
    IF NOT EXISTS (SELECT 1 FROM [dbo].[student] WHERE [student_id] = @S_ID)
    BEGIN
        SELECT 'The student does not exist' AS 'ErrMessage'
    END
    ELSE IF NOT EXISTS (SELECT 1 FROM [dbo].[exam] WHERE [exam_id] = @Exam_ID)
    BEGIN
        SELECT 'The exam does not exist' AS 'ErrMessage'
    END
    ELSE
    BEGIN
        DECLARE @Question_ID INT;
        DECLARE @Degree INT;
        DECLARE @Correct_Answer NVARCHAR(MAX);
        DECLARE @Student_Answer NVARCHAR(MAX);
        DECLARE @Question_Type NVARCHAR(20);

        -- Cursor to fetch questions in the exam
        DECLARE exam_cursor CURSOR FOR
        SELECT EQ.[question_id], Q.[correct_answer], Q.[degree], Q.[type]
        FROM [dbo].[exam_question] AS EQ
        JOIN [dbo].[question] AS Q ON EQ.[question_id] = Q.[question_id]
        WHERE EQ.[exam_id] = @Exam_ID;

        OPEN exam_cursor;

        FETCH NEXT FROM exam_cursor INTO @Question_ID, @Correct_Answer, @Degree, @Question_Type;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Fetch the student's answer for each question
            SET @Student_Answer = (
                SELECT [student_answer]
                FROM [dbo].[student_exam]
                WHERE [student_id] = @S_ID AND [question_id] = @Question_ID
            );

            -- Compare the student's answer with the correct answer based on question type
            IF @Question_Type = 'TRUE&FALSE' OR @Question_Type = 'CHOICE'
            BEGIN
                IF @Correct_Answer = @Student_Answer
                    SET @Degree = @Degree;
                ELSE
                    SET @Degree = 0;
            END
            ELSE IF @Question_Type = 'TEXTQUESTION'
            BEGIN
                -- Split the correct answer and student answer into separate values
                DECLARE @Correct_Answers TABLE (Answer NVARCHAR(MAX));
                DECLARE @Student_Answers TABLE (Answer NVARCHAR(MAX));

                INSERT INTO @Correct_Answers (Answer)
                SELECT value
                FROM STRING_SPLIT(@Correct_Answer, ',');

                INSERT INTO @Student_Answers (Answer)
                SELECT value
                FROM STRING_SPLIT(@Student_Answer, ',');

                -- Check for matching answers
                IF EXISTS (SELECT 1 FROM @Student_Answers WHERE Answer IN (SELECT Answer FROM @Correct_Answers))
                    SET @Degree = @Degree;
                ELSE
                    SET @Degree = 0;
            END

            -- Update the degree in the student_exam table
            UPDATE [dbo].[student_exam]
            SET [degree] = @Degree
            WHERE [student_id] = @S_ID AND [question_id] = @Question_ID;

            FETCH NEXT FROM exam_cursor INTO @Question_ID, @Correct_Answer, @Degree, @Question_Type;
        END;

        CLOSE exam_cursor;
        DEALLOCATE exam_cursor;
    END
END TRY
BEGIN CATCH
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH;

exec correct_exam @S_ID =1, @Exam_ID =1001

-----------------------------total grade of the exam and show pass or not ------------------------------------------

CREATE OR ALTER PROCEDURE Studentgrade
    @Std_ID INT,
    @Ex_No INT
AS
BEGIN TRY
	IF NOT EXISTS (SELECT 1 FROM Exam WHERE [exam_id] = @Ex_No)
	    BEGIN
            SELECT 'The exam does not exist' AS 'ErrMessage'
        END
    ELSE IF NOT EXISTS (SELECT 1 FROM Student WHERE [student_id] = @Std_ID)
	    BEGIN
            SELECT 'The student does not exist' AS 'ErrMessage'
        END
    ELSE
        BEGIN
            -- Calculate the total number of correct answers
            DECLARE @TotalCorrectAnswers INT;
			DECLARE @failorpass nvarchar(50);
            SELECT @TotalCorrectAnswers = SUM([degree])
            FROM [dbo].[student_exam] a inner join [dbo].[exam_question] b on a.question_id=b.question_id
            WHERE [exam_id] = @Ex_No AND [student_id] = @Std_ID;

			if @TotalCorrectAnswers >= (select a.[degree_main] from [dbo].[course] a inner join [dbo].[exam] b on a.[course_id]=b.[course_id]
											where [exam_id] = 1001)
				BEGIN
					set @failorpass = 'you pass in this exam'
				END
			else
				BEGIN
					set @failorpass = 'you fail in this exam'
				END
            -- Return the total grade 
            SELECT @TotalCorrectAnswers AS Grade ,@failorpass AS [state];
        END
 
END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE() AS errorMessage
END CATCH

exec Studentgrade @Std_ID =1, @Ex_No = 1001

-----------------------------details of student ------------------------------------------
CREATE OR ALTER PROCEDURE Studentdetails
    @Std_ID INT,
    @Ex_type nvarchar (20)
AS
BEGIN TRY
    IF NOT EXISTS (SELECT 1 FROM Student WHERE [student_id] = @Std_ID)
	    BEGIN
            SELECT 'The student does not exist' AS 'ErrMessage'
        END
	ELSE 
		BEGIN
			select a.[name],a.[email],c.[type],d.[name],e.[Question],f.[student_answer]
			from [dbo].[student] a inner join [dbo].[student_course] b on a.[student_id]=b.[student_id]
				inner join [dbo].[exam] c on b.[course_id] = c.[course_id]
				inner join [dbo].[course] d on c.[course_id] = d.[course_id]
				inner join [dbo].[question] e on  d.[course_id] = e.[course_id]
				inner join [dbo].[student_exam] f on  e.[question_id]=f.[question_id]
				where a.[student_id] = @Std_ID and c.type=@Ex_type
		END
END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE() AS errorMessage
END CATCH

exec Studentdetails @Std_ID =1, @Ex_type = 'FirstTime'

-----------------------------update student track------------------------------------------
CREATE OR ALTER PROCEDURE updateStudenttrack
    @Std_ID INT,
    @track_id INT
AS
BEGIN TRY
    IF NOT EXISTS (SELECT 1 FROM Student WHERE [student_id] = @Std_ID)
	    BEGIN
            SELECT 'The student does not exist' AS 'ErrMessage'
        END
	ELSE IF NOT EXISTS (SELECT 1 FROM track WHERE [track_id]=@track_id)
	    BEGIN
            SELECT 'The track does not exist' AS 'ErrMessage'
        END
	ELSE 
		BEGIN
			update [dbo].[student]
			set [track_id]=@track_id
			where [student_id]=@Std_ID
		END
END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE() AS errorMessage
END CATCH

exec updateStudenttrack @Std_ID=8,@track_id=300 

-----------------------------show student in specific track------------------------------------------
CREATE OR ALTER PROCEDURE StudentsInTrack(@TrackNumber INT)
AS 
BEGIN
    SELECT student_id, name
    FROM Student
    WHERE student_id IN
    (
        SELECT s.student_id
        FROM Student s
        INNER JOIN Track t ON s.track_id = t.track_id
        WHERE t.track_id = @TrackNumber
    )
END;

EXEC StudentsInTrack @TrackNumber =100;