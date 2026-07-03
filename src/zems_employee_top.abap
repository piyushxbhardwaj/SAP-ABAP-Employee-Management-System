*======================================================================*
* PROJECT: Employee Management System (EMS)
* INCLUDE: ZEMS_EMPLOYEE_TOP
* PACKAGE: ZEMS
* DESCRIPTION: Global variable declarations, constants, and structures.
*======================================================================*

*----------------------------------------------------------------------*
* DATABASE TABLES REFERENCE
*----------------------------------------------------------------------*
TABLES: zems_t_employee,   " Employee Master
        zems_t_dept,       " Department Master
        zems_t_audit.      " Audit Trail Logs

*----------------------------------------------------------------------*
* CLASS FORWARD DECLARATION
*----------------------------------------------------------------------*
CLASS lcl_employee_controller DEFINITION DEFERRED.

*----------------------------------------------------------------------*
* GLOBAL CONSTANTS
*----------------------------------------------------------------------*
CONSTANTS: gc_mode_create   TYPE char1 VALUE 'C',
           gc_mode_edit     TYPE char1 VALUE 'E',
           gc_mode_display  TYPE char1 VALUE 'V',
           gc_mode_delete   TYPE char1 VALUE 'D'.

*----------------------------------------------------------------------*
* GLOBAL VARIABLES & SCREEN FIELDS
*----------------------------------------------------------------------*
DATA: ok_code      TYPE sy-ucomm,     " Screen User Command
      save_ok_code TYPE sy-ucomm.     " Saved OK Code for processing

" Screen 100 Search & Action Input fields
DATA: gv_search_emp_id TYPE zems_t_employee-emp_id,
      gv_search_dept   TYPE zems_t_employee-dep_id,
      gv_action_mode   TYPE char1.        " Mode selected from Radio Buttons

" Screen 200 Form Work Fields
DATA: gv_emp_id      TYPE zems_t_employee-emp_id,
      gv_first_name  TYPE zems_t_employee-first_name,
      gv_last_name   TYPE zems_t_employee-last_name,
      gv_gender      TYPE zems_t_employee-gender,
      gv_dob         TYPE zems_t_employee-dob,
      gv_mobile      TYPE zems_t_employee-mobile,
      gv_email       TYPE zems_t_employee-email,
      gv_dept_id     TYPE zems_t_employee-dep_id,
      gv_designation TYPE zems_t_employee-designation,
      gv_salary      TYPE zems_t_employee-salary,
      gv_waers       TYPE zems_t_employee-waers,
      gv_join_date   TYPE zems_t_employee-join_date,
      gv_address     TYPE zems_t_employee-address,
      gv_status      TYPE zems_t_employee-status.

" Dashboard KPI Fields (Screen 100 display indicators)
DATA: gv_kpi_total      TYPE i,
      gv_kpi_active     TYPE i,
      gv_kpi_inactive   TYPE i,
      gv_kpi_avg_salary TYPE zems_de_salary,
      gv_kpi_waers      TYPE waers VALUE 'INR'.

" Status Text field for Screen 200 Title Bar
DATA: gv_screen_title TYPE char40.

*----------------------------------------------------------------------*
* OBJECT REFERENCES
*----------------------------------------------------------------------*
DATA: go_controller TYPE REF TO lcl_employee_controller.
