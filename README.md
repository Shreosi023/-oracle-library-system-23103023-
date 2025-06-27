📚 University Library Management System
Database Course – Final Assignment (Oracle Database)

📋 Overview
This project serves as the final submission for the Database Systems course. It implements a fully functional University Library Management System using Oracle Database, demonstrating practical skills in database design, SQL programming, PL/SQL development, and administrative optimization.

🎯 Assignment Objectives
🏗️ Design a complete, normalized relational database for a library system

🧠 Apply core database concepts: constraints, joins, indexing, and transactions

🖋️ Develop complex SQL queries and PL/SQL business logic

🔐 Implement security, role management, and performance optimization

✅ Learning Outcomes
Database Design: Applied ER modeling, normalization (1NF–3NF), and referential integrity

SQL Expertise: Used DDL, DML, DCL, and TCL commands proficiently

PL/SQL Programming: Created procedures, functions, and triggers

Database Administration: Managed roles, privileges, and performance strategies

📌 Assignment Breakdown
📁 Part 1: Database Setup (15 Marks)
✅ Created core tables: BOOKS, MEMBERS, TRANSACTIONS

✅ Inserted sample data: 20 books, 15 members, 25 transactions

🛠️ Part 2: Basic SQL Operations (20 Marks)
✅ Retrieved data for:

Available books

Overdue members

Top borrowed books

Members who returned late

✅ Manipulated data:

Updated fines

Inserted members with constraints

Archived transactions

🧩 Part 3: Advanced SQL (25 Marks)
✅ Complex Joins: INNER, LEFT, SELF, and CROSS JOINs

✅ Subqueries for analytics (borrowing rates, fines, activity)

✅ Window functions (ranking, running totals, trend analysis)

🔄 Part 4: PL/SQL Programming (25 Marks)
✅ ISSUE_BOOK procedure: Validates book availability, inserts transactions, and updates inventory

✅ CALCULATE_FINE function: Computes fine (₹5/day after due date)

✅ Trigger: Automatically updates available copies when a book is returned

🛡️ Part 5: Database Administration (15 Marks)
✅ Role Management:

librarian: Full access

student_user: Read-only access to books

✅ Performance:

Indexed frequent columns

Reviewed execution plans

🧪 Technologies Used
Component	Technology
Database	Oracle Database
Language	SQL, PL/SQL
Tools	Oracle SQL*Plus
Features	ER Modeling, Triggers, Functions, Joins, Subqueries

🌟 Highlights
📖 Book Management
Detailed inventory with ISBN, category, and price

Tracks total and available copies dynamically

👥 Member Management
Handles students, faculty, and staff

Ensures unique contact info with constraints

🔁 Transactions
Tracks book issues and returns with dates

Fine system integrated using PL/SQL logic

📊 Query Capabilities
Book availability, member activity, overdue tracking

Top borrowers, least borrowed books, and category trends

⚙️ PL/SQL Automation
Seamless issuing via stored procedure

Real-time fine computation

Triggers for automatic updates

🔐 Security & Optimization
Role-based access control

Strategic indexing and execution analysis

🗂️ Submission Structure
pgsql
Copy code
oracle-library-system-[student-id]/
│
├── README.md           → Assignment documentation
└── sql/
    ├── setup.sql       → DDL and sample data
    ├── queries.sql     → SQL queries (basic & advanced)
    ├── plsql.sql       → Procedures, functions, triggers
    └── admin.sql       → User creation & indexing
🚀 How to Run
sql
Copy code
-- Step 1: Connect to Oracle SQL*Plus
sqlplus username/password@database

-- Step 2: Execute SQL scripts in order
@sql/setup.sql
@sql/queries.sql
@sql/plsql.sql
@sql/admin.sql
🧱 Database Schema
Tables
BOOKS: Book details, inventory, pricing

MEMBERS: Personal details, role classification

TRANSACTIONS: Borrow/return history, fines, and status

📌 Requirements Covered
Sample data: 20 books, 15 members, 25 transactions

Queries:

Books with fewer available copies

Overdue members

Top 5 most borrowed books

Late returns

PL/SQL Logic:

Book issuance

Fine calculation

Return-triggered updates

Security:

Role and privilege management

Indexing for performance
