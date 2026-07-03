*======================================================================*
* PROJECT: Employee Management System (EMS)
* PROGRAM: ZEMS_REPORTS (Transaction: ZEMS_REP)
* PACKAGE: ZEMS
* TYPE:    Executable Program (Type 1)
* DESCRIPTION: Advanced OO ALV Report Dashboard demonstrating selection 
*              screens, grid layout variants, zebra patterns, cell 
*              hotspots, row coloring, and toolbar event handling.
*======================================================================*

REPORT zems_reports.

*----------------------------------------------------------------------*
* TABLES & TYPES
*----------------------------------------------------------------------*
TABLES: zems_t_employee, zems_t_dept.

" Output Structure for ALV including coloring configurations
TYPES: BEGIN OF ty_report_out,
         emp_id      TYPE zems_t_employee-emp_id,
         first_name  TYPE zems_t_employee-first_name,
         last_name   TYPE zems_t_employee-last_name,
         gender      TYPE zems_t_employee-gender,
         dob         TYPE zems_t_employee-dob,
         mobile      TYPE zems_t_employee-mobile,
         email       TYPE zems_t_employee-email,
         dep_id      TYPE zems_t_employee-dep_id,
         dep_name    TYPE zems_t_dept-dep_name,
         designation TYPE zems_t_employee-designation,
         salary      TYPE zems_t_employee-salary,
         waers       TYPE zems_t_employee-waers,
         join_date   TYPE zems_t_employee-join_date,
         status      TYPE zems_t_employee-status,
         row_color   TYPE char4,         " Row level coloring (CXXX)
         cell_color  TYPE lvc_t_scol,    " Cell level coloring
       END OF ty_report_out.

*----------------------------------------------------------------------*
* SELECTION SCREEN LAYOUT
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK blk_filter WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_empid FOR zems_t_employee-emp_id,
                  s_dept  FOR zems_t_employee-dep_id,
                  s_date  FOR zems_t_employee-join_date.
  PARAMETERS:     p_status TYPE zems_t_employee-status AS LISTBOX VISIBLE LENGTH 10.
SELECTION-SCREEN END OF BLOCK blk_filter.

SELECTION-SCREEN BEGIN OF BLOCK blk_salary WITH FRAME TITLE TEXT-002.
  PARAMETERS:     p_salmin TYPE zems_t_employee-salary,
                  p_salmax TYPE zems_t_employee-salary.
SELECTION-SCREEN END OF BLOCK blk_salary.

SELECTION-SCREEN BEGIN OF BLOCK blk_reports WITH FRAME TITLE TEXT-003.
  PARAMETERS:     p_rep1 RADIOBUTTON GROUP rep DEFAULT 'X', " Employee List
                  p_rep2 RADIOBUTTON GROUP rep,             " Department-wise Count
                  p_rep3 RADIOBUTTON GROUP rep,             " Salary Report (> 80k)
                  p_rep4 RADIOBUTTON GROUP rep,             " Active Employees
                  p_rep5 RADIOBUTTON GROUP rep.             " Joined Between Dates (2023-2024)
SELECTION-SCREEN END OF BLOCK blk_reports.

*----------------------------------------------------------------------*
* GLOBAL DATA
*----------------------------------------------------------------------*
DATA: gt_report_out TYPE TABLE OF ty_report_out,
      go_alv_grid   TYPE REF TO cl_gui_alv_grid,
      go_container  TYPE REF TO cl_gui_custom_container,
      gt_fieldcat   TYPE lvc_t_fcat,
      gs_layout     TYPE lvc_s_layo,
      gs_variant    TYPE disvariant.

*----------------------------------------------------------------------*
* OO ALV EVENT HANDLER DEFINITION
*----------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS:
      handle_double_click
        FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_row e_column es_row_no,

      handle_toolbar
        FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object e_interactive,

      handle_user_command
        FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm.
ENDCLASS.

*----------------------------------------------------------------------*
* START-OF-SELECTION
*----------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM fetch_report_data.
  PERFORM prepare_field_catalog.
  PERFORM prepare_layout.
  
  " In a standard report, we call Screen 100 or use screen0 container
  IF gt_report_out IS INITIAL.
    MESSAGE 'No records found matching selection criteria.' TYPE 'I'.
  ELSE.
    CALL SCREEN 9000. " Custom screen wrapper to hold ALV container
  ENDIF.

*----------------------------------------------------------------------*
* PBO & PAI FOR ALV WRAPPER SCREEN 9000
*----------------------------------------------------------------------*
PROCESS BEFORE OUTPUT.
  MODULE status_9000.

PROCESS AFTER INPUT.
  MODULE user_command_9000.

*----------------------------------------------------------------------*
* FORM ROUTINES IMPLEMENTATION
*----------------------------------------------------------------------*

FORM fetch_report_data.
  DATA: ls_out TYPE ty_report_out.

  CLEAR gt_report_out.

  " Select matching employee rows joining with department details (Optimized Join)
  SELECT e~emp_id, e~first_name, e~last_name, e~gender, e~dob, e~mobile,
         e~email, e~dep_id, d~dep_name, e~designation, e~salary, e~waers,
         e~join_date, e~status
    FROM zems_t_employee AS e
    LEFT OUTER JOIN zems_t_dept AS d ON e~dep_id = d~dep_id
    INTO CORRESPONDING FIELDS OF TABLE @gt_report_out
    WHERE e~emp_id   IN @s_empid
      AND e~dep_id   IN @s_dept
      AND e~join_date IN @s_date.

  " Apply parameter filters on internal table (Performance optimized filtering)
  LOOP AT gt_report_out ASSIGNING FIELD-SYMBOL(<fs_out>).
    " Filter by Status parameter
    IF p_status IS NOT INITIAL AND <fs_out>-status <> p_status.
      DELETE gt_report_out WHERE emp_id = <fs_out>-emp_id.
      CONTINUE.
    ENDIF.

    " Filter by Min Salary
    IF p_salmin IS NOT INITIAL AND <fs_out>-salary < p_salmin.
      DELETE gt_report_out WHERE emp_id = <fs_out>-emp_id.
      CONTINUE.
    ENDIF.

    " Filter by Max Salary
    IF p_salmax IS NOT INITIAL AND <fs_out>-salary > p_salmax.
      DELETE gt_report_out WHERE emp_id = <fs_out>-emp_id.
      CONTINUE.
    ENDIF.

    " Apply Radio Button Sub-Report filters
    IF p_rep3 = 'X' AND <fs_out>-salary < 80000. " High Salary Report
      DELETE gt_report_out WHERE emp_id = <fs_out>-emp_id.
      CONTINUE.
    ENDIF.

    IF p_rep4 = 'X' AND <fs_out>-status <> 'A'. " Active Employees Only
      DELETE gt_report_out WHERE emp_id = <fs_out>-emp_id.
      CONTINUE.
    ENDIF.

    IF p_rep5 = 'X' AND ( <fs_out>-join_date < '20230101' OR <fs_out>-join_date > '20241231' ).
      DELETE gt_report_out WHERE emp_id = <fs_out>-emp_id.
      CONTINUE.
    ENDIF.

    " Row-level coloring based on Active Status
    IF <fs_out>-status = 'A'.
      <fs_out>-row_color = 'C500'. " Soft Green for Active
    ELSE.
      <fs_out>-row_color = 'C100'. " Soft Red for Inactive
    ENDIF.
  ENDLOOP.
ENDFORM.

FORM prepare_field_catalog.
  DATA: ls_fcat TYPE lvc_s_fcat.
  CLEAR gt_fieldcat.

  " Helper macro to build field catalog quickly
  DEFINE add_column.
    clear ls_fcat.
    ls_fcat-fieldname = &1.
    ls_fcat-coltext   = &2.
    ls_fcat-ref_table = 'ZEMS_T_EMPLOYEE'.
    ls_fcat-ref_field = &3.
    if &4 = 'X'.
      ls_fcat-hotspot = 'X'.
    endif.
    if &5 = 'X'.
      ls_fcat-do_sum = 'X'.
    endif.
    append ls_fcat to gt_fieldcat.
  END-OF-DEFINITION.

  add_column 'EMP_ID'      'Employee ID'     'EMP_ID'      'X' ''.
  add_column 'FIRST_NAME'  'First Name'      'FIRST_NAME'  '' ''.
  add_column 'LAST_NAME'   'Last Name'       'LAST_NAME'   '' ''.
  add_column 'GENDER'      'Gender'          'GENDER'      '' ''.
  add_column 'DEP_ID'      'Dept Code'       'DEP_ID'      '' ''.
  add_column 'DEP_NAME'    'Department'      'DEP_NAME'    '' ''.
  add_column 'DESIGNATION' 'Designation'     'DESIGNATION' '' ''.
  add_column 'SALARY'      'Salary'          'SALARY'      '' 'X'. " Sum Enabled
  add_column 'WAERS'       'Currency'        'WAERS'       '' ''.
  add_column 'JOIN_DATE'   'Join Date'       'JOIN_DATE'   '' ''.
  add_column 'STATUS'      'Status'          'STATUS'      '' ''.
  add_column 'EMAIL'       'Email Address'   'EMAIL'       '' ''.
ENDFORM.

FORM prepare_layout.
  CLEAR gs_layout.
  gs_layout-zebra      = 'X'.          " Enable Zebra Pattern striping
  gs_layout-info_fname = 'ROW_COLOR'.  " Set Row Color Source field
  gs_layout-ctab_fname = 'CELL_COLOR'.  " Set Cell Color Source field
  gs_layout-grid_title = 'Employee Master Dashboard'.
  gs_layout-cwidth_opt = 'X'.          " Optimize Column Widths

  gs_variant-report    = sy-repid.
  gs_variant-username  = sy-uname.
ENDFORM.

*----------------------------------------------------------------------*
* SCREEN MODULES IMPLEMENTATION
*----------------------------------------------------------------------*
MODULE status_9000 OUTPUT.
  SET PF-STATUS 'STATUS_ALV'.
  SET TITLEBAR 'TITLE_ALV'.

  " Instantiate ALV container on Screen 9000
  IF go_alv_grid IS INITIAL.
    " Using screen0 container (Full screen container shortcut)
    CREATE OBJECT go_alv_grid
      EXPORTING
        i_parent = cl_gui_container=>screen0.

    " Instantiate and register events
    DATA: lo_handler TYPE REF TO lcl_event_handler.
    CREATE OBJECT lo_handler.
    
    SET HANDLER lo_handler->handle_double_click FOR go_alv_grid.
    SET HANDLER lo_handler->handle_toolbar      FOR go_alv_grid.
    SET HANDLER lo_handler->handle_user_command FOR go_alv_grid.

    " Display Grid
    go_alv_grid->set_table_for_first_display(
      EXPORTING
        is_layout                     = gs_layout
        is_variant                    = gs_variant
        i_save                        = 'A'            " Allow layout saving
      CHANGING
        it_outtab                     = gt_report_out
        it_fieldcatalog               = gt_fieldcat
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4 ).
  ELSE.
    " Refresh grid layout and contents
    go_alv_grid->refresh_table_display( ).
  ENDIF.
ENDMODULE.

MODULE user_command_9000 INPUT.
  IF sy-ucomm = 'BACK' OR sy-ucomm = 'EXIT' OR sy-ucomm = 'CANCEL'.
    SET SCREEN 0.
    LEAVE TO SCREEN 0.
  ENDIF.
ENDMODULE.

*----------------------------------------------------------------------*
* CLASS lcl_event_handler IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD handle_double_click.
    " Read selected row index
    READ TABLE gt_report_out INTO DATA(ls_selected) INDEX e_row-index.
    IF sy-subrc = 0 AND e_column-fieldname = 'EMP_ID'.
      " Hotspot Navigation: Drilldown to Employee CRUD screen
      " Export Employee ID parameter and call ZEMS_CRUD
      SET PARAMETER ID 'ZEMS_EMP' FIELD ls_selected-emp_id.
      SET PARAMETER ID 'ZEMS_MODE' FIELD 'V'. " Display Mode 'V'
      
      CALL TRANSACTION 'ZEMS_CRUD' AND SKIP FIRST SCREEN.
    ENDIF.
  ENDMETHOD.

  METHOD handle_toolbar.
    DATA: ls_button TYPE tb_button.

    " Add separator
    ls_button-function = 'SEP'.
    ls_button-butn_type = 3.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

    " Custom Button 1: Print Employee Profile
    CLEAR ls_button.
    ls_button-function  = 'PRINT_SF'.
    ls_button-icon      = '@0X@'. " Standard print icon
    ls_button-quickinfo = 'Print Employee Profile'.
    ls_button-text      = 'Print Profile'.
    ls_button-disabled  = ' '.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

    " Custom Button 2: Email Salary Slip
    CLEAR ls_button.
    ls_button-function  = 'EMAIL_SLIP'.
    ls_button-icon      = '@AY@'. " Standard email envelope icon
    ls_button-quickinfo = 'Email Monthly Salary Slip'.
    ls_button-text      = 'Email Slip'.
    ls_button-disabled  = ' '.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.
  ENDMETHOD.

  METHOD handle_user_command.
    DATA: lt_rows TYPE lvc_t_row,
          ls_row  TYPE lvc_s_row.

    " Get highlighted rows
    go_alv_grid->get_selected_rows( IMPORTING et_index_rows = lt_rows ).

    READ TABLE lt_rows INTO ls_row INDEX 1.
    IF sy-subrc <> 0.
      MESSAGE 'Please select a row first.' TYPE 'I'.
      EXIT.
    ENDIF.

    READ TABLE gt_report_out INTO DATA(ls_selected) INDEX ls_row-index.
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.

    CASE e_ucomm.
      WHEN 'PRINT_SF'.
        " Trigger driver program parameter setting and execution
        SET PARAMETER ID 'ZEMS_EMP' FIELD ls_selected-emp_id.
        SET PARAMETER ID 'ZEMS_SF_ACT' FIELD 'PRINT'.
        SUBMIT zems_smartforms_driver AND RETURN.

      WHEN 'EMAIL_SLIP'.
        SET PARAMETER ID 'ZEMS_EMP' FIELD ls_selected-emp_id.
        SET PARAMETER ID 'ZEMS_SF_ACT' FIELD 'EMAIL'.
        SUBMIT zems_smartforms_driver AND RETURN.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.
