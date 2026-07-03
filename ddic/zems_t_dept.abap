*======================================================================*
* PROJECT: Employee Management System (EMS)
* COMPONENT: SAP Dictionary (DDIC) - Transparent Table
* TABLE: ZEMS_T_DEPT
* PACKAGE: ZEMS
* DESCRIPTION: Department Master Table
*======================================================================*

TABLE ZEMS_T_DEPT {
  CLIENT (MANDT) KEY;
  DEP_ID (ZEMS_DE_DEPID) KEY NOT NULL;
  DEP_NAME (ZEMS_DE_DEPNAME) NOT NULL;
  MANAGER_ID (ZEMS_DE_EMPID);          " Manager Employee ID
  LOCATION (ZEMS_DE_LOCATION);
}

*----------------------------------------------------------------------*
* TECHNICAL SETTINGS (SE13)
*----------------------------------------------------------------------*
* Data Class:        APPL0 (Master Data, Transparent Tables)
* Size Category:     0     (0 to 8,000 records)
* Buffering Status:  Buffering Allowed
* Buffering Type:    Fully Buffered
* Log Data Changes:  Active (Checked)

*----------------------------------------------------------------------*
* FOREIGN KEY RELATIONSHIPS
*----------------------------------------------------------------------*
* Fields: MANAGER_ID
* Check Table: ZEMS_T_EMPLOYEE
* Cardinality: 1:C (One employee can manage zero or one department)
* Type of Foreign Key Field: Key Field / Candidates
* Message Class: ZEMS_MSG
* Message Number: 004 (Invalid Manager ID)

*----------------------------------------------------------------------*
* SEARCH HELPS ASSIGNED
*----------------------------------------------------------------------*
* Fields: DEP_ID
* Search Help: ZEMS_SH_DEPT
* Proposal: Checked (Value proposal active)
