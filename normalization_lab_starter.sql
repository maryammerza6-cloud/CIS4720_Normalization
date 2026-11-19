/* ================================================================
   CIS 4720  Normalization Lab
   Starter file: normalization_lab_starter.sql

   Name: ______________________________
   Date: ______________________________

   Work in this file and keep its name. It lives in your OneDrive
   folder CIS4720_Normalization, and it is the one file you publish
   to GitHub at the end.

   Write a comment in your own words above every statement.
   Total: 10 points.

   For EVERY problem below, complete all five steps:

     Step 1  DIAGNOSE  Which normal form (1NF, 2NF, or 3NF) does the
                       table break? Why? Name the columns involved.
     Step 2  DESIGN    List your new tables. Mark the primary key (PK)
                       and every foreign key (FK).
     Step 3  CREATE    Write a CREATE TABLE statement for each table,
                       with PRIMARY KEY and FOREIGN KEY constraints.
                       Create parent tables before child tables.
     Step 4  INSERT    Insert at least TWO rows into EVERY table.
                       Insert parent rows before child rows.
     Step 5  JOIN      Write one SELECT with JOINs that shows the data
                       from all of the problem's tables together.

   Use ONLY the table names given in each problem.
   The whole file must run from top to bottom without errors.
   ================================================================ */

CREATE DATABASE IF NOT EXISTS misc_db;
USE misc_db;

SELECT DATABASE();
SHOW TABLES;
/* ================================================================
   PROBLEM 1  Pet owners and their pets                 (2 points)
   ================================================================

   A pet grooming shop keeps one table named owner_pets:

     owner_id, owner_name, owner_city, pet1_name, pet2_name, pet3_name

   Sample rows:

   owner_id | owner_name   | owner_city | pet1_name | pet2_name | pet3_name
   =========+==============+============+===========+===========+==========
   1        | Maria Lopez  | Turlock    | Bella     | Max       | NULL
   2        | James Chen   | Modesto    | Luna      | NULL      | NULL
   3        | Priya Singh  | Ceres      | Rocky     | Daisy     | Coco

   The shop just signed up a customer with four pets.

   Use these table names:  owner, pet

   Step 1  DIAGNOSE:
The table breaks 1NF because it has repeating
columns: pet1_name, pet2_name, and pet3_name.
Each pet should have its own row instead.

   Step 2  DESIGN:
owner:
owner_id (PK)
owner_name
owner_city

pet:
pet_id (PK)
owner_id (FK references owner)
pet_name

*/

/* Step 3  CREATE */
-- Create the owner table to store owner information.
CREATE TABLE owner (
    owner_id INT PRIMARY KEY,
    owner_name VARCHAR(50),
    owner_city VARCHAR(50)
);

-- Create the pet table and connect each pet to an owner.
CREATE TABLE pet (
    pet_id INT PRIMARY KEY,
    owner_id INT,
    pet_name VARCHAR(50),
    FOREIGN KEY (owner_id) REFERENCES owner(owner_id)
);

/* Step 4  INSERT */

-- Add the three pet owners.
INSERT INTO owner VALUES
(1, 'Maria Lopez', 'Turlock'),
(2, 'James Chen', 'Modesto'),
(3, 'Priya Singh', 'Ceres');

-- Add the six pets and connect them to their owners.
INSERT INTO pet VALUES
(1, 1, 'Bella'),
(2, 1, 'Max'),
(3, 2, 'Luna'),
(4, 3, 'Rocky'),
(5, 3, 'Daisy'),
(6, 3, 'Coco');
/* Step 5  JOIN */
-- Show each pet together with its owner's information.
SELECT o.owner_id, o.owner_name,
       o.owner_city, p.pet_name
FROM owner o
JOIN pet p ON o.owner_id = p.owner_id;


/* ================================================================
   PROBLEM 2  Apartment buildings and units             (2 points)
   ================================================================

   A property manager keeps one table named building_unit.
   Unit numbers repeat across buildings (every building has a 101),
   so the primary key is (building_id, unit_number).

     building_id, unit_number, building_name, building_address,
     bedrooms, monthly_rent

   Sample rows:

   building_id | unit_number | building_name | building_address  | bedrooms | monthly_rent
   ============+=============+===============+===================+==========+=============
   B1          | 101         | Oak Terrace   | 100 Oak St        | 1        | 1250.00
   B1          | 102         | Oak Terrace   | 100 Oak St        | 2        | 1600.00
   B2          | 101         | Canal Court   | 45 Canal Dr       | 2        | 1550.00
   B2          | 201         | Canal Court   | 45 Canal Dr       | 3        | 1900.00

   Hint: look at which columns need BOTH key columns and which
   need only one of them.

   Use these table names:  building, apartment_unit

   Step 1  DIAGNOSE:

The table breaks 2NF because building_name and
building_address depend only on building_id,
not on the full composite key (building_id,
unit_number).

The bedrooms and monthly_rent depend on both
building_id and unit_number.

   Step 2  DESIGN:

building:
building_id (PK)
building_name
building_address

apartment_unit:
building_id (PK, FK references building)
unit_number (PK)
bedrooms
monthly_rent

Composite primary key: (building_id, unit_number)
*/

/* Step 3  CREATE */

-- Create the building table to store building details.
CREATE TABLE building (
    building_id VARCHAR(5) PRIMARY KEY,
    building_name VARCHAR(50),
    building_address VARCHAR(100)
);

-- Create the apartment_unit table with a composite primary key.
CREATE TABLE apartment_unit (
    building_id VARCHAR(5),
    unit_number INT,
    bedrooms INT,
    monthly_rent DECIMAL(8,2),
    PRIMARY KEY (building_id, unit_number),
    FOREIGN KEY (building_id) REFERENCES building(building_id)
);
/* Step 4  INSERT */
-- Add the two buildings.
INSERT INTO building VALUES
('B1', 'Oak Terrace', '100 Oak St'),
('B2', 'Canal Court', '45 Canal Dr');

-- Add four apartment units to the buildings.
INSERT INTO apartment_unit VALUES
('B1', 101, 1, 1250.00),
('B1', 102, 2, 1600.00),
('B2', 101, 2, 1550.00),
('B2', 201, 3, 1900.00);

/* Step 5  JOIN */

-- Show each apartment unit with its building information.
SELECT b.building_id,
       a.unit_number,
       b.building_name,
       b.building_address,
       a.bedrooms,
       a.monthly_rent
FROM building b
JOIN apartment_unit a
ON b.building_id = a.building_id;

/* ================================================================
   PROBLEM 3  Employees and departments                 (2 points)
   ================================================================

   A company keeps one table named employee_info.
   The primary key is emp_id.

     emp_id, emp_name, hire_year, dept_id, dept_name, dept_phone

   Sample rows:

   emp_id | emp_name      | hire_year | dept_id | dept_name  | dept_phone
   =======+===============+===========+=========+============+=============
   E01    | Linda Park    | 2019      | D10     | Accounting | 209.555.0300
   E02    | Raj Mehta     | 2021      | D20     | Marketing  | 209.555.0400
   E03    | Carlos Vega   | 2022      | D10     | Accounting | 209.555.0300
   E04    | Emma Wilson   | 2024      | D20     | Marketing  | 209.555.0400

   Accounting gets a new phone number. How many rows must change?
   What happens to the Marketing department if Raj and Emma both quit?

   Use these table names:  department, employee

   Step 1  DIAGNOSE:
The table breaks 3NF because dept_name and
dept_phone depend on dept_id, not directly
on emp_id.

This is a transitive dependency:
emp_id → dept_id → dept_name, dept_phone.

If Accounting changes its phone number,
two rows must be updated.

If both Marketing employees quit, the
department information could be lost.

   Step 2  DESIGN:

department:
dept_id (PK)
dept_name
dept_phone

employee:
emp_id (PK)
emp_name
hire_year
dept_id (FK references department)
*/

/* Step 3  CREATE */

-- Create a department table to store department information.
CREATE TABLE department (
    dept_id VARCHAR(5) PRIMARY KEY,
    dept_name VARCHAR(50),
    dept_phone VARCHAR(20)
);

-- Create an employee table linked to departments.
CREATE TABLE employee (
    emp_id VARCHAR(5) PRIMARY KEY,
    emp_name VARCHAR(50),
    hire_year INT,
    dept_id VARCHAR(5),
    FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);
/* Step 4  INSERT */

-- Add the two departments.
INSERT INTO department VALUES
('D10', 'Accounting', '209.555.0300'),
('D20', 'Marketing', '209.555.0400');

-- Add four employees and assign their departments.
INSERT INTO employee VALUES
('E01', 'Linda Park', 2019, 'D10'),
('E02', 'Raj Mehta', 2021, 'D20'),
('E03', 'Carlos Vega', 2022, 'D10'),
('E04', 'Emma Wilson', 2024, 'D20');
/* Step 5  JOIN */

-- Show employee information with department details.
SELECT e.emp_id,
       e.emp_name,
       e.hire_year,
       d.dept_id,
       d.dept_name,
       d.dept_phone
FROM employee e
JOIN department d
ON e.dept_id = d.dept_id;

/* ================================================================
   PROBLEM 4  Students and courses                     (2.5 points)
              This problem REQUIRES a bridge table with a
              composite primary key.
   ================================================================

   A college keeps one table named student_course.
   One student takes many courses, and one course has many students.

     student_id, student_name, student_major, course_id,
     course_name, course_description, units, grade

   Sample rows:

   student_id | student_name | student_major | course_id | course_name        | course_description                 | units | grade
   ===========+==============+===============+===========+====================+====================================+=======+======
   S100       | Ana Torres   | CIS           | CIS4720   | Database Mgmt      | Relational design and SQL          | 3     | A
   S100       | Ana Torres   | CIS           | CIS2000   | Intro to Python    | Programming fundamentals in Python | 3     | B
   S200       | Ben Shah     | Business      | CIS4720   | Database Mgmt      | Relational design and SQL          | 3     | B
   S300       | Chloe Nguyen | CIS           | CIS2000   | Intro to Python    | Programming fundamentals in Python | 3     | A

   Questions to think about:
     Which columns describe only the STUDENT?
     Which columns describe only the COURSE?
     Which column describes "this student in this course"?

   Use these table names:  student, course, enrollment
   enrollment is the bridge table. Its primary key must be the
   composite key (student_id, course_id), and each of those columns
   must also be a foreign key.

   Step 1  DIAGNOSE:

The table breaks 2NF because student_name and
student_major depend only on student_id.

The course_name, course_description, and units
depend only on course_id.

The grade depends on both student_id and
course_id because each student receives a
grade for each course.

We need a bridge table to separate this
many-to-many relationship.

   Step 2  DESIGN:
student:
student_id (PK)
student_name
student_major

course:
course_id (PK)
course_name
course_description
units

enrollment:
student_id (PK, FK references student)
course_id (PK, FK references course)
grade

Composite primary key: (student_id, course_id)

*/

/* Step 3  CREATE */
-- Create a student table to store student information.
CREATE TABLE student (
    student_id VARCHAR(5) PRIMARY KEY,
    student_name VARCHAR(50),
    student_major VARCHAR(50)
);

-- Create a course table to store course information.
CREATE TABLE course (
    course_id VARCHAR(10) PRIMARY KEY,
    course_name VARCHAR(50),
    course_description VARCHAR(100),
    units INT
);

-- Create a bridge table to connect students and courses.
CREATE TABLE enrollment (
    student_id VARCHAR(5),
    course_id VARCHAR(10),
    grade VARCHAR(2),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (course_id) REFERENCES course(course_id)
);

/* Step 4  INSERT
   Enroll at least one student in two courses, and put at least two
   students in the same course, so the many to many relationship shows. */
-- Add three students.
INSERT INTO student VALUES
('S100', 'Ana Torres', 'CIS'),
('S200', 'Ben Shah', 'Business'),
('S300', 'Chloe Nguyen', 'CIS');

-- Add two courses.
INSERT INTO course VALUES
('CIS4720', 'Database Mgmt', 'Relational design and SQL', 3),
('CIS2000', 'Intro to Python', 'Programming fundamentals in Python', 3);

-- Enroll students in courses and record their grades.
INSERT INTO enrollment VALUES
('S100', 'CIS4720', 'A'),
('S100', 'CIS2000', 'B'),
('S200', 'CIS4720', 'B'),
('S300', 'CIS2000', 'A');

/* Step 5  JOIN  (three tables: student, enrollment, course) */
-- Show students, their courses, and their grades.
SELECT s.student_id,
       s.student_name,
       s.student_major,
       c.course_id,
       c.course_name,
       c.course_description,
       c.units,
       e.grade
FROM student s
JOIN enrollment e
ON s.student_id = e.student_id
JOIN course c
ON e.course_id = c.course_id;