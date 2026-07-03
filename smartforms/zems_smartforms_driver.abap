*======================================================================*
* PROJECT: Employee Management System (EMS)
* PROGRAM: ZEMS_SMARTFORMS_DRIVER (SE38)
* PACKAGE: ZEMS
* TYPE:    Executable Program (Type 1)
* DESCRIPTION: Driver program for EMS Smart Forms. Fetches employee data,
*              resolves dynamic Smart Form function modules, and triggers
*              Print Preview or emails PDF attachments via Business 
*              Communication Services (BCS / CL_BCS API).
*======================================================================*

REPORT zems_smartforms_driver.

*----------------------------------------------------------------------*
* SELECTION SCREEN
*----------------------------------------------------------------------*
PARAMETER: p_empid  TYPE zems_de_empid MEMORY ID zems_emp,
           p_action TYPE char10 DEFAULT 'PRINT' MEMORY ID zems_sf_act. " PRINT or EMAIL

*----------------------------------------------------------------------*
* GLOBAL DATA
*----------------------------------------------------------------------*
DATA: ls_employee     TYPE zems_t_employee,
      ls_dept         TYPE zems_t_dept,
      lv_fm_name      TYPE rs38l_fnam,
      ls_ctrl_param   TYPE ssfctrlop,
      ls_output_opt   TYPE ssfcompop,
      ls_job_info     TYPE ssfcrescl,
      lt_otf_data     TYPE TABLE OF itcoo,
      lt_pdf_tab      TYPE TABLE OF tline,
      lv_bin_filesize TYPE i,
      lv_pdf_xstring  TYPE xstring.

*----------------------------------------------------------------------*
* START-OF-SELECTION
*----------------------------------------------------------------------*
START-OF-SELECTION.

  " 1. FETCH EMPLOYEE AND DEPARTMENT DATA
  "----------------------------------------------------------------------
  SELECT SINGLE * FROM zems_t_employee INTO @ls_employee WHERE emp_id = @p_empid.
  IF sy-subrc <> 0.
    MESSAGE 'Employee record not found.' TYPE 'E'.
  ENDIF.

  SELECT SINGLE * FROM zems_t_dept INTO @ls_dept WHERE dep_id = @ls_employee-dep_id.

  " 2. DYNAMICALLY RESOLVE SMART FORM FUNCTION MODULE NAME
  "----------------------------------------------------------------------
  DATA: lv_form_name TYPE tdsfname.
  
  IF p_action = 'EMAIL'.
    lv_form_name = 'ZEMS_SF_SALSLIP'.   " Emailing Salary Slips
  ELSE.
    lv_form_name = 'ZEMS_SF_PROFILE'.   " Default Printing Profile
  ENDIF.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = lv_form_name
    IMPORTING
      fm_name            = lv_fm_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.

  IF sy-subrc <> 0.
    MESSAGE 'Error retrieving Smart Form function module.' TYPE 'E'.
  ENDIF.

  " 3. CONFIGURE PRINT CONTROL PARAMETERS
  "----------------------------------------------------------------------
  IF p_action = 'EMAIL'.
    " For Emailing: Tell Smart Form engine to return raw OTF spool instead of opening print GUI
    ls_ctrl_param-getotf    = 'X'.
    ls_ctrl_param-no_dialog = 'X'. " Suppress printer dialog popup
  ELSE.
    " For Printing/Previewing: Display standard print dialog with preview
    ls_ctrl_param-no_dialog = ' '.
    ls_ctrl_param-preview   = 'X'. " Enable Print Preview mode
  ENDIF.

  " 4. CALL DYNAMIC SMART FORM FUNCTION MODULE
  "----------------------------------------------------------------------
  CALL FUNCTION lv_fm_name
    EXPORTING
      control_parameters = ls_ctrl_param
      output_options     = ls_output_opt
      user_settings      = 'X'
      is_employee        = ls_employee
      is_dept            = ls_dept
      iv_month           = 'July'
      iv_year            = '2026'
    IMPORTING
      job_output_info    = ls_job_info
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.

  IF sy-subrc <> 0.
    MESSAGE e018(zems_msg) WITH 'SMARTFORM CALL'.
  ENDIF.

  " 5. IF EMAIL REQUESTED, CONVERT TO PDF AND EMAIL VIA BCS
  "----------------------------------------------------------------------
  IF p_action = 'EMAIL'.
    lt_otf_data = ls_job_info-otfdata.

    " Convert OTF raw stream to PDF Binary Table
    CALL FUNCTION 'CONVERT_OTF'
      EXPORTING
        format                = 'PDF'
      IMPORTING
        bin_filesize          = lv_bin_filesize
        bin_file              = lv_pdf_xstring
      TABLES
        otf                   = lt_otf_data
        lines                 = lt_pdf_tab
      EXCEPTIONS
        err_max_linewidth     = 1
        err_format            = 2
        err_conv_not_possible = 3
        err_bad_otf           = 4
        OTHERS                = 5.

    IF sy-subrc <> 0.
      MESSAGE e015(zems_msg). " 'Error converting OTF data to PDF'
    ENDIF.

    " Check if Employee has a valid email address configured
    IF ls_employee-email IS INITIAL.
      MESSAGE 'Employee email address is empty. Cannot send email.' TYPE 'E'.
    ENDIF.

    " Trigger BCS Mailing routine
    PERFORM send_pdf_via_bcs USING lv_pdf_xstring ls_employee-email.
  ENDIF.

*----------------------------------------------------------------------*
* ROUTINE: send_pdf_via_bcs
*----------------------------------------------------------------------*
* Converts PDF binary raw format, sets up BCS classes, attaches the PDF,
* maps sender/recipient details, and sends mail.
*----------------------------------------------------------------------*
FORM send_pdf_via_bcs USING iv_pdf_bin TYPE xstring
                            iv_recipient TYPE ad_smtpadr.

  DATA: lo_send_request TYPE REF TO cl_bcs,
        lo_document     TYPE REF TO cl_document_bcs,
        lo_sender       TYPE REF TO cl_sapuser_bcs,
        lo_recipient    TYPE REF TO cl_cam_address_bcs,
        lt_message_body TYPE bcsy_text,
        lv_sent         TYPE os_boolean,
        lx_bcs          TYPE REF TO cx_bcs.

  TRY.
      " 1. Create BCS Send Request container
      lo_send_request = cl_bcs=>create_persistent( ).

      " 2. Build Email text body
      APPEND 'Dear Employee,' TO lt_message_body.
      APPEND ' ' TO lt_message_body.
      APPEND 'Please find attached your monthly Salary Slip Statement generated by Antigravity EMS.' TO lt_message_body.
      APPEND ' ' TO lt_message_body.
      APPEND 'This is an automated system-generated email. Please do not reply.' TO lt_message_body.
      APPEND ' ' TO lt_message_body.
      APPEND 'Regards,' TO lt_message_body.
      APPEND 'Human Resources Department' TO lt_message_body.

      " 3. Initialize Document container
      lo_document = cl_document_bcs=>create_document(
        i_type    = 'RAW'
        i_text    = lt_message_body
        i_subject = 'EMS Monthly Salary Slip Statement' ).

      " 4. Attach PDF Binary file to the Document
      " Convert xstring to BCS attachment format
      DATA: lt_att_content TYPE solix_tab.
      lt_att_content = cl_bcs_convert=>xstring_to_solix( iv_pdf_bin ).

      DATA: lv_att_subject TYPE so_obj_des.
      CONCATENATE 'Salary_Slip_' ls_employee-emp_id INTO lv_att_subject.

      lo_document->add_attachment(
        i_attachment_type    = 'PDF'
        i_attachment_subject = lv_att_subject
        i_att_content_hex    = lt_att_content ).

      " Add document attachment to send request
      lo_send_request->set_document( lo_document ).

      " 5. Define Sender & Recipient addresses
      lo_sender = cl_sapuser_bcs=>create( sy-uname ).
      lo_send_request->set_sender( lo_sender ).

      lo_recipient = cl_cam_address_bcs=>create_internet_address( iv_recipient ).
      lo_send_request->add_recipient( i_recipient = lo_recipient i_express = 'X' ).

      " Set request to send immediately
      lo_send_request->set_send_immediately( 'X' ).

      " 6. Send Document
      lv_sent = lo_send_request->send( ).

      IF lv_sent = abap_true.
        COMMIT WORK.
        MESSAGE s016(zems_msg) WITH iv_recipient. " 'Salary slip emailed successfully'
      ELSE.
        MESSAGE e017(zems_msg).
      ENDIF.

    CATCH cx_bcs INTO lx_bcs.
      ROLLBACK WORK.
      DATA: lv_err TYPE string.
      lv_err = lx_bcs->get_text( ).
      MESSAGE e018(zems_msg) WITH lv_err(50).
  ENDTRY.

ENDFORM.
