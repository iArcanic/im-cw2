-- Create the Student table
CREATE TABLE IF NOT EXISTS student_info.Student (
  student_id SERIAL PRIMARY KEY,
  first_name TEXT,
  last_name TEXT,
  date_of_birth DATE,
  address TEXT,
  year_of_study INTEGER
);

-- Create the User_Roles table
CREATE TABLE IF NOT EXISTS student_info.User_Roles (
  role_id SERIAL PRIMARY KEY,
  role_name TEXT NOT NULL UNIQUE
);

-- Create the Users table
CREATE TABLE IF NOT EXISTS student_info.Users (
  user_id SERIAL PRIMARY KEY,
  username TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  role_id INTEGER NOT NULL,
  FOREIGN KEY (role_id) REFERENCES student_info.User_Roles (role_id)
);

-- Create the Audit_Trail table
CREATE TABLE IF NOT EXISTS student_info.Audit_Trail (
  audit_id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  table_name TEXT NOT NULL,
  record_id INTEGER NOT NULL,
  action TEXT NOT NULL,
  change_details JSON,
  change_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES student_info.Users (user_id)
);
