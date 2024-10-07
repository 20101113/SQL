create database employeemanagement;
show databases;

use employeemanagement;
create table employees(
id int auto_increment primary key,
first_name varchar(50),
last_name varchar(50),
email varchar(100),
hire_date DATE,
salary decimal(10,2)
);

select * from employees;


Insert into employees(first_name,last_name,email,hire_date,salary) values('John','A','johna@gmail.com','2023-05-15',80000),
('Park','B','parkb@gmail.com','2023-05-15',75000);

select * from employees;

update employees set salary=78000 where id=1;

select * from employees where salary>5000;
create database testdb;
use testdb;
SELECT COUNT(*) FROM test_table;
