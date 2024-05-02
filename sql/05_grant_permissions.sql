-- Grant privileges to administrators
GRANT SELECT, INSERT, UPDATE (name, address, student_id, year_of_study) ON student_info.Students TO administrator;
GRANT SELECT, INSERT ON student_info.Audit_Trail TO administrator;
GRANT SELECT, INSERT, UPDATE, DELETE ON student_info.Departments TO administrator;
GRANT SELECT, INSERT, UPDATE, DELETE ON student_info.Courses TO administrator;
GRANT SELECT, INSERT, UPDATE, DELETE ON student_info.Grades TO administrator;
GRANT SELECT, INSERT, UPDATE, DELETE ON student_info.Financial_Information TO administrator;

-- Grant privileges to faculty members
GRANT SELECT, INSERT, UPDATE (name, address, date_of_birth, student_id, year_of_study) ON student_info.Students TO faculty_member;

-- Grant privileges to students
GRANT SELECT, INSERT, UPDATE (name, student_id, year_of_study) ON student_info.Students TO student;

GRANT SELECT ON student_info.Courses TO faculty_member, student;
GRANT SELECT ON student_info.Grades TO faculty_member, student;
GRANT SELECT ON student_info.Financial_Information TO faculty_member, student;
