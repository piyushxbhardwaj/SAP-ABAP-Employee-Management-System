*======================================================================*
* PROJECT: Employee Management System (EMS)
* COMPONENT: SAP Dictionary (DDIC) - Transparent Table
* TABLE: ZEMS_T_EMPLOYEE
* PACKAGE: ZEMS
* DESCRIPTION: Employee Master Table
*======================================================================*

TABLE ZEMS_T_EMPLOYEE {
  CLIENT (MANDT) KEY;
  EMP_ID (ZEMS_DE_EMPID) KEY NOT NULL;
  FIRST_NAME (ZEMS_DE_FNAME) NOT NULL;
  LAST_NAME (ZEMS_DE_LNAME) NOT NULL;
  GENDER (ZEMS_DE_GENDER) NOT NULL;
  DOB (ZEMS_DE_DOB) NOT NULL;
  MOBILE (ZEMS_DE_MOBILE);
  EMAIL (ZEMS_DE_EMAIL);
  DEP_ID (ZEMS_DE_DEPID);              " Foreign Key to ZEMS_T_DEPT
  DESIGNATION (ZEMS_DE_DESIG);
  SALARY (ZEMS_DE_SALARY);             " Reference: ZEMS_T_EMPLOYEE-WAERS
  WAERS (WAERS) DEFAULT 'INR';         " Currency Key
  JOIN_DATE (ZEMS_DE_JOINDATE) NOT NULL;
  ADDRESS (ZEMS_DE_ADDRESS);
  STATUS (ZEMS_DE_STATUS) DEFAULT 'A'; " Default: Active
}

*----------------------------------------------------------------------*
* TECHNICAL SETTINGS (SE13)
*----------------------------------------------------------------------*
* Data Class:        APPL0 (Master Data, Transparent Tables)
* Size Category:     1     (8,000 to 32,000 records)
* Buffering Status:  Buffering Not Allowed (Frequent CRUD operations)
* Log Data Changes:  Active (Checked for Audit trail)

*----------------------------------------------------------------------*
* FOREIGN KEY RELATIONSHIPS
*----------------------------------------------------------------------*
* Fields: DEP_ID
* Check Table: ZEMS_T_DEPT
* Cardinality: 1:N (A department can have multiple employees)
* Type of Foreign Key Field: Key Field / Candidates
* Message Class: ZEMS_MSG
* Message Number: 003 (Invalid Department ID)

*----------------------------------------------------------------------*
* SEARCH HELPS ASSIGNED
*----------------------------------------------------------------------*
* Fields: EMP_ID
* Search Help: ZEMS_SH_EMP
* Proposal: Checked (Value proposal active)
