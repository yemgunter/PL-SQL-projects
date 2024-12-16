Yolanda Gunter ITSE 1345 Lab 2

----01----

CREATE TABLE Theater (
    lv_row NUMBER(10)
);

CREATE SEQUENCE th_list_seq
    INCREMENT BY 1
    START WITH 1;


DECLARE
    list# NUMBER := th_list_seq.nextval;
    C_XYZ CONSTANT NUMBER(10) := 10;
    V_Counter1 BINARY_INTEGER;
    V_Row_number Theater.lv_row%TYPE;
    lv_StringA VARCHAR2(50); -- can't use the keyword String
BEGIN   
     NULL;
END;

----02----

CREATE TABLE Student (
    Stu_ID NUMBER(8) PRIMARY KEY,
    Lname VARCHAR2(12),
    Fname VARCHAR2(12),
    Mi CHAR(1),
    Sex CHAR(1),
    Major VARCHAR2(12),
    Home_State VARCHAR2(12)
);

INSERT INTO Student VALUES (10011, 'Schmitt', 'Peter', 'M', 'M', 'History', 'Ok.');
INSERT INTO Student VALUES (10012, 'Jones', 'Samson', 'A', 'M', 'English', 'Fl');
INSERT INTO Student VALUES (10013, 'Peters', 'Amy', 'A', 'F', 'English', 'Me');
INSERT INTO Student VALUES (10014, 'Johnson', 'John', 'J', 'M', 'CompSci', 'Ca');
INSERT INTO Student VALUES (10015, 'Penders', 'Alton', 'P', 'F', 'Math', 'Ga');
INSERT INTO Student VALUES (10016, 'Allen', 'Diana', 'J', 'F', 'Geography', 'Minn');
INSERT INTO Student VALUES (10017, 'Gillis', 'Jennifer', NULL, 'F', 'CompSci', 'Tx');
INSERT INTO Student VALUES (10018, 'Johns', 'Roberta', NULL, 'F', 'CompSci', 'Tx');
INSERT INTO Student VALUES (10019, 'Wise', 'Paula', NULL, 'M', 'Math', 'Cal');
INSERT INTO Student VALUES (10020, 'Evan', 'Richmond', NULL, 'M', 'English', 'Tx');

CREATE TABLE Course (
    Course_ID VARCHAR2(12) PRIMARY KEY,
    Section# VARCHAR2(10),
    C_Name VARCHAR2(25),
    C_Description VARCHAR2(30)
);

INSERT INTO Course VALUES ('COSC1301', '001', 'Intro to Comp.', 'First Computer Course');
INSERT INTO Course VALUES ('ITSE2356', '001', 'Intro to DBA', 'Database Course');
INSERT INTO Course VALUES ('GEOG1791', '002', 'World Geography', 'Second Geography Course');
INSERT INTO Course VALUES ('COSC1315', '001', 'Intro to Prog.', 'Second Computer Course');
INSERT INTO Course VALUES ('ITSE1345', '001', 'Intro to DB Prog.', 'Second Database Course');
INSERT INTO Course VALUES ('ENGL2024', '002', 'English Literature', 'Second English Course');	
INSERT INTO Course VALUES ('MATH1102', '001', 'Calculus II', 'Second Math Course');
INSERT INTO Course VALUES ('ENGL1001', '001', 'American Literature', 'First English Course');
INSERT INTO Course VALUES ('MATH1011', '001', 'Trig and Algebra', 'First Math Course');
INSERT INTO Course VALUES ('GEOG1010', '001', 'Texas Geography', 'First Geography Course');


CREATE TABLE Student_Course (
    Stu_ID NUMBER(10),
    Course_ID VARCHAR2(10),
    Section# VARCHAR2(12),
    PRIMARY KEY (Stu_ID, Course_ID, Section#),
    FOREIGN KEY (Stu_ID) REFERENCES Student(Stu_ID),
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID)
);
 
INSERT INTO Student_Course VALUES (10011, 'MATH1101', '001');
INSERT INTO Student_Course VALUES (10012, 'ENGL2024', '002');
INSERT INTO Student_Course VALUES (10013, 'ENGL1001', '001');
INSERT INTO Student_Course VALUES (10013, 'ENGL2024', '002');
INSERT INTO Student_Course VALUES (10013, 'GEOG1010', '001');
INSERT INTO Student_Course VALUES (10014, 'COSC1315', '001');
INSERT INTO Student_Course VALUES (10015, 'MATH1101', '001');
INSERT INTO Student_Course VALUES (10016, 'GEOG1010', '001');
INSERT INTO Student_Course VALUES (10016, 'GEOG1791', '002');
INSERT INTO Student_Course VALUES (10017, 'COSC1315', '001');
INSERT INTO Student_Course VALUES (10017, 'ITSE2356', '001');
INSERT INTO Student_Course VALUES (10018, 'COSC1315', '001');
INSERT INTO Student_Course VALUES (10019, 'ITSE2356', '001');
INSERT INTO Student_Course VALUES (10020, 'ENGL2024', '002'); 
 
 
SELECT * FROM Student;
SELECT * FROM Course;
SELECT * FROM Student_Course;

DESC Student;
DESC Course;
DESC Student_Course;
 
 -----Part 3 ---
 
DECLARE
    -- Variables to store student details and course count
    lv_Stu_ID      Student.STU_ID%TYPE;
    lv_Full_Name   VARCHAR2(25);
    Num_Courses   NUMBER(2);
BEGIN
    -- Loop through all students in the Student table
    FOR student_rec IN (SELECT STU_ID, FNAME || ' ' || LNAME AS Full_Name FROM Student) LOOP
        -- Count the number of courses the student is enrolled in
        SELECT COUNT(*)
        INTO Num_Courses
        FROM Student_Course
        WHERE STU_ID = student_rec.STU_ID;

        -- Display the student's ID, full name, and course count
        DBMS_OUTPUT.PUT_LINE(
            'Student ID: ' || student_rec.STU_ID || ', Name: ' || student_rec.Full_Name ||
            ' is enrolled in ' || Num_Courses || ' course(s).'
        );
    END LOOP;
END;

 -----Part 4 ---
 
 DECLARE
    -- Variables to store total student 
    Num_Students   NUMBER(2);
BEGIN
        -- Count the number of courses the student is enrolled in
        SELECT COUNT(*)
        INTO Num_Students
        FROM Student;
        
        DBMS_OUTPUT.PUT_LINE('Number of students enrolled is: ' || Num_Students);
END;
 
 -----Part 5 ---
 
 DECLARE
    -- Variable to store number of courses
    Num_Courses NUMBER(5);
BEGIN
    -- Count number of courses in the Student_Course table
    SELECT COUNT(*)
    INTO Num_Courses
    FROM Student_Course;

    -- Analyze if there are greater than or less than 10 courses
    IF Num_Courses > 10 THEN
        DBMS_OUTPUT.PUT_LINE('More than 10 courses have been established.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Less than 10 courses established.');
    END IF;
END;

---Part 6 ---

DECLARE
    -- Variables to store student state and count
    lv_Full_Name VARCHAR2(25);
    lv_Home_State Student.HOME_STATE%TYPE;
    InState_Count NUMBER(5) := 0;
    OutState_Count NUMBER(5) := 0;
BEGIN
    -- Loop through students in Student table
    FOR student_rec IN (SELECT FNAME || ' ' || LNAME AS Full_Name, HOME_STATE FROM Student) LOOP
        -- Check if from Texas
        IF student_rec.HOME_STATE = 'Tx' THEN
            DBMS_OUTPUT.PUT_LINE(student_rec.Full_Name || ' is an in-state Texas student.');
            InState_Count := InState_Count + 1;
        ELSE
            DBMS_OUTPUT.PUT_LINE(student_rec.Full_Name || ' is not an in-state Texas student.');
            OutState_Count := OutState_Count + 1;
        END IF;
    END LOOP;

    -- Print the total counts of in-state and out-of-state students
    DBMS_OUTPUT.PUT_LINE('Total in-state Texas students: ' || InState_Count);
    DBMS_OUTPUT.PUT_LINE('Total out-of-state students: ' || OutState_Count);
END;

---Part 7 ---
 
DECLARE
    -- Named parameters with variable name for student ID and course ID
    p_Stu_ID Student.STU_ID%TYPE := 10016;  -- Example student ID
    p_Course_ID Course.COURSE_ID%TYPE := 'ITSE1345';  -- Example course ID

    -- Variable for count of resulting records
    Num_Records NUMBER(1);
    -- Variable for student full name for more personal touch 
    lv_Full_Name VARCHAR2(30);
BEGIN
    -- Get student's full name
    SELECT FNAME || ' ' || LNAME AS Full_Name
    INTO lv_Full_Name
    FROM Student
    WHERE Stu_ID = p_Stu_ID;
    
    -- Check if student is registered for specified course
    SELECT COUNT(*)
    INTO Num_Records
    FROM Student_Course
    WHERE STU_ID = p_Stu_ID AND COURSE_ID = p_Course_ID;

    -- Output the result
    IF Num_Records > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Student ID ' || p_Stu_ID || ' ' ||  lv_Full_Name ||  ' is registered in course ' || p_Course_ID || '.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Student ID ' || p_Stu_ID || ' ' || lv_Full_Name ||  ' is NOT registered in course ' || p_Course_ID || '.');
    END IF;
END;


 
DECLARE
    -- Named parameters with variable name for student ID and course ID
    p_Stu_ID Student.STU_ID%TYPE := 10018;  -- Example student ID
    p_Course_ID Course.COURSE_ID%TYPE := 'COSC1315';  -- Example course ID

    -- Variable for count of resulting records
    Num_Records NUMBER(1);
    -- Variable for student full name for more personal touch 
    lv_Full_Name VARCHAR2(30);
BEGIN
    -- Get student's full name
    SELECT FNAME || ' ' || LNAME AS Full_Name
    INTO lv_Full_Name
    FROM Student
    WHERE Stu_ID = p_Stu_ID;
    
    -- Check if student is registered for specified course
    SELECT COUNT(*)
    INTO Num_Records
    FROM Student_Course
    WHERE STU_ID = p_Stu_ID AND COURSE_ID = p_Course_ID;

    -- Output the result
    IF Num_Records > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Student ID ' || p_Stu_ID || ' ' ||  lv_Full_Name ||  ' is registered in course ' || p_Course_ID || '.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Student ID ' || p_Stu_ID || ' ' || lv_Full_Name ||  ' is NOT registered in course ' || p_Course_ID || '.');
    END IF;
END;
 
 
 
--- Part 8 ---

DECLARE
    -- Variables for student details
    lv_Full_Name VARCHAR2(30);
    lv_Sex VARCHAR2(15);
    lv_Major Student.MAJOR%TYPE;
    lv_Major_Type VARCHAR2(25);
BEGIN
    -- Loop through Student table for gender data
    FOR student_rec IN (SELECT FNAME || ' ' || LNAME AS Full_Name, SEX, MAJOR FROM Student) LOOP
        lv_Full_Name := student_rec.Full_Name;
        lv_Sex := student_rec.SEX;
        lv_Major := student_rec.MAJOR;

        -- Pull data on student's gender
        IF lv_Sex = 'M' THEN 
            lv_Sex := ' is a male';
        ELSE
            lv_Sex := ' is a female';
        END IF;

        -- Pull data on student's major
    CASE
        WHEN lv_Major = 'Math' THEN lv_Major_Type := 'Math Major';
        WHEN lv_Major = 'English' THEN lv_Major_Type := 'English Major';
        WHEN lv_Major = 'CompSci' THEN lv_Major_Type := 'Computer Science Major';
        WHEN lv_Major = 'Geography' THEN lv_Major_Type := 'Geography Major';
        ELSE lv_Major_Type := 'Undeclared Major';
     END CASE;

        DBMS_OUTPUT.PUT_LINE(lv_Full_Name || lv_Sex ||  ' declared as a ' || lv_Major_Type || '.');
    END LOOP;
END;


--- Part 9 ----

DECLARE
    -- Variables for student details
    lv_Full_Name VARCHAR2(30);
    lv_Sex VARCHAR2(15);
    lv_Major Student.MAJOR%TYPE;
    lv_Major_Type VARCHAR2(25);
BEGIN
    -- Loop through Student table for gender data
    FOR student_rec IN (SELECT FNAME || ' ' || LNAME AS Full_Name, SEX, MAJOR FROM Student) LOOP
        lv_Full_Name := student_rec.Full_Name;
        lv_Sex := student_rec.SEX;
        lv_Major := student_rec.MAJOR;

        -- Pull data on student's gender
        IF lv_Sex = 'M' THEN 
            lv_Sex := ' is a male';
        ELSE
            lv_Sex := ' is a female';
        END IF;

        -- Pull data on student's major using IF and ELSE IF
        IF lv_Major = 'Math' THEN
            lv_Major_Type := 'Math Major';
        ELSIF lv_Major = 'English' THEN
            lv_Major_Type := 'English Major';
        ELSIF lv_Major = 'CompSci' THEN
            lv_Major_Type := 'Computer Science Major';
        ELSIF lv_Major = 'Geography' THEN
            lv_Major_Type := 'Geography Major';
        ELSE
            lv_Major_Type := 'Undeclared Major';
        END IF;

        DBMS_OUTPUT.PUT_LINE(lv_Full_Name || lv_Sex ||  ' declared as a ' || lv_Major_Type || '.');
    END LOOP;
END;
/

---Part 10 ---

CREATE TABLE Temp_Student AS SELECT * FROM Student;

DECLARE
    -- Variables to handle temporary table and loop counter
    lv_Counter NUMBER := 0;
    lv_Total_Rows NUMBER;
BEGIN
    -- Create a temporary table for the student data
    

    -- Get the total number of rows in the Student table
    SELECT COUNT(*) INTO lv_Total_Rows FROM Student;

    -- Loop through each student and insert into the temporary table
    FOR student_rec IN (SELECT * FROM Student) LOOP
        INSERT INTO Temp_Student (STU_ID, LNAME, FNAME, MI, SEX, MAJOR, HOME_STATE)
        VALUES (student_rec.STU_ID, student_rec.LNAME, student_rec.FNAME, student_rec.MI, student_rec.SEX, student_rec.MAJOR, student_rec.HOME_STATE);

        -- Increment the counter
        lv_Counter := lv_Counter + 1;

        -- Output progress
        DBMS_OUTPUT.PUT_LINE('Inserted student ID ' || student_rec.STU_ID || ' into temporary table.');

        -- Exit the loop when the counter matches the total rows
        IF lv_Counter = lv_Total_Rows THEN
            EXIT;
        END IF;
    END LOOP;

    -- Output final results
    DBMS_OUTPUT.PUT_LINE('Total students processed: ' || lv_Counter);

END;


SELECT * FROM Temp_Student;
