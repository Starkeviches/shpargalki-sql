select * from geo;
alter table geo add parent_name text;

update geo set parent_name = 
concat(parent_id, ' ', name);
-- создаем функцию
create or replace function update_geo_name()
returns trigger as
$body$
begin
new.parent_name = concat(new.parent_id, ' ', new.name);
return new;
end;
$body$
LANGUAGE plpgsql volatile
cost 100;

create trigger "update_geo_name_on_update_tpigger"
before update of parent_id, name on geo
for each row when ((new.parent_id != old.parent_id) or (new.name != old.name))
execute procedure "update_geo_name"();
select * from geo;
update geo set name = 'Континент Евразия' where name ='Конт Евр';