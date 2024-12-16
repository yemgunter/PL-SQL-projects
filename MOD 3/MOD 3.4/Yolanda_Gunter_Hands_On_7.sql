----Assignment 7-1: Creating a Package ------

CREATE OR REPLACE PACKAGE order_info_pkg IS
 FUNCTION ship_name_pf  
   (p_basket IN NUMBER)
   RETURN VARCHAR2;
 PROCEDURE basket_info_pp
  (p_basket IN NUMBER,
   p_shop OUT NUMBER,
   p_date OUT DATE);
END;

CREATE OR REPLACE PACKAGE BODY order_info_pkg 
    IS
 FUNCTION ship_name_pf  
   (p_basket IN NUMBER)
   RETURN VARCHAR2
  IS
   lv_name_txt VARCHAR2(25);
 BEGIN
  SELECT shipfirstname||' '||shiplastname
   INTO lv_name_txt
   FROM bb_basket
   WHERE idBasket = p_basket;
  RETURN lv_name_txt;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('Invalid basket id');
 END ship_name_pf;
 PROCEDURE basket_info_pp
  (p_basket IN NUMBER,
   p_shop OUT NUMBER,
   p_date OUT DATE)
  IS
 BEGIN
   SELECT idshopper, dtordered
    INTO p_shop, p_date
    FROM bb_basket
    WHERE idbasket = p_basket;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('Invalid basket id');
 END basket_info_pp;
END;


----Assignment 7-2: Using Program Units in a Package ------

DECLARE
    lv_shopper_id NUMBER;      -- Variable for OUT parameter (shopper ID)
    lv_ord_date DATE;          -- Variable for OUT parameter (order date)
    lv_recip_name VARCHAR2(25); -- Variable for function return value
BEGIN
    -- Call function for recipient's name
    lv_recip_name := order_info_pkg.ship_name_pf(12);
    DBMS_OUTPUT.PUT_LINE(lv_recip_name);

    -- Call  procedure for shopper ID and order date
    order_info_pkg.basket_info_pp(12, lv_shopper_id, lv_ord_date);
    DBMS_OUTPUT.PUT_LINE(lv_shopper_id);
    DBMS_OUTPUT.PUT_LINE(lv_ord_date);
END;
/

SELECT order_info_pkg.ship_name_pf(idbasket) AS recipient_name
FROM bb_basket
WHERE idbasket = 12;



---Assignment 7-3: Creating a Package with Private Program Units ----


SELECT order_info_pkg.ship_name_pf(idbasket) AS recipient_name
FROM bb_basket
WHERE idbasket = 4;

CREATE OR REPLACE PACKAGE order_info_pkg IS
--Take out function ship_name_pf
 PROCEDURE basket_info_pp
  (p_basket IN NUMBER,
   p_shop OUT NUMBER,
   p_date OUT DATE,
   p_ship_name OUT VARCHAR);--variable to return name order shipped by
END;
/
CREATE OR REPLACE PACKAGE BODY order_info_pkg IS
 FUNCTION ship_name_pf  
   (p_basket IN NUMBER)
   RETURN VARCHAR2
  IS
   lv_name_txt VARCHAR2(25);
 BEGIN
  SELECT shipfirstname||' '||shiplastname
   INTO lv_name_txt
   FROM bb_basket
   WHERE idBasket = p_basket;
  RETURN lv_name_txt;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('Invalid basket id');
 END ship_name_pf;
 PROCEDURE basket_info_pp
  (p_basket IN NUMBER,
   p_shop OUT NUMBER,
   p_date OUT DATE,
   p_ship_name OUT VARCHAR) --variable to return name order shipped by
  IS
 BEGIN
   SELECT idshopper, dtordered
    INTO p_shop, p_date
    FROM bb_basket
    WHERE idbasket = p_basket;
    p_ship_name := ship_name_pf(p_basket); -- for p_ship_name variable
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('Invalid basket id');
 END basket_info_pp;
END;
/


DECLARE
    lv_shopper_id NUMBER;        -- Variable to store the shopper ID
    lv_ord_date DATE;            -- Variable to store the order date
    lv_ship_name VARCHAR2(25);   -- Variable to store the shipped-to name
BEGIN
    -- Call the BASKET_INFO_PP procedure
    order_info_pkg.basket_info_pp(
        p_basket => 4,          -- Basket ID to test
        p_shop => lv_shopper_id,
        p_date => lv_ord_date,
        p_ship_name => lv_ship_name
    );

    -- Display the returned values using DBMS_OUTPUT
    DBMS_OUTPUT.PUT_LINE(lv_shopper_id);
    DBMS_OUTPUT.PUT_LINE(lv_ord_date);
    DBMS_OUTPUT.PUT_LINE(lv_ship_name);
END;
/


-----Assignment 7-4: Using Packaged Variables  ----

CREATE OR REPLACE FUNCTION verify_logon (
    p_username IN VARCHAR2,
    p_password IN VARCHAR2) 
    RETURN CHAR
IS
    lv_verify_user bb_shopper.username%TYPE := 'N'; -- Default value to 'N'
    verified char(1) := 'N';
BEGIN
    SELECT p_username
    INTO lv_verify_user
    FROM bb_shopper
    WHERE password = p_password;
     
    verified := 'Y';
    RETURN verified;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Logon values are invalid.');
END verify_logon;
/
Drop function verify_logon;


DECLARE
    lv_confirm CHAR(1);
BEGIN
    lv_confirm := verify_logon('gma1', 'goofy');
    DBMS_OUTPUT.PUT_LINE('Logon verified?: ' || lv_confirm);
END;
/

--- Place Function in Package with Packaged Variables---

CREATE OR REPLACE PACKAGE login_pkg IS
    lv_shopper_id NUMBER; --Variable for idshopper
    lv_zip_prefix VARCHAR2(3); --Variable for first three of zip

    -- Function declaration
    FUNCTION verify_logon (
        p_username IN VARCHAR2,
        p_password IN VARCHAR2) 
        RETURN CHAR;
END login_pkg;
/

CREATE OR REPLACE PACKAGE BODY login_pkg IS
    FUNCTION verify_logon (
        p_username IN VARCHAR2,
        p_password IN VARCHAR2) 
        RETURN CHAR
    IS
        lv_verify_user bb_shopper.username%TYPE := 'N'; -- Default value to 'N'
        verified char(1) := 'N';
       
    BEGIN
        SELECT p_username, idshopper, SUBSTR(zipcode, 1, 3)
        INTO lv_verify_user, lv_shopper_id, lv_zip_prefix
        FROM bb_shopper
        WHERE password = p_password;
         
        verified := 'Y';
        RETURN verified;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Logon values are invalid.');
            RETURN verified;
    END verify_logon;
END login_pkg;
/

DECLARE
    confirm CHAR(1);
BEGIN
    -- Test the verify_logon function with a sample username and password
    confirm := login_pkg.verify_logon('gma1', 'goofy');

    -- Display the function result
    DBMS_OUTPUT.PUT_LINE('Logon Result: ' || confirm);

    -- Display the values of packaged variables
    DBMS_OUTPUT.PUT_LINE('Shopper ID: ' || login_pkg.lv_shopper_id);
    DBMS_OUTPUT.PUT_LINE('ZIP Prefix: ' || login_pkg.lv_zip_prefix);
END;
/

----Assignment 7-5: Overloading Packaged Procedures----

CREATE OR REPLACE PACKAGE shop_query_pkg IS
    -- Procedure to get shopper information by shopper ID
    PROCEDURE get_shopper_info
        (p_shopper_id IN NUMBER,--Numeric IN parameter                   
        p_name OUT VARCHAR2, 
        p_city OUT VARCHAR2, 
        p_state OUT VARCHAR2, 
        p_phone OUT VARCHAR2, 
        p_email OUT VARCHAR2);

    -- Procedure to get shopper information by last name
    PROCEDURE get_shopper_info
        (p_last_name IN VARCHAR2,--Character IN parameter
        p_name OUT VARCHAR2, 
        p_city OUT VARCHAR2, 
        p_state OUT VARCHAR2, 
        p_phone OUT VARCHAR2, 
        p_email OUT VARCHAR2);
END;
/

CREATE OR REPLACE PACKAGE BODY shop_query_pkg 
    IS
    PROCEDURE get_shopper_info --Get shopper info by ID
        (p_shopper_id IN NUMBER,                         
        p_name OUT VARCHAR2, 
        p_city OUT VARCHAR2, 
        p_state OUT VARCHAR2, 
        p_phone OUT VARCHAR2, 
        p_email OUT VARCHAR2)
    IS
    BEGIN
        SELECT firstname || ' ' || lastname, city, state, phone, email
        INTO p_name, p_city, p_state, p_phone, p_email
        FROM bb_shopper
        WHERE idshopper = p_shopper_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Shopper ID not found.');
    END get_shopper_info;
    
    PROCEDURE get_shopper_info
        (p_last_name IN VARCHAR2,           
        p_name OUT VARCHAR2, 
        p_city OUT VARCHAR2, 
        p_state OUT VARCHAR2, 
        p_phone OUT VARCHAR2, 
        p_email OUT VARCHAR2)
    IS
    BEGIN
        SELECT firstname || ' ' || lastname, city, state, phone, email
        INTO p_name, p_city, p_state, p_phone, p_email
        FROM bb_shopper
        WHERE lastname = p_last_name;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Shopper with last name not found.');
    END get_shopper_info;
END shop_query_pkg;
/

DROP PACKAGE shop_query_pkg; 


----- TEST 1 ----

DECLARE
    v_name VARCHAR2(50);
    v_city VARCHAR2(50);
    v_state VARCHAR2(50);
    v_phone VARCHAR2(15);
    v_email VARCHAR2(50);
BEGIN
    -- Call the procedure with shopper ID
    shop_query_pkg.get_shopper_info(23, v_name, v_city, v_state, v_phone, v_email);

    -- Display the shopper information
    DBMS_OUTPUT.PUT_LINE('Shopper Name: ' || v_name);
    DBMS_OUTPUT.PUT_LINE('City: ' || v_city);
    DBMS_OUTPUT.PUT_LINE('State: ' || v_state);
    DBMS_OUTPUT.PUT_LINE('Phone: ' || v_phone);
    DBMS_OUTPUT.PUT_LINE('Email: ' || v_email);
END;
/

----- TEST 2 -----

DECLARE
    v_name VARCHAR2(50);
    v_city VARCHAR2(50);
    v_state VARCHAR2(50);
    v_phone VARCHAR2(15);
    v_email VARCHAR2(50);
BEGIN
    -- Call the procedure with last name
    shop_query_pkg.get_shopper_info('Ratman', v_name, v_city, v_state, v_phone, v_email);

    -- Display the shopper information
    DBMS_OUTPUT.PUT_LINE('Shopper Name: ' || v_name);
    DBMS_OUTPUT.PUT_LINE('City: ' || v_city);
    DBMS_OUTPUT.PUT_LINE('State: ' || v_state);
    DBMS_OUTPUT.PUT_LINE('Phone: ' || v_phone);
    DBMS_OUTPUT.PUT_LINE('Email: ' || v_email);
END;
/



------Assignment 7-6: Creating a Package with Only a Specification -----

CREATE OR REPLACE PACKAGE tax_rate_pkg IS
    -- Packaged constants for tax rates
    pv_tax_nc CONSTANT NUMBER := 0.035; -- North Carolina
    pv_tax_tx CONSTANT NUMBER := 0.05;  -- Texas
    pv_tax_tn CONSTANT NUMBER := 0.02;  -- Tennessee
END tax_rate_pkg;
/

BEGIN
    -- Display the values of the tax rates
    DBMS_OUTPUT.PUT_LINE('Tax Rate for NC: ' || tax_rate_pkg.pv_tax_nc);
    DBMS_OUTPUT.PUT_LINE('Tax Rate for TX: ' || tax_rate_pkg.pv_tax_tx);
    DBMS_OUTPUT.PUT_LINE('Tax Rate for TN: ' || tax_rate_pkg.pv_tax_tn);
END;
/

------Assignment 7-7: Using a Cursor in a Package -------

CREATE OR REPLACE PACKAGE tax_rate_pkg IS
    -- Packaged cursor 
    CURSOR tax_cursor IS
        SELECT taxrate, state
        FROM bb_tax;

    -- Function for a specific state
    FUNCTION get_tax_rate
        (pv_state in bb_tax.state%TYPE) 
        RETURN bb_tax.taxrate%TYPE;
END;
/

CREATE OR REPLACE PACKAGE BODY tax_rate_pkg IS
    -- Function to get tax rate
    FUNCTION get_tax_rate
        (pv_state in bb_tax.state%TYPE) 
        RETURN bb_tax.taxrate%TYPE
        IS
            pv_tax_rate bb_tax.taxrate%TYPE := 0; -- Default tax rate
    BEGIN
        -- Loop through cursor for matching state
        FOR rec_tax IN tax_cursor LOOP
            IF rec_tax.state = pv_state THEN
                pv_tax_rate := rec_tax.taxrate;
                 
            END IF;
        END LOOP;

        RETURN pv_tax_rate; -- Return the tax rate or 0
    END get_tax_rate;
END tax_rate_pkg;
/
----TEST PACKAGED FUNCTION ----
BEGIN
    DBMS_OUTPUT.PUT_LINE('NC'||' '||tax_rate_pkg.get_tax_RATE('NC'));
END;
/

----Assignment 7-8: Using a One-Time-Only Procedure in a Package----

CREATE OR REPLACE PACKAGE login_pkg IS
    pv_id_num NUMBER(3);             -- Packaged variable for ID
    pv_logon_time TIMESTAMP;         -- Packaged variable for logon timestamp

    -- Function declaration
    FUNCTION login_ck_pf 
        (p_user IN VARCHAR2,
        p_pass IN VARCHAR2) 
        RETURN CHAR;

    -- One-time-only procedure declaration
    PROCEDURE set_logon_time;
END login_pkg;
/

CREATE OR REPLACE PACKAGE BODY login_pkg IS
    -- Function implementation
    FUNCTION login_ck_pf 
        (p_user IN VARCHAR2,
        p_pass IN VARCHAR2) 
        RETURN CHAR
    IS
        lv_ck_txt CHAR(1) := 'N';    -- Default value
        lv_id_num NUMBER(5);         -- Local variable for ID
    BEGIN
        SELECT idShopper
        INTO lv_id_num
        FROM bb_shopper
        WHERE username = p_user
          AND password = p_pass;

        -- Set values upon successful logon
        lv_ck_txt := 'Y';
        pv_id_num := lv_id_num;

        -- Call the one-time-only procedure to set the logon time
        set_logon_time;

        RETURN lv_ck_txt;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN lv_ck_txt;       -- Return 'N' if no match
    END login_ck_pf;

    -- One-time-only procedure implementation
    PROCEDURE set_logon_time IS
    BEGIN
        IF pv_logon_time IS NULL THEN
            pv_logon_time := SYSTIMESTAMP; -- Set logon timestamp
        END IF;
    END set_logon_time;
END login_pkg;
/

-- anonymous block for testing
BEGIN
    -- Call the login function to trigger the one-time procedure
    IF login_pkg.login_ck_pf('gma1', 'goofy') = 'Y' THEN
        DBMS_OUTPUT.PUT_LINE('Logon Time: ' || login_pkg.pv_logon_time);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Logon Failed');
    END IF;
END;
/


BEGIN
    -- Call the login function to trigger the one-time procedure
    IF login_pkg.login_ck_pf('gma1', 'goofy') = 'Y' THEN
        DBMS_OUTPUT.PUT_LINE('Logon Successful');
        DBMS_OUTPUT.PUT_LINE('Logon Time: ' || TO_CHAR(login_pkg.pv_logon_time, 'MM-DD-YYYY HH24:MI:SS'));
    ELSE
        DBMS_OUTPUT.PUT_LINE('Logon Failed');
    END IF;
END;
