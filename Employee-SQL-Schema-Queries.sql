
-- -- 1. Drop the table if it exists
-- -- 2. Create the table and its columns and primary key (or make composite)
-- -- 3. Create the foreign key (FK) as necessary
-- -- 4. Then import table data after all schema is set up in order before queries


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- To start make it easier to
-- Drop the existing tables
DROP TABLE IF EXISTS departments, dept_emp, dept_manager, salaries, titles;

-- Recreate the table to run

-- Create the table, departments first (no FKs or constraints)
CREATE TABLE departments(
	dept_no CHAR(4) PRIMARY KEY NOT NULL,
	dept_name VARCHAR(50) NOT NULL
);


--Table for titles
CREATE TABLE titles(
	title_id CHAR(5) PRIMARY KEY NOT NULL,
	title VARCHAR(30) NOT NULL
);


-- Table for employees
--Don't need to record all foreign key references, would make it circular and this is our parent table
CREATE TABLE employees(
	emp_no INT PRIMARY KEY NOT NULL,
	emp_title_id CHAR(5) NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	sex CHAR(1) NOT NULL,
	hire_date DATE NOT NULL,
	FOREIGN KEY (emp_title_id) REFERENCES titles(title_id)	
);

-- Table dept_manager
CREATE TABLE dept_manager (
	dept_no CHAR(4) NOT NULL,
	emp_no INT PRIMARY KEY NOT NULL,	
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

-- Table dept_emp
CREATE TABLE dept_emp(
	emp_no INT NOT NULL,
	dept_no CHAR(4) NOT NULL,
	PRIMARY KEY (emp_no, dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);


-- Table salaries
CREATE TABLE salaries (
	emp_no INT PRIMARY KEY,
	salary INT NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- 1. List the following details of each employee: employee number, last name, first name, sex, and salary.
--Remember, could also use aliases
SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
FROM employees
JOIN salaries ON employees.emp_no = salaries.emp_no;

-- 2. List first name, last name, and hire date for employees who were hired in 1986.
SELECT first_name, last_name, hire_date
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 1986;

-- 3. List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name.
SELECT dept_manager.dept_no, departments.dept_name, dept_manager.emp_no, employees.last_name, employees.first_name
FROM dept_manager
JOIN departments ON dept_manager.dept_no = departments.dept_no
JOIN employees ON dept_manager.emp_no = employees.emp_no;

-- 4. List the department of each employee with the following information: employee number, last name, first name, and department name.
SELECT employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM employees
JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no;

-- 5. List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' and last_name LIKE 'B%';

-- 6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT * FROM departments;
-- The department number of Sales is d007
SELECT employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM employees
JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_no = 'd007';

-- 7. List all employees in the Sales and Development departments (not mutually exclusive), including their employee number, last name, first name, and department name.
SELECT * FROM departments;
-- The department numbers of Sales and Development departments are d007 and d005
SELECT employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM employees
JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_no = 'd005' or departments.dept_no = 'd007';

-- 8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT last_name, COUNT(last_name) AS "Frequency count"
FROM employees
GROUP BY last_name
ORDER BY "Frequency count" DESC;
