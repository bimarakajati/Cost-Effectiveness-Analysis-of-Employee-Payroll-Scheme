WITH
  bloom AS (
  SELECT
    employe_id,
    salary,
    DATE_DIFF(resign_date, join_date, month) AS Length_of_Work,
    EXTRACT(year FROM date) AS Year,
    CAST(TIME_DIFF(checkout, checkin, hour) AS int) AS Duration
  FROM
    `TheBloomCompany.I_CID_04.employees` AS employees
  FULL OUTER JOIN
    `TheBloomCompany.I_CID_04.timesheets` AS timesheets
  ON
    employees.employe_id = timesheets.employee_id
  WHERE
    checkout IS NOT NULL AND checkin IS NOT NULL)

SELECT
  *
FROM (
  SELECT
    *,
    CASE
      WHEN Salary_per_Hour >= 115000 THEN 40
      WHEN Salary_per_Hour BETWEEN 110000 AND 115000 THEN 45
      WHEN Salary_per_Hour BETWEEN 105000 AND 110000 THEN 50
      WHEN Salary_per_Hour BETWEEN 100000 AND 105000 THEN 55
      WHEN Salary_per_Hour BETWEEN 97500 AND 100000 THEN 100
      WHEN Salary_per_Hour BETWEEN 95000 AND 97500 THEN 95
      WHEN Salary_per_Hour BETWEEN 90000 AND 95000 THEN 90
      WHEN Salary_per_Hour BETWEEN 85000 AND 90000 THEN 85
      WHEN Salary_per_Hour BETWEEN 80000 AND 85000 THEN 80
      WHEN Salary_per_Hour BETWEEN 75000 AND 80000 THEN 75
      WHEN Salary_per_Hour BETWEEN 70000 AND 75000 THEN 70
      WHEN Salary_per_Hour BETWEEN 65000 AND 70000 THEN 65
      WHEN Salary_per_Hour <= 65000 THEN 60
  END
    AS Effectiveness_Score
  FROM (
    SELECT
      *,
      ROUND(Salary_per_Month/126) AS Salary_per_Hour
    FROM (
      SELECT
        employe_id AS Employe_ID,
        MAX(bloom.salary) AS Salary_per_Month,
        SUM(Duration) AS Total_Hours_Worked
      FROM
        bloom
      WHERE
        Year = 2020
      GROUP BY
        Employe_ID))
)
WHERE
   Total_Hours_Worked > 0
   AND Effectiveness_Score <= 50
ORDER BY
  Employe_ID asc