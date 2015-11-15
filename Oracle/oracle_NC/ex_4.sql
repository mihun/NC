/* 4.       �������� ������, ������� ������� ������� ��������� �� ������ ��������� (����������. ����� ���������� 
		 ������������ �� ���, ��� � ���������� ������� �������� ��� �� ���������� ����� ��������� (�N�)).  
		 ����� ���������� ������� �������� ������ ����� ������ ��������� , �������� � � ������� ������ ���� 
		 ������ � ���������� ���������. ��������� ������ �� ������ 3.
     */

UPDATE EMPLOYEES
SET  SALARY = 12000, JOB_ID = 'SA_MAN'
WHERE LAST_NAME = 'Bloom';

commit;

SELECT DISTINCT emp.FIRST_NAME||' '||emp.LAST_NAME emp_name, j.JOB_TITLE job, emp.SALARY salary, DECODE (jh.END_DATE, null, 'N',
                                                                                                                            'Y') flag
FROM EMPLOYEES emp JOIN JOBS j ON (j.JOB_ID = emp.JOB_ID)
LEFT JOIN JOB_HISTORY jh ON (jh.EMPLOYEE_ID = emp.EMPLOYEE_ID);