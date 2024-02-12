SELECT TOP (1000) [EmployeeID]
      ,[JobTitle]
      ,[Salary]
  FROM [SQL Tutorial].[dbo].[EmployeeSalary]

  SELECT *
  From [SQL Tutorial].dbo.EmployeeDemographics

  SELECT JobTitle, AVG(Salary)
  FROM [SQL Tutorial].dbo.EmployeeDemographics
  Inner Join [SQL Tutorial].dbo.EmployeeSalary
  ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
  WHERE JobTitle = 'Salesman'
  GROUP BY Jobtitle

  