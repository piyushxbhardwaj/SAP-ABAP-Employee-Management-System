*======================================================================*
* PROJECT: Employee Management System (EMS)
* INCLUDE: ZEMS_EMPLOYEE_LCL
* PACKAGE: ZEMS
* DESCRIPTION: Local Class LCL_EMPLOYEE_CONTROLLER definition & implementation
*              Encapsulates business logic, audits, validations, and logs.
*======================================================================*

*----------------------------------------------------------------------*
* CLASS lcl_employee_controller DEFINITION
*----------------------------------------------------------------------*
CLASS lcl_employee_controller DEFINITION.

  PUBLIC SECTION.
    METHODS:
      load_employee
        IMPORTING iv_emp_id TYPE zems_de_empid
        RETURNING VALUE(rv_subrc) TYPE sy-subrc,

      save_employee
        RETURNING VALUE(rv_subrc) TYPE sy-subrc,

      delete_employee
        IMPORTING iv_emp_id TYPE zems_de_empid
        RETURNING VALUE(rv_subrc) TYPE sy-subrc,

      calculate_kpis,

      lock_employee
        IMPORTING iv_emp_id TYPE zems_de_empid
        RETURNING VALUE(rv_subrc) TYPE sy-subrc,

      unlock_employee
        IMPORTING iv_emp_id TYPE zems_de_empid,

      check_authority
        IMPORTING iv_dep_id TYPE zems_de_depid
                  iv_actvt  TYPE char2
        RETURNING VALUE(rv_subrc) TYPE sy-subrc.

  PRIVATE SECTION.
    METHODS:
      validate_inputs
        RETURNING VALUE(rv_valid) TYPE abap_bool,

      get_next_empid
        RETURNING VALUE(rv_emp_id) TYPE zems_de_empid,

      write_audit_log
        IMPORTING iv_emp_id TYPE zems_de_empid
                  iv_action TYPE zems_de_action,

      write_app_log
        IMPORTING iv_msg_text TYPE string
                  iv_msg_type TYPE char1.

ENDCLASS.                    "lcl_employee_controller DEFINITION


*----------------------------------------------------------------------*
* CLASS lcl_employee_controller IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS lcl_employee_controller IMPLEMENTATION.

  *----------------------------------------------------------------------*
  * METHOD load_employee
  *----------------------------------------------------------------------*
  METHOD load_employee.

    SELECT SINGLE emp_id, first_name, last_name, gender, dob, mobile,
                  email, dep_id, designation, salary, waers, join_date,
                  address, status
      FROM zems_t_employee
      INTO (@gv_emp_id, @gv_first_name, @gv_last_name, @gv_gender, @gv_dob,
            @gv_mobile, @gv_email, @gv_dept_id, @gv_designation, @gv_salary,
            @gv_waers, @gv_join_date, @gv_address, @gv_status)
      WHERE emp_id = @iv_emp_id.

    rv_subrc = sy-subrc.
  ENDMETHOD.                    "load_employee

  *----------------------------------------------------------------------*
  * METHOD save_employee
  *----------------------------------------------------------------------*
  METHOD save_employee.
    DATA: ls_emp TYPE zems_t_employee.

    rv_subrc = 4.

    " Run field validation check
    IF validate_inputs( ) = abap_false.
      EXIT.
    ENDIF.

    " Set values for database insertion/update
    ls_emp-first_name  = gv_first_name.
    ls_emp-last_name   = gv_last_name.
    ls_emp-gender      = gv_gender.
    ls_emp-dob         = gv_dob.
    ls_emp-mobile      = gv_mobile.
    ls_emp-email       = gv_email.
    ls_emp-dep_id      = gv_dept_id.
    ls_emp-designation = gv_designation.
    ls_emp-salary      = gv_salary.
    ls_emp-waers       = gv_waers.
    ls_emp-join_date   = gv_join_date.
    ls_emp-address     = gv_address.
    ls_emp-status      = gv_status.

    IF gv_action_mode = gc_mode_create.
      " Retrieve next ID using Number Range API
      gv_emp_id = get_next_empid( ).
      IF gv_emp_id IS INITIAL.
        write_app_log( iv_msg_text = 'Failed to generate Employee ID from SNRO.' iv_msg_type = 'E' ).
        MESSAGE e014(zems_msg).
        EXIT.
      ENDIF.
      ls_emp-emp_id = gv_emp_id.

      INSERT zems_t_employee FROM ls_emp.
      IF sy-subrc = 0.
        rv_subrc = 0.
        write_audit_log( iv_emp_id = gv_emp_id iv_action = 'CREATE' ).
        write_app_log( iv_msg_text = 'Employee ' && gv_emp_id && ' created successfully.' iv_msg_type = 'S' ).
        MESSAGE s000(zems_msg) WITH gv_emp_id.
      ELSE.
        write_app_log( iv_msg_text = 'DB Error inserting Employee ' && gv_emp_id, iv_msg_type = 'E' ).
        MESSAGE e018(zems_msg) WITH 'INSERT'.
      ENDIF.

    ELSEIF gv_action_mode = gc_mode_edit.
      ls_emp-emp_id = gv_emp_id.
      UPDATE zems_t_employee FROM ls_emp.
      IF sy-subrc = 0.
        rv_subrc = 0.
        write_audit_log( iv_emp_id = gv_emp_id iv_action = 'UPDATE' ).
        write_app_log( iv_msg_text = 'Employee ' && gv_emp_id && ' updated successfully.' iv_msg_type = 'S' ).
        MESSAGE s001(zems_msg) WITH gv_emp_id.
        unlock_employee( iv_emp_id = gv_emp_id ).
      ELSE.
        write_app_log( iv_msg_text = 'DB Error updating Employee ' && gv_emp_id, iv_msg_type = 'E' ).
        MESSAGE e018(zems_msg) WITH 'UPDATE'.
      ENDIF.
    ENDIF.
  ENDMETHOD.                    "save_employee

  *----------------------------------------------------------------------*
  * METHOD delete_employee
  *----------------------------------------------------------------------*
  METHOD delete_employee.
    DELETE FROM zems_t_employee WHERE emp_id = @iv_emp_id.
    rv_subrc = sy-subrc.
    IF rv_subrc = 0.
      write_audit_log( iv_emp_id = iv_emp_id iv_action = 'DELETE' ).
      write_app_log( iv_msg_text = 'Employee ' && iv_emp_id && ' deleted.', iv_msg_type = 'S' ).
      unlock_employee( iv_emp_id = iv_emp_id ).
    ELSE.
      write_app_log( iv_msg_text = 'Error deleting Employee ID ' && iv_emp_id, iv_msg_type = 'E' ).
    ENDIF.
  ENDMETHOD.                    "delete_employee

  *----------------------------------------------------------------------*
  * METHOD calculate_kpis
  *----------------------------------------------------------------------*
  METHOD calculate_kpis.
    " Dynamic KPI calculation on Dashboard using aggregates (Performance optimized)
    SELECT COUNT(*) FROM zems_t_employee INTO @gv_kpi_total.
    SELECT COUNT(*) FROM zems_t_employee INTO @gv_kpi_active WHERE status = 'A'.
    SELECT COUNT(*) FROM zems_t_employee INTO @gv_kpi_inactive WHERE status = 'I'.

    IF gv_kpi_total > 0.
      SELECT AVG( salary ) FROM zems_t_employee INTO @gv_kpi_avg_salary.
    ELSE.
      CLEAR gv_kpi_avg_salary.
    ENDIF.
  ENDMETHOD.                    "calculate_kpis

  *----------------------------------------------------------------------*
  * METHOD lock_employee
  *----------------------------------------------------------------------*
  METHOD lock_employee.
    " Call the generated lock enqueue function module
    CALL FUNCTION 'ENQUEUE_EZEMS_EMPLOYEE'
      EXPORTING
        mode_zems_t_employee = 'E'
        emp_id               = iv_emp_id
        _scope               = '2'
      EXCEPTIONS
        foreign_lock         = 1
        system_failure       = 2
        OTHERS               = 3.

    rv_subrc = sy-subrc.
    IF rv_subrc <> 0.
      " If locked by another user, retrieve username and display warning
      DATA(lv_msg_user) = sy-msgv1.
      IF lv_msg_user IS INITIAL.
        lv_msg_user = 'Another user'.
      ENDIF.
      MESSAGE e012(zems_msg) WITH lv_msg_user.
    ENDIF.
  ENDMETHOD.                    "lock_employee

  *----------------------------------------------------------------------*
  * METHOD unlock_employee
  *----------------------------------------------------------------------*
  METHOD unlock_employee.
    " Call dequeue function module to release lock
    CALL FUNCTION 'DEQUEUE_EZEMS_EMPLOYEE'
      EXPORTING
        mode_zems_t_employee = 'E'
        emp_id               = iv_emp_id
        _scope               = '2'.
  ENDMETHOD.                    "unlock_employee

  *----------------------------------------------------------------------*
  * METHOD check_authority
  *----------------------------------------------------------------------*
  METHOD check_authority.
    " Custom authority check with Z_EMS_AUTH
    " Fields: ACTVT (01-Create, 02-Edit, 03-Display, 06-Delete), DEP_ID (Department scope)
    AUTHORITY-CHECK OBJECT 'Z_EMS_AUTH'
      ID 'ACTVT'  FIELD iv_actvt
      ID 'DEP_ID' FIELD iv_dep_id.

    rv_subrc = sy-subrc.
  ENDMETHOD.                    "check_authority

  *----------------------------------------------------------------------*
  * METHOD validate_inputs
  *----------------------------------------------------------------------*
  METHOD validate_inputs.
    rv_valid = abap_true.

    " 1. Mandatory Field Checks
    IF gv_first_name IS INITIAL OR gv_last_name IS INITIAL OR 
       gv_gender IS INITIAL OR gv_dob IS INITIAL OR gv_join_date IS INITIAL.
      MESSAGE w022(zems_msg). " 'Please enter all mandatory fields.'
      rv_valid = abap_false.
      EXIT.
    ENDIF.

    " 2. Salary Must Be Positive
    IF gv_salary <= 0.
      MESSAGE w007(zems_msg). " 'Salary must be a positive value.'
      rv_valid = abap_false.
      EXIT.
    ENDIF.

    " 3. Dates Checking: Joining Date cannot be in the future
    IF gv_join_date > sy-datum.
      MESSAGE w006(zems_msg). " 'Joining Date cannot be in the future.'
      rv_valid = abap_false.
      EXIT.
    ENDIF.

    " 4. Dates Checking: Date of Birth cannot be in the future
    IF gv_dob > sy-datum.
      MESSAGE w005(zems_msg). " 'Date of Birth cannot be in the future.'
      rv_valid = abap_false.
      EXIT.
    ENDIF.

    " 5. Age check: Employee must be at least 18 years old
    DATA: lv_years TYPE i.
    lv_years = ( sy-datum - gv_dob ) / 365.
    IF lv_years < 18.
      write_app_log( iv_msg_text = 'Employee candidate is underage: Age ' && lv_years, iv_msg_type = 'W' ).
      MESSAGE w005(zems_msg) WITH 'Underage employee'.
      rv_valid = abap_false.
      EXIT.
    ENDIF.

    " 6. Mobile number validation (Must be digits, min 10 chars)
    FIND REGEX '^\+?[0-9]{10,15}$' IN gv_mobile.
    IF sy-subrc <> 0.
      MESSAGE w009(zems_msg) WITH gv_mobile. " 'Invalid Mobile Number format.'
      rv_valid = abap_false.
      EXIT.
    ENDIF.

    " 7. Email validation using standard regex
    FIND REGEX '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$' IN gv_email.
    IF sy-subrc <> 0.
      MESSAGE w008(zems_msg) WITH gv_email. " 'Invalid Email Address format.'
      rv_valid = abap_false.
      EXIT.
    ENDIF.

    " 8. Check Department Validity
    IF gv_dept_id IS NOT INITIAL.
      SELECT SINGLE dep_id FROM zems_t_dept INTO @DATA(lv_dept_chk) WHERE dep_id = @gv_dept_id.
      IF sy-subrc <> 0.
        MESSAGE w003(zems_msg) WITH gv_dept_id.
        rv_valid = abap_false.
        EXIT.
      ENDIF.
    ENDIF.
  ENDMETHOD.                    "validate_inputs

  *----------------------------------------------------------------------*
  * METHOD get_next_empid
  *----------------------------------------------------------------------*
  METHOD get_next_empid.
    DATA: lv_number TYPE char20.

    " Call standard SAP Number Range retrieval API
    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = '01'
        object                  = 'ZEMS_NR_EP'
      IMPORTING
        number                  = lv_number
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_not_1       = 4
        interval_overflow       = 5
        buffer_overflow         = 6
        OTHERS                  = 7.

    IF sy-subrc = 0.
      rv_emp_id = lv_number.
    ELSE.
      CLEAR rv_emp_id.
    ENDIF.
  ENDMETHOD.                    "get_next_empid

  *----------------------------------------------------------------------*
  * METHOD write_audit_log
  *----------------------------------------------------------------------*
  METHOD write_audit_log.
    DATA: ls_audit TYPE zems_t_audit.
    DATA: lv_log_nr TYPE char20.

    " Retrieve sequencial number for Audit Log Entry using Number Range ZEMS_NR_AD
    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr       = '01'
        object            = 'ZEMS_NR_AD'
      IMPORTING
        number            = lv_log_nr
      EXCEPTIONS
        OTHERS            = 1.

    IF sy-subrc <> 0.
      " Fallback to timestamp if number range fails
      lv_log_nr = sy-uzeit.
    ENDIF.

    ls_audit-audit_id    = lv_log_nr.
    ls_audit-emp_id      = iv_emp_id.
    ls_audit-action      = iv_action.
    ls_audit-changed_by  = sy-uname.
    ls_audit-change_date = sy-datum.
    ls_audit-change_time = sy-uzeit.

    INSERT zems_t_audit FROM ls_audit.
  ENDMETHOD.                    "write_audit_log

  *----------------------------------------------------------------------*
  * METHOD write_app_log
  *----------------------------------------------------------------------*
  METHOD write_app_log.
    " Write to Standard Application Log (SLG1) using BAL_* API instead of custom DB table
    DATA: ls_log        TYPE bal_s_log,
          lv_log_handle TYPE balloghndl,
          ls_msg        TYPE bal_s_msg.

    " 1. Initialize Log Header Properties
    ls_log-object    = 'ZEMS_LOG'.
    ls_log-subobject = 'CRUD'.
    ls_log-aluser    = sy-uname.
    ls_log-alprog    = sy-cprog.

    " 2. Create Log Context
    CALL FUNCTION 'BAL_LOG_CREATE'
      EXPORTING
        i_s_log      = ls_log
      IMPORTING
        e_log_handle = lv_log_handle
      EXCEPTIONS
        OTHERS       = 1.

    IF sy-subrc = 0.
      " 3. Map message properties to Log
      ls_msg-msgty = iv_msg_type.   " S - Success, E - Error, W - Warning
      ls_msg-msgid = 'ZEMS_MSG'.
      ls_msg-msgno = '018'.         " Central exception code message
      ls_msg-msgv1 = iv_msg_text(50).
      ls_msg-msgv2 = iv_msg_text+50(50).

      CALL FUNCTION 'BAL_LOG_MSG_ADD'
        EXPORTING
          i_log_handle = lv_log_handle
          i_s_msg      = ls_msg
        EXCEPTIONS
          OTHERS       = 1.

      " 4. Save Logs to Database (BALHDR/BALDAT)
      DATA: lt_handles TYPE bal_t_logh.
      APPEND lv_log_handle TO lt_handles.

      CALL FUNCTION 'BAL_DB_SAVE'
        EXPORTING
          i_t_log_handle = lt_handles
        EXCEPTIONS
          OTHERS         = 1.
    ENDIF.
  ENDMETHOD.                    "write_app_log

ENDCLASS.                    "lcl_employee_controller IMPLEMENTATION
