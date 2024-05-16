---
title: "IM-CW2 Report"
author: "2242090"
bibliography: docs/report/references.bib
toc: true
toc-title: Table of Contents
toc-depth: 3
csl: docs/report/harvard-imperial-college-london.csl
---

---

# 1 Introduction

The integrity of student information systems is vital since they concern personal and confidential information. This report therefore aims to address the security concerns regarding the database system that manages the storage of student records, grades, financial information, and other information typical to a university.

The database will therefore have many user roles with different levels of access, those being administrators, faculty staff, and students. Robust access controls and relevant security measures must be integrated to prevent misuse through unauthorised access, maintain data integrity, and meet certain regulations such as the General Data Protection Regulation (GDPR) [@voigt2017]. Additionally, the report explores role-based security, appropriate controls to avoid unauthorised access, and the importance of data auditing to maintain a secure system [@bertino2005].

Via industry practices and the aforementioned security measures, the university can be confident that the student information is attributed to the elements of the CIA triad – that is the confidentiality, integrity, and availability of the data [@samonas2014]. This ensures the protection of sensitive data, also meaning that the stakeholders gain confidence [@elmasri2016].

A practical implementation of this database design is implemented as a Dockerised PostgreSQL setup. A link to the GitHub repository can be found in [Appendix 5.1](#51-github-repository).

Please also see [Appendix 5.2](#52-postgresql-database-dump) for the complete PostgreSQL dump of the database design.

# 2 Database design and security

## 2.1 Table design

The database design for the student information system of the university includes the already provided `Student` table, along with other additional tables that address security concerns and access controls. The schema follows a normalised database design to reduce the chance of data redundancy or anomalies [@elmasri2016]. Here is an entity relationship diagram (ERD) to demonstrate the schema graphically.

![Entity relationship diagram](docs/report/images/erd.png)

However, to go more into detail, the core tables include:

1. **`Students`**: This already provided table stores personal information of students, such as `student_id`, `name`, `date_of_birth`, `address`, and `year_of_study`. Here, the `student_id` serves as the primary key.

2. **`Departments`**: Stores information on the various university departments through fields such as `department_id` and `department_name`. `department_id` here serves as the primary key.

3. **`Courses`**: This table details the courses that the university offers among the departments. This is demonstrated via the fields of `course_id`, i.e. the primary key, `course_name`, and `department_id` being the foreign key relation to `Departments`.

4. **`Grades`**: Records the grades obtained by students for each course, with `grade_id` being the primary key, `grade` being the actual grade, and a connection to both the student and the course via `student_id` and `course_id` respectively [@ramakrishnan2002].

5. **`Financial information`**: Concerns information about the student's financial information via `financial_id`, the primary key, `scholarship_amount`, `tuition_fee_paid`, and `student_id` being the foreign key relation to `Students` [@silberschatz2011].

6. **`Audit_Trail`**: A table that contains a log of all activities and changes made to the database, through details such as `audit_id` the primary key, `user_id`, `table_name`, `record_id`, `action`, `change_details`, and `change_time` [@mukherjee1994].

Indexes have also been created to increase query speed and performance on frequently queried columns [@shasha2004].

```sql
-- Students table
CREATE INDEX idx_students_name ON student_info.Students (name);
CREATE INDEX idx_students_year_of_study ON student_info.Students (year_of_study);

-- Courses table
CREATE INDEX idx_courses_course_name ON student_info.Courses (course_name);

-- Grades table
CREATE INDEX idx_grades_student_id ON student_info.Grades (student_id);
CREATE INDEX idx_grades_course_id ON student_info.Grades (course_id);
```

The database design is compatible with data archival and backup strategies for long-term maintenance. Any data that is backed up or archived will be stored in a completely isolated schema or database, with periodic backups scheduled in the event of data destruction or exfiltration [@chervenak1998]. The following code snippet is a proof of concept that provides a database dump whenever the script is executed, using the `pg_dump` command (for the full contents of this script, please see the [`scripts/backup.sh`](https://github.com/iArcanic/im-cw2/blob/main/scripts/backup.sh) in the GitHub repository).

## 2.2 Security requirements

Many security requirements need to be addressed as part of this solution. These requirements aim to uphold the values of confidentiality, integrity, and availability of the data being held in the database [@elmasri2016].

**Confidentiality**: the system should acknowledge what is categorised as sensitive information, including student personal details, and their financial and academic information. These should only be accessible to authorised users who have permissions, such as through data encryption and access control measures [@bertino2005].

**Integrity**: The accuracy of the information held in the database should be maintained even in the event of accidental or intentional modifications [@garcia2008].

**Availability**: The student information should be up and running at all times to authorised users when needed. For this attribute, denial-of-service attacks, system failures (both hardware and software), or other disruptions are the biggest challenges that can impact the availability of the system [@stallings2015].

**Authentication and authorisation**: Strong authentication mechanisms need to be put in place to verify users, to only to ensure that authorised individuals have access to the system along with permissions they have been assigned [@sandhu1994].

**Auditing and logging**: If a security breach happens, it would be beneficial for the system to implement detailed logging that records all activities occurring within the schema. This includes user activities, modifications to data, and access attempts – whether that be authorised (for insider threats) or unauthorised [@mukherjee1994].

## 2.3 Security measures

The identified security requirements can be practically met through these measures.

**Access control**: Through the PostgreSQL role mechanism, a role-based access control (RBAC) system [@ferraiolo2001] can be implemented. The various user roles (administrators, faculty members, and students) are assigned the necessary privileges. This is in alignment with the principle least privilege [@saltzer1975].

**Data encryption**: Sensitive data is to be encrypted using industry level algorithms such as AES-256 or of similar strength [@deamen2002]. This ensures the confidentiality and integrity of the data even in the event of a leak, as the data is in ciphertext form.

**Input validation**: Injection attacks are a main concern with SQL databases, so stored procedures should be used to validate user input when new data is inserted [@stuttard2011]. This enforces the integrity of the data.

**Auditing**: Via the `Audit_Trail` table, all activities, including user details, are recorded along with their timestamp. This information can be used to improve existing security measures and therefore prevent future data breach incidents [@mukherjee1994].

**Backup and recovery**: Scheduled, regular backups are to be a part of disaster recovery plans to ensure business continuity and data availability in events such as system failures or data loss [@chervenak1998].

**Authentication**: This would mainly be through a strong password policy mandated by the university. Additionally, mechanisms such as multi-factor authentication can also be used to authenticate the identity of users [@stallings2015].

# 3 Access control

## 3.1 SQL queries for user roles

To implement the desired access controls for each user role (administrators, faculty members, and students) and the corresponding privileges, SQL queries have been written to reflect access logic. This ensures that each user role only has access to the necessary information to perform the relevant operations all whilst being by the principle of least privilege [@saltzer1975].

### 3.1.1 Administrators

```sql
CREATE ROLE admin;
```

This statement creates a new role called `admin`.

```sql
GRANT SELECT, INSERT, UPDATE (name, address, student_id, year_of_study) ON student_info.Students TO administrator;

GRANT SELECT, INSERT ON student_info.Audit_Trail TO administrator;

GRANT SELECT, INSERT, UPDATE, DELETE ON student_info.Departments TO administrator;

GRANT SELECT, INSERT, UPDATE, DELETE ON student_info.Courses TO administrator;

GRANT SELECT, INSERT, UPDATE, DELETE ON student_info.Grades TO administrator;

GRANT SELECT, INSERT, UPDATE, DELETE ON student_info.Financial_Information TO administrator;
```

The series of `GRANT` statements [@postgresql2024] here provide the `admin` role to perform operations such as `SELECT` (list data), `INSERT` (insert new data), `UPDATE` (update table records with new data), and `DELETE` (remove data) on all tables within the database. This makes sense for an administrative role, as in reality, they would have complete control over the system for maintenance and management purposes.

### 3.1.2 Faculty members

```sql
CREATE ROLE faculty_member;
```

This statement creates a new role called `faculty_member`.

```sql
GRANT SELECT, INSERT, UPDATE (name, address, date_of_birth, student_id, year_of_study) ON student_info.Students TO faculty_member;

GRANT SELECT ON student_info.Courses TO faculty_member;

GRANT SELECT ON student_info.Grades TO faculty_member;

GRANT SELECT ON student_info.Financial_Information TO faculty_member;
```

Here, this series of `GRANT` statements allows certain privileges on the `Students` table for specific fields. In the other tables, `Courses`, `Grades`, and `Financial_Information`, faculty members are only able to view the data through the `SELECT` permission.

### 3.1.3 Students

```sql
CREATE ROLE student;
```

This statement creates a new role called `student`.

```sql
GRANT SELECT, INSERT, UPDATE (name, student_id, year_of_study) ON student_info.Students TO student;

GRANT SELECT ON student_info.Courses TO student;

GRANT SELECT ON student_info.Grades TO student;

GRANT SELECT ON student_info.Financial_Information TO student;
```

For the `student` role, the `GRANT` statements [@mysql2024] here allow for the student to view their personal information on the `Courses`, `Grades`, and `Financial_Information` tables via the `SELECT` privilege.

# 4 Miscellaneous

## 4.1 Role-based security

Role-based security (RBAC) is a model that describes access control on a granular level, specifically the management of privileges for users based on roles granted by the organisation [@ferraiolo2001]. In this scenario of the university's student information, the RBAC model is vital to ensure that access to sensitive data is granted to authorised individuals – only based on their permissions and job functions.

The principle of least privilege is the underlying concept of the RBAC model. It states that users should be granted the lowest level of access possible only to perform their functions [@saltzer1975]. The advantages of this approach help reduce the risk of data breaches (insider threats), malicious or accidental modification to sensitive data, or unauthorised access.

In the context of the university's student information system, there are a wide range of roles such as administrators, students, and faculty members. These are all defined through responsibilities and therefore the level of access for each role. Administrators typically have the highest level of privilege. This is followed by faculty members who may have some access to student records, course information, grades, and so on. Finally, students have the least access, typically just restricted to viewing their information such as personal data, course enrollments, and current grades.

Benefits of using the RBAC model is that it's simple but scalable. Instead of managing permissions for each user individually – which is an error-prone and tiresome process, RBAC allows administrators to assign roles and define permissions at a role level [@sandhu1998] to streamline the process of revoking or granting access to users based on business needs.

Another benefit of the RBAC model is its ability to synchronise with the separation of duties (SoD). SoD is a security mindset that makes sure that no single individual has privileges granted in excess [@pereira2012]. Assigning different roles with certain privileges can enforce a SoD mindset to reduce fraud, errors, or conflicts of interest.

RBAC also supports auditing mechanisms as well as complying with relevant security regulations. This includes the General Data Protection Regulation (GDPR) or the Family Educational Rights and Privacy Act (FERPA) [@bertino2005]. Through clear role mapping, user assignments, and permissions, the university can demonstrate competence in access control requirements.

As robust as the RBAC model is, it can only be maintained in that manner if roles, permissions, and user assignments are reviewed periodically to ensure that they are in alignment with the university's security and operational needs [@ferraiolo1992]. Furthermore, RBAC alone is not sufficient – it should be combined with other security measures mentioned previously, such as strong encryption, authentication methods, and auditing.

## 4.2 Minimising risk of unauthorised access

Minimising the risk of unauthorised access to sensitive student information is crucial for the university's. A lot of these measures have been implemented previously, but here are some additional ones to consider specific to this case.

**Regular security assessments**: This may include penetration testing and likewise risk assessments to help identify and address potential vulnerabilities within the system before they can be exploited [@weidman2014]. These assessments should only be conducted by certified third-party organisations or qualified security professionals.

**User awareness and training**: Users of the system themselves are considered one of the biggest security weaknesses. A program that educates and trains users on security best practices such as phishing protection, using strong passwords, and reporting any suspicious activity, can be effective in mitigating unauthorised access attempts that may occur in the form of social engineering or human errors [@kruger2006].

**Incident response plan**: If an unauthorised access attempt succeeds, a detailed response plan can help the university to recover and respond quickly, helping to minimise the impact of the attack [@cichonski2012].

## 4.3 Data auditing

Data auditing is important when maintaining the integrity of stored information. For the university's student information system, a data auditing mechanism is necessary to track changes made to tables in the schema and monitor access history to help detect any potential security breaches that may occur in the future.

The main goal of data auditing is to provide a detailed audit trail that captures all operations performed in the database system, including access attempts and data modifications. The audit trail is insightful for administrators and security professionals to identify vulnerabilities, and investigate security incidents.

The designed database schema itself consists of the `Audit_Trail` table that plays the role of data auditing, where the table logs various types of events, including updates, insertions, deletes, and selections among all tables within the system. Each audit entry would typically contain details such as the user's ID, operation type, timestamp, table name, and other relevant metadata.

Maintaining a detailed audit log can help with the following:

1. **Security breach detection**: Analysis of the audit trail can help in identifying patterns or errors that may indicate malicious access attempts or security violations [@mukherjee1994]. A proactive approach enables the university to not only detect breaches but also to respond to them promptly before they appear.

2. **Forensic analysis**: In the event of a security incident, the audit trail is a resource for forensic analysis purposes [@carrier2005]. It allows security professionals to reconstruct the sequence of events that occurred, and gather evidence to support investigations to uncover the parties responsible.

3. **Compliance and regulatory requirements**: The various industry regulations and standards such as the General Data Protection Regulation (GDPR) and the Family Educational Rights and Privacy Act (FERPA) require a data auditing scheme to demonstrate compliance [@bertino2005].

4. **Access monitoring**: The audit log can be used to track all user activities and ensure that sensitive data is restricted to authorised personnel only [@sandhu1994]. Potential cases of unauthorised access or privilege issues can be categorised quickly, meaning the university can promptly adress them.

5. **Data integrity verification**: By tracking changes made to the database tables as well as to other critical data, the audit trail can provide a sense of confidence for the university in regards to the integrity of the data to exclude out any accidental or unauthorised modifications [@garcia2008].

For the above to be effective, the data auditing mechanism itself needs to be secured through proper access controls and robust storage. This means that the `Audit_Trail` table should be protected from any modifications or deletions. If required, access should be granted to a very small number of authorised personnel, such as dedicated auditors and/or administrators.

It would also be beneficial for the university to establish well-defined policies and procedures for regular review and analysis of the collected logs. This can be achieved through log management visual analysis (graphs, pie charts, etc.) that can also be automated.

# 5 Appendices

## 5.1 GitHub repository

[https://github.com/iArcanic/im-cw2](https://github.com/iArcanic/im-cw2)

## 5.2 PostgreSQL database dump

```sql
--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2 (Debian 16.2-1.pgdg120+2)
-- Dumped by pg_dump version 16.2 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: student_info; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA student_info;


ALTER SCHEMA student_info OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_trail; Type: TABLE; Schema: student_info; Owner: postgres
--

CREATE TABLE student_info.audit_trail (
    audit_id integer NOT NULL,
    user_id integer NOT NULL,
    table_name text NOT NULL,
    record_id integer NOT NULL,
    action text NOT NULL,
    change_details json,
    change_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE student_info.audit_trail OWNER TO postgres;

--
-- Name: audit_trail_audit_id_seq; Type: SEQUENCE; Schema: student_info; Owner: postgres
--

CREATE SEQUENCE student_info.audit_trail_audit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE student_info.audit_trail_audit_id_seq OWNER TO postgres;

--
-- Name: audit_trail_audit_id_seq; Type: SEQUENCE OWNED BY; Schema: student_info; Owner: postgres
--

ALTER SEQUENCE student_info.audit_trail_audit_id_seq OWNED BY student_info.audit_trail.audit_id;


--
-- Name: courses; Type: TABLE; Schema: student_info; Owner: postgres
--

CREATE TABLE student_info.courses (
    course_id integer NOT NULL,
    course_name text NOT NULL,
    department_id integer NOT NULL
);


ALTER TABLE student_info.courses OWNER TO postgres;

--
-- Name: courses_course_id_seq; Type: SEQUENCE; Schema: student_info; Owner: postgres
--

CREATE SEQUENCE student_info.courses_course_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE student_info.courses_course_id_seq OWNER TO postgres;

--
-- Name: courses_course_id_seq; Type: SEQUENCE OWNED BY; Schema: student_info; Owner: postgres
--

ALTER SEQUENCE student_info.courses_course_id_seq OWNED BY student_info.courses.course_id;


--
-- Name: departments; Type: TABLE; Schema: student_info; Owner: postgres
--

CREATE TABLE student_info.departments (
    department_id integer NOT NULL,
    department_name text NOT NULL
);


ALTER TABLE student_info.departments OWNER TO postgres;

--
-- Name: departments_department_id_seq; Type: SEQUENCE; Schema: student_info; Owner: postgres
--

CREATE SEQUENCE student_info.departments_department_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE student_info.departments_department_id_seq OWNER TO postgres;

--
-- Name: departments_department_id_seq; Type: SEQUENCE OWNED BY; Schema: student_info; Owner: postgres
--

ALTER SEQUENCE student_info.departments_department_id_seq OWNED BY student_info.departments.department_id;


--
-- Name: financial_information; Type: TABLE; Schema: student_info; Owner: postgres
--

CREATE TABLE student_info.financial_information (
    financial_id integer NOT NULL,
    student_id integer NOT NULL,
    scholarship_amount numeric(10,2),
    tuition_fee_paid numeric(10,2)
);


ALTER TABLE student_info.financial_information OWNER TO postgres;

--
-- Name: financial_information_financial_id_seq; Type: SEQUENCE; Schema: student_info; Owner: postgres
--

CREATE SEQUENCE student_info.financial_information_financial_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE student_info.financial_information_financial_id_seq OWNER TO postgres;

--
-- Name: financial_information_financial_id_seq; Type: SEQUENCE OWNED BY; Schema: student_info; Owner: postgres
--

ALTER SEQUENCE student_info.financial_information_financial_id_seq OWNED BY student_info.financial_information.financial_id;


--
-- Name: grades; Type: TABLE; Schema: student_info; Owner: postgres
--

CREATE TABLE student_info.grades (
    grade_id integer NOT NULL,
    student_id integer NOT NULL,
    course_id integer NOT NULL,
    grade character varying(2)
);


ALTER TABLE student_info.grades OWNER TO postgres;

--
-- Name: grades_grade_id_seq; Type: SEQUENCE; Schema: student_info; Owner: postgres
--

CREATE SEQUENCE student_info.grades_grade_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE student_info.grades_grade_id_seq OWNER TO postgres;

--
-- Name: grades_grade_id_seq; Type: SEQUENCE OWNED BY; Schema: student_info; Owner: postgres
--

ALTER SEQUENCE student_info.grades_grade_id_seq OWNED BY student_info.grades.grade_id;


--
-- Name: students; Type: TABLE; Schema: student_info; Owner: postgres
--

CREATE TABLE student_info.students (
    student_id integer NOT NULL,
    name text,
    date_of_birth date,
    address text,
    year_of_study integer
);


ALTER TABLE student_info.students OWNER TO postgres;

--
-- Name: students_student_id_seq; Type: SEQUENCE; Schema: student_info; Owner: postgres
--

CREATE SEQUENCE student_info.students_student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE student_info.students_student_id_seq OWNER TO postgres;

--
-- Name: students_student_id_seq; Type: SEQUENCE OWNED BY; Schema: student_info; Owner: postgres
--

ALTER SEQUENCE student_info.students_student_id_seq OWNED BY student_info.students.student_id;


--
-- Name: audit_trail audit_id; Type: DEFAULT; Schema: student_info; Owner: postgres
--

ALTER TABLE ONLY student_info.audit_trail ALTER COLUMN audit_id SET DEFAULT nextval('student_info.audit_trail_audit_id_seq'::regclass);


--
-- Name: courses course_id; Type: DEFAULT; Schema: student_info; Owner: postgres
--

ALTER TABLE ONLY student_info.courses ALTER COLUMN course_id SET DEFAULT nextval('student_info.courses_course_id_seq'::regclass);


--
-- Name: departments department_id; Type: DEFAULT; Schema: student_info; Owner: postgres
--

ALTER TABLE ONLY student_info.departments ALTER COLUMN department_id SET DEFAULT nextval('student_info.departments_department_id_seq'::regclass);


--
-- Name: financial_information financial_id; Type: DEFAULT; Schema: student_info; Owner: postgres
--

ALTER TABLE ONLY student_info.financial_information ALTER COLUMN financial_id SET DEFAULT nextval('student_info.financial_information_financial_id_seq'::regclass);


--
-- Name: grades grade_id; Type: DEFAULT; Schema: student_info; Owner: postgres
--

ALTER TABLE ONLY student_info.grades ALTER COLUMN grade_id SET DEFAULT nextval('student_info.grades_grade_id_seq'::regclass);


--
-- Name: students student_id; Type: DEFAULT; Schema: student_info; Owner: postgres
--

ALTER TABLE ONLY student_info.students ALTER COLUMN student_id SET DEFAULT nextval('student_info.students_student_id_seq'::regclass);


--
-- Data for Name: audit_trail; Type: TABLE DATA; Schema: student_info; Owner: postgres
--

COPY student_info.audit_trail (audit_id, user_id, table_name, record_id, action, change_details, change_time) FROM stdin;
\.


--
-- Data for Name: courses; Type: TABLE DATA; Schema: student_info; Owner: postgres
--

COPY student_info.courses (course_id, course_name, department_id) FROM stdin;
1	Introduction to Programming	1
2	Calculus I	2
3	Introduction to Electrical Engineering	3
\.


--
-- Data for Name: departments; Type: TABLE DATA; Schema: student_info; Owner: postgres
--

COPY student_info.departments (department_id, department_name) FROM stdin;
1	Computer Science
2	Mathematics
3	Engineering
\.


--
-- Data for Name: financial_information; Type: TABLE DATA; Schema: student_info; Owner: postgres
--

COPY student_info.financial_information (financial_id, student_id, scholarship_amount, tuition_fee_paid) FROM stdin;
1	1	5000.00	2500.00
2	2	0.00	3000.00
\.


--
-- Data for Name: grades; Type: TABLE DATA; Schema: student_info; Owner: postgres
--

COPY student_info.grades (grade_id, student_id, course_id, grade) FROM stdin;
1	1	1	A
2	1	2	B
3	2	1	B+
\.


--
-- Data for Name: students; Type: TABLE DATA; Schema: student_info; Owner: postgres
--

COPY student_info.students (student_id, name, date_of_birth, address, year_of_study) FROM stdin;
1	John Doe	2000-01-01	123 Main St	1
2	Jane Smith	2001-05-15	456 Oak Rd	2
3	Michael Johnson	1999-12-31	789 Elm St	3
4	Emily Williams	2002-06-30	321 Pine Ave	1
5	David Brown	2001-09-20	654 Maple Ln	2
\.


--
-- Name: audit_trail_audit_id_seq; Type: SEQUENCE SET; Schema: student_info; Owner: postgres
--

SELECT pg_catalog.setval('student_info.audit_trail_audit_id_seq', 1, false);


--
-- Name: courses_course_id_seq; Type: SEQUENCE SET; Schema: student_info; Owner: postgres
--

SELECT pg_catalog.setval('student_info.courses_course_id_seq', 3, true);


--
-- Name: departments_department_id_seq; Type: SEQUENCE SET; Schema: student_info; Owner: postgres
--

SELECT pg_catalog.setval('student_info.departments_department_id_seq', 3, true);


--
-- Name: financial_information_financial_id_seq; Type: SEQUENCE SET; Schema: student_info; Owner: postgres
--

SELECT pg_catalog.setval('student_info.financial_information_financial_id_seq', 2, true);


--
-- Name: grades_grade_id_seq; Type: SEQUENCE SET; Schema: student_info; Owner: postgres
--

SELECT pg_catalog.setval('student_info.grades_grade_id_seq', 3, true);


--
-- Name: students_student_id_seq; Type: SEQUENCE SET; Schema: student_info; Owner: postgres
--

SELECT pg_catalog.setval('student_info.students_student_id_seq', 5, true);


--
-- Name: audit_trail audit_trail_pkey; Type: CONSTRAINT; Schema: student_info; Owner: postgres
--

ALTER TABLE ONLY student_info.audit_trail
    ADD CONSTRAINT audit_trail_pkey PRIMARY KEY (audit_id);


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: student_info; Owner: postgres
--

ALTER TABLE ONLY student_info.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (course_id);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: student_info; Owner: postgres
--

ALTER TABLE ONLY student_info.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (department_id);


--
-- Name: financial_information financial_information_pkey; Type: CONSTRAINT; Schema: student_info; Owner: postgres
--

ALTER TABLE ONLY student_info.financial_information
    ADD CONSTRAINT financial_information_pkey PRIMARY KEY (financial_id);


--
-- Name: grades grades_pkey; Type: CONSTRAINT; Schema: student_info; Owner: postgres
--

ALTER TABLE ONLY student_info.grades
    ADD CONSTRAINT grades_pkey PRIMARY KEY (grade_id);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: student_info; Owner: postgres
--

ALTER TABLE ONLY student_info.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (student_id);


--
-- Name: idx_audit_trail_change_time; Type: INDEX; Schema: student_info; Owner: postgres
--

CREATE INDEX idx_audit_trail_change_time ON student_info.audit_trail USING btree (change_time);


--
-- Name: idx_audit_trail_record_id; Type: INDEX; Schema: student_info; Owner: postgres
--

CREATE INDEX idx_audit_trail_record_id ON student_info.audit_trail USING btree (record_id);


--
-- Name: idx_audit_trail_table_name; Type: INDEX; Schema: student_info; Owner: postgres
--

CREATE INDEX idx_audit_trail_table_name ON student_info.audit_trail USING btree (table_name);


--
-- Name: idx_courses_course_name; Type: INDEX; Schema: student_info; Owner: postgres
--

CREATE INDEX idx_courses_course_name ON student_info.courses USING btree (course_name);


--
-- Name: idx_financial_information_student_id; Type: INDEX; Schema: student_info; Owner: postgres
--

CREATE INDEX idx_financial_information_student_id ON student_info.financial_information USING btree (student_id);


--
-- Name: idx_grades_course_id; Type: INDEX; Schema: student_info; Owner: postgres
--

CREATE INDEX idx_grades_course_id ON student_info.grades USING btree (course_id);


--
-- Name: idx_grades_student_id; Type: INDEX; Schema: student_info; Owner: postgres
--

CREATE INDEX idx_grades_student_id ON student_info.grades USING btree (student_id);


--
-- Name: idx_students_name; Type: INDEX; Schema: student_info; Owner: postgres
--

CREATE INDEX idx_students_name ON student_info.students USING btree (name);


--
-- Name: idx_students_year_of_study; Type: INDEX; Schema: student_info; Owner: postgres
--

CREATE INDEX idx_students_year_of_study ON student_info.students USING btree (year_of_study);


--
-- Name: courses courses_department_id_fkey; Type: FK CONSTRAINT; Schema: student_info; Owner: postgres
--

ALTER TABLE ONLY student_info.courses
    ADD CONSTRAINT courses_department_id_fkey FOREIGN KEY (department_id) REFERENCES student_info.departments(department_id);


--
-- Name: financial_information financial_information_student_id_fkey; Type: FK CONSTRAINT; Schema: student_info; Owner: postgres
--

ALTER TABLE ONLY student_info.financial_information
    ADD CONSTRAINT financial_information_student_id_fkey FOREIGN KEY (student_id) REFERENCES student_info.students(student_id);


--
-- Name: grades grades_course_id_fkey; Type: FK CONSTRAINT; Schema: student_info; Owner: postgres
--

ALTER TABLE ONLY student_info.grades
    ADD CONSTRAINT grades_course_id_fkey FOREIGN KEY (course_id) REFERENCES student_info.courses(course_id);


--
-- Name: grades grades_student_id_fkey; Type: FK CONSTRAINT; Schema: student_info; Owner: postgres
--

ALTER TABLE ONLY student_info.grades
    ADD CONSTRAINT grades_student_id_fkey FOREIGN KEY (student_id) REFERENCES student_info.students(student_id);


--
-- Name: TABLE audit_trail; Type: ACL; Schema: student_info; Owner: postgres
--

GRANT SELECT,INSERT ON TABLE student_info.audit_trail TO administrator;


--
-- Name: TABLE courses; Type: ACL; Schema: student_info; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE student_info.courses TO administrator;
GRANT SELECT ON TABLE student_info.courses TO faculty_member;
GRANT SELECT ON TABLE student_info.courses TO student;


--
-- Name: TABLE departments; Type: ACL; Schema: student_info; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE student_info.departments TO administrator;


--
-- Name: TABLE financial_information; Type: ACL; Schema: student_info; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE student_info.financial_information TO administrator;
GRANT SELECT ON TABLE student_info.financial_information TO faculty_member;
GRANT SELECT ON TABLE student_info.financial_information TO student;


--
-- Name: TABLE grades; Type: ACL; Schema: student_info; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE student_info.grades TO administrator;
GRANT SELECT ON TABLE student_info.grades TO faculty_member;
GRANT SELECT ON TABLE student_info.grades TO student;


--
-- Name: TABLE students; Type: ACL; Schema: student_info; Owner: postgres
--

GRANT SELECT,INSERT ON TABLE student_info.students TO administrator;
GRANT SELECT,INSERT ON TABLE student_info.students TO faculty_member;
GRANT SELECT,INSERT ON TABLE student_info.students TO student;


--
-- Name: COLUMN students.student_id; Type: ACL; Schema: student_info; Owner: postgres
--

GRANT UPDATE(student_id) ON TABLE student_info.students TO administrator;
GRANT UPDATE(student_id) ON TABLE student_info.students TO faculty_member;
GRANT UPDATE(student_id) ON TABLE student_info.students TO student;


--
-- Name: COLUMN students.name; Type: ACL; Schema: student_info; Owner: postgres
--

GRANT UPDATE(name) ON TABLE student_info.students TO administrator;
GRANT UPDATE(name) ON TABLE student_info.students TO faculty_member;
GRANT UPDATE(name) ON TABLE student_info.students TO student;


--
-- Name: COLUMN students.date_of_birth; Type: ACL; Schema: student_info; Owner: postgres
--

GRANT UPDATE(date_of_birth) ON TABLE student_info.students TO faculty_member;


--
-- Name: COLUMN students.address; Type: ACL; Schema: student_info; Owner: postgres
--

GRANT UPDATE(address) ON TABLE student_info.students TO administrator;
GRANT UPDATE(address) ON TABLE student_info.students TO faculty_member;


--
-- Name: COLUMN students.year_of_study; Type: ACL; Schema: student_info; Owner: postgres
--

GRANT UPDATE(year_of_study) ON TABLE student_info.students TO administrator;
GRANT UPDATE(year_of_study) ON TABLE student_info.students TO faculty_member;
GRANT UPDATE(year_of_study) ON TABLE student_info.students TO student;


--
-- PostgreSQL database dump complete
--
```

# 6 References
