drop table DEPARTMENTS CASCADE CONSTRAINTS;
drop table MANAGER CASCADE CONSTRAINTS;
drop table EMPLOYEES CASCADE CONSTRAINTS;
drop table PRODUCT CASCADE CONSTRAINTS;
drop table LOCATION CASCADE CONSTRAINTS;
drop table JOB CASCADE CONSTRAINTS;



CREATE TABLE JOB (
	job_id NUMERIC(2),
	job_name VARCHAR2(10),
	salary NUMERIC(5)
);

CREATE TABLE LOCATION(
	loc_id NUMERIC(2),
	country VARCHAR2(15),
	city VARCHAR2(15),
	street_adress VARCHAR2(20)
);

CREATE TABLE PRODUCT(
	product_id NUMERIC(4),
	product_name VARCHAR2(15),
	sale_price NUMERIC(7),
	buy_price NUMERIC(7)
);

CREATE TABLE EMPLOYEES(
	emp_id NUMERIC(4),
	emp_name VARCHAR2(12),
	hire_date DATE,
	job_id NUMERIC(2),
	dept_id NUMERIC(2),
	manager_id NUMERIC(2)
);

CREATE TABLE MANAGER(
	manager_id NUMERIC(2),
	emp_id NUMERIC(4)
);

CREATE TABLE DEPARTMENTS(
	dept_id NUMERIC(2),
	dept_name VARCHAR2(20),
	manager_id NUMERIC(2),
	loc_id NUMERIC(2),
	product_id NUMERIC(4)
);

ALTER TABLE JOB ADD CONSTRAINT
	job_pk PRIMARY KEY (job_id);
ALTER TABLE JOB ADD CONSTRAINT
	job_unique_name UNIQUE (job_name);
ALTER TABLE JOB ADD CONSTRAINT
	non_negative_sal CHECK (salary > 0);

ALTER TABLE LOCATION ADD CONSTRAINT
		loc_pk PRIMARY KEY (loc_id);
		
ALTER TABLE PRODUCT ADD CONSTRAINT
	product_pk PRIMARY KEY (product_id);
ALTER TABLE PRODUCT ADD CONSTRAINT
	product_unique_name UNIQUE (product_name);
ALTER TABLE PRODUCT ADD CONSTRAINT
	non_negative_price CHECK (sale_price > 0 AND buy_price > 0);
	
ALTER TABLE DEPARTMENTS ADD CONSTRAINT
	dept_pk PRIMARY KEY (dept_id);
ALTER TABLE MANAGER ADD CONSTRAINT
	manager_pk PRIMARY KEY (manager_id);
	
ALTER TABLE EMPLOYEES ADD CONSTRAINT
	emp_pk PRIMARY KEY (emp_id);
ALTER TABLE EMPLOYEES ADD CONSTRAINT
	name_is_not_null CHECK (TRIM(emp_name) IS NOT NULL);
ALTER TABLE EMPLOYEES MODIFY (hire_date NOT NULL);
ALTER TABLE EMPLOYEES ADD CONSTRAINT
	fk_job_id FOREIGN KEY (job_id) REFERENCES JOB(job_id);
ALTER TABLE EMPLOYEES ADD CONSTRAINT
	fk_dept_id FOREIGN KEY (dept_id) REFERENCES DEPARTMENTS(dept_id);
ALTER TABLE EMPLOYEES ADD CONSTRAINT
	fk_manag_id FOREIGN KEY (manager_id) REFERENCES MANAGER(manager_id);
	

ALTER TABLE MANAGER ADD CONSTRAINT
	fk_emp_id FOREIGN KEY (emp_id) REFERENCES EMPLOYEES(emp_id);
	

ALTER TABLE DEPARTMENTS ADD CONSTRAINT
	dept_uniqui_name UNIQUE (dept_name);
ALTER TABLE DEPARTMENTS ADD CONSTRAINT
	fk_manag_id_from_dept FOREIGN KEY (manager_id) REFERENCES MANAGER(manager_id);
ALTER TABLE DEPARTMENTS ADD CONSTRAINT
	fk_product_id FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id);
ALTER TABLE DEPARTMENTS ADD CONSTRAINT
	fk_loc_id FOREIGN KEY (loc_id) REFERENCES LOCATION(loc_id);
	




	