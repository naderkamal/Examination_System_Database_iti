create database projectExaminationSystem

create table track
(
	track_id int primary key ,
	[name] nvarchar(50) not null,
)

create table intaka
(
	intaka_id int primary key ,
	[name] nvarchar(50) not null,
	track_id int

	constraint FK_intaka_track foreign key (track_id) REFERENCES track(track_id)
)

create table branch
(
	branch_id int primary key ,
	[name] nvarchar(50) not null,
	intaka_id int

	constraint FK_branch_intaka foreign key (intaka_id) REFERENCES intaka(intaka_id)
)

create table course
(
	course_id int primary key ,
	[name] nvarchar(50),
	[description] nvarchar(20),
	degree_main int not null,
	degree_max int not null
)

create table instructor
(
	instructor_id int primary key,
	[name] nvarchar(50),
	birthday date not null,
	email nvarchar(100) unique not null,
	[password] nvarchar(100) not null,
	manager_id int,
	branch_id int

	constraint FK_instructor_branch foreign key (branch_id) REFERENCES branch(branch_id)
)

create table exam
(
	exam_id int primary key ,
	[year] date not null,
	start_time time not null,
    end_time time not null,
	degree int ,
	[type] nvarchar(20),
	instructor_id int not null foreign key references instructor(instructor_id),
	course_id int not null foreign key references course(course_id)
)

create table student
(
	student_id int primary key,
	[name] nvarchar(50),
	birthday date not null,
	email nvarchar(100) unique not null,
	[password] nvarchar(100) not null,
	track_id int

	constraint FK_student_track foreign key (track_id) REFERENCES track(track_id)
)

create table question
(
	question_id int primary key,
	degree int ,
	[type] nvarchar(20),
	Question nvarchar(max),
	answer nvarchar(max),
	correct_answer nvarchar(max),
	course_id int,
	instructor_id int

	constraint FK_question_course foreign key (course_id) REFERENCES course(course_id),
	constraint FK_question_instructor foreign key (instructor_id) REFERENCES instructor(instructor_id)
)

/*************************************************************/

create table student_course
(
  course_id int not null foreign key references course(course_id),
  student_id int not null  foreign key references student(student_id)

   constraint PK_course_student primary key (course_id,student_id)

);

create table student_exam
(
	student_exam_id int primary key identity(1,1),
	student_id int not null foreign key references student (student_id),
	question_id int not null foreign key references question(question_id),
	student_answer nvarchar(max) ,
	degree int 
);

create table instructor_course
(
  instructor_id int not null foreign key references instructor(instructor_id),
  course_id int not null foreign key references course(course_id),
  _year date  not null,

);

create table exam_question
(
	exam_question_id int primary key identity(1,1),
	exam_id int not null foreign key references exam(exam_id),
	question_id int not null foreign key references question(question_id),
)

------------------------------