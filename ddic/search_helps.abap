*======================================================================*
* PROJECT: Employee Management System (EMS)
* COMPONENT: SAP Dictionary (DDIC) - Search Helps (SE11)
* PACKAGE: ZEMS
* DESCRIPTION: Custom Search Helps with Search Help Exit logic
*======================================================================*

* 1. ZEMS_SH_EMP (Elementary Search Help for Employee Lookup)
*----------------------------------------------------------------------*
* Selection Method:   ZEMS_T_EMPLOYEE (Reads from Employee Master)
* Dialog Type:        Dialog depends on value set (Standard behavior)
* Description:        Search Help for Employee Master
*
* Search Help Parameters:
*   Parameter     IMP   EXP   LPos  SPos  Data Element
*   -----------------------------------------------------
*   EMP_ID         X     X     1     1    ZEMS_DE_EMPID
*   FIRST_NAME           X     2     2    ZEMS_DE_FNAME
*   LAST_NAME            X     3     3    ZEMS_DE_LNAME
*   DEP_ID         X     X     4     4    ZEMS_DE_DEPID
*   STATUS               X     5     5    ZEMS_DE_STATUS


* 2. ZEMS_SH_DEPT (Elementary Search Help for Department Lookup)
*----------------------------------------------------------------------*
* Selection Method:   ZEMS_T_DEPT     (Reads from Department Master)
* Dialog Type:        Dialog depends on value set
* Search Help Exit:   ZEMS_SH_EXIT_DEPT (Filters out empty locations/inactive)
* Description:        Search Help for Department Master
*
* Search Help Parameters:
*   Parameter     IMP   EXP   LPos  SPos  Data Element
*   -----------------------------------------------------
*   DEP_ID         X     X     1     1    ZEMS_DE_DEPID
*   DEP_NAME             X     2     2    ZEMS_DE_DEPNAME
*   LOCATION             X     3     3    ZEMS_DE_LOCATION


* 3. ZEMS_SH_EXIT_DEPT (Search Help Exit Function Module)
*----------------------------------------------------------------------*
* Transaction: SE37
* Import/Export: Matches standard search help exit signatures.
* ABAP Source Code Blueprint:
*----------------------------------------------------------------------*
FUNCTION zems_sh_exit_dept.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  TABLES
*"      SHLP_TAB TYPE  SHLP_DESCT
*"      RECORD_TAB TYPE  SEAHLPRES
*"  CHANGING
*"      SHLP TYPE  SHLP_DESCR
*"      CALLCONTROL TYPE  DDSHFCTRL
*"----------------------------------------------------------------------

  DATA: l_step TYPE ddshstep.
  
  l_step = callcontrol-step.
  
  CASE l_step.
    WHEN 'SELECT'.
      " Example Exit Customization:
      " Intercept before selection to enforce that location is not empty
      " or restrict selection according to user authorizations.
      
      " Read the selection parameters and force locations to not be empty
      " if user hasn't specified a filter.
      DATA: ls_selopt TYPE ddshselopt.
      
      READ TABLE shlp-selopt INTO ls_selopt WITH KEY shlpfield = 'LOCATION'.
      IF sy-subrc <> 0.
        ls_selopt-sign      = 'I'.
        ls_selopt-option    = 'NE'.
        ls_selopt-low       = ' '.
        ls_selopt-shlpfield = 'LOCATION'.
        APPEND ls_selopt TO shlp-selopt.
      ENDIF.
      
    WHEN 'DISP'.
      " Intercept before display to format or filter records dynamically
      " e.g., coloring specific rows, restricting values, etc.
  ENDCASE.

ENDFUNCTION.
