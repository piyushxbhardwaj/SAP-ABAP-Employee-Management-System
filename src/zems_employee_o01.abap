*======================================================================*
* PROJECT: Employee Management System (EMS)
* INCLUDE: ZEMS_EMPLOYEE_O01
* PACKAGE: ZEMS
* DESCRIPTION: PBO (Process Before Output) modules for screens 100 & 200.
*======================================================================*

*----------------------------------------------------------------------*
* MODULE STATUS_0100 OUTPUT
*----------------------------------------------------------------------*
* Executed before Screen 100 is displayed. Sets GUI status, title,
* and updates KPI counters on the dashboard.
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  " Set GUI Status and Title Bar
  SET PF-STATUS 'STATUS_100'.
  SET TITLEBAR 'TITLE_100'. " 'Employee Management System - Dashboard'

  " Instantiate Controller if not done already
  IF go_controller IS INITIAL.
    CREATE OBJECT go_controller.
  ENDIF.

  " Calculate KPIs to display on Screen 100
  go_controller->calculate_kpis( ).

ENDMODULE.

*----------------------------------------------------------------------*
* MODULE STATUS_0200 OUTPUT
*----------------------------------------------------------------------*
* Executed before Screen 200 is displayed. Sets GUI status, sets dynamic
* titles, and enables/disables screen input fields based on Mode.
*----------------------------------------------------------------------*
MODULE status_0200 OUTPUT.

  " Set GUI Status
  SET PF-STATUS 'STATUS_200'.

  " Set Dynamic Title Bar Text
  CASE gv_action_mode.
    WHEN gc_mode_create.
      gv_screen_title = 'Create New Employee'.
    WHEN gc_mode_edit.
      CONCATENATE 'Edit Employee ID: ' gv_emp_id INTO gv_screen_title.
    WHEN gc_mode_display.
      CONCATENATE 'Display Employee ID: ' gv_emp_id INTO gv_screen_title.
  ENDCASE.

  SET TITLEBAR 'TITLE_200' WITH gv_screen_title.

  " Control field visibility and input controls dynamically
  LOOP AT screen.
    " Identify fields belonging to Employee Data Entry group (Group1 = 'EDT')
    IF screen-group1 = 'EDT'.
      IF gv_action_mode = gc_mode_display.
        screen-input = 0. " Disable input in Display Mode
        MODIFY screen.
      ELSEIF gv_action_mode = gc_mode_edit.
        " In Edit mode, make all editable except Key field (Employee ID)
        IF screen-name = 'GV_EMP_ID'.
          screen-input = 0. " Lock Employee ID key
          MODIFY screen.
        ELSE.
          screen-input = 1. " Enable other fields
          MODIFY screen.
        ENDIF.
      ELSEIF gv_action_mode = gc_mode_create.
        " In Create mode, Employee ID is read-only because it is generated via SNRO
        IF screen-name = 'GV_EMP_ID'.
          screen-input = 0.
          MODIFY screen.
        ELSE.
          screen-input = 1.
          MODIFY screen.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDMODULE.
