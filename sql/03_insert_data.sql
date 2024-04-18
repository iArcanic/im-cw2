-- Insert sample data into the Student table
INSERT INTO student_info.Student (first_name, last_name, date_of_birth, address, year_of_study)
VALUES
  ('John', 'Doe', '2000-01-01', '123 Main St', 1),
  ('Jane', 'Smith', '2001-05-15', '456 Oak Rd', 2),
  ('Michael', 'Johnson', '1999-12-31', '789 Elm St', 3),
  ('Emily', 'Williams', '2002-06-30', '321 Pine Ave', 1),
  ('David', 'Brown', '2001-09-20', '654 Maple Ln', 2);

-- Insert sample data into the User_Roles table
INSERT INTO student_info.User_Roles (role_name)
VALUES
  ('Administrator'),
  ('Faculty'),
  ('Student');

-- Insert sample data into the Users table
INSERT INTO student_info.Users (username, password, role_id)
VALUES
  ('admin', 'changeme', 1),
  ('faculty01', 'faculty123', 2),
  ('faculty02', 'faculty456', 2),
  ('student01', 'student123', 3),
  ('student02', 'student456', 3);