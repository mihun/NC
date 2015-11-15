/* 2.       �������� ������, ������� ������� �������� � �������������� � ����� ������: �������� ������������, 
		 ������� ����� ������������ � ����������� ��������� � ������������. */
SELECT dept.DEPARTMENT_NAME, MAX(NVL(emp.SALARY, 0)) - MIN(NVL(emp.SALARY, 0)) diff_sal
FROM EMPLOYEES emp RIGHT JOIN DEPARTMENTS dept ON (emp.DEPARTMENT_ID = dept.DEPARTMENT_ID)
GROUP BY dept.DEPARTMENT_NAME;