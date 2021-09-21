-- Hello! I wrote this script to showcase my mastery of basic, intermediate and advanced SQL Concepts.

-- #1. Table 1: Create Employee Demographics Table

	Create Table EmployeeDemographics
	(EmployeeID Int, 
	FirstName Varchar(50),
	LastName Varchar(50), 
	Age Int, 
	Gender Varchar(50)) 

-- #2. Table 1: Insert Data Into Employee Demographics Table

	Insert Into EmployeeDemographics Values
	(1001, 'Jim', 'Halpert', 30, 'Male'),
	(1002, 'Pam', 'Beasley', 30, 'Female'),
	(1003, 'Dwight', 'Schrute', 29, 'Male'),
	(1004, 'Angela', 'Martin', 31, 'Female'),
	(1005, 'Toby', 'Flenderson', 32, 'Male'),
	(1006, 'Michael', 'Scott', 35, 'Male'),
	(1007, 'Meredith', 'Palmer', 32, 'Female'),
	(1008, 'Stanley', 'Hudson', 38, 'Male'),
	(1009, 'Kevin', 'Malone', 31, 'Male')

-- #3. Table 2: Create Employee Salary Table

	Create Table EmployeeSalary
	(EmployeeID Int,
	JobTitle Varchar(50),
	Salary Int)



-- #4. Table 2: Insert Data Into Employee Salary Table

	Insert Into EmployeeSalary Values
	(1001, 'Salesman', 45000),
	(1002, 'Receptionist', 36000),
	(1003, 'Salesman', 63000),
	(1004, 'Accountant', 47000),
	(1005, 'HR', 50000),
	(1006, 'Regional Manager', 65000),
	(1007, 'Supplier Relations', 41000),
	(1008, 'Salesman', 48000),
	(1009, 'Accountant', 42000)

-- #5. Showing Use Of The "Where" And "And" Statement

	Select *
	From EmployeeDemographics
	Where Age <= 32 And Gender = 'Male'

-- #6. Showing Use Of "Group By" Statement

	Select Gender, Count(Gender)
	From EmployeeDemographics
	Group By Gender 


-- #7. Showing Use Of "Order By" And "Desc" Statement

	Select Gender, Count(Gender)
	From EmployeeDemographics
	Group By Gender 
	Order By Gender Desc


-- #8. Join Tables 

	Select * 
	From [SQL Tutorial].dbo.EmployeeDemographics
	Full Outer Join  [SQL Tutorial].dbo.EmployeeSalary
	On EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
	
-- #9. ID The Employee With Highest Salary (Not Michael B/c It Is His Request)

	Select EmployeeDemographics.EmployeeID, FirstName, LastName, Salary
	From [SQL Tutorial].dbo.EmployeeDemographics
	Inner Join  [SQL Tutorial].dbo.EmployeeSalary
	On EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
	Where FirstName <> 'Michael'
	Order By Salary Desc

-- #10. Average Salesman Salary

	Select JobTitle, Avg(Salary)
	From [SQL Tutorial].dbo.EmployeeDemographics
	Inner Join [SQL Tutorial].dbo.EmployeeSalary
	On EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
	Where JobTitle = 'Salesman'
	Group By JobTitle

-- #11. Create WareHouseEmployeeDemographics Table

	Create Table WareHouseEmployeeDemographics 
	(EmployeeID int, 
	FirstName varchar(50), 
	LastName varchar(50), 
	Age int, 
	Gender varchar(50))

-- #12. Insert Data Into WareHouseEmployeeDemographics Table

	Insert into WareHouseEmployeeDemographics VALUES
	(1013, 'Darryl', 'Philbin', NULL, 'Male'),
	(1050, 'Roy', 'Anderson', 31, 'Male'),
	(1051, 'Hidetoshi', 'Hasagawa', 40, 'Male'),
	(1052, 'Val', 'Johnson', 31, 'Female')

-- #13. Using "Union" Statement

	Select *
	From [SQL Tutorial].dbo.EmployeeDemographics
	Union
	Select *
	From [SQL Tutorial].dbo.WareHouseEmployeeDemographics
	Order By EmployeeID

-- #14. Using "Case" Statement

	Select FirstName, LastName, Age,
	Case
	When Age >= 30 Then 'Old'
	Else ' Young'
	End
	From [SQL Tutorial].dbo.EmployeeDemographics
	Where Age is Not Null
	Order By Age

-- #15. Using "Case" Statement With Raise

	Select FirstName, LastName, JobTitle, Salary,
	Case
	When JobTitle = 'Salesman' Then Salary + (Salary * .10)
	When JobTitle = 'Accountant' Then Salary + (Salary * .05)
	When JobTitle = 'HR' Then Salary + (Salary * .000001)
	Else Salary  + (Salary * .03)
	End As SalaryAfterRaise
	From [SQL Tutorial].dbo.EmployeeDemographics
	Join [SQL Tutorial].dbo.EmployeeSalary
	On EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

-- #16. Using "Having Clause"

	Select JobTitle, Count(JobTitle)
	From [SQL Tutorial].dbo.EmployeeDemographics
	Join  [SQL Tutorial].dbo.EmployeeSalary
	On EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
	Group By JobTitle
	Having Count(JobTitle) > 1

-- #17. Updating Data

	Select *
	From [SQL Tutorial].dbo.EmployeeDemographics
	Update [SQL Tutorial].dbo.EmployeeDemographics
	Set EmployeeID = 1002
	Where FirstName = 'Pam' And LastName = 'Beasley'

	Select *
	From [SQL Tutorial].dbo.EmployeeDemographics
	Update [SQL Tutorial].dbo.EmployeeDemographics
	Set Age = 31, Gender = 'Male'
	Where FirstName = 'Pam' And LastName = 'Beasley'

-- #18. Delete Data

	Delete From [SQL Tutorial].dbo.EmployeeDemographics
	Where EmployeeID = 1005


-- #19. Use "Aliasing" 

	Select FirstName + ' ' + LastName As FullName
	From [SQL Tutorial].dbo.EmployeeDemographics

	Select Demo.EmployeeID
	From [SQL Tutorial].dbo.EmployeeDemographics As Demo
	Join  [SQL Tutorial].dbo.EmployeeSalary As Sal
	On Demo.EmployeeID = Sal.EmployeeID

-- #20. Use "Partition By" Statement

	Select 	FirstName, LastName, Gender, Salary, 
	Count(Gender) Over(Partition By Gender) As TotalGender
	From [SQL Tutorial].dbo.EmployeeDemographics Demo
	Join  [SQL Tutorial].dbo.EmployeeSalary Sal
	On Demo.EmployeeID = Sal.EmployeeID

-- #21. Using "CTE"

	With CTE_Employee As 
	(Select FirstName, LastName, Gender, Salary,
	Count(Gender) Over(Partition By Gender) As TotalGender,
	Avg(Salary) Over(Partition By Gender) As AvgSalary
	From [SQL Tutorial].dbo.EmployeeDemographics Demo
	Join [SQL Tutorial].dbo.EmployeeSalary Sal
	On Demo.EmployeeID = Sal.EmployeeID
	Where Salary > '4500') 
	Select * 
	From CTE_Employee

-- #22. Create Temp Tables

	Create Table #Temp_Employee (
	EmployeID Int,
	JobTitle Varchar(100),
	Salary Int)

	Select *
	From #Temp_Employee

	Insert Into #Temp_Employee Values
	('1001', 'HR', '45000')

	Insert Into #Temp_Employee
	Select *
	From [SQL Tutorial].dbo.EmployeeSalary

-- #23. String Functions (Trim, LTrim, RTrim, Replace, Substring)

	CREATE TABLE EmployeeErrors (
	EmployeeID varchar(50)
	,FirstName varchar(50)
	,LastName varchar(50)
	)

	Insert into EmployeeErrors Values 
	('1001  ', 'Jimbo', 'Halbert')
	,('  1002', 'Pamela', 'Beasely')
	,('1005', 'TOby', 'Flenderson - Fired')

	Select *
	From EmployeeErrors
	
	-- Trim

	Select EmployeeID, Trim(EmployeeID) As IDTrim
	From EmployeeErrors

	Select EmployeeID, LTrim(EmployeeID) As IDTrim
	From EmployeeErrors

	Select EmployeeID, RTrim(EmployeeID) As IDTrim
	From EmployeeErrors

	-- Replace

	Select LastName, Replace(LastName, '- Fired', '') As LastNameFixed
	From EmployeeErrors

	-- Substring

	Select Substring(FirstName, 1, 3)
	From EmployeeErrors

	Select *
	From EmployeeErrors Err
	Join EmployeeDemographics Demo
	On Substring(Err.FirstName, 1, 3)  = Substring(Demo.FirstName, 1, 3)

	-- Using Upper and Lower

	Select FirstName, Lower(FirstName)
	From EmployeeErrors

	Select FirstName, Upper(FirstName)
	From EmployeeErrors

-- #24. Stored Procedures

	Create Procedure Test
	As 
	Select *
	From EmployeeDemographics

	Exec Test



	Create Procedure Temp_Employee
	As 
	Create Table #Temp_Employee
	(JobTitle Varchar(100),
	EmployeesPerJob Int,
	AvgAge Int,
	AvgSalary Int)


-- #25. Subqueries

	Select EmployeeID, Salary, (Select Avg(Salary) From EmployeeSalary) As AllAvgSalary
	From EmployeeSalary

