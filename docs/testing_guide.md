# EMS Go-Live Testing Script Guide

This guide provides step-by-step test scripts to validate the functionality, security, concurrent locking, and reporting of the Employee Management System (EMS) once deployed on your SAP system.

---

## Test Script 1: Employee Hiring (Create & Validation)

* **Objective**: Verify employee creation and input validation rules.
* **Pre-requisites**: Run seeder report `ZEMS_MOCK_DATA` first to ensure department `HR01` exists in database.

### Execution Steps
1. Execute Transaction code **`/nZEMS_CRUD`** to open the dashboard.
2. Select **Create Employee** radio button and click **Execute**.
3. Verify that Screen 200 opens and all inputs are editable except the **Employee ID** key field (locked for SNRO auto-generation).
4. **Test Case 1A: Email Syntax Validation Check**
   * Enter First Name: `Piyush`, Last Name: `Bhardwaj`, Gender: `Male`, DOB: `15.08.1998`, Joining Date: `01.07.2023`, Dept ID: `HR01`, Designation: `Developer`, Salary: `95000.00`.
   * Enter Email Address: `piyush.bhardwaj.com` (Missing `@` sign).
   * Click **Save**.
   * *Expected Result*: System stops processing, blocks save, and displays warning message: **`Invalid Email Address format: piyush.bhardwaj.com`** (from `ZEMS_MSG` ID `008`).
5. **Test Case 1B: Positive Salary Check**
   * Correct the email to `piyush@example.com`.
   * Change Salary to `-5000.00` (Negative value).
   * Click **Save**.
   * *Expected Result*: Blocked, warning message: **`Salary must be a positive value.`** (ID `007`).
6. **Test Case 1C: Future Date Checks**
   * Correct the salary to `95000.00`.
   * Change Joining Date to a future date (e.g. `01.01.2030`).
   * Click **Save**.
   * *Expected Result*: Blocked, warning message: **`Joining Date cannot be in the future.`** (ID `006`).
7. **Test Case 1D: Underage Check**
   * Correct the joining date to `01.07.2023`.
   * Change DOB to make candidate under 18 years old (e.g., set DOB to 3 years ago).
   * Click **Save**.
   * *Expected Result*: Blocked, warning message: **`Date of Birth cannot be in the future.`** (Underage candidate error, ID `005`).
8. **Test Case 1E: Success Execution**
   * Reset DOB to a valid birthdate (e.g. `15.08.1998`).
   * Click **Save**.
   * *Expected Result*: Record is inserted successfully. Dashboard displays success message: **`Employee 00000011 created successfully.`** (ID `000`).

---

## Test Script 2: Concurrency Lock Enforce (Lock Object Check)

* **Objective**: Verify that two users cannot modify the same employee profile at the same time.

### Execution Steps
1. Log in to the SAP client with two separate user accounts (User A and User B).
2. **User A**: Opens `/nZEMS_CRUD`, searches Employee ID `00000011`, selects **Edit Employee** radio button, and clicks **Execute**.
   * *Result*: User A is redirected to Screen 200, fields are editable, and lock object `EZEMS_EMPLOYEE` writes a lock entry to `SM12` queue.
3. **User B**: Opens `/nZEMS_CRUD`, searches Employee ID `00000011`, selects **Edit Employee** radio button, and clicks **Execute**.
   * *Expected Result*: System blocks User B, remains on Screen 100, and displays error message: **`Record is currently locked by user USER_A.`** (ID `012`).

---

## Test Script 3: Interactive OO ALV Report Dashboard

* **Objective**: Verify reporting filters, row color highlighting, and double-click hotspots.

### Execution Steps
1. Execute Transaction code **`/nZEMS_REP`** to open selection filters.
2. Select **Active Employees** radio button and click **Execute (F8)**.
3. Verify that the grid displays:
   * Zebra striping on alternating rows.
   * Total salary aggregate summary row at the bottom of the grid.
   * Highlighted rows: Active employees have a soft green background, and Inactive employees have a soft red background.
4. **Test Case 3A: Hotspot Drilldown Navigation**
   * Move cursor over the **Employee ID** cell of employee `00000011`. Notice cursor changes to a hand indicator.
   * Double-click on the Employee ID cell.
   * *Expected Result*: System executes hotspot handler, reads selected row index, sets SPA/GPA parameters, and calls transaction `ZEMS_CRUD` in Display Mode. Screen 200 is shown with employee `00000011` details, and all fields are locked (input = 0).

---

## Test Script 4: Smart Forms PDF & BCS Email Distribution

* **Objective**: Verify print previews and automated email spools.

### Execution Steps
1. Execute transaction `/nZEMS_REP` and run the employee grid report.
2. Select a row (e.g. Employee `00000001`).
3. Click the custom toolbar button **Print Profile**.
   * *Expected Result*: System calls dynamic Smart Form function module for `ZEMS_SF_PROFILE` and displays standard print spool parameters dialogue. Clicking Print Preview displays the styled A4 sheet with logo and Code 128 barcode format.
4. Click the custom toolbar button **Email Slip**.
   * *Expected Result*: System calls `ZEMS_SF_SALSLIP`, converts OTF spool data to PDF format, initiates class `CL_BCS` send request, and attaches the file. Dashboard returns success message: **`Salary slip emailed successfully to piyush@example.com.`** (ID `016`).
5. Execute transaction **`/nSOST`** (SAP Send Status overview).
   * Verify that a new email entry is queued with recipient `piyush@example.com` and subject `EMS Monthly Salary Slip Statement` containing the PDF attachment.
