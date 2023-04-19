-- ������ �������� �������� ��������� �� �����
select name as ����, concat(sred, ' ���') as �������_������� from
(select c.name as name,
	   round(avg(s.age), 0) as sred from courses c 
inner join studentcourses sc on (c.id=sc.course_id)
inner join students s on (sc.student_id=s.id)
group by c.name
having round(avg(s.age), 0) % 10 in (0, 5, 6, 7, 8, 9)) q
union
select name, concat(sred, ' ���') from
(select c.name as name,
	   round(avg(s.age), 0) as sred from courses c 
inner join studentcourses sc on (c.id=sc.course_id)
inner join students s on (sc.student_id=s.id)
group by c.name
having round(avg(s.age), 0) % 10 = 1) q1
union
select name, concat(sred, ' ����') from
(select c.name as name,
	   round(avg(s.age), 0) as sred from courses c 
inner join studentcourses sc on (c.id=sc.course_id)
inner join students s on (sc.student_id=s.id)
group by c.name
having round(avg(s.age), 0) % 10 in (2, 3, 4)) q2


