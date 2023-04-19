-- поиск людей, у которых пересекаются даты отпуска в 2020 году
select 
	VF.ID_Employee as КодСотрудника1, 
	VF.DateBegin as НачалоОтпуска, 
	VF.DateEnd as КонецОтпуска, 
	VS.ID_Employee as КодСотрудника2, 
	VS.DateBegin as НачалоОтпуска, 
	VS.DateEnd as КонецОтпуска
FROM Vacation VF 
	cross JOIN Vacation VS  
WHERE VF.DateBegin<=VS.DateBegin 
	and VF.DateEnd>=VS.DateEnd 
	and VF.ID_Employee!=VS.ID_Employee 
	and (year (VS.DateBegin) = 2020 or year (VS.DateEnd) = 2020)


 