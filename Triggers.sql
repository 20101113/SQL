create database trigger_practise;

use trigger_practise;

create table customers(id int auto_increment primary key,
name varchar(100),
email varchar(100));

create table email_changes_log(
id int auto_increment primary key,
customer_id int,
old_email varchar(100),
new_email varchar(100),
changed_at timestamp default current_timestamp);


insert into customers(name,email) values('Auahdahd','dqhduiqwh@gmail.com');

select * from customers;

DELIMITER //
CREATE TRIGGER log_email_changes
before update on customers
for each row
begin
     if old.email!=new.email then
           insert into email_changes_log(customer_id,old_email,new_email)
           values(old.id,old.email, new.email);
	 end if;
end//

delimiter ;

select * from email_changes_log;
update customers set email='jdiejweiod@gmail.com' where id =1
select * from customers