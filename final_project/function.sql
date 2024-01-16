-----------------------------function to print course name in track------------------------------------------
create FUNCTION CoursesIDFunc(@TrackNumber INT)
RETURNS TABLE
AS RETURN
(
    SELECT  dbo.course.name AS courseName, dbo.track.name AS trackName
    FROM dbo.student
         INNER JOIN dbo.student_course ON dbo.student.student_id = dbo.student_course.student_id
         INNER JOIN dbo.course ON dbo.student_course.course_id = dbo.course.course_id
         INNER JOIN dbo.track ON dbo.student.track_id = dbo.track.track_id
    WHERE dbo.track.track_id = @TrackNumber -- Filter by track_id
    group by dbo.track.name, dbo.course.name
);


select * from CoursesIDFunc(100)

-----------------------------function to print questuin of exam ------------------------------------------
CREATE FUNCTION QuestitionExam(@ExamNumber INT)
RETURNS TABLE
AS RETURN
(
    SELECT
        DISTINCT Question.Question,
        Question.question_id,
        Question.type
    FROM
        Question
        LEFT JOIN exam_question ON Question.question_id = exam_question.question_id
    WHERE
        exam_question.exam_id = @ExamNumber
        AND Question.question_id IN
        (
            SELECT
                Question.question_id
            FROM
                Question
                LEFT JOIN exam_question ON Question.question_id = exam_question.question_id
            WHERE
                exam_id = @ExamNumber
            GROUP BY
                Question.question_id
        )
);

SELECT * FROM QuestitionExam(1001);