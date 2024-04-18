-- Create users for different roles

-- Create an administrator user
CREATE USER admin_user WITH PASSWORD 'admin_password';
GRANT administrator TO admin_user;

-- Create a faculty member user
CREATE USER faculty_user WITH PASSWORD 'faculty_password';
GRANT faculty_member TO faculty_user;

-- Create a student user
CREATE USER student_user WITH PASSWORD 'student_password';
GRANT student TO student_user;
