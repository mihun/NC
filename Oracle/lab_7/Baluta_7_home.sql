/* Задание 1 Массовое внесение изменений в БД */

/* 1.1 В предыдущей лабораторной работе при рассмотрении иерархических запросов
был указан способ их использования для массовой (пакетной) генерации значений атрибутов
таблиц.
Создать запрос типа INSERT ALL по автоматической регистрации в БД 10000
сотрудников, учитывая следующее:
− для идентификаторов сотрудника использовать значение, сгенерированное
иерархическим запросом ( значение генератора);
− имя, фамилия сотрудника определяется как Ваше имя, фамилия + значение
генератора;
− E-mail сотрудника определяется как Ваше имя + значение генератора;
− дата зачисления определяется как ‘01.01.2000’ + значение генератора;
− должность = «Finance Manager»;
− остальные значения колонок оставить NULL. */
ALTER SESSION SET NLS_DATE_FORMAT = 'dd.mm.yyyy';
CREATE SEQUENCE emp_id START With 208;
INSERT ALL 
	INTO EMPLOYEES (employee_id, first_name,  last_name,  email, phone_number, hire_date, 
		job_id, salary, commission_pct, manager_id, department_id)
    VALUES (emp_id.nextval,  'Michael', 'Baluta'||rn, 'MICHAEL'||rn, null, 
		TO_DATE('01.01.2000')+rn -1, 'FI_MGR', null, null, null, null )
SELECT rownum as rn FROM dual
CONNECT BY level <= 10000;
/*
10,000 rows inserted.
*/

/* 1.2 Предыдущее решение позволяет создавать простые генераторы.
Отменить операцию внесения данных предыдущего задания.
Создать анонимный PL/SQL-блок, автоматически регистрирующий в БД 10000
сотрудников, учитывая условия из задания 1.1. */
ROLLBACK;
BEGIN 
  FOR i IN 1..10000 LOOP
      INSERT INTO EMPLOYEES (employee_id, first_name,  last_name,  email, phone_number, hire_date, 
        job_id, salary, commission_pct, manager_id, department_id)
      VALUES (emp_id.nextval,  'Michael', 'Baluta'||i, 'MICHAEL'||i, null, 
        TO_DATE('01.01.2000')+i -1, 'FI_MGR', null, null, null, null );
  END LOOP;
END;
/
/*
PL/SQL procedure successfully completed.
*/


/* Задание 2 Обработка исключений */

/* В решение задания 1.2 добавить контроль ограничений целостности:
- внесения дубликатов по E-mail сотрудников, нарушающих ограничение целостности
UNIQUE, с выводом ошибки, например, “ E-mail Ivanov already exists!”;
- внесения отрицательной зарплаты с выводом сообщения об ошибке, например,
“Salary = -100 is incorrect salary! ”
Для проверки срабатывания созданных исключений последовательно выполнить
PL/SQL-блок, вносящий:
1) те же E-mail, что и при выполнении задания 1.2;
2) любую отрицательную зарплату. */
DECLARE
  v_sal EMPLOYEES.SALARY%TYPE;
  v_email EMPLOYEES.EMAIL%TYPE;
  v_count_emails NUMBER;
  negative_sal EXCEPTION;
  non_unique_email EXCEPTION;
BEGIN
 FOR i IN 1..10000 LOOP
  v_sal:= null;
  v_email:= 'MICHAEL'||i;
  if (v_sal < 0) THEN RAISE negative_sal;
  end if;
  SELECT count(*)
  INTO v_count_emails
  FROM EMPLOYEES
  WHERE EMAIL = v_email;
  if v_count_emails > 0 THEN  RAISE non_unique_email;
  end if;
 INSERT INTO EMPLOYEES (employee_id, first_name,  last_name,  email, phone_number, hire_date, 
        job_id, salary, commission_pct, manager_id, department_id)
        VALUES (emp_id.nextval,  'Michael', 'Baluta'||i, v_email, null, 
        TO_DATE('01.01.2000')+i -1, 'FI_MGR', v_sal, null, null, null );
 END LOOP;
        EXCEPTION
        WHEN negative_sal  THEN
        RAISE_APPLICATION_ERROR(-20550,
        'Salary='||v_sal||' is incorrect salary!');
        WHEN non_unique_email  THEN
      	RAISE_APPLICATION_ERROR(-20551,
      	'E-mail '||v_email||' already exists!');
END;
/
/*
PL/SQL procedure successfully completed.
*/  
DECLARE
  v_sal EMPLOYEES.SALARY%TYPE;
  v_email EMPLOYEES.EMAIL%TYPE;
  v_count_emails NUMBER;
  negative_sal EXCEPTION;
  non_unique_email EXCEPTION;
BEGIN
 FOR i IN 1..10000 LOOP
  v_sal:= null;
  v_email:= 'MICHAEL'||i; /* NON UNIQUE E-MAIL */
  if (v_sal < 0) THEN RAISE negative_sal;
  end if;
  SELECT count(*)
  INTO v_count_emails
  FROM EMPLOYEES
  WHERE EMAIL = v_email;
  if v_count_emails > 0 THEN  RAISE non_unique_email;
  end if;
 INSERT INTO EMPLOYEES (employee_id, first_name,  last_name,  email, phone_number, hire_date, 
        job_id, salary, commission_pct, manager_id, department_id)
        VALUES (emp_id.nextval,  'Michael', 'Baluta'||i, v_email, null, 
        TO_DATE('01.01.2000')+i -1, 'FI_MGR', v_sal, null, null, null );
 END LOOP;
        EXCEPTION
        WHEN negative_sal  THEN
        RAISE_APPLICATION_ERROR(-20550,
        'Salary='||v_sal||' is incorrect salary!');
        WHEN non_unique_email  THEN
      	RAISE_APPLICATION_ERROR(-20551,
      	'E-mail '||v_email||' already exists!');
END;
/
/*
Error report -
ORA-20551: E-mail MICHAEL1 already exists!
ORA-06512: at line 29
*/


DECLARE
  v_sal EMPLOYEES.SALARY%TYPE;
  v_email EMPLOYEES.EMAIL%TYPE;
  v_count_emails NUMBER;
  negative_sal EXCEPTION;
  non_unique_email EXCEPTION;
BEGIN
 FOR i IN 1..10000 LOOP
  v_sal:= -250; /* NEGATIVE SALARY */
  v_email:= 'MICHAEL'||i;
  if (v_sal < 0) THEN RAISE negative_sal;
  end if;
  SELECT count(*)
  INTO v_count_emails
  FROM EMPLOYEES
  WHERE EMAIL = v_email;
  if v_count_emails > 0 THEN  RAISE non_unique_email;
  end if;
 INSERT INTO EMPLOYEES (employee_id, first_name,  last_name,  email, phone_number, hire_date, 
        job_id, salary, commission_pct, manager_id, department_id)
        VALUES (emp_id.nextval,  'Michael', 'Baluta'||i, v_email, null, 
        TO_DATE('01.01.2000')+i -1, 'FI_MGR', v_sal, null, null, null );
 END LOOP;
        EXCEPTION
        WHEN negative_sal  THEN
        RAISE_APPLICATION_ERROR(-20550,
        'Salary='||v_sal||' is incorrect salary!');
        WHEN non_unique_email  THEN
      	RAISE_APPLICATION_ERROR(-20551,
      	'E-mail '||v_email||' already exists!');
END;
/
/*
Error report -
ORA-20550: Salary=-250 is incorrect salary!
ORA-06512: at line 26
*/  


/* Задание 3 Работа с курсорами */
/* 
Описать операции транзакции в виде PL/SQL-кода:
1) получить список идентификаторов подразделений, в которых есть сотрудники;
2) получить список сотрудников 2-го по списку подразделения;
3) перевести сотрудников в 3-е по списку подразделение
4) сохранить данные о сотрудниках в таблице job_history
*/
DECLARE
    CURSOR dept_list IS
      SELECT DISTINCT dept.DEPARTMENT_ID
      FROM EMPLOYEES emp JOIN DEPARTMENTS dept ON (emp.DEPARTMENT_ID = dept.DEPARTMENT_ID);
    dept_rec dept_list%ROWTYPE;
    second_dept_id DEPARTMENTS.DEPARTMENT_ID%TYPE;
    third_dept_id DEPARTMENTS.DEPARTMENT_ID%TYPE;
    emp_list_cursor SYS_REFCURSOR;
    TYPE emp_rec_type IS RECORD ( e_id EMPLOYEES.EMPLOYEE_ID%TYPE, hire_date EMPLOYEES.HIRE_DATE%TYPE, j_id EMPLOYEES.JOB_ID%TYPE, d_id EMPLOYEES.DEPARTMENT_ID%TYPE );
    emp_rec emp_rec_type;
BEGIN
  OPEN dept_list; 
  FETCH dept_list INTO dept_rec; /* 1 str */
  FETCH dept_list INTO dept_rec; /* 2 str */
  second_dept_id := dept_rec.DEPARTMENT_ID;
  FETCH dept_list INTO dept_rec; /* 3 str */
  third_dept_id := dept_rec.DEPARTMENT_ID;
  CLOSE dept_list;
  OPEN emp_list_cursor FOR 'SELECT EMPLOYEE_ID, HIRE_DATE, JOB_ID, DEPARTMENT_ID FROM EMPLOYEES WHERE DEPARTMENT_ID = '|| second_dept_id||' for UPDATE';
  FETCH emp_list_cursor INTO emp_rec;
 	WHILE emp_list_cursor%FOUND LOOP
    INSERT INTO JOB_HISTORY(employee_id, start_date, end_date, job_id, department_id)
    VALUES (emp_rec.e_id, emp_rec.hire_date, SYSDATE, emp_rec.j_id, emp_rec.d_id);
	UPDATE EMPLOYEES
    SET DEPARTMENT_ID = third_dept_id
    WHERE EMPLOYEE_ID = emp_rec.e_id;
	FETCH emp_list_cursor INTO emp_rec;
	END LOOP;
  CLOSE emp_list_cursor;
commit;
END;
/
/*
PL/SQL procedure successfully completed.
*/


/* Задание 4 Автоматическая инициализация генераторов уникальных значений */
/* 4.1 Создать анонимный PL/SQL-блок, автоматизирующий этот процесс на основе
шагов:
− определение максимального значения идентификатора подразделения в таблице
Departments и идентификатора сотрудника в таблице Employees;
− проверка наличия генератора в БД с учетом заранее известных названий для таблиц
Departments, Employees, используя запрос по шаблону select sequence_name from
user_sequences where sequence_name = 'название_в_верхнем_регистре';
− если генераторы уже существуют, выполнение команды удаления генераторов;
− создание генераторов с учетом смещений начального значения, превышающего на 1
полученные максимальные значения.
*/
DECLARE
	s_name varchar2(30);
	max_emp EMPLOYEES.EMPLOYEE_ID%TYPE;
	max_dept DEPARTMENTS.DEPARTMENT_ID%TYPE;
BEGIN
	BEGIN
			SELECT MAX(EMPLOYEES.EMPLOYEE_ID) 
      INTO max_emp 
      FROM EMPLOYEES;
      SELECT MAX(DEPARTMENTS.DEPARTMENT_ID) 
      INTO max_dept 
      FROM DEPARTMENTS;
  EXCEPTION
      WHEN OTHERS THEN 
					RAISE_APPLICATION_ERROR(-20558,
								'Some Error');
			
	END;	
  BEGIN
	SELECT sequence_name
		INTO s_name
		FROM user_sequences
		WHERE sequence_name = UPPER('emp_id');
		execute immediate 'drop sequence emp_id';
		execute immediate 'create sequence emp_id start with '||(max_emp+1);
 EXCEPTION
		WHEN NO_DATA_FOUND THEN
		execute immediate 'create sequence emp_id start with '||(max_emp+1);
 END;
 BEGIN
	SELECT sequence_name
		INTO s_name
		FROM user_sequences
		WHERE sequence_name = UPPER('dept_id');
		execute immediate 'drop sequence dept_id';
		execute immediate 'create sequence dept_id start with '||(max_dept+1);
 EXCEPTION
		WHEN NO_DATA_FOUND THEN
		execute immediate 'create sequence dept_id start with '||(max_dept+1);
 END;		
END;
/
/*
PL/SQL procedure successfully completed.
*/

/* 4.2 В решение 1-го задания изменить PL/SQL-код так, чтобы не было необходимости
проверять наличие генераторов в БД через создание заглушки */
DECLARE
	max_emp EMPLOYEES.EMPLOYEE_ID%TYPE;
	max_dept DEPARTMENTS.DEPARTMENT_ID%TYPE;
BEGIN
	BEGIN
	SELECT MAX(EMPLOYEES.EMPLOYEE_ID) 
      INTO max_emp 
      FROM EMPLOYEES;
      SELECT MAX(DEPARTMENTS.DEPARTMENT_ID) 
      INTO max_dept 
      FROM DEPARTMENTS;
  EXCEPTION
      WHEN OTHERS THEN 
					RAISE_APPLICATION_ERROR(-20558,
								'Some Error');
			
	END;	
  BEGIN
	BEGIN
		execute immediate 'drop sequence emp_id';
	EXCEPTION
       WHEN OTHERS THEN
        NULL;
    END;
  execute immediate 'create sequence emp_id start with '||(max_emp+1);
	BEGIN
        execute immediate 'drop sequence dept_id';
	EXCEPTION
       WHEN OTHERS THEN
        NULL;
    END;
  execute immediate 'create sequence dept_id start with '||(max_dept+1);
  EXCEPTION
		WHEN OTHERS THEN 
					RAISE_APPLICATION_ERROR(-20559,
								'Some Error with sequences');
  END;
END;
/
/*
PL/SQL procedure successfully completed.
*/

/* Задание 5 Динамические запросы */

/* Отменить ранее выполненные операции внесения записей по сотрудникам.
Создать анонимный PL/SQL-блок, который автоматически зарегистрирует
сотрудников с фамилией (last_name), начинающейся на букву C или D, как пользователей
Oracle с учетом условий:
− имена пользователей (логины) совпадают с E-mail сотрудников из таблицы
employees;
− пароль генерируется как любая константа;
− пользователю-сотруднику после регистрации предоставляется право входа в
систему, т.е. автоматически выполняется команда GRANT CONNECT TO пользователь;
− пользователю-сотруднику, работающему на должности, связанной с управлением ( в
названии должности есть слово manager ), предоставить право управлять ресурсами, т.е.
автоматически выполняется команда GRANT RESOURCE TO пользователь;
Необходимо учесть, что пользователь, запускающий созданный скрипт, должен иметь
полномочия на выполнение команд: CREATE USER, GRANT CONNECT, GRANT RESOURCE.
*/

/* Для предоставления прав пользователю, запускающему скрипт, необходимо под пользователем SYSTEM выполнить:
grant connect, resource to lab7 with admin option;
grant create user to lab7;
grant drop user to lab7; 
где lab7 - имя пользователя, под которым будут выполняться дальнейшие операции.
*/
DECLARE
	CURSOR emp_list IS
		SELECT emp.EMAIL email, j.JOB_TITLE job
		FROM EMPLOYEES emp JOIN JOBS j ON (emp.JOB_ID = j.JOB_ID)
    WHERE emp.LAST_NAME LIKE 'C%'
    OR emp.LAST_NAME LIKE 'D%';
BEGIN
	FOR emp_rec IN emp_list LOOP
      BEGIN
       execute immediate 'drop user '||emp_rec.email||' cascade';
      EXCEPTION
       WHEN OTHERS THEN
        NULL;
      END;
      execute immediate 'create user '||emp_rec.email||' identified by aa11';
      execute immediate 'grant connect to '||emp_rec.email;
      if (emp_rec.job LIKE '%Manager%') THEN
         execute immediate 'grant resource to '||emp_rec.email;
      end if;
    END LOOP;	
END;
/
/*
PL/SQL procedure successfully completed.
*/
