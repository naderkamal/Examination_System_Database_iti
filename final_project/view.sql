-------------------view to show student course------------------------
create view studentCourse_v
as
SELECT c.student_id, c.name, a.course_id, a.name AS course_name
	FROM dbo.course a INNER JOIN dbo.student_course b ON a.course_id = b.course_id INNER JOIN
		dbo.student c ON b.student_id = c.student_id

select * from studentCourse_v

-------------------view to show student question------------------------
create view studentQuestion_v
as
SELECT a.Question, b.student_answer, c.name, d.name AS courseName
	FROM dbo.question a INNER JOIN dbo.student_exam b ON a.question_id = b.question_id INNER JOIN
    dbo.student c ON b.student_id = c.student_id INNER JOIN
    dbo.course d ON a.course_id = d.course_id;

select * from studentQuestion_v

-------------------view to show instructor information ------------------------
create VIEW instructorInfo_v AS
SELECT
    i.name AS instructor_name,
    c.name AS course_name,
    s.name AS student_name
FROM
    instructor_course ic INNER JOIN instructor i ON ic.instructor_id = i.instructor_id
    INNER JOIN course c ON ic.course_id = c.course_id
    INNER JOIN student_course sc ON c.course_id = sc.course_id
    INNER JOIN student s ON sc.student_id = s.student_id;

select * from instructorInfo_v
-------------------view to show student information ------------------------
create VIEW vw_StudentInfo AS
SELECT
    s.student_id ,
    s.name AS student_name,
    s.birthday AS student_birthday,
    s.email AS student_email,
    t.name AS track_name
 
FROM
    student s
    JOIN track t ON s.track_id = t.track_id
    JOIN intaka i ON t.track_id = i.track_id
	
  group by s.student_id,s.name,s.email,s.birthday, t.name

SELECT * FROM vw_StudentInfo;

-------------------view to show Exam Details with Instructor and Course Information ------------------------
CREATE VIEW vw_ExamDetails AS
SELECT
    e.exam_id,
    e.year AS exam_year,
    e.start_time,
    e.end_time,
    e.degree,
    e.type AS exam_type,
    i.name AS instructor_name,
    c.name AS course_name
FROM
    exam e JOIN instructor i ON e.instructor_id = i.instructor_id
    JOIN course c ON e.course_id = c.course_id;

SELECT * FROM vw_ExamDetails;