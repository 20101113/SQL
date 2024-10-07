CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    location_id INT
);

CREATE TABLE locations (
    location_id INT PRIMARY KEY,
    city VARCHAR(50)
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone_number VARCHAR(20),
    hire_date DATE,
    job_id VARCHAR(10),
    salary DECIMAL(10, 2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);


CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100)
);


CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

CREATE TABLE discontinued_products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50)
);

INSERT INTO departments (department_id, department_name, location_id) VALUES
(10, 'Administration', 1),
(20, 'Marketing', 2),
(30, 'Purchasing', 1),
(40, 'Human Resources', 2),
(50, 'Shipping', 3);

INSERT INTO locations (location_id, city) VALUES
(1, 'New York'),
(2, 'Los Angeles'),
(3, 'Chicago');

INSERT INTO employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, department_id) VALUES
(1, 'John', 'Doe', 'john.doe@example.com', '515.123.4567', '2019-06-17', 'AD_PRES', 24000.00, 10),
(2, 'Jane', 'Smith', 'jane.smith@example.com', '515.123.4568', '2020-02-20', 'AD_VP', 17000.00, 10),
(3, 'Alice', 'Johnson', 'alice.johnson@example.com', '515.123.4569', '2020-08-11', 'MK_MAN', 9000.00, 20),
(4, 'Bob', 'Brown', 'bob.brown@example.com', '515.123.4560', '2021-03-05', 'HR_REP', 6000.00, 40),
(5, 'Charlie', 'Davis', 'charlie.davis@example.com', '515.123.4561', '2021-11-30', 'SH_CLERK', 3000.00, 50);

INSERT INTO customers (customer_id, customer_name, email) VALUES
(1, 'Acme Corp', 'contact@acmecorp.com'),
(2, 'GlobalTech', 'info@globaltech.com'),
(3, 'Local Shop', 'owner@localshop.com');

INSERT INTO orders (order_id, customer_id, order_date) VALUES
(1, 1, '2023-01-15'),
(2, 1, '2023-02-20'),
(3, 2, '2023-02-22');

INSERT INTO products (product_id, product_name, category, price) VALUES
(1, 'Laptop', 'Electronics', 999.99),
(2, 'Smartphone', 'Electronics', 699.99),
(3, 'Desk Chair', 'Furniture', 199.99);

INSERT INTO discontinued_products (product_id, product_name, category) VALUES
(101, 'Old Laptop Model', 'Electronics'),
(102, 'Discontinued Phone', 'Electronics');-- Create tables



select e.first_name, e.last_name, d.department_name
from employees e
inner join departments d 
on e.department_id= d.department_id

select c.customer_name , o.order_id
from customers c
left join orders o on c.customer_id =o.customer_id

select c.customer_name , o.order_id
from customers c
right join orders o on c.customer_id =o.customer_id

select first_name,last_name, salary
from employees 
where salary >(select avg(salary) from employees);

select department_id , avg(salary) as avgsalary
from employees 
group by department_id
having avgsalary >10000

select e.first_name, e.last_name, d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
WHERE e.salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
);

select 
d.department_name,
e.first_name,
e.last_name,
e.salary,
(select avg(salary) from employees where department_id = e.department_id) as dept_avg_salary
from 
employees e
inner join
departments d
on e.department_id =d.department_id
where e.salary > (select avg(salary) from employees )
order by d.department_name , e.salary desc

select c.customer_name,
count(o.order_id) as order_count,
coalesce(sum(p.price),0) as total_order_value
from 
customers c
left join 
orders o on c.customer_id =o.customer_id
left join 
products p on p.product_id in (select product_id from orders where order_id = o.order_id )
group by
c.customer_id,c.customer_name
having 
count(o.order_id)>0
order by 
total_order_value asc;

select e1.first_name as employee1_first_name,
e1.last_name as employee1_last_name,
e2.first_name as employee2_first_name,
e2.last_name as employee2_last_name,
e1.job_id
from 
employees e1
inner join 
employees e2
on e1.job_id =e2.job_id and e1.employee_id<e2.employee_id

SELECT 
    d.department_name,
    e.first_name,
    e.last_name,
    e.salary,
    AVG(e.salary) OVER (PARTITION BY d.department_id) AS dept_avg_salary,
    RANK() OVER (PARTITION BY d.department_id ORDER BY e.salary DESC) AS salary_rank
FROM 
    departments d
LEFT OUTER JOIN 
    employees e ON d.department_id = e.department_id
ORDER BY 
    d.department_name, e.salary DESC;

select c.customer_name,
o.order_date,
case 
  when DAYOFWEEK(o.order_date) in (1,7) Then 'Weekend'
  else 'Weekday'
end as order_day_type,
p.product_name,
p.price,
case
  when p.price<100 then 'Budget'
  when p.price between 100 and 500 then 'mid range'
  else 'premium'
end as price_category
from customers c
inner join 
orders o on  c.customer_id =o.customer_id
inner join products p on p.product_id -- in (select product_id from orders where order_id =o.order_id)
where 
o.order_date <= DATE_SUB(CURDATE(),INTERVAL 1 YEAR)
order by 
o.order_date desc;

show tables;