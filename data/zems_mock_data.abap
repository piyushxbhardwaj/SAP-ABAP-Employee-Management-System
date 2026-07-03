*======================================================================*
* PROJECT: Employee Management System (EMS)
* PROGRAM: ZEMS_MOCK_DATA (SE38)
* PACKAGE: ZEMS
* TYPE:    Executable Program (Type 1)
* DESCRIPTION: Seed script to populate Department and Employee Master
*              tables with realistic, production-like test records.
*======================================================================*

REPORT zems_mock_data.

DATA: lt_dept TYPE TABLE OF zems_t_dept,
      ls_dept TYPE zems_t_dept,
      lt_emp  TYPE TABLE OF zems_t_employee,
      ls_emp  TYPE zems_t_employee.

START-OF-SELECTION.

  " 1. CLEAR EXISTING DATA
  "----------------------------------------------------------------------
  WRITE: / 'Clearing existing records...'.
  DELETE FROM zems_t_employee.
  DELETE FROM zems_t_dept.
  DELETE FROM zems_t_audit.
  COMMIT WORK.
  WRITE: / 'Tables cleared successfully.'.

  " 2. SEED DEPARTMENT MASTER DATA
  "----------------------------------------------------------------------
  WRITE: / 'Seeding Department Table (ZEMS_T_DEPT)...'.

  ls_dept-client = sy-mandt.

  ls_dept-dep_id     = 'HR01'.
  ls_dept-dep_name   = 'Human Resources'.
  ls_dept-manager_id = '00000001'.
  ls_dept-location   = 'Bangalore'.
  APPEND ls_dept TO lt_dept.

  ls_dept-dep_id     = 'IT01'.
  ls_dept-dep_name   = 'Information Technology'.
  ls_dept-manager_id = '00000002'.
  ls_dept-location   = 'Bangalore'.
  APPEND ls_dept TO lt_dept.

  ls_dept-dep_id     = 'FIN01'.
  ls_dept-dep_name   = 'Finance & Accounts'.
  ls_dept-manager_id = '00000003'.
  ls_dept-location   = 'Mumbai'.
  APPEND ls_dept TO lt_dept.

  ls_dept-dep_id     = 'MKT01'.
  ls_dept-dep_name   = 'Marketing & Sales'.
  ls_dept-manager_id = '00000004'.
  ls_dept-location   = 'Delhi'.
  APPEND ls_dept TO lt_dept.

  ls_dept-dep_id     = 'RND01'.
  ls_dept-dep_name   = 'Research & Development'.
  ls_dept-manager_id = '00000005'.
  ls_dept-location   = 'Pune'.
  APPEND ls_dept TO lt_dept.

  INSERT zems_t_dept FROM TABLE lt_dept.
  IF sy-subrc = 0.
    WRITE: / 'Seeded 5 Department records successfully.'.
  ELSE.
    WRITE: / 'Error seeding Department table.'.
  ENDIF.

  " 3. SEED EMPLOYEE MASTER DATA
  "----------------------------------------------------------------------
  WRITE: / 'Seeding Employee Table (ZEMS_T_EMPLOYEE)...'.

  ls_emp-client = sy-mandt.

  " Emp 1 - HR Manager
  ls_emp-emp_id      = '00000001'.
  ls_emp-first_name  = 'Piyush'.
  ls_emp-last_name   = 'Bhardwaj'.
  ls_emp-gender      = 'M'.
  ls_emp-dob         = '19980815'.
  ls_emp-mobile      = '+919876543210'.
  ls_emp-email       = 'piyush@example.com'.
  ls_emp-dep_id      = 'HR01'.
  ls_emp-designation = 'HR Manager'.
  ls_emp-salary      = '95000.00'.
  ls_emp-waers       = 'INR'.
  ls_emp-join_date   = '20230701'.
  ls_emp-address     = '123 SAP Lane, Bangalore, India'.
  ls_emp-status      = 'A'.
  APPEND ls_emp TO lt_emp.

  " Emp 2 - IT Lead
  ls_emp-emp_id      = '00000002'.
  ls_emp-first_name  = 'Amit'.
  ls_emp-last_name   = 'Sharma'.
  ls_emp-gender      = 'M'.
  ls_emp-dob         = '19920423'.
  ls_emp-mobile      = '+919812345670'.
  ls_emp-email       = 'amit.sharma@example.com'.
  ls_emp-dep_id      = 'IT01'.
  ls_emp-designation = 'Technical Lead'.
  ls_emp-salary      = '120000.00'.
  ls_emp-waers       = 'INR'.
  ls_emp-join_date   = '20220115'.
  ls_emp-address     = '45 Tech Boulevard, Bangalore'.
  ls_emp-status      = 'A'.
  APPEND ls_emp TO lt_emp.

  " Emp 3 - Finance Mgr
  ls_emp-emp_id      = '00000003'.
  ls_emp-first_name  = 'Priya'.
  ls_emp-last_name   = 'Patel'.
  ls_emp-gender      = 'F'.
  ls_emp-dob         = '19900910'.
  ls_emp-mobile      = '+919988776655'.
  ls_emp-email       = 'priya.patel@example.com'.
  ls_emp-dep_id      = 'FIN01'.
  ls_emp-designation = 'Finance Manager'.
  ls_emp-salary      = '110000.00'.
  ls_emp-waers       = 'INR'.
  ls_emp-join_date   = '20210610'.
  ls_emp-address     = '88 Nariman Point, Mumbai'.
  ls_emp-status      = 'A'.
  APPEND ls_emp TO lt_emp.

  " Emp 4 - Marketing Lead
  ls_emp-emp_id      = '00000004'.
  ls_emp-first_name  = 'Rajesh'.
  ls_emp-last_name   = 'Kumar'.
  ls_emp-gender      = 'M'.
  ls_emp-dob         = '19941120'.
  ls_emp-mobile      = '+919122334455'.
  ls_emp-email       = 'rajesh.k@example.com'.
  ls_emp-dep_id      = 'MKT01'.
  ls_emp-designation = 'Marketing Lead'.
  ls_emp-salary      = '80000.00'.
  ls_emp-waers       = 'INR'.
  ls_emp-join_date   = '20231120'.
  ls_emp-address     = '12 Connaught Place, New Delhi'.
  ls_emp-status      = 'A'.
  APPEND ls_emp TO lt_emp.

  " Emp 5 - Research Lead
  ls_emp-emp_id      = '00000005'.
  ls_emp-first_name  = 'Sneha'.
  ls_emp-last_name   = 'Rao'.
  ls_emp-gender      = 'F'.
  ls_emp-dob         = '19881001'.
  ls_emp-mobile      = '+919567890123'.
  ls_emp-email       = 'sneha.rao@example.com'.
  ls_emp-dep_id      = 'RND01'.
  ls_emp-designation = 'Research Lead'.
  ls_emp-salary      = '130000.00'.
  ls_emp-waers       = 'INR'.
  ls_emp-join_date   = '20200901'.
  ls_emp-address     = '10 R&D Tech Park, Pune'.
  ls_emp-status      = 'A'.
  APPEND ls_emp TO lt_emp.

  " Emp 6 - IT Developer
  ls_emp-emp_id      = '00000006'.
  ls_emp-first_name  = 'John'.
  ls_emp-last_name   = 'Doe'.
  ls_emp-gender      = 'M'.
  ls_emp-dob         = '19960512'.
  ls_emp-mobile      = '+919001122334'.
  ls_emp-email       = 'john.doe@example.com'.
  ls_emp-dep_id      = 'IT01'.
  ls_emp-designation = 'Developer'.
  ls_emp-salary      = '75000.00'.
  ls_emp-waers       = 'INR'.
  ls_emp-join_date   = '20240301'.
  ls_emp-address     = '99 Koramangala, Bangalore'.
  ls_emp-status      = 'A'.
  APPEND ls_emp TO lt_emp.

  " Emp 7 - HR Associate
  ls_emp-emp_id      = '00000007'.
  ls_emp-first_name  = 'Jane'.
  ls_emp-last_name   = 'Smith'.
  ls_emp-gender      = 'F'.
  ls_emp-dob         = '19970315'.
  ls_emp-mobile      = '+919005566778'.
  ls_emp-email       = 'jane.smith@example.com'.
  ls_emp-dep_id      = 'HR01'.
  ls_emp-designation = 'HR Associate'.
  ls_emp-salary      = '65000.00'.
  ls_emp-waers       = 'INR'.
  ls_emp-join_date   = '20230515'.
  ls_emp-address     = '44 Saket, New Delhi'.
  ls_emp-status      = 'A'.
  APPEND ls_emp TO lt_emp.

  " Emp 8 - RND Analyst
  ls_emp-emp_id      = '00000008'.
  ls_emp-first_name  = 'Vikram'.
  ls_emp-last_name   = 'Singh'.
  ls_emp-gender      = 'M'.
  ls_emp-dob         = '19950801'.
  ls_emp-mobile      = '+919890123456'.
  ls_emp-email       = 'vikram.s@example.com'.
  ls_emp-dep_id      = 'RND01'.
  ls_emp-designation = 'R&D Analyst'.
  ls_emp-salary      = '70000.00'.
  ls_emp-waers       = 'INR'.
  ls_emp-join_date   = '20220801'.
  ls_emp-address     = '12 Hinjewadi, Pune'.
  ls_emp-status      = 'A'.
  APPEND ls_emp TO lt_emp.

  " Emp 9 - Finance Clerk
  ls_emp-emp_id      = '00000009'.
  ls_emp-first_name  = 'Pooja'.
  ls_emp-last_name   = 'Hegde'.
  ls_emp-gender      = 'F'.
  ls_emp-dob         = '19990210'.
  ls_emp-mobile      = '+919320495867'.
  ls_emp-email       = 'pooja.h@example.com'.
  ls_emp-dep_id      = 'FIN01'.
  ls_emp-designation = 'Accountant'.
  ls_emp-salary      = '55000.00'.
  ls_emp-waers       = 'INR'.
  ls_emp-join_date   = '20240210'.
  ls_emp-address     = '23 Andheri, Mumbai'.
  ls_emp-status      = 'A'.
  APPEND ls_emp TO lt_emp.

  " Emp 10 - Inactive IT Dev (Left Company)
  ls_emp-emp_id      = '00000010'.
  ls_emp-first_name  = 'David'.
  ls_emp-last_name   = 'Warner'.
  ls_emp-gender      = 'M'.
  ls_emp-dob         = '19861027'.
  ls_emp-mobile      = '+919090909090'.
  ls_emp-email       = 'david.w@example.com'.
  ls_emp-dep_id      = 'IT01'.
  ls_emp-designation = 'Senior Developer'.
  ls_emp-salary      = '145000.00'.
  ls_emp-waers       = 'INR'.
  ls_emp-join_date   = '20190101'.
  ls_emp-address     = '101 Whitefield, Bangalore'.
  ls_emp-status      = 'I'. " Inactive
  APPEND ls_emp TO lt_emp.

  INSERT zems_t_employee FROM TABLE lt_emp.
  IF sy-subrc = 0.
    WRITE: / 'Seeded 10 Employee records successfully.'.
  ELSE.
    WRITE: / 'Error seeding Employee table.'.
  ENDIF.

  " 4. COMMIT AND FINISH
  "----------------------------------------------------------------------
  COMMIT WORK.
  WRITE: / 'Database seeding operation completed successfully!'.
