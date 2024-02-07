# sql_xenonstack

Here we have to run some commands on postgre sql

The schema tables are : 

student (sid, sname, sex, age, year, gpa)
dept (dname, numphds)
prof (pname, dname)
course (cno, dname, cname)
major (dname, sid)
section (dname, cno, sectno, pname)
enroll (sid, dname, cno, sectno, grade)

#ER diagram Link : https://lucid.app/lucidchart/7dfeced7-6762-481b-8bec-e738ef71d018/edit?viewport_loc=83%2C-510%2C4561%2C1587%2C0_0&invitationId=inv_fbc32413-3964-48f0-be79-fd323396aa2e

Queries to run are : 

1. Print the names of professors who work in departments that have fewer than 50 PhD 
students.
2. Print the names of the students with the lowest GPA.
3. For each Computer Sciences class, print the class number, section number, and the average 
gpa of the students enrolled in the class section.
4. Print the names and section numbers of all sections with more than six students enrolled in 
them.
5. Print the name(s) and sid(s) of the student(s) enrolled in the most sections.
6. Print the names of departments that have one or more majors who are under 18 years old.
7. Print the names and majors of students who are taking one of the College Geometry 
courses.
8. For those departments that have no major taking a College Geometry course print the 
department name and the number of PhD students in the department.
9. Print the names of students who are taking both a Computer Sciences course and a 
Mathematics course.
10. Print the age difference between the oldest and the youngest Computer Sciences major.
11. For each department that has one or more majors with a GPA under 1.0, print the name of 
the department and the average GPA of its majors.
12. Print the ids, names and GPAs of the students who are currently taking all the Civil 
Engineering courses.




Steps on postgre sql : 

First of all we have to create database for our work

Then we have to click on "Create script" option right clicking database

Here we will write commands to create tables : 

All commands are : 

	CREATE TABLE student
	(
		sid INT PRIMARY KEY,
		sname VARCHAR(30) ,
		sex CHAR,
		age INT,
		year INT,
		gpa FLOAT
	);
	
	
	CREATE TABLE dept
	(
		dname VARCHAR(50) PRIMARY KEY,
		numphds INT
	);
	
	
	CREATE TABLE prof
	(
		pname VARCHAR(50) PRIMARY KEY,
		dname VARCHAR(50)
	);
	
	
	CREATE TABLE course
	(
		cno INT PRIMARY KEY,
		cname VARCHAR(50),
		dname VARCHAR(50),
		FOREIGN KEY (dname) REFERENCES dept(dname)
	);
	
	
	
	CREATE TABLE major
	(
		dname VARCHAR(50),
		sid INT,
		FOREIGN KEY (dname) REFERENCES dept (dname),
    	FOREIGN KEY (sid) REFERENCES student (sid)
	);
	
	
	
	CREATE TABLE section
	(
		dname VARCHAR(50), 
		cno INT, 
		sectno INT,
		pname VARCHAR(50),
    	FOREIGN KEY (dname) REFERENCES dept (dname),
    	FOREIGN KEY (cno) REFERENCES course (cno)
	);
	
	
	CREATE TABLE enroll
	(
		sid INT,
		grade FLOAT,
		dname VARCHAR(50),
		cno INT,
		sectno INT,
		FOREIGN KEY (sid) REFERENCES student (sid),
    	FOREIGN KEY (dname) REFERENCES dept (dname),
    	FOREIGN KEY (cno) REFERENCES course (cno)
	);


 Now after creating table we have to import data into the tables
 We'll do it by right clicking table and importing respective files
 When all data is successfully imported then you can write answer queries On "create script" option or "PSQL" window tool


 Here are all the answer scripts below : 


	 -- 1: Print the names of professors who work in departments that have fewer than 50 PhD students.
	SELECT pname
	FROM prof
	WHERE dname IN (
	    SELECT dname
	    FROM dept
	    WHERE numphds < 50
	);
	
	-- 2: Print the names of the students with the lowest GPA.
	SELECT sname
	FROM student
	WHERE gpa = (
	    SELECT MIN(gpa)
	    FROM student
	);
	
	-- 3: For each Computer Sciences class, print the class number, section number, and the average GPA of the students enrolled in the class section.
	SELECT e.cno, e.sectno, AVG(s.gpa) AS avg_gpa
	FROM enroll e
	JOIN student s ON e.sid = s.sid
	JOIN course c ON e.cno = c.cno
	WHERE c.dname = 'Computer Sciences'
	GROUP BY e.cno, e.sectno;
	
	-- 4: Print the names and section numbers of all sections with more than six students enrolled in them.
	SELECT s.sname, e.sectno
	FROM enroll e
	JOIN student s ON e.sid = s.sid
	WHERE e.sectno IN (
	    SELECT sectno
	    FROM enroll
	    GROUP BY sectno
	    HAVING COUNT(sid) > 6
	);
	
	-- 5: Print the name(s) and sid(s) of the student(s) enrolled in the most sections.
	SELECT sid, sname 
	FROM student 
	WHERE sid IN(
	SELECT sid
	FROM enroll
	GROUP BY sid
	ORDER BY COUNT(sectno) DESC
	LIMIT 1);
	
	-- 6: Print the names of departments that have one or more majors who are under 18 years old.
	SELECT dname
	FROM dept
	WHERE dname IN (
	    SELECT dname
	    FROM major
	    JOIN student ON major.sid = student.sid
	    WHERE age < 18
	);
	
	-- 7: Print the names and majors of students who are taking one of the College Geometry courses.
	SELECT s.sname, m.dname
	FROM student s
	JOIN major m ON s.sid = m.sid
	JOIN enroll e ON s.sid = e.sid
	JOIN course c ON e.cno = c.cno
	WHERE c.cname LIKE '%College Geometry%';
	
	-- 8: For those departments that have no major taking a College Geometry course print the department name and the number of PhD students in the department.
	SELECT d.dname, d.numphds
	FROM dept d
	JOIN course c ON d.dname=c.dname
	WHERE c.cname NOT LIKE '%College Geometry%';
	
	-- 9: Print the names of students who are taking both a Computer Sciences course and a Mathematics course.
	SELECT s.sname
	FROM student s
	JOIN enroll e1 ON s.sid = e1.sid AND e1.dname='Computer Sciences'
	JOIN enroll e2 ON s.sid = e2.sid AND e2.dname='Mathematics';
	
	-- 10: Print the age difference between the oldest and the youngest Computer Sciences major.
	SELECT MAX(age) - MIN(age) AS age_difference
	FROM student
	WHERE sid IN (
	    SELECT sid
	    FROM major
	    WHERE dname = 'Computer Sciences'
	);
	
	-- 11: For each department that has one or more majors with a GPA under 1.0, print the name of the department and the average GPA of its majors.
	SELECT m.dname, AVG(s.gpa) 
	FROM major m 
	JOIN student s 
	ON s.sid=m.sid 
	WHERE s.sid IN(
	SELECT sid FROM student WHERE gpa < 1.0) 
	GROUP BY m.dname, s.sname;
	
	
	-- 12: Print the ids, names, and GPAs of the students who are currently taking all the Civil Engineering courses.
	SELECT s.sid, s.sname, s.gpa 
	FROM student s 
	JOIN major m 
	ON s.sid=m.sid 
	WHERE m.dname='Civil Engineering';



THANK YOU !
	
