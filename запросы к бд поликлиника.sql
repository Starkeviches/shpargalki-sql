SELECT 
    COUNT(CASE WHEN bdate is null then 1 ELSE NULL END) as [���������� ��������� � ����������� ����� ��������]
    from clients;

select fullname as [��� ��������] from clients where month(bdate)=month(getdate()) and day(bdate)=day(getdate()); 

insert into clients (fullname, bdate) values ('����', '2001-03-15');

select count(*) as [���������� ��������� � ����������� ����� ��������] from clients where bdate is null;

select bdate as [������ ������������� ���� ��������] from (
select bdate,
rank() over(order by bdate desc) nom from clients) q
where q.nom=2;


select max(bdate) as [������ ������������� ���� ��������] 
from clients where bdate<(select max(bdate) from clients);

select bdate from (
select bdate,
rank() over(order by bdate desc) nom from clients) q
where q.nom=2;

select distinct bdate as [������ ������������� ���� ��������] from (
select bdate,
dense_rank() over(order by bdate desc) nom from clients) q
where q.nom=2;

select c.pcode, c.fullname, c.bdate from clients c
left join treat t on t.pcode=c.pcode
where t.pcode is null;

select c.pcode, c.fullname, c.bdate from clients c
inner join treat t on t.pcode=c.pcode;


-- ������� ������ ������� �������, ��� ������� �����, ����������� �� ��������, 
-- (TREAT.AMOUNTCL) �������� ������������ � ������ ����� ��������

select * from treat where amountcl in(
select max(amountcl) from treat t
inner join clients c on t.pcode=c.pcode group by t.pcode);

-- ������� ������ ������ ������������� (���������� ��� � ���� ��������): 
-- ���, ���� ��������, ����������.

select fullname as ���, bdate as [���� ��������], count(*) as ���������� 
	from clients where 
	fullname in
		(select fullname from 
			(select * from clients
			union
			select * from clients) q
		group by fullname, bdate
		having count(*)>1) and 
	bdate in 
		(select bdate from 
			(select * from clients
			union
			select * from clients) q
		group by fullname, bdate
		having count(*)>1)
	group by fullname, bdate;

-- ������� ��������� ������: ��� �������, ���������� ������� �� �������, ���������� ������� �� �������, 
-- ��������� ������� ������ 10000.

SELECT
    (select distinct dname from doctor d 
	inner join treat t on d.dcode=t.dcode
	WHERE treatdate=CONVERT(DATE,GETDATE())) as [��� �������], 
    COUNT(CASE WHEN treatdate=CONVERT(DATE, GETDATE()) then 1 ELSE NULL END) as [���������� ������� �� �������],
	COUNT(CASE WHEN treatdate=CONVERT(DATE, GETDATE()) AND amountcl>10000 then 1 ELSE NULL END) as [���������� ������� �� �������, ��������� ������� ������ 10000]
	from treat;

-- ������� ������ ������� ������������, ��� ������� ���� ����������� (CLHISTNUM.FDATE) 
-- �������� ������������ � ������ ������� ��������

select * from CLHISTNUM where fdate in (
select max(fdate) from CLHISTNUM group by pcode);

-- ��� ���� ������ ������� ��������� ���������� ��������� ������� ��������� 
-- ��������� ����� (TREAT.AMOUNTCL) � 2019 ���� �� ��������� � 2018 ����. 
-- ������� ��� ������� � ��������� ����������

select z.dname, z.a2019-z.a2018 as [���������� ��������� ������� ��������� ��������� ������] from
(select q.dname, q.a2019, w.a2018 from
(select year(treatdate) as y2019, d.dname, 
sum(avg(amountcl)) over(order by year(treatdate), dname) as a2019 from treat t
inner join doctor d on t.dcode=d.dcode
where year(treatdate) = 2019
group by year(treatdate), d.dname) q
inner join
(select year(treatdate) as y2018, d.dname, 
sum(avg(amountcl)) over(order by year(treatdate), dname) as a2018 from treat t
inner join doctor d on t.dcode=d.dcode
where year(treatdate) = 2018
group by year(treatdate), d.dname) w
on q.dname=w.dname) z;

-- ������� ������ ������������, ��� ������� ��������� �������� ������������ (CLHISTNUM.AMOUNTRUB) 
-- ������ �������� ��������� ���������� ��������� �� ����� ������������ ����� (TREAT.AMOUNTJP). 
-- ������� ��� ��������, ����� �������� (JPAGREEMENT.AGNUM), ����� ������ (CLHISTNUM.NSP), 
-- ������ ������������ (CLHISTNUM.BDATE,FDATE)

select c.fullname as [��� ��������], j.agnum as [����� ��������], q.nsp as [����� ������], q.bdate as [���� ������ ������������], q.fdate as [���� ��������� ������������] from 
(select histid, pcode, nsp, BDATE, FDATE, agrid, sum(amountrub) as s_cl from CLHISTNUM group by histid, pcode, nsp, BDATE, FDATE, agrid) q
inner join 
(select histid, pcode, sum(amountjp) as s_t from treat group by histid, pcode) w
on q.histid=w.histid
inner join clients c on c.pcode=w.pcode
inner join JPAGREEMENT j on j.agrid=q.agrid
where q.s_cl < w.s_t/2;

select * from CLHISTNUM;
select * from JPAGREEMENT;



