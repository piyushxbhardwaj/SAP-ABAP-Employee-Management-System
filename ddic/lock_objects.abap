*======================================================================*
* PROJECT: Employee Management System (EMS)
* COMPONENT: SAP Dictionary (DDIC) - Lock Objects
* PACKAGE: ZEMS
* DESCRIPTION: Custom Lock Objects for record locking (SE11)
*======================================================================*

* 1. EZEMS_EMPLOYEE (Lock Object for Employee Records)
*----------------------------------------------------------------------*
* Primary Table:      ZEMS_T_EMPLOYEE
* Lock Mode:          Exclusive lock, non-cumulative (Write Lock / E)
* Lock Parameters:
*   MANDT             Refers to ZEMS_T_EMPLOYEE-MANDT
*   EMP_ID            Refers to ZEMS_T_EMPLOYEE-EMP_ID
*
* System-Generated Function Modules:
*   - ENQUEUE_EZEMS_EMPLOYEE (To lock an employee record)
*   - DEQUEUE_EZEMS_EMPLOYEE (To release lock on an employee record)
*
* FM Parameters (ENQUEUE):
*   Importing:
*     MODE_ZEMS_T_EMPLOYEE (Default 'E')
*     MANDT                (Default SY-MANDT)
*     EMP_ID               (The Employee ID to lock)
*     X_EMP_ID             (Flag to specify lock type initialization)
*     _SCOPE               (Default '2')
*     _WAIT                (Flag to wait if lock cannot be acquired)
*   Exceptions:
*     FOREIGN_LOCK         (Record is already locked by another user)
*     SYSTEM_FAILURE       (System lock table error)


* 2. EZEMS_DEPT (Lock Object for Department Records)
*----------------------------------------------------------------------*
* Primary Table:      ZEMS_T_DEPT
* Lock Mode:          Exclusive lock, non-cumulative (Write Lock / E)
* Lock Parameters:
*   MANDT             Refers to ZEMS_T_DEPT-MANDT
*   DEP_ID            Refers to ZEMS_T_DEPT-DEP_ID
*
* System-Generated Function Modules:
*   - ENQUEUE_EZEMS_DEPT (To lock a department record)
*   - DEQUEUE_EZEMS_DEPT (To release lock on a department record)
*
* FM Parameters (ENQUEUE):
*   Importing:
*     MODE_ZEMS_T_DEPT     (Default 'E')
*     MANDT                (Default SY-MANDT)
*     DEP_ID               (The Department ID to lock)
*     X_DEP_ID             (Flag)
*     _SCOPE               (Default '2')
*     _WAIT                (Flag)
*   Exceptions:
*     FOREIGN_LOCK         (Record is already locked)
*     SYSTEM_FAILURE       (System lock table error)
