create table clients ( 
pcode integer primary key identity(1,1),
fullname varchar(255),
bdate date);

insert into clients (fullname, bdate) values
('Петров Петр', '1984-03-01'),
('Смирнов Валерий', '1985-04-02'),
('Мамонтов Геннадий', '1986-05-03');


create table treat (
treatcode integer primary key identity(1,1),
pcode integer,
constraint FK_treat_pcode foreign key (pcode) references 
clients(pcode),
dcode integer,
constraint FK_treat_dcode foreign key (dcode) references 
doctor(dcode),
treatdate date,
amountcl decimal,
amountjp decimal,
histid integer,
constraint FK_treat_clhistnum foreign key (histid) references 
clhistnum(histid));

insert into treat (pcode, dcode, treatdate, amountcl, amountjp, histid) values
(1, 1, '2023-03-08', 900.17, 800.10, 1),
(1, 2, '2023-03-08', 100.10, 80.10, 1),
(2, 1, '2023-03-09', 10.17, 8.10, 2);

/*select * from treat where pcode in (
select w.pcode from (
select pcode, max(summa) max_summa from (
select t.treatcode, t.pcode, t.dcode, t.treatdate, t.amountjp, t.histid, sum(amountcl) as summa from clients c 
inner join treat t on (c.pcode=t.pcode)
group by t.treatcode, t.pcode, t.dcode, t.treatdate, t.amountjp, t.histid) q
group by pcode) w);

select * from treat where 
amountcl=;*/


create table doctor (
dcode integer primary key identity(1,1),
dname varchar(255)
);

insert into doctor (dname) values
('Миронов Владимир'),
('Колесов Евгений'),
('Алимов Андрей');

create table jpersons (
jid integer primary key identity(1,1),
jname varchar(255));

insert into jpersons (jname) values
('СОГАЗ'),
('ВОДОЛАЗ');

create table jpagreement (
agrid integer primary key identity(1,1),
jid integer,
constraint FK_jpagreement_jpersons foreign key (jid) references 
jpersons(jid));

insert into jpagreement (jid) values
(1),
(2);

create table clhistnum (
histid integer primary key identity(1,1),
pcode integer,
constraint FK_clhistnum_clients foreign key (pcode) references 
clients(pcode),
bdate date,
fdate date,
nsp varchar(255),
amountrue decimal,
agrid integer);

insert into clhistnum (pcode, bdate, fdate, nsp, amountrue, agrid) values
(1, '2011-03-12', '2030-03-12', 'm', 1000.50, 1),
(2, '2010-04-21', '2030-05-17', 'm', 1100.50, 1),
(3, '2009-12-03', '2031-09-18', 'q', 1200.50, 2);


