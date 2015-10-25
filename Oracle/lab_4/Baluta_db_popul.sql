

/*1.1.1 Создать представление, которое:
- получает фамилию сотрудников и количество месяцев, прошедшее с момента найма на
работу;
- фамилию сотрудников представить как: первая буква в верхнем регистре, остальные - в
нижнем;
- количество месяцев округлить до ближайшего целого;
- отсортировать сотрудников по убыванию периода работы.
Выполните запрос к созданному представлению. 
*/
CREATE VIEW emp_month
AS SELECT INITCAP(last_name) lastname, ROUND (MONTHS_BETWEEN(SYSDATE, hire_date)) monthes
FROM EMPLOYEES 
ORDER BY monthes DESC;

SELECT * FROM emp_month;
/*
LASTNAME                     MONTHES                                            
------------------------- ----------                                            
King                             345                                            
Whalen                           337                                            
Kochhar                          313                                            
Hunold                           310                                            
Ernst                            293                                            
De Haan                          273                                            
Mavris                           261                                            
Baer                             261                                           
*/


/*1.1.2. Создать представление, которое:
- получает фамилии, имена сотрудников;
- получает для сотрудников надбавку к зарплате "Tax", которая определяется как 0.4% за
каждый месяц работы для Programmer, 0.3% за каждый месяц работы дляAccountant, 0.2% за каждый
месяц работы для Sales Manager 0.1% за каждый месяц работы для Administration Assistant.
Выполните запрос к созданному представлению. 
*/

CREATE VIEW emp_taxs
AS SELECT last_name lastname, first_name firstname, 
  DECODE (job_id, 'IT_PROG', TRUNC (MONTHS_BETWEEN(SYSDATE, hire_date))*salary*0.004,
                  'FI_ACCOUNT', TRUNC (MONTHS_BETWEEN(SYSDATE, hire_date))*salary*0.003,
                  'SA_MAN', TRUNC (MONTHS_BETWEEN(SYSDATE, hire_date))*salary*0.002,
                  'AD_ASST', TRUNC (MONTHS_BETWEEN(SYSDATE, hire_date))*salary*0.001,
                              0) TAX
FROM EMPLOYEES;

SELECT * FROM emp_taxs;
/*
LASTNAME                  FIRSTNAME                   TAX                       
------------------------- -------------------- ----------                       
King                      Steven                        0                       
Kochhar                   Neena                         0                       
De Haan                   Lex                           0                       
Hunold                    Alexander                 11124                       
Ernst                     Bruce                      7008                       
Austin                    David                    4300,8                       
Pataballa                 Valli                    4070,4                       
Lorentz                   Diana                      3360 
*/


/* 1.1.3. Создать представление, которое:
- получает фамилии сотрудников и количество выходных дней (суббота, воскресенье) с
момента их зачисления на работу;
- сотрудники зачислены в марте 1999 года.
Выполните запрос к созданному представлению. 
*/
ALTER SESSION SET NLS_Language='american';
CREATE VIEW emp_weekend
AS SELECT last_name lastname, (NEXT_DAY(TRUNC(SYSDATE), 'SUNDAY') - NEXT_DAY(TRUNC(hire_date), 'SUNDAY'))/7 +
                           (NEXT_DAY(TRUNC(SYSDATE), 'SATURDAY') - NEXT_DAY(TRUNC(hire_date), 'SATURDAY'))/7 WEEKEND
FROM EMPLOYEES
WHERE TO_CHAR(hire_date, 'fmMM YYYY') = '3 1999';

SELECT * FROM emp_weekend;
/*
LASTNAME     WEEKEND                        
------------ -----------
Greene	     1732
Bates	     1730
Jones	     1732
*/


/* Этап 2. Первичное заполнение таблиц БД, хранящих данные о проектах ( новая БД ) */

/* 2.1. Для всех таблиц новой БД создать генераторы последовательности, обеспечивающие
автоматическое создание новых значений колонок, входящих в первичный ключ. 
*/
CREATE SEQUENCE job_job_id;
CREATE SEQUENCE loc_loc_id;
CREATE SEQUENCE product_prod_id;
CREATE SEQUENCE emp_emp_id;
CREATE SEQUENCE mng_mng_id;
CREATE SEQUENCE dept_dept_id;
/*
Sequence JOB_JOB_ID created.
Sequence LOC_LOC_ID created.
Sequence PRODUCT_PROD_ID created.
Sequence EMP_EMP_ID created.
Sequence MNG_MNG_ID created.
Sequence DEPT_DEPT_ID created.
*/

/* 2.2. Для каждой таблицы новой БД создать 2 команды на внесение данных(внести две строки). 
*/
IINSERT INTO	JOB 
	VALUES	(job_job_id.NEXTVAL, 'IT manager', 12000);
INSERT INTO	JOB 
	VALUES	(job_job_id.NEXTVAL, 'SA manager', 14000);
INSERT INTO	LOCATION 
	VALUES	(loc_loc_id.NEXTVAL, 'England', 'London', 'White 15');
INSERT INTO	LOCATION 
	VALUES	(loc_loc_id.NEXTVAL, 'France', 'Paris', 'Vaneau 10');
INSERT INTO	PRODUCT 
	VALUES	(product_prod_id.NEXTVAL, 'Engine', 5700, 6900);
INSERT INTO	PRODUCT 
	VALUES	(product_prod_id.NEXTVAL, 'Remote control', 2300, 3500);
ALTER TABLE MANAGER 
  DISABLE CONSTRAINT fk_emp_id;
INSERT INTO	MANAGER 
	VALUES	(mng_mng_id.NEXTVAL, 1);  
INSERT INTO	MANAGER 
	VALUES	(mng_mng_id.NEXTVAL, 2);
ALTER TABLE EMPLOYEES 
  DISABLE CONSTRAINT fk_dept_id;  
INSERT INTO	EMPLOYEES 
	VALUES	(emp_emp_id.NEXTVAL, 'Bach', TO_DATE('21-02-2002', 'dd-mm-yyyy'), 1, 1, null);
INSERT INTO	EMPLOYEES 
	VALUES	(emp_emp_id.NEXTVAL, 'Barrios', TO_DATE('13-09-2003', 'dd-mm-yyyy'), 2, 2, null);
INSERT INTO	DEPARTMENTS 
	VALUES	(dept_dept_id.NEXTVAL, 'IT', 1, 1, 1);
INSERT INTO	DEPARTMENTS 
	VALUES	(dept_dept_id.NEXTVAL, 'Sales', 2, 2, 2);
ALTER TABLE MANAGER 
  ENABLE CONSTRAINT fk_emp_id;
ALTER TABLE EMPLOYEES 
  ENABLE CONSTRAINT fk_dept_id;
/*
1 row inserted.
1 row inserted.
1 row inserted.
1 row inserted.
1 row inserted.
1 row inserted.
Table MANAGER altered.
1 row inserted.
1 row inserted.
Table EMPLOYEES altered.
1 row inserted.
1 row inserted.
1 row inserted.
1 row inserted.
Table MANAGER altered.
Table EMPLOYEES altered.
*/

/* 2.3. Выполнить команду по фиксации всех изменений в БД. 
*/
commit;
/*
Commit complete.
*/
/* 2.4. Для одной из таблиц, содержащей ограничение целостности внешнего ключа, выполнить
команду по изменению значения колонки внешнего ключа на значение, отсутствующее в колонке  
*/
UPDATE DEPARTMENTS
SET loc_id = 7
WHERE DEPT_ID = 1;
/*
SQL Error: ORA-02291: integrity constraint (NEW_DB.FK_LOC_ID) violated - parent key not found
*/

/* 2.5. Для одной из таблиц, содержащей ограничение целостности первичного ключа, выполнить
команду по изменению значения колонки первичного ключа на значение, отсутствующее в колонке
внешнего ключа соответствующей таблицы. Проверить реакцию СУБД на подобное изменение.   
*/
UPDATE LOCATION
SET loc_id = 7
WHERE loc_id = 1;
/*
SQL Error: ORA-02292: integrity constraint (NEW_DB.FK_LOC_ID) violated - child record found
*/

/* 2.6. Для одной из таблиц, содержащей ограничение целостности первичного ключа, выполнить
одну команду по удалению строки со значением колонки первичного ключа, присутствующее в
колонке внешнего ключа соответствующей таблицы. Проверить реакцию СУБД на изменение.   
*/
DELETE FROM LOCATION
WHERE loc_id = 1;
/*
SQL Error: ORA-02292: integrity constraint (NEW_DB.FK_LOC_ID) violated - child record found
*/

/* 2.7. Для одной из таблиц изменить ограничение целостности внешнего ключа,
обеспечивающее каскадное удаление. Повторить задание 2.6 для измененной таблицы.
*/ 
ALTER TABLE EMPLOYEES DISABLE CONSTRAINT fk_loc_id;
DELETE FROM LOCATION
WHERE loc_id = 1;
/*
1 row deleted.
*/

/* 2.8. Выполнить команду по отмене (откату) операции удаления из пункта 2.6 
*/
ROLLBACK;
/*
Rollback complete.
*/

/* Этап 3. Ведение операций изменения БД */

/* 3.1. Увеличить комиссионные на 5% всем программистам (Programmer), которые проработали
более 20 лет. 
*/
UPDATE EMPLOYEES
SET commission_pct = NVL(commission_pct, 0) + 0.05
WHERE job_id = 'IT_PROG' AND ROUND(MONTHS_BETWEEN(SYSDATE, hire_date))/12 > 20;
commit;
/*
2 rows updated.
Commit complete.
*/

/* 3.2 Уволить всех сотрудников (удалить из таблицы), которые проработали более 20 лет на
должности Shipping Clerk. Перед удалением сохранить информацию об увольняемых сотрудниках в
отдельную таблицу employee_drop, которая содержит такую же структуру, как и таблица employee.
При создании таблицы использовать конструкцию типа CREATE TABLE … AS SELECT …
Указанная операция автоматически создаст таблицу и заполнит ее значениями из ответа на
запрос.
Все операции завершать командой фиксации изменений транзакции. 
*/

CREATE TABLE EMPLOYEE_DROP
AS SELECT employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id
FROM EMPLOYEES
WHERE job_id = 'SH_CLERK' AND ROUND(MONTHS_BETWEEN(SYSDATE, hire_date))/12 > 20;

DELETE FROM EMPLOYEES
WHERE job_id = 'SH_CLERK' AND ROUND(MONTHS_BETWEEN(SYSDATE, hire_date))/12 > 20;

commit;
/*
Table EMPLOYEE_DROP created.
0 rows deleted.
Commit complete.
*/

/* Этап 4. Перенос данных о подразделениях и сотрудниках из старой БД в новую БД */
/* Выполнить перенос данных из таблиц старой БД в таблицы новой БД. Использовать
следующий вариант запросов по переносу:
INSERT INTO NEW_DB.таблица_новой_бд (колонки новой БД)
SELECT …. FROM OLD_DB.таблица_старой_бд …;
Необходимо учесть установку прав доступа к таблицам старой БД, используя команду:
GRANT SELECT ON OLD_DB.таблица_старой_бд TO NEW_DB;
Все операции оформить в виде одной транзакции. 
*/

INSERT INTO NEW_DB.EMPLOYEES (emp_id,	emp_name,	hire_date, job_id, dept_id,	manager_id)
SELECT employee_id, last_name, hire_date, job_job_id.NEXTVAL, department_id, manager_id
FROM OLD_DB.EMPLOYEES;
commit;
/*
107 rows inserted.
Commit complete.
*/
INSERT INTO NEW_DB.DEPARTMENTS (dept_id,	dept_name, manager_id, loc_id, product_id)
SELECT department_id,	department_name, manager_id, location_id, product_prod_id.NEXTVAL
FROM OLD_DB.DEPARTMENTS;
commit;
/*
27 rows inserted.
Commit complete.
*/
INSERT INTO NEW_DB.LOCATION (loc_id, country, city, street_adress)
SELECT loc.location_id,	cntry.country_name, loc.city, loc.street_address
FROM OLD_DB.LOCATIONS loc  JOIN OLD_DB.countries cntry ON  (loc.country_id = cntry.country_id) ;
commit;
/*
23 rows inserted.
Commit complete.
*/
INSERT INTO NEW_DB.JOB (job_id, job_name, salary)
SELECT job_job_id.NEXTVAL,	j.job_title, j.min_salary
FROM OLD_DB.JOBS j;
commit;
/*
19 rows inserted.
Commit complete.
*/
