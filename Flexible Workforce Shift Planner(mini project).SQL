-- 1. Drop and create database
DROP DATABASE company;
CREATE DATABASE company;
USE company;

-- 2. Create temporary employees table (with duplicates)
CREATE TABLE employees_temp (
    auto_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id VARCHAR(255),
    emp_name VARCHAR(255),
    emp_prefferedshift VARCHAR(255)
);

-- 3. Insert employees (with some duplicates for testing)
INSERT INTO employees_temp (emp_id, emp_name, emp_prefferedshift) VALUES
('2025IT01', 'Priyan', 'Day shift'), -- Priyan
('2025IT02', 'Ashwin', 'Night shift'), -- Ashwin
('2025IT03', 'Karthik', 'Day shift'),
('2025IT04', 'Divya', 'Night shift'),
('2025IT05', 'Sneha', 'Day shift'), -- Sneha
('2025IT06', 'Rahul', 'Night shift'), -- Rahul
('2025IT02', 'Ashwin', 'Day shift'), -- Ashwin
('2025IT07', 'Meena', 'Day shift'), -- Meena
('2025IT08', 'Vignesh', 'Night shift'),
('2025IT01', 'Priyan', 'Day shift'), -- Priyan
('2025IT09', 'Anjali', 'Day shift'),
('2025IT10', 'Sathish', 'Night shift'),
('2025IT11', 'Keerthi', 'Day shift'),
('2025IT07', 'Meena', 'Night shift'), -- Meena
('2025IT12', 'Manoj', 'Night shift'),
('2025IT05', 'Sneha', 'Day shift'), -- Sneha
('2025IT13', 'Nandhini', 'Day shift'),
('2025IT14', 'Harish', 'Night shift'),
('2025IT15', 'Ramya', 'Day shift'), -- Ramya
('2025IT13', 'Nandhini', 'Day shift'),
('2025IT16', 'Dinesh', 'Night shift'),
('2025IT15', 'Ramya', 'Day shift'), -- Ramya
('2025IT17', 'Pavithra', 'Day shift'),
('2025IT18', 'Santhosh', 'Night shift'),
('2025IT19', 'Revathi', 'Day shift'),
('2025IT06', 'Rahul', 'Night shift'), -- Rahul
('2025IT20', 'Arun', 'Night shift');

-- 4. Deduplicate and keep latest (based on auto_id)
CREATE TABLE employees AS
SELECT emp_id, emp_name, emp_prefferedshift
FROM ( -- Sub Query              - PARTITION BY (Group the row by emp_id) if you have duplicate emp_id values it shows as one group (rn 1,2..)
    SELECT *, ROW_NUMBER() OVER (PARTITION BY emp_id ORDER BY auto_id DESC) AS rn -- ROW_NUMBER() ASSIGN 1,2,3,4
    FROM employees_temp
) AS ranked
WHERE rn = 1; -- Filter duplicates

-- 5. Primary key
ALTER TABLE employees ADD PRIMARY KEY (emp_id);

-- 6. Drop temp
DROP TABLE employees_temp;

-- 7. Shift master table
CREATE TABLE shift (
    shift_id VARCHAR(255) PRIMARY KEY,
    shift_name VARCHAR(255),
    shift_time VARCHAR(255)
);

INSERT INTO shift VALUES
('D001', 'Day shift', 'Morning(10AM - 6PM)'),
('N001', 'Night shift', 'Night(6PM - 2AM)');

-- 8. Departments
CREATE TABLE departments (
    dept_id VARCHAR(255) PRIMARY KEY,
    dept_name VARCHAR(255)
);

INSERT INTO departments VALUES
('SDE_IT25', 'Software Development'),
('TEST_IT25', 'Software Testing'),
('NET_IT25', 'Networking'),
('SYS_IT25', 'System Administration'),
('UXUI_IT25', 'UI/UX Design');

-- 9. Employee Departments
-- CHILD TABLE VALUES emp_id and dep_id (to connect a table (called the "child" table) to another table (called the "parent" table).
CREATE TABLE employeeDepartments (
    emp_id VARCHAR(255),
    dept_id VARCHAR(255),
    PRIMARY KEY(emp_id, dept_id),
    FOREIGN KEY(emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY(dept_id) REFERENCES departments(dept_id)
);

INSERT INTO employeeDepartments VALUES
('2025IT01', 'SDE_IT25'),
('2025IT02', 'TEST_IT25'),
('2025IT03', 'NET_IT25'),
('2025IT04', 'SYS_IT25'),
('2025IT05', 'UXUI_IT25'),
('2025IT06', 'SDE_IT25'),
('2025IT07', 'TEST_IT25'),
('2025IT08', 'NET_IT25'),
('2025IT09', 'SYS_IT25'),
('2025IT10', 'UXUI_IT25'),
('2025IT11', 'SDE_IT25'),
('2025IT12', 'TEST_IT25'),
('2025IT13', 'NET_IT25'),
('2025IT14', 'SYS_IT25'),
('2025IT15', 'UXUI_IT25'),
('2025IT16', 'SDE_IT25'),
('2025IT17', 'TEST_IT25'),
('2025IT18', 'NET_IT25'),
('2025IT19', 'SYS_IT25'),
('2025IT20', 'UXUI_IT25');

-- 10. Shift Assignment (no shift_id here)
CREATE TABLE shiftassignment (
    assign_id VARCHAR(255) PRIMARY KEY,
    emp_id VARCHAR(255),
    dates DATE,
    FOREIGN KEY(emp_id) REFERENCES employees(emp_id)
);

INSERT INTO shiftassignment VALUES
('IT1', '2025IT01', '2025-11-21'),
('IT2', '2025IT02', '2025-11-21'),
('IT3', '2025IT03', '2025-11-21'),
('IT4', '2025IT04', '2025-11-21'),
('IT5', '2025IT05', '2025-11-21'),
('IT6', '2025IT06', '2025-11-21'),
('IT7', '2025IT07', '2025-11-21'),
('IT8', '2025IT08', '2025-11-21'),
('IT9', '2025IT09', '2025-11-21'),
('IT10', '2025IT10', '2025-11-21'),
('IT11', '2025IT11', '2025-11-21'),
('IT12', '2025IT12', '2025-11-21'),
('IT13', '2025IT13', '2025-11-21'),
('IT14', '2025IT14', '2025-11-21'),
('IT15', '2025IT15', '2025-11-21'),
('IT16', '2025IT16', '2025-11-21'),
('IT17', '2025IT17', '2025-11-21'),
('IT18', '2025IT18', '2025-11-21'),
('IT19', '2025IT19', '2025-11-21'),
('IT20', '2025IT20', '2025-11-21');

-- 11. Create dynamic view to link shift dynamically \

-- TO DISPLAY OUTPUT (virtual table. It doesn’t store data by itself — instead, it stores a SQL query.)
CREATE VIEW shiftassignment_dynamic AS
SELECT sa.assign_id, sa.emp_id, e.emp_name, e.emp_prefferedshift, s.shift_id, s.shift_time, sa.dates 
FROM shiftassignment sa -- it shows only the matched rows from the three tables, because of the JOINs. 
JOIN employees e ON sa.emp_id = e.emp_id
JOIN shift s ON e.emp_prefferedshift = s.shift_name; -- ultiple tables that all have a column named emp_id.

-- JOIN employees e ON sa.emp_id = e.emp_id This joins the employees table (called e). 
-- It matches rows where the employee ID in shiftassignment is the same as in employees.

-- 12. Query the dynamic assignment
SELECT * FROM shiftassignment_dynamic;

-- 13. Show all tables
-- SHOW TABLES;

-- 14. Display individual table contents
-- SELECT * FROM employees;
-- SELECT * FROM shift;
-- SELECT * FROM departments;
-- SELECT * FROM employeeDepartments;
-- SELECT * FROM shiftassignment;


-- SELECT * FROM shiftassignment_dynamic WHERE shift_id = 'D001';
-- SELECT * FROM shiftassignment_dynamic WHERE shift_id = 'N001';

select emp_id , COUNT(*) as count from employees group by emp_id;
select shift_name, count(*) as count from shift Group by shift_name;
select  shift_time, count(*) as count from shift group by shift_time;
select emp_prefferedshift, count(*) as count from employees group by emp_prefferedshift;

