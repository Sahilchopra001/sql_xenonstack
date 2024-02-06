-- Database: xenonstack

-- DROP DATABASE IF EXISTS xenonstack;

CREATE DATABASE xenonstack
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_India.1252'
    LC_CTYPE = 'English_India.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
	
	
	
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
	