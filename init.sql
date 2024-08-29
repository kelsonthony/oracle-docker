-- Check if the database is mounted and open
BEGIN
  EXECUTE IMMEDIATE 'ALTER SYSTEM SET local_listener=''LISTENER_TNS''';
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Database is not mounted or open');
END;
/

-- Create user and grant permissions
CREATE USER my_user IDENTIFIED BY my_password;
GRANT CONNECT, RESOURCE TO my_user;
