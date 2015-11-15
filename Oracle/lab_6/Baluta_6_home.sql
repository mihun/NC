/* Этап 1 Выполнение сложных SELECT-запросов. */

/* 1. Выполнить запрос, который:
- получает названия должностей;
- на указанных должностях должны работать сотрудники. 
*/
SELECT j.job_title
	FROM JOBS j
	WHERE EXISTS (
			SELECT e.job_id 
			FROM EMPLOYEES e 
			WHERE e.job_id = j.job_id);
/*
JOB_TITLE
-------------------------------
President
Administration Vice President
Programmer
Finance Manager
Accountant
Purchasing Manager
Purchasing Clerk	

19 rows selected.
*/		

			
/* 2. Выполнить запрос, который:
- получает фамилию сотрудников и их зарплату;
- размер зарплаты сотрудников должен быть больше средней зарплаты сотрудников,
работающих в Европе
*/
SELECT e.LAST_NAME, e.SALARY
FROM EMPLOYEES e 
WHERE e.SALARY > 
				(SELECT AVG(emp.SALARY)
				FROM EMPLOYEES emp JOIN  DEPARTMENTS dept ON(emp.DEPARTMENT_ID = dept.DEPARTMENT_ID)
				JOIN LOCATIONS loc ON (dept.LOCATION_ID = loc.LOCATION_ID)
				JOIN COUNTRIES c ON (c.country_ID = loc.country_ID)
				JOIN REGIONS r ON (r.REGION_ID = c.REGION_ID)
				WHERE r.REGION_NAME = 'Europe');
/*
LAST_NAME     SALARY
----------    -------
King	      24000
Kochhar	      17000
De Haan	      17000
Hunold	      9000
Greenberg	  12000
Faviet	      9000
Raphaely	  11000
Russell	      14000

27 rows selected.
*/
				
				
/* 3. Выполнить запрос, который:
- получает название подразделений;
- в указанных подразделениях средняя зарплата сотрудников должна быть больше средней
зарплаты сотрудников в других подразделениях. 
*/
SELECT dept.DEPARTMENT_NAME, avg(emp.SALARY) avg_sal
FROM DEPARTMENTS dept JOIN EMPLOYEES emp ON (emp.DEPARTMENT_ID = dept.DEPARTMENT_ID)
GROUP BY dept.DEPARTMENT_NAME
HAVING avg(emp.SALARY) > 
            (SELECT avg(emp2.SALARY)
            FROM DEPARTMENTS dept2 JOIN EMPLOYEES emp2 ON (emp2.DEPARTMENT_ID = dept2.DEPARTMENT_ID)
            WHERE dept2.DEPARTMENT_NAME <> dept.DEPARTMENT_NAME);
/*
DEPARTMENT_NAME    AVG_SAL
----------------   ------------------------------------------
Accounting	       10150
Executive	       19333.3333333333333333333333333333333333
Human Resources	   6500
Public Relations   10000
Finance	           8600
Sales	           8955.882352941176470588235294117647058824
Marketing	       9500

7 rows selected.
*/
		
/* 4. Выполнить запрос, который получает название страны с минимальным количеством
сотрудников по сравнению с другими странами. */
SELECT c.COUNTRY_NAME
FROM LOCATIONS loc JOIN COUNTRIES c ON(loc.COUNTRY_ID = c.COUNTRY_ID)
JOIN DEPARTMENTS dept ON (loc.LOCATION_ID = dept.LOCATION_ID)
JOIN EMPLOYEES emp ON (emp.DEPARTMENT_ID = dept.DEPARTMENT_ID)
Group by c.COUNTRY_NAME
HAVING count(emp.EMPLOYEE_ID) <= ALL (SELECT count(emp2.EMPLOYEE_ID)
                      FROM LOCATIONS loc2 JOIN COUNTRIES c2 ON(loc2.COUNTRY_ID = c2.COUNTRY_ID)
                      JOIN DEPARTMENTS dept2 ON (loc2.LOCATION_ID = dept2.LOCATION_ID)
                      JOIN EMPLOYEES emp2 ON (emp2.DEPARTMENT_ID = dept2.DEPARTMENT_ID)
                      WHERE c2.COUNTRY_NAME <> c.COUNTRY_NAME
                      Group by c2.COUNTRY_NAME);
/*
COUNTRY_NAME
-------------
Germany
*/

					  
/* 5. Выполнить запрос, который получает фамилию сотрудника с самым большим доходом
за все время работы в организации. */
SELECT emp.LAST_NAME
FROM EMPLOYEES emp
WHERE emp.SALARY*(1 + NVL(emp.COMMISSION_PCT, 0))*TRUNC(MONTHS_BETWEEN(SYSDATE, emp.HIRE_DATE)) > ALL
					(SELECT emp2.SALARY*(1 + NVL(emp2.COMMISSION_PCT, 0))*TRUNC(MONTHS_BETWEEN(SYSDATE, emp2.HIRE_DATE))
					FROM EMPLOYEES emp2
					WHERE emp2.EMPLOYEE_ID<>emp.EMPLOYEE_ID);
/*
LAST_NAME
-----------
King
*/

			
/* 6. Выполнить запрос, который получает список стран и подразделений, в которых не
работают сотрудники. */
SELECT c.COUNTRY_NAME, dept.DEPARTMENT_NAME 
FROM DEPARTMENTS dept LEFT JOIN EMPLOYEES emp ON (dept.DEPARTMENT_ID = emp.DEPARTMENT_ID)
JOIN LOCATIONS loc ON (loc.LOCATION_ID = dept.LOCATION_ID)
JOIN COUNTRIES c ON (loc.COUNTRY_ID = c.COUNTRY_ID)
WHERE NOT EXISTS (SELECT emp2.EMPLOYEE_ID
                FROM EMPLOYEES emp2 
                WHERE dept.DEPARTMENT_ID = emp2.DEPARTMENT_ID);
/*
COUNTRY_NAME                DEPARTMENT_NAME
------------------------    ------------------
United States of America	NOC
United States of America	Manufacturing
United States of America	Recruiting
United States of America	Government Sales
United States of America	Operations
United States of America	IT Support
United States of America	Benefits
United States of America	Treasury

16 rows selected.
*/

			
/* 7. Выполнить запрос, который получает:
- название подразделения
- сумму окладов сотрудников подразделения;
- процент, который сумма окладов сотрудников подразделения составляет от суммы
окладов всех сотрудников компании;
- если в подразделении нет сотрудников, то считать, что сумма их окладов равна нулю. */

WITH
amount_sal AS
(
SELECT SUM(NVL(SALARY, 0)*(1+NVL(COMMISSION_PCT, 0))) sal
FROM EMPLOYEES
)
SELECT dept.DEPARTMENT_NAME, SUM(NVL(emp.SALARY, 0)*(1+NVL(emp.COMMISSION_PCT, 0))) dept_sal, ROUND(SUM(NVL(emp.SALARY, 0)*(1+NVL(emp.COMMISSION_PCT, 0)))/amount_sal.sal*100, 2) percent
FROM DEPARTMENTS dept LEFT JOIN EMPLOYEES emp ON(emp.DEPARTMENT_ID = dept.DEPARTMENT_ID), amount_sal
GROUP BY dept.DEPARTMENT_NAME, amount_sal.sal;
/*
DEPARTMENT_NAME    DEPT_SAL    PERCENT
----------------   ---------   ---------
Purchasing         24900       3.25
Shipping	       156400	   20.44
Sales	           377140	   49.29
Accounting	       20300	   2.65
Government Sales   0	       0
Finance	           51600	   6.74
Retail Sales	   0	       0
Corporate Tax	   0	       0

27 rows selected.
*/


/* Этап 2 Выполнение запросов со сложной модификацией данных. */

/* 1. Используя одну INSERT-команду, зарегистрировать нового сотрудника с Вашей
фамилией и предпочитаемой Вами зарплатой, который будет работать:
- на должности Software Developer;
- в стране Ukraine;
- в городе Odessa;
- в подразделении NC Office.
Остальные необходимые для внесения данные выбрать самостоятельно. 
*/

CREATE SEQUENCE deptno start with 400 increment by 10;
CREATE SEQUENCE empno start with 300;
CREATE SEQUENCE locno start with 5000 increment by 100;

INSERT ALL
  INTO COUNTRIES (country_id, country_name , region_id )
    VALUES ('UA', 'Ukraine', 1) 
  INTO LOCATIONS (location_id , street_address , postal_code, city , state_province , country_id)
    VALUES (locno.nextval,  'Mihaylovska 25', '65432', 'Odessa', NULL, 'UA')
  INTO DEPARTMENTS (department_id , department_name, manager_id, location_id )
    VALUES (deptno.nextval,  'NC Office', 103, locno.currval)
  INTO JOBS (job_id , job_title, min_salary ,  max_salary  )
    VALUES ('SD',  'Software Developer', 500, 4500)
  INTO EMPLOYEES (employee_id, first_name,  last_name,  email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
    VALUES (empno.nextval,  'Michael', 'Baluta', 'MBALUTA', '063.352.6826', SYSDATE, 'SD', 1000, null, 103, deptno.currval )    
SELECT * FROM DUAL;
commit;
/*
Sequence DEPTNO created.
Sequence EMPNO created.
Sequence LOCNO created.
5 rows inserted.
Commit complete.
*/


/* 2. Ликвидировать страны, в которых не работают сотрудники. */
DELETE FROM LOCATIONS
WHERE LOCATION_ID IN (SELECT loc.LOCATION_ID
                      FROM COUNTRIES c LEFT JOIN LOCATIONS loc ON (loc.COUNTRY_ID = c.COUNTRY_ID)
                      LEFT JOIN DEPARTMENTS dept ON (loc.LOCATION_ID = dept.LOCATION_ID)
                      LEFT JOIN EMPLOYEES emp ON (emp.DEPARTMENT_ID = dept.DEPARTMENT_ID)
                      GROUP BY loc.LOCATION_ID
                      HAVING count(emp.EMPLOYEE_ID) = 0);
DELETE FROM COUNTRIES
WHERE COUNTRY_NAME IN (SELECT c.COUNTRY_NAME
                      FROM COUNTRIES c LEFT JOIN LOCATIONS loc ON (loc.COUNTRY_ID = c.COUNTRY_ID)
                      LEFT JOIN DEPARTMENTS dept ON (loc.LOCATION_ID = dept.LOCATION_ID)
                      LEFT JOIN EMPLOYEES emp ON (emp.DEPARTMENT_ID = dept.DEPARTMENT_ID)
                      GROUP BY c.COUNTRY_NAME
                      HAVING count(emp.EMPLOYEE_ID) = 0);
commit;
/*
16 rows deleted.
21 rows deleted.
Commit complete.
*/

/* 3. Сотруднику, который дольше всех работает в подразделении с самой низкой средней
зарплатой, увеличить комиссионные на 10% */
UPDATE EMPLOYEES
SET COMMISSION_PCT = NVL(COMMISSION_PCT, 0) + 0.1
WHERE EMPLOYEE_ID IN (SELECT emp.EMPLOYEE_ID
                    FROM EMPLOYEES emp JOIN DEPARTMENTS dept ON (emp.DEPARTMENT_ID = dept.DEPARTMENT_ID)
                    WHERE emp.HIRE_DATE IN (SELECT MIN(HIRE_DATE)
                                          FROM EMPLOYEES JOIN DEPARTMENTS ON (EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID)
                                          GROUP BY DEPARTMENTS.DEPARTMENT_ID))
AND DEPARTMENT_ID = (SELECT d.DEPARTMENT_ID
                    FROM DEPARTMENTS d JOIN EMPLOYEES e ON (e.DEPARTMENT_ID = d.DEPARTMENT_ID)
                    GROUP BY d.DEPARTMENT_ID
                    HAVING AVG(e.SALARY) = (SELECT MIN(AVG(e.SALARY))
                                           FROM DEPARTMENTS d JOIN EMPLOYEES e ON (e.DEPARTMENT_ID = d.DEPARTMENT_ID)
                                           GROUP BY d.DEPARTMENT_ID));
commit;
/*
1 row updated.
Commit complete.
*/	

/* 4. Перевести всех сотрудников из подразделения с самым низким количеством
сотрудников в подразделение с самой высокой средней зарплатой. */
UPDATE EMPLOYEES
SET DEPARTMENT_ID = (SELECT dept.DEPARTMENT_ID
                    FROM DEPARTMENTS dept JOIN EMPLOYEES emp ON (emp.DEPARTMENT_ID = dept.DEPARTMENT_ID)
                    GROUP BY dept.DEPARTMENT_ID
                    HAVING avg(emp.SALARY) = 
                                          (SELECT MAX(avg(emp2.SALARY))
                                          FROM DEPARTMENTS dept2 JOIN EMPLOYEES emp2 ON (emp2.DEPARTMENT_ID = dept2.DEPARTMENT_ID)
                                          GROUP BY dept2.DEPARTMENT_ID))
WHERE DEPARTMENT_ID IN 
                    (SELECT dept.DEPARTMENT_ID
                    FROM DEPARTMENTS dept JOIN EMPLOYEES emp ON (emp.DEPARTMENT_ID = dept.DEPARTMENT_ID)
                    Group by dept.DEPARTMENT_ID
                    HAVING count(emp.EMPLOYEE_ID) <= ALL (SELECT count(emp2.EMPLOYEE_ID)
                                                     FROM DEPARTMENTS dept2 JOIN EMPLOYEES emp2 ON (emp2.DEPARTMENT_ID = dept2.DEPARTMENT_ID)
                                                     WHERE dept2.DEPARTMENT_ID <> dept.DEPARTMENT_ID
                                                     Group by dept2.DEPARTMENT_ID));
commit;
/*
4 rows updated.
Commit complete.
*/


/* Этап 3 Выполнение иерархических запросов */
									   
/* 1. Выполнить запрос на получение названий подразделений, фамилий с учетом иерархии
подчинения, начиная с руководителей. 
*/
SELECT dept.DEPARTMENT_NAME, emp.LAST_NAME
FROM EMPLOYEES emp JOIN DEPARTMENTS dept ON (emp.DEPARTMENT_ID = dept.DEPARTMENT_ID) 
START WITH emp.MANAGER_ID is null
CONNECT BY prior emp.EMPLOYEE_ID = emp.MANAGER_ID 
ORDER SIBLINGS BY emp.LAST_NAME;
/*
DEPARTMENT_NAME     LAST_NAME
-----------------   -----------
Executive       	King
Sales           	Cambrault
Sales           	Bates
Sales           	Bloom
Sales           	Fox
Sales           	Kumar
Sales           	Ozer
Sales           	Smith

107 rows selected.
*/


/* 2. Выполнить запрос на получение названий подразделений, фамилий с учетом иерархии
подчинения, начиная с подчиненных. */
SELECT dept.DEPARTMENT_NAME, emp.LAST_NAME
FROM EMPLOYEES emp JOIN DEPARTMENTS dept ON (emp.DEPARTMENT_ID = dept.DEPARTMENT_ID)  
START WITH emp.LAST_NAME ='Abel'
CONNECT BY prior emp.MANAGER_ID = emp.EMPLOYEE_ID ;
/*
DEPARTMENT_NAME    LAST_NAME
----------------   -------------
Sales	           Abel
Sales	           Zlotkey
Executive	       King
*/

/* 3. Выполнить запрос на получение фамилии сотрудника, номера и названия
подразделения, где он работает, номер узла иерархии и имен всех его менеджеров через /.
Внутри одного уровня иерархии сотрудники должны быть отсортированы по названиям
подразделения. */

SELECT emp.LAST_NAME, dept.DEPARTMENT_ID dept_id, dept.DEPARTMENT_NAME, level, SYS_CONNECT_BY_PATH(emp.LAST_NAME, '/') as Path
FROM EMPLOYEES emp JOIN DEPARTMENTS dept ON(emp.DEPARTMENT_ID = dept.DEPARTMENT_ID)
START WITH emp.MANAGER_ID is null
CONNECT BY PRIOR emp.EMPLOYEE_ID = emp.MANAGER_ID
ORDER SIBLINGS BY dept.DEPARTMENT_NAME;
/*
LAST_NAME     DEPT_ID    DEPARTMENT_NAME    LEVEL       MNG
----------    --------   ----------------   -------     ----------------------
King	      90	     Executive	        1	        /King
Kochhar	      90	     Executive	        2	        /King/Kochhar
Higgins	      110	     Accounting	        3	        /King/Kochhar/Higgins
Gietz	      110	     Accounting	        4	        /King/Kochhar/Higgins/Gietz
Whalen	      90	     Executive	        3	        /King/Kochhar/Whalen
Mavris	      90	     Executive	        3	        /King/Kochhar/Mavris
Baer	      90	     Executive	        3	        /King/Kochhar/Baer
Greenberg	  100	     Finance	        3	        /King/Kochhar/Greenberg
*/

/* 4. Выполнить запрос на получение:
- календаря на предыдущий, текущий и следующий месяц текущего года
- формат вывода: номер дня в месяце (две цифры), полное название месяца,
- по каждому месяцу количество возвращаемых строк должно точно соответствовать
количеству дней в месяце. */
SELECT TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'), -1)+rownum-1
             , 'DD fmMONTH'
             , 'NLS_DATE_LANGUAGE=AMERICAN') AS d
FROM dual
CONNECT BY ROWNUM <= TO_CHAR(LAST_DAY(ADD_MONTHS(TRUNC(SYSDATE,'MM'), -1)), 'DD') + TO_CHAR(LAST_DAY(SYSDATE), 'DD') + TO_CHAR(LAST_DAY(ADD_MONTHS(TRUNC(SYSDATE,'MM'), +1)), 'DD');
/*
D
--------------
01 OCTOBER
02 OCTOBER
03 OCTOBER
04 OCTOBER
05 OCTOBER
06 OCTOBER
07 OCTOBER
08 OCTOBER

92 rows selected.
*/










			
