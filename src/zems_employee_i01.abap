*======================================================================*
* PROJECT: Employee Management System (EMS)
* INCLUDE: ZEMS_EMPLOYEE_I01
* PACKAGE: ZEMS
* DESCRIPTION: PAI (Process After Input) modules for screens 100 & 200.
*======================================================================*

*----------------------------------------------------------------------*
* MODULE USER_COMMAND_0100 INPUT
*----------------------------------------------------------------------*
* Handles actions on Screen 100 (Dashboard / Search Panel).
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  save_ok_code = ok_code.
  CLEAR ok_code.

  CASE save_ok_code.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      SET SCREEN 0.
      LEAVE PROGRAM.

    WHEN 'EXECUTE'.
      " Process according to selected action mode
      CASE gv_action_mode.
        WHEN gc_mode_create.
          " Clear fields and prepare Screen 200
          CLEAR: gv_emp_id, gv_first_name, gv_last_name, gv_gender, gv_dob,
                 gv_mobile, gv_email, gv_dept_id, gv_designation, gv_salary,
                 gv_waers, gv_join_date, gv_address, gv_status.
          gv_waers = 'INR'.
          gv_status = 'A'.
          CALL SCREEN 0200.

        WHEN gc_mode_edit OR gc_mode_display.
          " Validation: Employee ID is mandatory
          IF gv_search_emp_id IS INITIAL.
            MESSAGE e022(zems_msg). " 'Please enter all mandatory fields.'
          ENDIF.

          " Attempt to load employee details
          go_controller->load_employee( EXPORTING iv_emp_id = gv_search_emp_id ).
          IF sy-subrc <> 0.
            MESSAGE e011(zems_msg) WITH gv_search_emp_id. " 'Employee ID & not found.'
          ELSE.
            " Lock the record if in edit mode to avoid concurrency issues
            IF gv_action_mode = gc_mode_edit.
              go_controller->lock_employee( EXPORTING iv_emp_id = gv_search_emp_id ).
              IF sy-subrc <> 0.
                " Lock failed; error message shown by controller, stay on Screen 100
                EXIT.
              ENDIF.
            ENDIF.
            " Map search parameter to active work field and open form screen
            gv_emp_id = gv_search_emp_id.
            CALL SCREEN 0200.
          ENDIF.

        WHEN gc_mode_delete.
          " Validation: Employee ID is mandatory
          IF gv_search_emp_id IS INITIAL.
            MESSAGE e022(zems_msg).
          ENDIF.

          " Load employee for display in popup details or validation
          go_controller->load_employee( EXPORTING iv_emp_id = gv_search_emp_id ).
          IF sy-subrc <> 0.
            MESSAGE e011(zems_msg) WITH gv_search_emp_id.
          ELSE.
            " Role authorization check before deletion (requires Admin)
            go_controller->check_authority( EXPORTING iv_dep_id = gv_dept_id
                                                      iv_actvt  = '06' ). " 06 = Delete
            IF sy-subrc <> 0.
              MESSAGE e013(zems_msg) WITH 'DELETE' gv_dept_id.
            ENDIF.

            " Lock record before deletion
            go_controller->lock_employee( EXPORTING iv_emp_id = gv_search_emp_id ).
            IF sy-subrc <> 0.
              EXIT.
            ENDIF.

            " Confirmation Popup before deletion
            DATA: lv_answer TYPE char1.
            CALL FUNCTION 'POPUP_TO_CONFIRM'
              EXPORTING
                titlebar       = 'Confirm Deletion'
                text_question  = 'Are you sure you want to delete this employee?'
                text_button_1  = 'Yes'
                text_button_2  = 'No'
              IMPORTING
                answer         = lv_answer
              EXCEPTIONS
                text_not_found = 1
                OTHERS         = 2.

            IF lv_answer = '1'. " Yes
              go_controller->delete_employee( EXPORTING iv_emp_id = gv_search_emp_id ).
              IF sy-subrc = 0.
                MESSAGE s002(zems_msg) WITH gv_search_emp_id. " 'Deleted successfully'
                CLEAR gv_search_emp_id.
              ELSE.
                MESSAGE e018(zems_msg) WITH 'DELETE'. " 'Database error during DELETE'
              ENDIF.
            ELSE.
              " Unlock record if deletion cancelled
              go_controller->unlock_employee( EXPORTING iv_emp_id = gv_search_emp_id ).
            ENDIF.
          ENDIF.
      ENDCASE.
  ENDCASE.

ENDMODULE.

*----------------------------------------------------------------------*
* MODULE USER_COMMAND_0200 INPUT
*----------------------------------------------------------------------*
* Handles actions on Screen 200 (Employee Data Entry Form).
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.

  save_ok_code = ok_code.
  CLEAR ok_code.

  CASE save_ok_code.
    WHEN 'BACK' OR 'CANCEL'.
      " Release employee lock if in Edit mode
      IF gv_action_mode = gc_mode_edit.
        go_controller->unlock_employee( EXPORTING iv_emp_id = gv_emp_id ).
      ENDIF.
      CALL SCREEN 0100.

    WHEN 'SAVE'.
      " Check authorizations (Activity 01 for Create, 02 for Edit)
      DATA: lv_activity TYPE char2.
      IF gv_action_mode = gc_mode_create.
        lv_activity = '01'. " Create
      ELSE.
        lv_activity = '02'. " Update
      ENDIF.

      go_controller->check_authority( EXPORTING iv_dep_id = gv_dept_id
                                                iv_actvt  = lv_activity ).
      IF sy-subrc <> 0.
        MESSAGE e013(zems_msg) WITH 'SAVE' gv_dept_id.
      ENDIF.

      " Save operations trigger
      go_controller->save_employee( ).
      IF sy-subrc = 0.
        " Success: Unlock is handled by save subroutine on completion
        CALL SCREEN 0100.
      ENDIF.

    WHEN 'VAL_DEPT'.
      " Validate department exists dynamically during entry
      IF gv_dept_id IS NOT INITIAL.
        SELECT SINGLE dep_id FROM zems_t_dept INTO gv_dept_id WHERE dep_id = gv_dept_id.
        IF sy-subrc <> 0.
          MESSAGE w003(zems_msg) WITH gv_dept_id. " Department not found warning
        ENDIF.
      ENDIF.
  ENDCASE.

ENDMODULE.
