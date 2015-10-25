SET PAGESIZE 120
COL LASTNAME FORMAT A14
COL MNG_LASTNAME FORMAT A14
COL SALARY FORMAT 9999999
COL ANNUAL FORMAT 99999999
COL INFORMATION FORMAT A50
COL DEPARTMENT_NAME FORMAT A24
COL DEPT_NAME FORMAT A24
COL JOB FORMAT A28
COL DEPT_ID FORMAT 9999
COL EMP_ID FORMAT 9999
COL MNG_ID FORMAT 9999
COL NUM FORMAT 999
COL AVR_SAL FORMAT 9999999



/* 2.1 Выборка данных */

/* 1. Выполнить запрос, который получает фамилии сотрудников и их E-mail адреса в
полном формате: значение атрибута E-mail + "@Netcracker.com"
*/
SELECT last_name LastName, email||'@Netcracker.com' Full_Email
	FROM EMPLOYEES;
/*
LASTNAME     FULL_EMAIL                                                         
------------ ------------------------------                                     
King         SKING@Netcracker.com                                               
Kochhar      NKOCHHAR@Netcracker.com                                            
De Haan      LDEHAAN@Netcracker.com                                             
Hunold       AHUNOLD@Netcracker.com                                             
Ernst        BERNST@Netcracker.com                                              
Austin       DAUSTIN@Netcracker.com                                             
Pataballa    VPATABAL@Netcracker.com                                            
*/

/* 2. Выполнить запрос, который:
- получает фамилию сотрудников и их зарплату;
- зарплата превышает 15000$.
*/
SELECT last_name LASTNAME, salary
    FROM EMPLOYEES
    WHERE salary > 15000;
/*
LASTNAME       SALARY                                                           
------------ --------                                                           
King            24000                                                           
Kochhar         17000                                                           
De Haan         17000  
*/ 

/* 3. Выполнить запрос, который получает фамилии сотрудников, зарплату, комиссионные,
их зарплату за год с учетом комиссионных.
*/
SELECT last_name LASTNAME, salary, NVL(commission_pct, 0) comm, salary*12*(NVL(commission_pct, 0) + 1) ANNUAL
    FROM EMPLOYEES;
/*
LASTNAME       SALARY       COMM     ANNUAL                                     
------------ -------- ---------- ----------                                     
King            24000          0     288000                                     
Kochhar         17000          0     204000                                     
De Haan         17000          0     204000                                     
Hunold           9000          0     108000                                     
Partners        13500         ,3     210600                                     
Errazuriz       12000         ,3     187200                                     
Cambrault       11000         ,3     171600                                     
*/

/* 2.2 Работа со множествами */

/* 1. Выполнить запрос, который:
- получает для каждого сотрудника cтроку в формате
'Dear '+A+ ' ' + B + ’! ' + ‘ Your salary = ‘ + C,
где A = {‘Mr.’,’Mrs.’} – сокращенный вариант обращения к мужчине или женщине
(предположить, что женщиной являются все сотрудницы, имя которых заканчивается на букву
‘a’ или ‘e’)
B – фамилия сотрудника;
C – годовая зарплата с учетом комиссионных сотрудника
*/
SELECT 'Dear '||'Mrs.'||' '||last_name||'!'||' Your salary = '||12*salary*(NVL(commission_pct, 0) + 1) AS INFORMATION
	FROM EMPLOYEES
	WHERE first_name LIKE '%a'
	OR first_name LIKE '%e'
 UNION
 SELECT 'Dear '||'Mr.'||' '||last_name||'!'||' Your salary = '||12*salary*(NVL(commission_pct, 0) + 1) AS INFORMATION
	FROM EMPLOYEES
	WHERE NOT(first_name LIKE '%a' OR first_name LIKE '%e');
/*
INFORMATION                                                                     
--------------------------------------------------------------------------------
Dear Mr. Abel! Your salary = 171600                                             
Dear Mr. Ande! Your salary = 84480                                              
Dear Mr. Austin! Your salary = 57600                                            
Dear Mr. Weiss! Your salary = 96000                                             
Dear Mr. Whalen! Your salary = 52800                                            
Dear Mrs. Bissot! Your salary = 39600                                           
Dear Mrs. Cambrault! Your salary = 108000                                       
Dear Mrs. Dellinger! Your salary = 40800                                        
*/

/* 2.3 Операции соединения таблиц */

/* 1. Выполнить запрос, который:
- получает названия подразделений;
- подразделения расположены в городе Seattle.
*/
SELECT dept.department_name
   	FROM DEPARTMENTS dept JOIN LOCATIONS loc ON (dept.location_id = loc.location_id)
   	WHERE loc.city = 'Seattle';
/*
DEPARTMENT_NAME                                                                 
------------------------------                                                  
Administration                                                                  
Purchasing                                                                      
Executive                                                                       
Finance                                                                         
Accounting                                                                      
Treasury                                                                        
Corporate Tax    
*/

/* 2. Выполнить запрос, который:
- получает фамилию, должность, номер подразделения сотрудников
- сотрудники работают в городе Toronto.
*/
SELECT emp.last_name lastname, jobs.job_title job,  emp.department_id dept_id
   	FROM EMPLOYEES emp JOIN JOBS  ON (emp.job_id = jobs.job_id)
   	JOIN DEPARTMENTS dept ON (emp.department_id = dept.department_id)
  	JOIN LOCATIONS loc ON (dept.location_id = loc.location_id)
   	WHERE loc.city = 'Toronto';
/*
LASTNAME     JOB                            DEPT_ID                             
------------ ------------------------------ -------                             
Hartstein    Marketing Manager                   20                             
Fay          Marketing Representative            20 
*/

/* 3. Выполнить запрос, который:
- получает номер и фамилию сотрудника, номер и фамилию его менеджера
- для сотрудников без менеджеров выводить фамилию менеджера в виде «No manager».
*/
SELECT emp.employee_id emp_id, emp.last_name lastname, mng.employee_id mng_id, NVL(mng.last_name, 'No manager') mng_lastname
  	FROM EMPLOYEES emp LEFT JOIN EMPLOYEES mng ON (emp.manager_id = mng.employee_id);
/*
 EMP_ID LASTNAME      MNG_ID MNG_LASTNAME                                       
------- ------------ ------- --------------                                     
    178 Grant            149 Zlotkey                                            
    177 Livingston       149 Zlotkey                                            
    176 Taylor           149 Zlotkey                                            
    175 Hutton           149 Zlotkey                                            
    174 Abel             149 Zlotkey                                            
    202 Fay              201 Hartstein                                          
    206 Gietz            205 Higgins                                            
    100 King                 No manager   
*/

/* 4. Выполнить запрос, который:
- получает номер и название подразделений;
- подразделения расположены в стране UNITED STATES OF AMERICA
- в подразделениях не должно быть сотрудников.
*/
SELECT d.department_id dept_id, d.department_name
	from DEPARTMENTS d LEFT JOIN EMPLOYEES emp ON (d.department_id = emp.department_id)
	JOIN LOCATIONS loc ON (d.location_id = loc.location_id)
	JOIN COUNTRIES c ON (loc.country_id = c.country_id)
	WHERE c.country_name = 'United States of America' AND emp.employee_id IS NULL;
/*
DEPT_ID DEPARTMENT_NAME                                                         
------- ------------------------------                                          
    220 NOC                                                                     
    170 Manufacturing                                                           
    240 Government Sales                                                        
    260 Recruiting                                                              
    200 Operations                                                              
    210 IT Support                                                              
    160 Benefits                                                                
    120 Treasury                                                                
    270 Payroll                  
*/

/* 2.4 Агрегация данных */

/*
1. Выполнить запрос, который:
- получает кол-во сотрудников в каждом подразделении;
- кол-во сотрудников не должно быть меньше 2;
*/
SELECT d.department_name dept_name, count(emp.employee_id) num
	from DEPARTMENTS d LEFT JOIN EMPLOYEES emp ON (d.department_id = emp.department_id)
	GROUP BY d.department_name
	HAVING count(emp.employee_id) >= 2;
/*
DEPT_NAME      NUM                                                              
------------ -----                                                              
Accounting       2                                                              
Executive        3                                                              
IT               5                                                              
Purchasing       6                                                              
Shipping        45                                                              
Finance          6                                                              
Sales           34                                                              
Marketing        2  
*/

/*2. Выполнить запрос, который:
- получает названия должностей и среднюю зарплату по должности;
- должность должна быть связана с управлением, т.е. содержать слово Manager;
- средняя зарплата не должна быть менее 10 тысяч.
*/
SELECT j.job_title job, AVG(e.salary) avr_sal
	FROM EMPLOYEES e JOIN jobs j ON (e.job_id=j.job_id)
	GROUP BY j.job_title
	HAVING j.job_title LIKE '%Manager%' AND AVG(e.salary) >= 10000;
/*
JOB                        AVR_SAL                                              
------------------------ ---------                                              
Accounting Manager           12000                                              
Finance Manager              12000                                              
Purchasing Manager           11000                                              
Sales Manager                12200                                              
Marketing Manager            13000  
*/

/* 3. Выполнить запрос, который:
- получает кол-во сотрудников в каждом подразделении;
- последней строкой ответа на запрос должно быть общее кол-во сотрудников.
*/
SELECT d.department_name dept_name, count(emp.employee_id) num
	from DEPARTMENTS d LEFT JOIN EMPLOYEES emp ON (d.department_id = emp.department_id)
	GROUP BY ROLLUP(d.department_name);
/*
DEPT_NAME                  NUM                                                  
------------------------ -----                                                  
Recruiting                   0                                                  
Retail Sales                 0                                                  
Sales                       34                                                  
Shareholder Services         0                                                  
Shipping                    45                                                  
Treasury                     0                                                  
                           106                                                  

28 rows selected.
*/
	


    