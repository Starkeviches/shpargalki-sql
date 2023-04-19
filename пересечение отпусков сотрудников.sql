-- ����� �����, � ������� ������������ ���� ������� � 2020 ����
select 
	VF.ID_Employee as �������������1, 
	VF.DateBegin as �������������, 
	VF.DateEnd as ������������, 
	VS.ID_Employee as �������������2, 
	VS.DateBegin as �������������, 
	VS.DateEnd as ������������
FROM Vacation VF 
	cross JOIN Vacation VS  
WHERE VF.DateBegin<=VS.DateBegin 
	and VF.DateEnd>=VS.DateEnd 
	and VF.ID_Employee!=VS.ID_Employee 
	and (year (VS.DateBegin) = 2020 or year (VS.DateEnd) = 2020)


 