-- Example 2: Product Recommendations
create database products 
show databases;
use products;
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

CREATE TABLE product_recommendations (
    product_id INT,
    recommended_product_id INT,
    strength DECIMAL(3, 2),
    PRIMARY KEY (product_id, recommended_product_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (recommended_product_id) REFERENCES products(product_id)
);

INSERT INTO products (product_id, product_name, category, price) VALUES
(1, 'Laptop', 'Electronics', 999.99),
(2, 'Smartphone', 'Electronics', 699.99),
(3, 'Tablet', 'Electronics', 399.99),
(4, 'Headphones', 'Electronics', 149.99),
(5, 'Smart Watch', 'Electronics', 249.99);

INSERT INTO product_recommendations (product_id, recommended_product_id, strength) VALUES
(1, 2, 0.8),
(1, 3, 0.6),
(1, 4, 0.7),
(2, 1, 0.8),
(2, 3, 0.9),
(2, 5, 0.7),
(3, 1, 0.6),
(3, 2, 0.9),
(3, 4, 0.5);

select * from products;

select p1.product_name,
p2.product_name,
pr.strength
from product_recommendations pr
join products p1 on p1.product_id = pr.product_id
join products p2 on pr.recommended_product_id = p2.product_id
where p1.product_id =1
order by pr.strength desc

-- Example 3: Flight Connections
CREATE TABLE airports (
    airport_code CHAR(3) PRIMARY KEY,
    airport_name VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE flights (
    flight_id INT PRIMARY KEY,
    departure_airport CHAR(3),
    arrival_airport CHAR(3),
    departure_time TIME,
    arrival_time TIME,
    FOREIGN KEY (departure_airport) REFERENCES airports(airport_code),
    FOREIGN KEY (arrival_airport) REFERENCES airports(airport_code)
);

INSERT INTO airports (airport_code, airport_name, city, country) VALUES
('JFK', 'John F. Kennedy International Airport', 'New York', 'USA'),
('LAX', 'Los Angeles International Airport', 'Los Angeles', 'USA'),
('LHR', 'London Heathrow Airport', 'London', 'UK'),
('CDG', 'Charles de Gaulle Airport', 'Paris', 'France'),
('NRT', 'Narita International Airport', 'Tokyo', 'Japan');

INSERT INTO flights (flight_id, departure_airport, arrival_airport, departure_time, arrival_time) VALUES
(1, 'JFK', 'LAX', '08:00', '11:00'),
(2, 'LAX', 'NRT', '13:00', '17:00'),
(3, 'NRT', 'LHR', '19:00', '23:00'),
(4, 'LHR', 'CDG', '09:00', '10:30'),
(5, 'CDG', 'JFK', '12:00', '14:00'),
(6, 'JFK', 'LHR', '18:00', '06:00'),
(7, 'LHR', 'LAX', '10:00', '13:00');

-- Find all possible one-stop flights from JFK to NRT



select * from flights f1 join flights f2
on f1.arrival_airport=f2.departure_airport
where f1.departure_airport='JFK' and f2.arrival_airport='NRT';

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);



INSERT INTO employees (employee_id, first_name, last_name, manager_id) VALUES
(1, 'John', 'Doe', NULL),  -- CEO
(2, 'Jane', 'Smith', 1),   -- Reports to John
(3, 'Bob', 'Johnson', 1),  -- Reports to John
(4, 'Alice', 'Williams', 2), -- Reports to Jane
(5, 'Charlie', 'Brown', 2),  -- Reports to Jane
(6, 'David', 'Lee', 3),      -- Reports to Bob
(7, 'Eva', 'Garcia', 3),     -- Reports to Bob
(8, 'Frank', 'Lopez', 4),    -- Reports to Alice
(9, 'Grace', 'Kim', 6),      -- Reports to David
(10, 'Henry', 'Chen', 7);    -- Reports to Eva


WITH RECURSIVE employee_hierarchy AS (
    -- Base case: Select employees with no manager
    SELECT employee_id, first_name, last_name, manager_id, 0 AS level
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive case: Select employees who are managed by the previous level
    SELECT e.employee_id, e.first_name, e.last_name, e.manager_id, eh.level + 1
    FROM employees e
    JOIN employee_hierarchy eh ON eh.employee_id = e.manager_id  -- Fixed join condition
)

SELECT 
    employee_id,
    CONCAT(first_name, ' ', last_name) AS employee_name,
    level
FROM employee_hierarchy
ORDER BY level, employee_id;

-- Sample Data Setup
CREATE TABLE employeees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10, 2),
    hire_date DATE
);

INSERT INTO employeees VALUES
(1, 'John', 'Doe', 'IT', 75000, '2020-01-15'),
(2, 'Jane', 'Smith', 'HR', 65000, '2019-05-11'),
(3, 'Bob', 'Johnson', 'IT', 80000, '2018-03-23'),
(4, 'Alice', 'Williams', 'Finance', 72000, '2021-09-30'),
(5, 'Charlie', 'Brown', 'IT', 68000, '2022-02-14'),
(6, 'Eva', 'Davis', 'HR', 61000, '2020-11-18'),
(7, 'Frank', 'Miller', 'Finance', 79000, '2017-07-12'),
(8, 'Grace', 'Taylor', 'IT', 77000, '2019-04-22'),
(9, 'Henry', 'Anderson', 'Finance', 71000, '2021-01-05'),
(10, 'Ivy', 'Thomas', 'HR', 63000, '2022-06-30');

CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    start_date DATE,
    end_date DATE
);

INSERT INTO projects VALUES
(1, 'Database Migration', '2023-01-01', '2023-06-30'),
(2, 'New HR System', '2023-03-15', '2023-12-31'),
(3, 'Financial Reporting Tool', '2023-02-01', '2023-11-30'),
(4, 'IT Infrastructure Upgrade', '2023-05-01', '2024-04-30');

CREATE TABLE employee_projects (
    employee_id INT,
    project_id INT,
    role VARCHAR(50),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

INSERT INTO employee_projects VALUES
(1, 1, 'Project Lead'),
(2, 2, 'Project Manager'),
(3, 1, 'Database Admin'),
(4, 3, 'Financial Analyst'),
(5, 4, 'Network Engineer'),
(6, 2, 'HR Specialist'),
(7, 3, 'Data Analyst'),
(8, 4, 'Systems Architect'),
(1, 4, 'Security Consultant'),
(3, 4, 'Software Developer');

-- Questions

-- 1. Write a query to find the top 3 highest paid employees in each department.
select department,first_name,last_name,salary, rankno
from (
select department, first_name,last_name,salary,
ROW_NUMBER() over (partition by department order by salary desc) as rankno
from employeees
)ranked_employees
where rankno <=3
order by department , rankno;


-- 2. Calculate the running total of salaries in each department, ordered by hire date.
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    hire_date,
    salary,
    SUM(salary) OVER (PARTITION BY department ORDER BY hire_date) AS running_total_salary
FROM employeees
ORDER BY department, hire_date;

-- 3. Find employees who are working on more than one project, along with the count of projects they're involved in.
SELECT 
    ep.employee_id,
    e.first_name,
    e.last_name,
    COUNT(ep.project_id) AS project_count
FROM employee_projects ep
JOIN employees e ON ep.employee_id = e.employee_id
GROUP BY ep.employee_id, e.first_name, e.last_name
HAVING COUNT(ep.project_id) > 1;

-- 4. Identify projects that have team members from all departments.
SELECT p.project_id, p.project_name
FROM projects p
JOIN employee_projects ep ON p.project_id = ep.project_id
JOIN employeees e ON ep.employee_id = e.employee_id
GROUP BY p.project_id, p.project_name
HAVING COUNT(DISTINCT e.department) = (SELECT COUNT(DISTINCT department) FROM employeees);

-- 5. Calculate the average salary for each department, but only include employees hired in the last 3 years.
SELECT department, AVG(salary) AS avg_salary
FROM employeees
WHERE hire_date >= NOW() - INTERVAL 3 YEAR
GROUP BY department;


-- 6. Create a pivot table showing the count of employees in each department, with columns for different salary ranges (e.g., <65000, 65000-75000, >75000).
SELECT 
    department,
    COUNT(CASE WHEN salary < 65000 THEN 1 END) AS "Salary < 65000",
    COUNT(CASE WHEN salary BETWEEN 65000 AND 75000 THEN 1 END) AS "65000-75000",
    COUNT(CASE WHEN salary > 75000 THEN 1 END) AS "Salary > 75000"
FROM employeees
GROUP BY department;

-- 7. Find the employee(s) with the highest salary in their respective departments, who are also working on the longest-running project.
WITH LongestProject AS (
    SELECT 
        project_id, 
        DATEDIFF(end_date, start_date) AS project_duration
    FROM projects
    ORDER BY project_duration DESC
    LIMIT 1
)
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.salary
FROM employeees e
JOIN employee_projects ep ON e.employee_id = ep.employee_id
WHERE ep.project_id = (SELECT project_id FROM LongestProject)
AND e.salary = (
    SELECT MAX(salary) 
    FROM employeees 
    WHERE department = e.department
);

-- 8. Calculate the percentage of each department's salary compared to the total salary of the company.
SELECT 
    e.department,
    SUM(e.salary) AS total_salary,
    (SUM(e.salary) / company_total.total_company_salary * 100) AS salary_percentage
FROM employeees e
CROSS JOIN (SELECT SUM(salary) AS total_company_salary FROM employees) AS company_total
GROUP BY e.department;



-- 9. Identify employees who have a higher salary than their department's average, and show by what percentage their salary exceeds the average.

-- 10. Create a query that shows a hierarchical view of employees and their projects, with multiple levels of projects if an employee is in more than one.

-- Bonus Challenge:
-- 11. Implement a query to find the "Kevin Bacon Number" equivalent for projects. 
--     (i.e., for each pair of employees, find the shortest connection through shared projects)