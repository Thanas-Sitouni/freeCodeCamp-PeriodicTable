ALTER TABLE properties RENAME COLUMN weight TO atomic_mass;
ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius;
ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius;

ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL;
ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL;

ALTER TABLE elements ADD CONSTRAINT unique_name UNIQUE (name);
ALTER TABLE elements ADD CONSTRAINT unique_symbol UNIQUE (symbol);

ALTER TABLE elements ALTER COLUMN name SET NOT NULL;
ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL;

ALTER TABLE properties ADD CONSTRAINT fk_properties_elements FOREIGN KEY (atomic_number) REFERENCES elements(atomic_number);

create table types (
	type_id SERIAL PRIMARY KEY,
	type VARCHAR(50) not null
);

insert into types (type) values ('metal');
insert into types (type) values ('nonmetal');
insert into types (type) values ('metalloid');

alter table properties add type_id INT;
update properties set type_id = 1 where "type" = 'metal';
update properties set type_id = 2 where "type" = 'nonmetal';
update properties set type_id = 3 where "type" = 'metalloid';
alter table properties alter column type_id set not null;
alter table properties add constraint fk_properties_types foreign key (type_id) references types(type_id);

update elements set symbol = 'He' where symbol = 'he';
update elements set symbol = 'Li' where symbol = 'li';
update elements set symbol = 'MT' where symbol = 'mT';

ALTER TABLE properties ALTER COLUMN atomic_mass TYPE DECIMAL;
UPDATE properties SET atomic_mass = TRIM(TRAILING '0' FROM atomic_mass::text)::numeric;

insert into elements (atomic_number, symbol, name) values (9, 'F', 'Fluorine');
insert into properties (atomic_number, type, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) values (9, 'nonmetal', 18.998, -220, -188.1, 2);

insert into elements (atomic_number, symbol, name) values (10, 'Ne', 'Neon');
insert into properties (atomic_number, type, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) values (10, 'nonmetal', 20.18, -248.6, -246.1, 2);

delete from properties where atomic_number = 1000;
delete from elements where atomic_number = 1000;

alter elements drop column "type";
