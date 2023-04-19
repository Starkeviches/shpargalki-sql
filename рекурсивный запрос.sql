-- генератор последовательности
with rec(x) as
(
select 1
union all
select t.x + 1 from rec t
where t.x < 10
)
select * from rec t;

CREATE TABLE Department
(
ID INT,
ParentID INT,
Name VARCHAR(50)
);
 
INSERT INTO Department ( ID, ParentID, Name ) 
VALUES (1, 0, 'Finance Director')
INSERT INTO Department ( ID, ParentID, Name ) 
VALUES (2, 1, 'Deputy Finance Director')
INSERT INTO Department ( ID, ParentID, Name ) 
VALUES (3, 1, 'Assistance Finance Director')
INSERT INTO Department ( ID, ParentID, Name ) 
VALUES (4, 3, 'Executive Bodget Office')
INSERT INTO Department ( ID, ParentID, Name ) 
VALUES (5, 3, 'Comptroller')
INSERT INTO Department ( ID, ParentID, Name ) 
VALUES (6, 3, 'Purchasing')
INSERT INTO Department ( ID, ParentID, Name ) 
VALUES (7, 3, 'Debt Management')
INSERT INTO Department ( ID, ParentID, Name ) 
VALUES (8, 3, 'Risk Management')
INSERT INTO Department ( ID, ParentID, Name ) 
VALUES (9, 2, 'Public Relations')
INSERT INTO Department ( ID, ParentID, Name ) 
VALUES (10, 2, 'Finance Personnel')
INSERT INTO Department ( ID, ParentID, Name ) 
VALUES (11, 2, 'Finance Accounting')
INSERT INTO Department ( ID, ParentID, Name ) 
VALUES (12, 2, 'Liasion to Boards and Commissions');

select * from Department;
-- 
WITH RecursiveQuery (ID, ParentID, Name)
AS
(
 SELECT ID, ParentID, Name
 FROM Department dep
 WHERE dep.ID = 2
 UNION ALL
 SELECT dep.ID, dep.ParentID, dep.Name
 FROM Department dep
 JOIN RecursiveQuery rec ON dep.ParentID = rec.ID
)
SELECT ID, ParentID, Name
FROM RecursiveQuery;


