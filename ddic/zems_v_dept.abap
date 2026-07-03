*======================================================================*
* PROJECT: Employee Management System (EMS)
* COMPONENT: SAP Dictionary (DDIC) - Maintenance View
* VIEW: ZEMS_V_DEPT
* PACKAGE: ZEMS
* DESCRIPTION: Department Maintenance View (SE11/SM30)
*======================================================================*

VIEW ZEMS_V_DEPT {
  Base Table: ZEMS_T_DEPT

  View Fields:
    DEP_ID     Refers to ZEMS_T_DEPT-DEP_ID      (Key)
    DEP_NAME   Refers to ZEMS_T_DEPT-DEP_NAME
    MANAGER_ID Refers to ZEMS_T_DEPT-MANAGER_ID
    LOCATION   Refers to ZEMS_T_DEPT-LOCATION
}

*----------------------------------------------------------------------*
* TABLE MAINTENANCE GENERATOR (TMG) SPECIFICATIONS
*----------------------------------------------------------------------*
* Transaction:       SE11 -> Utilities -> Table Maintenance Generator
* Authorization Group: &NC& (No Authorization Group, default for custom)
* Package:           ZEMS
* Function Group:    ZEMS_FG_DEPT (Function Group for maintenance screens)
* Maintenance Type:  One-step (Single Screen)
* Screen Number:     0001 (Overview Screen)
* Recording Routine: Standard Recording Routine (Transport integration enabled)

*----------------------------------------------------------------------*
* SM30 MAINTENANCE BEHAVIOR
*----------------------------------------------------------------------*
* Allows complete Create, Read, Update, and Delete (CRUD) operations
* for departments directly through transaction SM30 using ZEMS_V_DEPT.
