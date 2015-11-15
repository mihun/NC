/*1.       Написать запрос, который выведет табличку с сотрудниками с двумя полями: имя и фамилия работника, 
		 адрес локации в которой расположен его департамент. */

SELECT emp.FIRST_NAME||' '||emp.LAST_NAME emp_name, loc.CITY||', '||loc.STATE_PROVINCE||' '||loc.POSTAL_CODE||', '||c.COUNTRY_NAME dept_address
FROM EMPLOYEES emp LEFT JOIN DEPARTMENTS dept ON (emp.DEPARTMENT_ID = dept.DEPARTMENT_ID)
LEFT JOIN LOCATIONS loc ON (dept.LOCATION_ID = loc.LOCATION_ID)
LEFT JOIN COUNTRIES c ON (loc.COUNTRY_ID = c.COUNTRY_ID);