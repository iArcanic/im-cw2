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

<!-- 200 words maximum -->

The integrity of student information systems is vital since they concern personal and confidential information. This report therefore aims to address the security concerns regarding the database system that manages the storage of student records, grades, financial information, and other information typical to a university.

The database under consideration will have many user roles with different levels of access, such as administrators, faculty staff, and students. Robust access controls and relevant security measures must be integrated to prevent misuse through unauthorised access, maintain data integrity, and meet certain regulations such as the General Data Protection Regulation (GDPR) [@voigt2017].

This report will therefore examine the design of the database, keeping in mind security aspects through the related practical implementations to address the risks and threats identified. Additionally, the report will further explore role-based security logic, appropriate controls to avoid unauthorised access, and the underlying importance of data auditing with the overarching goal of maintaining a secure system [@bertino2005].

Via industry practices and the aforementioned security measures, the university can be confident that the student information is attributed to the elements of the CIA triad – that is the confidentiality, integrity, and availability of the data [@samonas2014]. This ensures the protection of sensitive data, also meaning that the stakeholders gain confidence [@elmasri2016].

# 2 Database design and security

<!-- 800 words maximum -->

## 2.1 Table design

<!-- 400 words maximum -->

The database design for the student information system of the university includes the provided `Student` table, along with other additional tables that address security concerns and access controls. This proposed schema follows a normalised database design to reduce the chance of data redundancy and anomalies [@elmasri2016]. The entity relationship diagram (ERD) below shows this graphically.

![Entity relationship diagram](docs/report/images/erd.png)

However, to go more into detail, the core tables include:

1. **`Students`**: This already provided table stores personal information of students, such as `student_id`, `name`, `date_of_birth`, `address`, and `year_of_study`. Here, the `student_id` serves as the primary key.
2. **`Departments`**: Stores information on the various university departments through fields such as `department_id` and `department_name`. `department_id` here serves as the primary key.
3. **`Courses`**: This table details the courses that the university offers among the departments. This is demonstrated via the fields of `course_id`, i.e. the primary key, `course_name`, and `department_id` being the foreign key relation to `Departments`.
4. **`Grades`**: Records the grades obtained by students for each course, with `grade_id` being the primary key, `grade` being the actual grade, and a connection to both the student and the course via `student_id` and `course_id` respectively [@ramakrishnan2002].
5. **`Financial information`**: Concerns information about the student's financial information via `financial_id`, the primary key, `scholarship_amount`, `tuition_fee_paid`, and `student_id` being the foreign key relation to `Students` [@silberschatz2011].

In terms of security measures, an additional table that isn't core to the actual student information data is implemented:

6. **`Audit_Trail`**: A table that contains a log of all activities and changes made to the database, through details such as `audit_id` the primary key, `user_id`, `table_name`, `record_id`, `action`, `change_details`, and `change_time` [@mukherjee1994].

Indexes have also been created to increase query speed and performance on frequently queried columns, for example, the `student_id` field in the `Students` table and the `course_id` field in the `Courses` table [@shasha2004].

The database design is compatible with data archival and backup strategies for long-term maintenance. Any data that is backed up or archived will be stored in a completely isolated schema or database, with periodic backups scheduled in the event of data destruction or exfiltration [@chervenak1998].

## 2.2 Security requirements

<!-- 200 words maximum -->

Based on the provided scenario of the university's student information system, a system that handles sensitive student records including academic and financial information, several security requirements need to be addressed. These requirements aim to uphold the values of confidentiality, integrity, and availability regarding the data being held in the database [@elmasri2016].

**Confidentiality**: the system should guarantee that information that is sensitive, i.e. personal details, financial data, and grades, is only accessible to authorised users or those who have the necessary permissions. Therefore, access controls along with data encryption measures should be enforced to consolidate this [@bertino2005].

**Integrity**: The accuracy and correctness of the information held in the database should be maintained. This means through measures such as input validation, auditing, and enforcing constraints to prevent accidental or malicious data modifications [@garcia2008].

**Availability**: The student information should be up and running at all times to authorised users when needed. For this attribute, denial-of-service attacks, system failures (both hardware and software), or other disruptions are the biggest challenges that can impact the availability of the system [@stallings2015].

**Authentication and authorisation**: Robust authentication mechanisms should be integrated to verify the identity of users, only to ensure that authorised individuals have access to the system, and the relevant information based on their permissions [@sandhu1994].

**Auditing and logging**: In the event of a security breach or to detect potential ones, it would be beneficial for the system to implement comprehensive logging that records all user activities, modifications to data, and any attempts to access the system – whether that be authorised (for insider threats) or unauthorised [@mukherjee1994].

By taking into account the identified security requirements and addressing them, the university can be confident in protecting sensitive information stored in their information systems, as well as complying with relevant data protection regulations and adopting industry best practices.

## 2.3 Security measures

<!-- 200 words maximum -->

# 3 Access control

<!-- 500 words maximum -->

## 3.1 SQL queries for user roles

<!-- 300 words maximum -->

## 3.2 Access control mechanisms

<!-- 200 words maximum -->

# 4 Miscellaneous

## 4.1 Role-based security

<!-- 1250 words maximum -->

## 4.2 Minimising risk of unauthorised access

<!-- 350 words maximum -->

## 4.3 Data auditing

<!-- 550 words maximum -->

# 5 Conclusion

<!-- 200 words maximum -->

# 6 Appendices

## 6.1 GitHub repository

[https://github.com/iArcanic/im-cw2](https://github.com/iArcanic/im-cw2)

# 7 References
