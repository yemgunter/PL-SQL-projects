-----Yolanda Gunter ITSE 1345 Oracle 11g PL/SQL -----
---LAB 3 ------
---Part 1 -----
CREATE OR REPLACE PROCEDURE get_emp_data
    (p_empno IN employee.empno%TYPE)
IS
    -- Variable for the row data
    v_employee employee%ROWTYPE;
BEGIN
    -- Get data using a cursor
    SELECT *
    INTO v_employee
    FROM employee
    WHERE empno = p_empno;
    
    -- Output employee data
    DBMS_OUTPUT.PUT_LINE('Employee Number: ' || v_employee.empno);
    DBMS_OUTPUT.PUT_LINE('Emplohee Name: ' || v_employee.ename);
    DBMS_OUTPUT.PUT_LINE('Job Title: ' || v_employee.job);
    DBMS_OUTPUT.PUT_LINE('Hire Date: ' || v_employee.hiredate);
    DBMS_OUTPUT.PUT_LINE('Salary: ' || v_employee.sal);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee: ' || p_empno || ' does not exist.');
END get_emp_data;
/

BEGIN
  get_emp_data(7902);
  get_emp_data(7938);
END;


---Part 2 -----

CREATE OR REPLACE FUNCTION compare_dates
    (p_date1 DATE, 
    p_date2 DATE)
    RETURN INT
IS
    v_result INT;
BEGIN
    -- Compare two dates (ignoring time component)
    IF p_date1 < p_date2 THEN
        v_result := -1;
    ELSIF p_date1 = p_date2 THEN
        v_result := 0;
    ELSE
        v_result := 1;
    END IF;
    RETURN v_result;
END compare_dates;
/

drop function COMPARE_DATES;

BEGIN
    -- Test Case 1: p_date1 < p_date2
    DBMS_OUTPUT.PUT_LINE('Test 1: p_date1 < p_date2');
    DBMS_OUTPUT.PUT_LINE('Result: ' || compare_dates(TO_DATE('2024-12-01', 'YYYY-MM-DD'), TO_DATE('2024-12-10', 'YYYY-MM-DD')));

    -- Test Case 2: p_date1 = p_date2
    DBMS_OUTPUT.PUT_LINE('Test 2: p_date1 = p_date2');
    DBMS_OUTPUT.PUT_LINE('Result: ' || compare_dates(TO_DATE('2024-12-10', 'YYYY-MM-DD'), TO_DATE('2024-12-10', 'YYYY-MM-DD')));

    -- Test Case 3: p_date1 > p_date2
    DBMS_OUTPUT.PUT_LINE('Test 3: p_date1 > p_date2');
    DBMS_OUTPUT.PUT_LINE('Result: ' || compare_dates(TO_DATE('2024-12-15', 'YYYY-MM-DD'), TO_DATE('2024-12-10', 'YYYY-MM-DD')));
END;
/

---Part 3 -----

CREATE OR REPLACE PROCEDURE cust_info
    (p_account_id IN NUMBER)
IS
    -- Declare a record variable to hold customer data
    v_customer customer%ROWTYPE;
BEGIN
    -- Retrieve the customer row based on the account ID
    SELECT *
    INTO v_customer
    FROM customer
    WHERE account_id = p_account_id;

    -- Get customer information
    DBMS_OUTPUT.PUT_LINE('Account ID: ' || v_customer.account_id);
    DBMS_OUTPUT.PUT_LINE('Customer Name: ' || v_customer.cust_name);
    DBMS_OUTPUT.PUT_LINE('Cust ID: ' || v_customer.cust_id);
    DBMS_OUTPUT.PUT_LINE('Account Tupe: ' || v_customer.account_type);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Cust_ID not valid. Returning garbage values.');
        -- Display garbage values
        DBMS_OUTPUT.PUT_LINE('Account ID: ' || NULL);
        DBMS_OUTPUT.PUT_LINE('Customer Name: ' || NULL);
        DBMS_OUTPUT.PUT_LINE('Cust ID: ' || NULL);
        DBMS_OUTPUT.PUT_LINE('Account Tupe: ' || NULL);
END cust_info;
/

DROP PROCEDURE cust_info;

BEGIN
    -- Test with a valid account ID
    DBMS_OUTPUT.PUT_LINE('Testing with valid account ID: 1001');
    cust_info(1001);

    -- Test with an invalid account ID
    DBMS_OUTPUT.PUT_LINE('Testing with invalid account ID: 9999');
    cust_info(9999);
END;
/

---Part 4 -----

DROP TABLE Physician CASCADE CONSTRAINTS;

CREATE TABLE Physician (
    Phys_ID NUMBER(10) PRIMARY KEY,
    Phys_Name VARCHAR2(25),
    Phys_Phone VARCHAR2(15),
    Phys_Specialty VARCHAR2(25));

INSERT INTO Physician (Phys_ID, Phys_Name, Phys_Phone, Phys_Specialty)
VALUES (101, 'Wilcox, Christy', '512-329-1848', 'Throat, Eyes, Ears');

INSERT INTO Physician (Phys_ID, Phys_Name, Phys_Phone, Phys_Specialty)
VALUES (102, 'Nusca, Janie', '512-516-3947', 'Cardiovascular');

INSERT INTO Physician (Phys_ID, Phys_Name, Phys_Phone, Phys_Specialty)
VALUES (103, 'Gomez, Johny', '512-382-4987', 'Orthopedics');

INSERT INTO Physician (Phys_ID, Phys_Name, Phys_Phone, Phys_Specialty)
VALUES (104, 'Li, Jan', '512-516-3948', 'Cardiovascular');

INSERT INTO Physician (Phys_ID, Phys_Name, Phys_Phone, Phys_Specialty)
VALUES (105, 'Simmons, Alex', '512-940-5700', 'Hematology');
COMMIT;

--check data
SELECT * FROM Physician;

--update physician table

DECLARE
    -- Named parameters for input values
    v_phys_id NUMBER(3) := 106;
    v_phys_name VARCHAR2(50) := 'gunter, yolanda';
    v_phys_phone VARCHAR2(15) := '512-348-7936';
    v_phys_specialty VARCHAR2(30) := 'neurology';

    -- Counter to check if the record exists
    v_count NUMBER;
BEGIN
    -- Check if the phys_id already exists in the Physician table
    SELECT COUNT(*)
    INTO v_count
    FROM physician
    WHERE phys_id = v_phys_id;

    IF v_count > 0 THEN
        -- If record exists, update the record
        UPDATE physician
        SET phys_name = v_phys_name,
            phys_phone = v_phys_phone,
            phys_specialty = v_phys_specialty
        WHERE phys_id = v_phys_id;

        DBMS_OUTPUT.PUT_LINE('record updated successfully for phys_id: ' || v_phys_id);
    ELSE
        -- If record does not exist, insert a new record
        INSERT INTO physician (phys_id, phys_name, phys_phone, phys_specialty)
        VALUES (v_phys_id, v_phys_name, v_phys_phone, v_phys_specialty);

        DBMS_OUTPUT.PUT_LINE('record inserted successfully for phys_id: ' || v_phys_id);
    END IF;

    -- Commit the transaction
    COMMIT;
END;
/

----- Part 5 -----

CREATE OR REPLACE FUNCTION adjust_string
    (p_input_string VARCHAR2, 
    p_length NUMBER)
    RETURN VARCHAR2
IS
    v_trimmed_string VARCHAR2(32767);
    v_adjusted_string VARCHAR2(32767);
BEGIN
    -- Step 1 leading spaces, delete them
    v_trimmed_string := LTRIM(p_input_string);

    -- Step 2 specified length is greater than the actual length
    IF LENGTH(v_trimmed_string) < p_length THEN
        -- Pad on the right 
        v_adjusted_string := RPAD(v_trimmed_string, p_length);
    ELSIF LENGTH(v_trimmed_string) > p_length THEN
        -- Truncate 
        v_adjusted_string := SUBSTR(v_trimmed_string, 1, p_length);
    ELSE
        -- No adjustment needed if lengths are equal
        v_adjusted_string := v_trimmed_string;
    END IF;

    -- Return the adjusted string
    RETURN v_adjusted_string;
END adjust_string;
/


BEGIN
    -- Test Case 1: Truncate to length 8
    DBMS_OUTPUT.PUT_LINE('Original: ''When is the Time?'', Adjusted: ''' || adjust_string('When is the Time?', 8) || ''', Length: ' || LENGTH(adjust_string('When is the Time?', 8)));

    -- Test Case 2: Adjust to length 17 (no change needed)
    DBMS_OUTPUT.PUT_LINE('Original: ''When is the Time?'', Adjusted: ''' || adjust_string('When is the Time?', 17) || ''', Length: ' || LENGTH(adjust_string('When is the Time?', 17)));

    -- Test Case 3: Pad to length 30
    DBMS_OUTPUT.PUT_LINE('Original: ''    When is the Time.         '', Adjusted: ''' || adjust_string('    When is the Time.         ', 30) || ''', Length: ' || LENGTH(adjust_string('    When is the Time.         ', 30)));
END;
/
