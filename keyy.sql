CREATE TABLE `test_table` (
   `id` int NOT NULL,
   `value` varchar(255) DEFAULT NULL,
   PRIMARY KEY (`id`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

select * from test_table;


show databases;

use testdb;

show tables;

select * from key_value_table;
CREATE TABLE `key_value_table` (
   `id` int NOT NULL,
   `value` varchar(255) DEFAULT NULL,
   PRIMARY KEY (`id`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci



select * from key_value_table;
rename table  key_value_table to key_value_pair;
truncate key_value_pair;

insert into key_value_pair values(1,'asgdjhasd');

show create table key_val_pair;


CREATE TABLE `key_val_pair` (
   `id` int NOT NULL,
   `value` varchar(255) DEFAULT NULL,
   PRIMARY KEY (`id`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
 select * from key_val_pair;

insert into key_val_pair select * from key_value_pair;



select * into key_val_pair from key_value_pair;
insert ignore into key_val_pair select * from key_value_pair;
insert into key_val_pair (id, value)
select id, value from key_value_pair
where key_value_pair.id not in (select id from key_val_pair);
insert into key_val_pair (id, value)
select id, value from key_value_pair
on duplicate key update value = if(key_val_pair.value != values(value), values(value), key_val_pair.value);
select * into key_val_pair from key_value_pair;
INSERT INTO key_val_pair SELECT * FROM key_value_pair;
show tables;
insert into key_val_pair (id, value)
select id, value from key_value_pair;
select * from key_val_pair;
select * from key_value_pair;

insert into key_value_pair values(2,'Rama');
insert into key_value_pair values(3,'Rararrra');
UPDATE key_value_pair  SET value = 'Rama' WHERE id = 2;

select * from key_value_pair LIMIT 3;
SELECT MIN(ID) FROM key_value_pair;
SELECT Max(ID) FROM key_value_pair;

select count(id) from key_value_pair;
select sum(id) from key_value_pair;

select avg(id) from key_value_pair;

select * from key_value_pair where value like '%r%';
select * from key_value_pair where value like '__g%';

select * from key_value_pair where value in('asgdjhasd')

