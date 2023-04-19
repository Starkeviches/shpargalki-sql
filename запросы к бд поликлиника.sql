SELECT 
    COUNT(CASE WHEN bdate is null then 1 ELSE NULL END) as [Количество пациентов с неуказанной датой рождения]
    from clients;

select fullname as [ФИО пациента] from clients where month(bdate)=month(getdate()) and day(bdate)=day(getdate()); 

insert into clients (fullname, bdate) values ('Митя', '2001-03-15');

select count(*) as [Количество пациентов с неуказанной датой рождения] from clients where bdate is null;

select bdate as [Вторая максимоальная дата рождения] from (
select bdate,
rank() over(order by bdate desc) nom from clients) q
where q.nom=2;


select max(bdate) as [Вторая максимоальная дата рождения] 
from clients where bdate<(select max(bdate) from clients);

select bdate from (
select bdate,
rank() over(order by bdate desc) nom from clients) q
where q.nom=2;

select distinct bdate as [Вторая максимоальная дата рождения] from (
select bdate,
dense_rank() over(order by bdate desc) nom from clients) q
where q.nom=2;

select c.pcode, c.fullname, c.bdate from clients c
left join treat t on t.pcode=c.pcode
where t.pcode is null;

select c.pcode, c.fullname, c.bdate from clients c
inner join treat t on t.pcode=c.pcode;


-- Вывести строки таблицы лечений, для которых сумма, начисленная на пациента, 
-- (TREAT.AMOUNTCL) является максимальной в рамках этого пациента

select * from treat where amountcl in(
select max(amountcl) from treat t
inner join clients c on t.pcode=c.pcode group by t.pcode);

-- Вывести список полных однофамильцев (совпадение ФИО и даты рождения): 
-- ФИО, дата рождения, количество.

select fullname as ФИО, bdate as [Дата рождения], count(*) as Количество 
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

-- Вывести следующий список: ФИО доктора, количество лечений за сегодня, количество лечений за сегодня, 
-- стоимость которых больше 10000.

SELECT
    (select distinct dname from doctor d 
	inner join treat t on d.dcode=t.dcode
	WHERE treatdate=CONVERT(DATE,GETDATE())) as [ФИО доктора], 
    COUNT(CASE WHEN treatdate=CONVERT(DATE, GETDATE()) then 1 ELSE NULL END) as [Количество лечений за сегодня],
	COUNT(CASE WHEN treatdate=CONVERT(DATE, GETDATE()) AND amountcl>10000 then 1 ELSE NULL END) as [Количество лечений за сегодня, стоимость которых больше 10000]
	from treat;

-- Вывести строки таблицы прикреплений, для которых дата открепления (CLHISTNUM.FDATE) 
-- является максимальной в рамках каждого пациента

select * from CLHISTNUM where fdate in (
select max(fdate) from CLHISTNUM group by pcode);

-- Для всех врачей клиники вычислить абсолютное изменение средней стоимости 
-- наличного приёма (TREAT.AMOUNTCL) в 2019 году по отношению к 2018 году. 
-- Вывести ФИО доктора и указанный показатель

select z.dname, z.a2019-z.a2018 as [Абсолютное изменение средней стоимости наличного приема] from
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

-- Вывести список прикреплений, для которых стоимость годового прикрепления (CLHISTNUM.AMOUNTRUB) 
-- меньше половины стоимости фактически оказанных по этому прикреплению услуг (TREAT.AMOUNTJP). 
-- Указать ФИО пациента, номер договора (JPAGREEMENT.AGNUM), номер полиса (CLHISTNUM.NSP), 
-- период прикрепления (CLHISTNUM.BDATE,FDATE)

select c.fullname as [ФИО пациента], j.agnum as [Номер договора], q.nsp as [Номер полиса], q.bdate as [Дата начала прикрепления], q.fdate as [Дата окончания прикрепления] from 
(select histid, pcode, nsp, BDATE, FDATE, agrid, sum(amountrub) as s_cl from CLHISTNUM group by histid, pcode, nsp, BDATE, FDATE, agrid) q
inner join 
(select histid, pcode, sum(amountjp) as s_t from treat group by histid, pcode) w
on q.histid=w.histid
inner join clients c on c.pcode=w.pcode
inner join JPAGREEMENT j on j.agrid=q.agrid
where q.s_cl < w.s_t/2;

select * from CLHISTNUM;
select * from JPAGREEMENT;



