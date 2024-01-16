-----------------------------------------------------
CREATE NONCLUSTERED INDEX Search_by_Mgr_ID
ON [dbo].[Instructor] ([manager_id]);
-----------------------------------------------------

-----------------------------------------------------
CREATE NONCLUSTERED INDEX Search_by_Exam
ON [Exam] ([type]);
-----------------------------------------------------

-----------------------------------------------------
CREATE NONCLUSTERED INDEX search_by_Intaka 
ON intaka([name]);
-----------------------------------------------------

-----------------------------------------------------
CREATE NONCLUSTERED INDEX search_by_branch 
ON branch([name]);
-----------------------------------------------------

-----------------------------------------------------
CREATE UNIQUE INDEX IX_Unique_Email 
ON instructor(email);
-----------------------------------------------------