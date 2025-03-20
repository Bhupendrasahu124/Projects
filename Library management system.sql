# LIBRARY   management system
# IMPORTED ALL DATA FROM TABLES USING TABLE DATA IMPORT WIZARD
# ALTERING IMPORTED DATA AS FOLLOWS ESTABLISHING RELATIONSHIPS BETWEEN EACH TABLE 
use library
ALTER TABLE members
modify member_id VARCHAR(10) primary key

alter table return_status
modify return_id varchar(10) primary key

alter table books
modify isbn varchar(20) primary key

alter table branch
modify  branch_id varchar(20) primary key

alter table issued_status
modify issued_id varchar(20) primary key

alter table employees
modify  emp_id varchar(20) primary key
#all primary keys has been setted up now time for foreign keys

alter table employees
modify branch_id varchar(20) not null

alter table employees
add constraint FK_branch_id 
foreign key (branch_id) references branch(branch_id)

alter table return_status
Modify return_book_name varchar(20) not null
use library
alter table return_status
modify return_book_isbn varchar(20) not null


-- as there are so many data of issue id in return status table which are not present in parent table so we have to delete th
delete from return_status
where issued_id between 'IS101' and 'IS105'
-- now creating foreign key for return status
alter table return_status
add constraint Fk_return
foreign key (issued_id) references issued_status(issued_id)
----------------------------------------------------------------
-- Data modeling completed now solving some real life issues with theis data
-- project Tasks
--  create a new book record --('978-1-60129-456-2','To kill a Mockingbird','Classic',6.00,'yes','Harper Lee','J.B. Lippincott & co.')

select * from books
insert into books values('978-1-60129-456-2','To kill a Mockingbird','Classic',6.00,'yes','Harper Lee','J.B. Lippincott & co.')

-- update ana Existing member's address
update members
set member_address =' Lonawala india '
where member_id ='C103'

-- delete a record from the issued data table
-- objective: delete the record with issued_id = 'IS104' from the issued_status table
delete from issued_status
where issued_id='IS127'

-- use CTAS to generate new tabled based on query results- each book isbn, book name and total book_issued_cnt'

create table book_issued_cnt as
 select b.isbn, b.book_title, count(i.issued_ID)
 from books b
 join issued_status i
 on i.issued_book_isbn=b.isbn
 group by 1,2
 
-- find total rental income by category
select b.category, sum(b.rental_price) as total_rent 
from books b
join issued_status i
on i.issued_book_isbn=b.isbn
group by 1
 
-- list employees with therir branch manager name and their branch details
 select * from employees 
 select branch_id,branch_id from branch
 select e.emp_name,e.emp_name as manager_name, b.branch_id, b.branch_address, b.contact_no
 from employees e
 join branch b
 on e.emp_id=b.manager_id
 
 
 select e.*, b.manager_id, e1.emp_name as manager_namer  
 from employees e 
 join  branch b 
 on e.branch_id = b.branch_id
join employees e1
on b.manager_id=e1.emp_id

-- task -  create a table of books with rental price above a certain threshhold

create table Books_having_rental_price_more_than_5
as select * from books where rental_price>5
-- task - lsit books name  which is not returned yet'

select issued_book_name , count(issued_book_name) from issued_status 
where issued_id not in (select issued_id from return_status)
group by 1

use library
-- TAsk -Task 13: 
-- Identify Members with Overdue Books
-- rite a query to identify members who have overdue books (assume a 30-day return period). 
-- Display the member's_id, member's name, book title, issue date, and days overdue.


SELECT 
    ist.issued_member_id,
    m.member_name,
    bk.book_title,
    ist.issued_date,
    -- rs.return_date,
    CURRENT_DATE - ist.issued_date as over_dues_days
FROM issued_status as ist
JOIN 
members as m
    ON m.member_id = ist.issued_member_id
JOIN 
books as bk
ON bk.isbn = ist.issued_book_isbn
LEFT JOIN 
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE 
    rs.return_date IS NULL
    AND
    (CURRENT_DATE - ist.issued_date) > 30
ORDER BY 1
 
 
 
Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).
update books 
set status= 'yes'
where status in (select b.status from books b  join issued_status i on 
i.issued_book_isbn=b.isbn join return_status r on i.issued_id=r.issued_id  )
Task 15: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.
*/

- Task 16: CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.
 Task 17: Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

Task 19: Stored Procedure Objective: 

Create a stored procedure to manage the status of books in a library system. 

Description: Write a stored procedure that updates the status of a book in the library based on its issuance. 

The procedure should function as follows: 

The stored procedure should take the book_id as an input parameter. 

The procedure should first check if the book is available (status = 'yes'). 

If the book is available, it should be issued, and the status in the books table should be updated to 'no'. 

If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.