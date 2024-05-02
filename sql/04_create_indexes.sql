-- Students table
CREATE INDEX idx_students_name ON student_info.Students (name);
CREATE INDEX idx_students_year_of_study ON student_info.Students (year_of_study);

-- Courses table
CREATE INDEX idx_courses_course_name ON student_info.Courses (course_name);

-- Grades table
CREATE INDEX idx_grades_student_id ON student_info.Grades (student_id);
CREATE INDEX idx_grades_course_id ON student_info.Grades (course_id);

-- Financial_Information table
CREATE INDEX idx_financial_information_student_id ON student_info.Financial_Information (student_id);

-- Audit_Trail table
CREATE INDEX idx_audit_trail_table_name ON student_info.Audit_Trail (table_name);
CREATE INDEX idx_audit_trail_record_id ON student_info.Audit_Trail (record_id);
CREATE INDEX idx_audit_trail_change_time ON student_info.Audit_Trail (change_time);
