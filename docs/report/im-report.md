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

The database under consideration will have many user roles with different levels of access, such as administrators, faculty staff, and students. Robust access controls and relevant security measures must be integrated to prevent misuse through unauthorised access, maintain data integrity, and meet certain regulations such as the General Data Protection Regulation (GDPR) [@voigt2017].

This report will therefore examine the design of the database, keeping in mind security aspects through the related practical implementations to address the risks and threats identified. Additionally, the report will further explore role-based security logic, appropriate controls to avoid unauthorised access, and the underlying importance of data auditing with the overarching goal of maintaining a secure system [@bertino2005].

Via industry practices and the aforementioned security measures, the university can be confident that the student information is attributed to the elements of the CIA triad – that is the confidentiality, integrity, and availability of the data [@samonas2014]. This ensures the protection of sensitive data, also meaning that the stakeholders gain confidence [@elmasri2016].

A practical implementation of this database design is implemented as a Dockerised PostgreSQL setup. A link to the GitHub repository can be found in [Appendix 6.1](#61-github-repository).

# 2 Database design and security

## 2.1 Table design

The database design for the student information system of the university includes the provided `Student` table, along with other additional tables that address security concerns and access controls. This proposed schema follows a normalised database design to reduce the chance of data redundancy and anomalies [@elmasri2016]. The entity relationship diagram (ERD) below shows this graphically.

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

-- Financial_Information table
CREATE INDEX idx_financial_information_student_id ON student_info.Financial_Information (student_id);

-- Audit_Trail table
CREATE INDEX idx_audit_trail_table_name ON student_info.Audit_Trail (table_name);
CREATE INDEX idx_audit_trail_record_id ON student_info.Audit_Trail (record_id);
CREATE INDEX idx_audit_trail_change_time ON student_info.Audit_Trail (change_time);
```

The database design is compatible with data archival and backup strategies for long-term maintenance. Any data that is backed up or archived will be stored in a completely isolated schema or database, with periodic backups scheduled in the event of data destruction or exfiltration [@chervenak1998].

## 2.2 Security requirements

Several security requirements need to be addressed for this system. These requirements aim to uphold the values of confidentiality, integrity, and availability regarding the data being held in the database [@elmasri2016].

**Confidentiality**: the system should guarantee that information that is sensitive, i.e. personal details, financial data, and grades, is only accessible to authorised users or those who have the necessary permissions. Therefore, access controls along with data encryption measures should be enforced to consolidate this [@bertino2005].

**Integrity**: The accuracy and correctness of the information held in the database should be maintained to prevent accidental or malicious data modifications [@garcia2008].

**Availability**: The student information should be up and running at all times to authorised users when needed. For this attribute, denial-of-service attacks, system failures (both hardware and software), or other disruptions are the biggest challenges that can impact the availability of the system [@stallings2015].

**Authentication and authorisation**: Robust authentication mechanisms should be integrated to verify the identity of users, only to ensure that authorised individuals have access to the system, and the relevant information based on their permissions [@sandhu1994].

**Auditing and logging**: In the event of a security breach or to detect potential ones, it would be beneficial for the system to implement comprehensive logging that records all user activities, modifications to data, and any attempts to access the system – whether that be authorised (for insider threats) or unauthorised [@mukherjee1994].

## 2.3 Security measures

Through these security control measures, the identified security requirements can be met. These are to be implemented in the database design and their access control mechanisms.

**Access control**: Through the PostgreSQL role system, a role-based access control (RBAC) system [@ferraiolo2001] can be established. The various user roles (administrators, faculty members, and students) are assigned the necessary privileges whilst also restricting access to sensitive data. This adheres to the principle of least privilege [@saltzer1975].

**Data encryption**: Sensitive fields in the database, i.e. `date_of_birth` and `address` in the `Students` and data within the `Financial_Information` tables, should be encrypted using industry-standard cryptographic algorithms such as AES-256 or similar [@deamen2002]. This ensures the confidentiality of the information and confidence in data integrity even in the event of data exfiltration.

**Input validation**: Injection attacks are a main concern with SQL databases, so stored procedures with triggers to validate user input when new data is inserted should be implemented to ensure data integrity [@stuttard2011].

**Auditing**: Via the `Audit_Trail` table, all activities, including user details, are recorded along with their timestamp. This is to aid in preventing security breaches or using this information to improve existing security measures [@mukherjee1994].

**Backup and recovery**: Incorporating regular backups to be scheduled is vital for disaster recovery plans to ensure business continuity and data availability in the event of system failures or data loss incidents [@chervenak1998].

**Authentication**: This would mainly be through strong password policies enforced by the university. Additionally, mechanisms such as multi-factor authentication can also be used to authenticate the identity of users to prevent unauthorised access [@stallings2015].

# 3 Access control

## 3.1 SQL queries for user roles

To implement the desired access controls for each user role (administrators, faculty members, and students) and the corresponding privileges, SQL queries have been written based on the access requirements for the tables (see [2.1 Table design](#21-table-design)). This ensures that each user role only has access to the necessary information and performs the relevant operations in adherence with the principle of least privilege [@saltzer1975].

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

## 3.2 Access control mechanisms

To make sure that only designated users have access to specific information within the proposed database schema (see [2.1 Table design](#21-table-design)), several access control methods have been implemented.

**Role-Based Access Control (RBAC)**: As mentioned previously, the database employs an RBAC model where permissions are based upon the user's assigned role rather than just individual users [@ferraiolo2001]. This therefore simplifies access management.

**Encryption and masking**: Sensitive data in tables such as addresses in the `Student` table or entries in the `Financial_Information` table, can be encrypted using industry-standard algorithms such as AES-256 [@deamen2002].

**Auditing and logging**: All access controls and any modifications to tables or data are recorded in the `Audit_Trail` table, which captures operation types, timestamps, and details of the user. It enables logging unauthorised access attempts [@mukherjee1994].

**Authentication and authorisation**: Strong mechanisms for authentication, such as 2FA and well-defined password policies to verify user identity. Authorisation is handled through the aforementioned RBAC model, allowing users to perform the necessary actions dependent on their role [@stallings2015].

# 4 Miscellaneous

## 4.1 Role-based security

Role-based security (RBAC) is a model that describes access control on a granular level. It concerns the permissions and privileges of users based on the roles granted by the system or organisation [@ferraiolo2001]. In this scenario of the university's student information, the RBAC model is vital to ensure that sensitive access to sensitive data is granted to authorised individuals – only based on their permissions and job functions.

The principle of least privilege is the underlying concept of the RBAC model. It states that users should be granted the minimum level of access possible to perform their relevant functions [@saltzer1975]. The advantages of this approach help reduce the risk of data breaches (insider threats), malicious or accidental modification to sensitive data, or unauthorised access.

In the context of the university's student information system, there are a wide range of roles such as administrators, students, and faculty members. These are all defined through responsibilities and therefore the level of access for each role. Administrators typically have the highest level of privilege. This is followed by faculty members who may have some access to student records, course information, grades, and so on. Finally, students have the least access, typically just restricted to viewing their own information such as personal data, course enrollments, and current grades.

The RBAC model allows for simplicity and scalability. Instead of managing permissions for each user individually which is an error-prone and tiresome process, RBAC allows administrators to assign roles and define permissions at a role level [@sandhu1998]. This streamlines the process of revoking or granting access to users based on business needs.

Another benefit of the RBAC model is its ability to synchronise with the separation of duties (SoD). SoD is a security mindset that makes sure that no single individual has privileges granted in excess or control over vital business operations [@pereira2012]. Assigning different roles with certain privileges can enforce a SoD mindset to reduce fraud, errors, or conflicts of interest.

RBAC also supports auditing mechanisms and compliance with relevant security regulations, such as the General Data Protection Regulation (GDPR) or the Family Educational Rights and Privacy Act (FERPA) [@bertino2005]. By maintaining clear role mapping, user assignments, and permissions, the university can demonstrate its competence in access control requirements.

As robust as the RBAC model is, it can only be maintained in that manner if roles, permissions, and user assignments are reviewed periodically to ensure that they are in alignment with the university's security and operational needs [@ferraiolo1992]. Furthermore, RBAC alone is not sufficient – it should be combined with other security measures mentioned previously, such as strong encryption, authentication methods, and auditing.

## 4.2 Minimising risk of unauthorised access

Minimising the risk of unauthorised access to sensitive student information is crucial to the university's database system. Therefore, several security measures can be employed to effectively meet this requirement.

**Strong authentication mechanisms**: Strong authentication mechanisms is vital in preventing unauthorised access. This may be through multi-factor authentication (MFA) in combination with passwords, biometrics, or security tokens [@jansen2011]. MFA heavily reduces the risk of unauthorised access through compromised credentials.

**Encryption**: Sensitive data fields, such as address or financial information, should be encrypted using industry-grade algorithms, i.e. AES-256 or RSA. This means even if a malicious third party gains access to the data, it is in an unreadable format without the according decryption keys [@deamen2002]. Encryption should be applied at rest (in the database) and in transit (when data is being transmitted).

**Least privilege principle**: This states that users should only be granted the minimum set of privileges needed to perform their required operations [@saltzer1975]. This principle is implemented through the RBAC model described earlier (see [4.1 Role-based security](#41-role-based-security)).

**Regular security assessments**: Via regular security assessments, i.e. penetration testing, risk assessments, and penetration testing to help identify and address potential vulnerabilities within the system before they can be exploited [@weidman2014]. These assessments should only be conducted by certified third-party organisations or qualified security professionals.

**User awareness and training**: Users of the system themselves are considered one of the biggest security weaknesses. A program that educates and trains users on security best practices such as phishing protection, using strong passwords, and reporting any suspicious activity, can be effective in mitigating unauthorised access attempts in the form of social engineering or human errors [@kruger2006].

**Incident response plan**: If an unauthorised access attempt succeeds, a comprehensive response plan can help the university to recover quickly and respond efficiently, helping to minimise the impact of the attack [@cichonski2012].

## 4.3 Data auditing

Data auditing is an important aspect when maintaining the security and integrity of sensitive information stored in the database. For the university's student information system, a data auditing mechanism is necessary to track changes made to tables in the schema, monitor access history, and potential security breaches.

The main goal of data auditing is to provide a detailed audit trail that captures all operations performed in the database system, including access attempts and data modifications. The audit trail serves as a valuable source of information for administrators and security professionals to identify vulnerabilities, investigate security incidents, and comply with regulations.

The designed database schema itself consists of the `Audit_Trail` table that plays the role of data auditing. The table logs various types of events, including updates, insertions, deletes, and selections among all tables within the system. Each audit entry would typically contain details such as the user's ID, operation type, timestamp, table name, and other relevant metadata.

Maintaining a detailed audit log can help with the following:

1. **Security breach detection**: Analysis of the audit trail can help in identifying patterns or errors that may indicate malicious access attempts or security violations [@mukherjee1994]. A proactive approach like so enables the university to not only detect breaches but also to respond to them promptly before they appear.

2. **Forensic analysis**: In the event of a security violation, the audit trail is a resource for forensic analysis purposes [@carrier2005]. It allows security professionals to reconstruct the sequence of events that occurred, and gather evidence to support investigations to uncover the parties responsible.

3. **Compliance and regulatory requirements**: The various industry regulations and standards such as the General Data Protection Regulation (GDPR) and the Family Educational Rights and Privacy Act (FERPA) require some sort of data auditing scheme to ensure the protection of sensitive information [@bertino2005]. Therefore by maintaining details logging mechanisms, the university can demonstrate compliance with regulations.

4. **Access monitoring**: The audit log can be used to track all user activities and ensure that sensitive data is restricted to authorised personnel only [@sandhu1994]. Potential cases of unauthorised access or privilege issues can be categorised quickly, meaning the university can promptly take the necessary corrective actions.

5. **Data integrity verification**: Tracking changes made to the database tables as well as to other critical data, the audit trail can provide a sense of confidence for the university in regards to the integrity of the data to rule out any accidental or unauthorised modifications [@garcia2008]. This feature allows for data accuracy and completeness of the student records.

For the above to be effective, the data auditing mechanism itself needs to be secured through proper access controls and robust storage. This means that the `Audit_Trail` table should be protected from any modifications or deletions. If required, access should be granted to a very small number of authorised personnel, such as dedicated auditors and administrators.

It would also be beneficial for the university to establish well-defined policies and procedures for regular review and analysis of the collected logs. This can be achieved through log management visual analysis (graphs, pie charts, etc.) that can also be automated.

# 6 Appendices

## 6.1 GitHub repository

[https://github.com/iArcanic/im-cw2](https://github.com/iArcanic/im-cw2)

# 7 References
