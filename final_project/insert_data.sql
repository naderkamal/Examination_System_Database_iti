
insert into [dbo].[track] ([track_id],[name])
values(100,'.Net'),(200,'PHP'),(300,'MERN'),
(400,'Python'),(500,'Cross_Platform')

insert into [dbo].[intaka] ([intaka_id],[name],[track_id])
values(11,'intaka1',200),(21,'intaka2',200) ,(31,'intaka3',500) 
,(41,'intaka4',100) ,(51,'intaka5',300) ,(61,'intaka6',100) ,(71,'intaka7',400) ,(81,'intaka8',500) 
,(91,'intaka9',100)

insert into [dbo].[branch] ([branch_id],[name],[intaka_id])
values(1,'Smart',21),(2,'Minia',51),(3,'Alex',41),(4,'Ismallia',91),
(5,'NSity',71),(6,'Mnofea',21),(7,'Mansora',31),(8,'Sohag',81),(9,'Qina',41),(10,'Assiut',61)

insert into [dbo].[course]([course_id],[name],[description],[degree_main],[degree_max])
values(001,'JavaScript','FullstackWeb',10,20),(002,'sql','FullstackWeb',10,20),(003,'Html','FullstackWeb',10,20),
(004,'css','FullstackWeb',10,20),(005,'c#','FullstackWeb',10,20),(006,'es6','FullstackWeb',10,20),(007,'oop','FullstackWeb',10,20)

insert into [dbo].[instructor] ([instructor_id],[name],[birthday],[email],[password],[manager_id],[branch_id])
values(01,'elshery','1988-01-12','elshery@gmail.com','elshery123',null,1),(02,'sarah','1990-06-05','sarah@gmail.com','sarah123',null,3),
(03,'tony','1980-06-06','tony@gmail.com','tony123',null,2),(04,'marihan','1990-06-07','marihan@gmail.com','marihan123',03,2),
(05,'nader','2001-06-05','nader@gmail.com','nader123',null,3),(06,'Ahmed','1999-04-05','Ahmed@gmail.com','Ahmed123',04,2),
(07,'dina','2001-07-12','dina@gmail.com','dina123',03,10),(08,'Khaled','1997-08-02','Khaled@gmail.com','Khaled123',null,8),
(09,'Mahmmod','1991-03-22','Mahmmod@gmail.com','Mahmmod123',04,7),(010,'hossam','2000-11-27','hossam@gmail.com','hossam123',null,6)

insert into [dbo].[exam] ([exam_id],[year],[start_time],[end_time],[degree],[type],[instructor_id],[course_id])
values(1001,'2021','10:00','1:00',20,'FirstTime',01,001),(1002,'2021','10:00','1:00',20,'corrective',01,001),
(1003,'2021','11:00','2:00',20,'FirstTime',02,002),(1004,'2021','11:00','2:00',20,'corrective',02,002),
(1005,'2022','11:00','2:00',20,'FirstTime',04,006),(1006,'2022','11:00','2:00',20,'corrective',04,006),
(1007,'2022','11:00','2:00',20,'FirstTime',07,003),(1008,'2022','11:00','2:00',20,'corrective',07,003),
(1009,'2022','11:00','2:00',20,'FirstTime',06,005),(1010,'2022','11:00','2:00',20,'corrective',06,005),
(1011,'2023','11:00','2:00',20,'FirstTime',03,004),(1012,'2023','11:00','2:00',20,'corrective',03,004)

insert into [dbo].[student] ([student_id],[name],[birthday],[email],[password],[track_id])
values(1,'ahmed','1988-12-01','ahmedu@gmail.com','ahmedu123',100),(2,'botros','1995-11-03','botrosu@gmail.com','botrosu123',100),
(3,'abanoub','1996-11-05','abanoubu@gmail.com','abanoubu123',200),(4,'beshoy','1994-11-06','beshoyu@gmail.com','beshoyu123',300),
(5,'ali','1993-11-07','aliu@gmail.com','aliu123',300),(6,'amr','1992-11-08','amru@gmail.com','amru123',300),
(7,'azza','1991-11-09','azzau@gmail.com','azzau123',400),(8,'evon','1990-11-10','evonu@gmail.com','evonu123',400),
(9,'aya','1989-11-11','ayau@gmail.com','ayau123',500),(10,'lamia','1995-03-12','lamiau@gmail.com','lamiau123',100)

insert into [dbo].[question]([question_id],[Question],[answer],[correct_answer],[type],[degree],[instructor_id],[course_id])
values(1,'prince harry is taller than william','a-TRUE,b-FALSE','true','TRUE&FALSE',2,01,001),(2,'the star sign aquarivsis represented by atiger','a-TRUE,b-FALSE','false','TRUE&FALSE',2,01,001),
(3,'m%m stands for marsand mooradle','a-TRUE,b-FALSE','true','TRUE&FALSE',2,01,001),(4,'marrakesh is the capital of maraco','a-TRUE,b-FALSE','false','TRUE&FALSE',2,01,001),
(5,'the unicorn is the national animal in scotland','a-TRUE,b-FALSE','true','TRUE&FALSE',2,01,001),(6,'howward donad is the oldest member to take that','a-TRUE,b-FALSE','true','TRUE&FALSE',2,01,001),
(7,'in javascript what is ablock of satement','a-conditional block,b-block,c-both','c-both','CHOICE',2,01,001),(8,'function and var are known as','a-data type,b-kewords,c-declaration','c-declaration','CHOICE',2,01,001),
(9,'what are java script data types',null,'number,string,boolean,object,undfined','TEXTQuESTION',2,01,001),(10,'what is the use of nan function',null,'is nan function returns true if argument is not number','TEXTQuESTION',2,01,001)

insert into [dbo].[exam_question]([exam_id],[question_id])
values(1001,1),(1001,2),(1001,3),(1001,4),(1001,5),
(1001,6),(1001,7),(1001,8),(1001,9),(1001,10)

insert into [dbo].[student_exam]([student_id],[question_id],[student_answer])
values(1,1,'true'),(1,2,'false'),(1,3,'true'),(1,4,'true'),(1,5,'false'),(1,6,'true'),
(1,7,'c-both'),(1,8,'b-kewords'),(1,9,'string'),(1,10,'is nan function returns true')

insert into [dbo].[instructor_course]
values(1,1,'2017-02-02'),(2,2,'2020-08-03')

insert into [dbo].[student_course]
values(1,1),(1,2),(2,5),(2,7)