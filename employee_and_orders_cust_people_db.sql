create database employee_and_orders_cust_people_analysis;

use employee_and_orders_cust_people_analysis;

CREATE TABLE Dept(
    deptno INT PRIMARY KEY,
    dname VARCHAR(50),
    loc VARCHAR(50));

INSERT INTO Dept (deptno, dname, loc) VALUES
(10, 'OPERATIONS', 'BOSTON'),
(20, 'RESEARCH', 'DALLAS'),
(30, 'SALES', 'CHICAGO'),
(40, 'ACCOUNTING', 'NEW YORK');

select * from dept;

CREATE TABLE Employee(
    empno INT PRIMARY KEY,  -- Here to make sure that empno cannot be NULL or duplicate
    ename VARCHAR(50),
    job VARCHAR(50) DEFAULT 'CLERK',  -- here Default job should be CLERK  that why we used default fucntion
    mgr INT,
    hiredate DATE,
    sal DECIMAL(10, 2) CHECK (sal > 0),  -- Salary cannot be negative or zero so check function to make sure that sal must not be in negative or zero
    comm DECIMAL(10, 2),
    deptno INT,
    FOREIGN KEY (deptno) REFERENCES Dept(deptno)  -- deptno should be a foreign key
);

INSERT INTO Employee (empno, ename, job, mgr, hiredate, sal, comm, deptno) VALUES
(7369, 'SMITH', 'CLERK', 7902, '1980-12-17', 800.00, NULL, 20),
(7499, 'ALLEN', 'SALESMAN', 7698, '1981-02-20', 1600.00, 300.00, 30),
(7521, 'WARD', 'SALESMAN', 7698, '1981-02-22', 1250.00, 500.00, 30),
(7566, 'JONES', 'MANAGER', 7839, '1981-04-02', 2975.00, NULL, 20),
(7654, 'MARTIN', 'SALESMAN', 7698, '1981-09-28', 1250.00, 1400.00, 30),
(7698, 'BLAKE', 'MANAGER', 7839, '1981-05-01', 2850.00, NULL, 30),
(7782, 'CLARK', 'MANAGER', 7839, '1981-06-09', 2450.00, NULL, 10),
(7788, 'SCOTT', 'ANALYST', 7566, '1987-04-19', 3000.00, NULL, 20),
(7839, 'KING', 'PRESIDENT', NULL, '1981-11-17', 5000.00, NULL, 10),
(7844, 'TURNER', 'SALESMAN', 7698, '1981-09-08', 1500.00, 0.00, 30),
(7876, 'ADAMS', 'CLERK', 7788, '1987-05-23', 1100.00, NULL, 20),
(7900, 'JAMES', 'CLERK', 7698, '1981-12-03', 950.00, NULL, 30),
(7902, 'FORD', 'ANALYST', 7566, '1981-12-03', 3000.00, NULL, 20),
(7934, 'MILLER', 'CLERK', 7782, '1982-01-23', 1300.00, NULL, 10);

select * from employee;

 # 3.List the Names and salary of the employee whose salary is greater than 1000
 select ename,sal from employee where sal>1000;

# 4.	List the details of the employees who have joined before end of September 81.
select * from employee where hiredate <'1981-10-01';

# 5.	List Employee Names having I as second character.
select ename from employee where ename like '_I%';

# 6.	List Employee Name, Salary, Allowances (40% of Sal), P.F. (10 % of Sal) and Net Salary. Also assign the alias name for the columns
select ename as employee_name, sal as salary,
round((sal * 0.40),2) as allowances,
round((sal * 0.10),2) as P_F,
round((sal+(sal * 0.40) - (sal * 0.10)),2) as net_salary
from employee;

# 7 List Employee Names with designations who does not report to anybody
select ename as employee_name,job as designation from employee where mgr is null;

# 8.	List Empno, Ename and Salary in the ascending order of salary.
select empno,ename ,sal from employee order by sal;

# 9.	How many jobs are available in the Organization ?
select distinct job as Available_jobs, count(job) as job_count from employee group by job;

# 10.	Determine total payable salary of salesman category
select sum(sal) as total_sal_payable from employee where job = "SALESMAN";

# 11.	List average monthly salary for each job within each department   
select deptno,job,
round(avg(sal),2) as monthly_avg_sal from employee
group by deptno,job;

#12.	Use the Same EMP and DEPT table used in the Case study to Display EMPNAME, SALARY and DEPTNAME in which the employee is working.
select e.ename,e.sal,d.deptno from employee e join dept d where e.deptno = d.deptno;

#13.	  Create the Job Grades Table as below
create table job_grades ( grade char(10) primary key,
lowest_sal decimal(10,2),
highest_sal decimal(10,2));

INSERT INTO Job_Grades (grade, lowest_sal, highest_sal) VALUES
('A', 0, 999),
('B', 1000, 1999),
('C', 2000, 2999),
('D', 3000, 3999),
('E', 4000, 5000);

select * from job_grades;

#14.	Display the last name, salary and  Corresponding Grade.
select e.ename as last_name,
e.sal as salary,
g.grade as grade from employee e 
join job_grades g on e.sal between g.lowest_sal and g.highest_sal;

# 15. 	Display the Emp name and the Manager name under whom the Employee works in the below format .--Emp Report to Mgr
SELECT e.ename AS 'Emp', m.ename AS 'Report to Mgr'
FROM employee e
 LEFT JOIN employee m ON e.mgr = m.empno;

# 16.	Display Empname and Total sal where Total Sal (sal + Comm)
select ename as empname,(sal+coalesce(comm,0)) as total_sal from employee;

# 17.	Display Empname and Sal whose empno is a odd number
select ename,sal from employee where mod(empno,2)<>0;


# 18.	Display Empname , Rank of sal in Organisation , Rank of Sal in their department
select ename, rank() over (order by sal desc) as org_rank,
rank() over (partition by deptno order by sal desc) as dept_rank from employee;

# 19.	Display Top 3 Empnames based on their Salary
select ename,sal from employee order by sal desc limit 3;

# 20.	 Display Empname who has highest Salary in Each Department.
select e.deptno, e.ename ,e.sal, d.dname from employee e join dept d on e.deptno = d.deptno 
where sal = (select max(sal) from employee where deptno = e.deptno) order by deptno ;

-- ORDERS ,CUST SALESPEOPLE 
# 1.	Create the Salespeople as below screenshot.
CREATE TABLE Salespeople ( snum int,sname varchar(20),city varchar(20),comm decimal(4,2));

INSERT INTO Salespeople (snum, sname, city, comm) VALUES
(1001, 'Peel', 'London', 0.12),
(1002, 'Serres', 'San Jose', 0.13),
(1003, 'Axelrod', 'New York', 0.10),
(1004, 'Motika', 'London', 0.11),
(1007, 'Rafkin', 'Barcelona', 0.15);

# 2.	 Create the Cust Table as below Screenshot     
CREATE TABLE cust(cnum int,cname varchar(20),city varchar(20),rating int,snum int);

INSERT INTO Cust (cnum, cname, city, rating, snum) VALUES
(2001, 'Hoffman', 'London', 100, 1001),
(2002, 'Giovanne', 'Rome', 200, 1003),
(2003, 'Liu', 'San Jose', 300, 1002),
(2004, 'Grass', 'Berlin', 100, 1002),
(2006, 'Clemens', 'London', 300, 1007),
(2007, 'Pereira', 'Rome', 100, 1004),
(2008, 'James', 'London', 200, 1007);

# 3.	Create orders table as below screenshot.
CREATE TABLE orders(onum int,amt decimal(10,2),odate date,cnum int,snum int);

INSERT INTO Orders (onum, amt, odate, cnum, snum) VALUES
(3001, 18.69, '1994-10-03', 2008, 1007),
(3002, 1900.10, '1994-10-03', 2007, 1004),
(3003, 767.19, '1994-10-03', 2001, 1001),
(3005, 5160.45, '1994-10-03', 2003, 1002),
(3006, 1098.16, '1994-10-04', 2008, 1007),
(3007, 75.75, '1994-10-05', 2004, 1002),
(3008, 4723.00, '1994-10-05', 2001, 1001),
(3009, 1713.23, '1994-10-06', 2002, 1003),
(3010, 1309.95, '1994-10-06', 2004, 1002),
(3011, 989.88, '1994-10-06', 2006, 1001);

# 4.	Write a query to match the salespeople to the customers according to the city they are living.
select s.snum as salesperson_no,
s.sname as salesperson_name,
s.city as city,
c.cnum as customer_no,
c.cname as customer_name 
from salespeople s join cust c on s.city = c.city; 

# 5.	Write a query to select the names of customers and the salespersons who are providing service to them
select c.cname as customer_name,
 s.sname as salesperson_name
from cust c join salespeople s 
      on c.snum = s.snum;
      
# 6.	Write a query to find out all orders by customers not located in the same cities as that of their salespeople
select o.onum as order_no,
o.amt as amount,
o.odate as order_date,
c.cnum as customer_no,
c.cname as customer_name,
c.city as coustomer_city,
s.sname as salesperson_name,
s.city as salesperson_city
from orders o 
join cust c on o.snum = c.snum
join salespeople s on o.snum = s.snum
where c.city <> s.city;  

# 7.	Write a query that lists each order number followed by name of customer who made that order
select o.onum as order_no,
c.cname as customer_name
from orders o join cust c on o.cnum = c.cnum;    
     
# 8. Write a query that finds all pairs of customers having the same rating
SELECT 
    c.cname as customer_name1, c1.cname as customer_name2, c.rating
FROM
    cust c
        JOIN
    cust c1 ON c.rating = c1.rating
        AND c.cnum < c1.cnum
ORDER BY rating;

#  9. Write a query to find out all pairs of customers served by a single salesperson
SELECT 
    c.cname AS customer_name1,
    c1.cname AS customer_name2,
    s.sname AS salesperson_name
FROM
    cust c
        JOIN
    cust c1 ON c.snum = c1.snum AND c.cname < c1.cname
        JOIN
    salespeople s ON s.snum = c.snum;
    
#   10. Write a query that produces all pairs of salespeople who are living in same city
SELECT 
    s.sname AS salesperson_name1,
    s1.sname AS salesperson_name2,
    s.city
FROM
    salespeople s
        JOIN
    salespeople s1 ON s.city = s1.city AND s.snum < s1.snum; 
  
  # 11. Write a Query to find all orders credited to the same salesperson who services Customer 2008
  SELECT 
    o.onum AS order_no,
    s.snum AS salesperson_no,
    s.sname AS salesperson_name
FROM
    orders o
        JOIN
    salespeople s ON o.snum = s.snum
WHERE
    o.cnum = 2008;  
    
  # 12.	Write a Query to find out all orders that are greater than the average for Oct 4th
SELECT 
    *
FROM
    orders
WHERE
    amt > (SELECT 
            AVG(amt) AS avg_amount
        FROM
            orders
        WHERE
            DATE_FORMAT(odate, '%m-%d') = '10-04');
            
 # 13.	Write a Query to find all orders attributed to salespeople in London.
 SELECT 
    o.onum AS order_no,
    o.amt AS amount,
    odate AS order_date,
    s.sname AS salesperson_name,
    s.city AS salesperson_city
FROM
    orders o
        JOIN
    salespeople s ON o.snum = s.snum
WHERE
    s.city = 'London';
    
 #   14. Write a query to find all the customers whose cnum is 1000 above the snum of Serres. 
SELECT 
    *
FROM
    cust c
        JOIN
    salespeople s ON c.snum = s.snum
WHERE
    c.cnum > 1000 AND s.sname = 'serres';
    
 # 15.	Write a query to count customers with ratings above San Jose’s average rating.
SELECT 
    COUNT(*) AS customer_above_avg
FROM
    cust c
WHERE
    rating > (SELECT 
            AVG(rating)
        FROM
            cust
        WHERE
            city = 'san jose');
            
 # 16.	Write a query to show each salesperson with multiple customers.
SELECT 
    c.snum AS salesperson_name,
    s.sname AS salesperson_name,
    COUNT(c.cnum) AS customer_count
FROM
    cust c
        JOIN
    salespeople s ON c.snum = s.snum
GROUP BY s.snum , s.sname
HAVING COUNT(cnum) > 1;