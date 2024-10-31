SET SERVEROUTPUT ON;
DECLARE

    today DATE := SYSDATE;

BEGIN

    DBMS_OUTPUT.PUT_LINE('This is my first PLSQL GIT file');
    DBMS_OUTPUT.PUT_LINE('Today''s date is:' || today);


END;
/