--�������� ������������� ������ (������) ��������, 
--�������� � ���������� ������ ����� ����.
select sb_subscriber, count(sb_book) as kol from subscriptions group by sb_subscriber order by kol desc

select * from subscriptions

--�������� �������������� ���� ����� �������� 
--���������, ������� � ���������� ������ ����� ����.

select sb_subscriber, count(sb_book) from subscriptions group by sb_subscriber having count(sb_book)

select sb_subscriber, 
max(y.kol) from   
(select sb_subscriber, count(sb_book) as kol from subscriptions group by sb_subscriber) y
group by sb_subscriber

insert into subscribers (s_name) values ('������� �.�.')

select * from subscribers

insert into subscriptions (sb_subscriber,sb_book,sb_start,sb_finish,sb_is_active)
values (5,1,'2011-04-12','2011-05-12','Y')