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
