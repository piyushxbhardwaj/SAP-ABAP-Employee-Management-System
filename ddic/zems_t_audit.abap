*======================================================================*
* PROJECT: Employee Management System (EMS)
* COMPONENT: SAP Dictionary (DDIC) - Transparent Table
* TABLE: ZEMS_T_AUDIT
* PACKAGE: ZEMS
* DESCRIPTION: Audit Log Table to track CRUD activities
*======================================================================*

TABLE ZEMS_T_AUDIT {
  CLIENT (MANDT) KEY;
  AUDIT_ID (ZEMS_DE_AUDITID) KEY NOT NULL; " Auto-generated/Sequence Key
  EMP_ID (ZEMS_DE_EMPID) NOT NULL;
  ACTION (ZEMS_DE_ACTION) NOT NULL;        " CREATE, UPDATE, DELETE
  CHANGED_BY (UNAME) NOT NULL;             " Changed by SY-UNAME
  CHANGE_DATE (DATUM) NOT NULL;            " Date of change SY-DATUM
  CHANGE_TIME (UZEIT) NOT NULL;            " Time of change SY-UZEIT
}

*----------------------------------------------------------------------*
* TECHNICAL SETTINGS (SE13)
*----------------------------------------------------------------------*
* Data Class:        APPL1 (Transaction Data)
* Size Category:     2     (30,000 to 120,000 records)
* Buffering Status:  Buffering Not Allowed
* Log Data Changes:  Not Active (Auditing table itself doesn't need logging)
