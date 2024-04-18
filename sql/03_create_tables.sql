-- Create the Student table
CREATE TABLE IF NOT EXISTS student_info.Students (
  student_id SERIAL PRIMARY KEY,
  name TEXT,
  date_of_birth DATE,
  address TEXT,
  year_of_study INTEGER
);

-- Create the Audit_Trail table
CREATE TABLE IF NOT EXISTS student_info.Audit_Trail (
  audit_id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  table_name TEXT NOT NULL,
  record_id INTEGER NOT NULL,
  action TEXT NOT NULL,
  change_details JSON,
  change_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create the Departments table
CREATE TABLE IF NOT EXISTS student_info.Departments (
  department_id SERIAL PRIMARY KEY,
  department_name TEXT NOT NULL
);

-- Create the Courses table
CREATE TABLE IF NOT EXISTS student_info.Courses (
  course_id SERIAL PRIMARY KEY,
  course_name TEXT NOT NULL,
  department_id INTEGER NOT NULL,
  FOREIGN KEY (department_id) REFERENCES student_info.Departments (department_id)
);

-- Create the Grades table
CREATE TABLE IF NOT EXISTS student_info.Grades (
  grade_id SERIAL PRIMARY KEY,
  student_id INTEGER NOT NULL,
  course_id INTEGER NOT NULL,
  grade VARCHAR(2),
  FOREIGN KEY (student_id) REFERENCES student_info.Students (student_id),
  FOREIGN KEY (course_id) REFERENCES student_info.Courses (course_id)
);

-- Create the Financial_Information table
CREATE TABLE IF NOT EXISTS student_info.Financial_Information (
  financial_id SERIAL PRIMARY KEY,
  student_id INTEGER NOT NULL,
  scholarship_amount NUMERIC(10, 2),
  tuition_fee_paid NUMERIC(10, 2),
  FOREIGN KEY (student_id) REFERENCES student_info.Students (student_id)
);
