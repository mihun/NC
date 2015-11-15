/* 3.       Написать запрос, который выведет табличку с сотрудниками с полями: имя и фамилия работника, должность,
		 зарплата, признак - занимал ли работник ранее другую должность в компании ('Y') или нет ('N'). */
SELECT DISTINCT emp.FIRST_NAME||' '||emp.LAST_NAME emp_name, j.JOB_TITLE job, emp.SALARY salary, DECODE (jh.END_DATE, null, 'N',
                                                                                                                            'Y') flag
FROM EMPLOYEES emp JOIN JOBS j ON (j.JOB_ID = emp.JOB_ID)
LEFT JOIN JOB_HISTORY jh ON (jh.EMPLOYEE_ID = emp.EMPLOYEE_ID);