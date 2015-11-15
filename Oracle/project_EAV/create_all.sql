ALTER SESSION SET NLS_Language='american';
ALTER SESSION SET NLS_DATE_FORMAT = 'dd-mm-yyyy';

/* create 5 tables */
@ cre_eav_db.sql;


/* insert into OBJTYPE and ATTRTYPE */
@ popul_types.sql;


/* insert into OBJECTS */
@ popul_obj.sql;


/* insert into ATTRIBUTES */
@ popul_attr.sql;


/* insert into OBJREFERENCE */
@ popul_ref.sql;