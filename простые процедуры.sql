create procedure proc_avg
 @a int = 0,
 @b int = 0,
 @c int = 0

 as 
 begin
 set nocount on;

 select avg_abc = avg(@a+@b+@c) 

 end
 
 go

create procedure a_name_authors
 @a_name nvarchar(150) = ''

 as 
 begin
 set nocount on;

  select * from authors
  where a_name=@a_name

 end

 exec a_name_authors 'А. Азимов'



create procedure a_id_authors

 @a_id int = 0

 as 
 begin
 set nocount on;

  select * from authors
  where a_id=@a_id

 end

 exec a_id_authors 2


