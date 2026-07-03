# Screen Painter Layout Specifications (SE51)

This document provides the technical layout coordinates, field properties, and dynpro element list required to construct Screen 100 and Screen 200 of transaction `ZEMS_CRUD` in Screen Painter (`SE51`).

---

## 1. Screen 100: HR Dashboard Panel

* **Screen Type**: Normal
* **Next Screen**: 100
* **Title Bar**: `TITLE_100` ("Employee Management System - Dashboard")
* **Status**: `STATUS_100`

### 1.1 Dynpro Flow Logic

```abap
PROCESS BEFORE OUTPUT.
  MODULE status_0100.

PROCESS AFTER INPUT.
  MODULE user_command_0100.
```

### 1.2 Layout Coordinates & Fields List

| Line | Col | Element Type | Element Name | Text / Value | Vis. Lgth | Dict / Field Binding | Attributes | Group |
|------|-----|--------------|--------------|--------------|-----------|-----------------------|------------|-------|
| 2    | 2   | Box / Frame  | BOX_KPI      | "KPI Dashboard Summary" | 75 | - | - | - |
| 3    | 4   | Text / Label | TXT_TOTAL    | "Total Employees:" | 16 | - | - | - |
| 3    | 21  | Input/Output | GV_KPI_TOTAL | -            | 10        | `INT4` | Read-only | KPI |
| 3    | 40  | Text / Label | TXT_ACTIVE   | "Active Employees:" | 17 | - | - | - |
| 3    | 58  | Input/Output | GV_KPI_ACTIVE| -            | 10        | `INT4` | Read-only | KPI |
| 4    | 4   | Text / Label | TXT_INACTIVE | "Inactive Employees:" | 18 | - | - | - |
| 4    | 23  | Input/Output | GV_KPI_INACT | -            | 10        | `INT4` | Read-only | KPI |
| 4    | 40  | Text / Label | TXT_AVG_SAL  | "Average Salary:" | 15 | - | - | - |
| 4    | 56  | Input/Output | GV_KPI_AVGSAL| -            | 15        | `ZEMS_DE_SALARY` | Read-only | KPI |
| 4    | 72  | Input/Output | GV_KPI_WAERS | -            | 3         | `WAERS` | Read-only | KPI |
| 6    | 2   | Box / Frame  | BOX_FILTER   | "Search Criteria" | 75 | - | - | - |
| 7    | 4   | Text / Label | TXT_SRCH_EMP | "Employee ID:" | 13 | - | - | - |
| 7    | 18  | Input/Output | GV_SEARCH_EMP_ID | -        | 8         | `ZEMS_T_EMPLOYEE-EMP_ID` | F4 Help: `ZEMS_SH_EMP` | SCH |
| 8    | 4   | Text / Label | TXT_SRCH_DEP | "Department:"  | 12 | - | - | - |
| 8    | 18  | Input/Output | GV_SEARCH_DEPT   | -        | 8         | `ZEMS_T_EMPLOYEE-DEP_ID` | F4 Help: `ZEMS_SH_DEPT` | SCH |
| 10   | 2   | Box / Frame  | BOX_OPS      | "Operations Control" | 75 | - | - | - |
| 11   | 4   | Radio Button | RAD_CREATE   | "Create Employee" | 18 | `GV_ACTION_MODE` | Value: 'C' (Radiogroup: MOD) | MOD |
| 11   | 25  | Radio Button | RAD_EDIT     | "Edit Employee" | 15 | `GV_ACTION_MODE` | Value: 'E' (Default Group check) | MOD |
| 11   | 43  | Radio Button | RAD_VIEW     | "Display Employee" | 18 | `GV_ACTION_MODE` | Value: 'V' | MOD |
| 11   | 64  | Radio Button | RAD_DELETE   | "Delete Employee" | 16 | `GV_ACTION_MODE` | Value: 'D' | MOD |
| 13   | 20  | Push Button  | BTN_EXECUTE  | "Execute"    | 10        | - | FCode: `EXECUTE`, Icon: `@15@` | - |
| 13   | 35  | Push Button  | BTN_CLEAR    | "Clear"      | 10        | - | FCode: `CLEAR` | - |

---

## 2. Screen 200: Employee Maintenance Form

* **Screen Type**: Normal
* **Next Screen**: 100
* **Title Bar**: `TITLE_200` (Dynamic title set in PBO)
* **Status**: `STATUS_200`

### 2.1 Dynpro Flow Logic

```abap
PROCESS BEFORE OUTPUT.
  MODULE status_0200.

PROCESS AFTER INPUT.
  " Dynamic field validation triggers
  FIELD gv_dept_id MODULE val_dept ON INPUT.
  
  MODULE user_command_0200.
```

### 2.2 Layout Coordinates & Fields List

| Line | Col | Element Type | Element Name | Text / Value | Vis. Lgth | Dict / Field Binding | Attributes | Group |
|------|-----|--------------|--------------|--------------|-----------|-----------------------|------------|-------|
| 2    | 2   | Box / Frame  | BOX_PERSONAL | "Personal Information" | 45 | - | - | - |
| 3    | 4   | Text / Label | TXT_EMP_ID   | "Employee ID:" | 12 | - | - | - |
| 3    | 18  | Input/Output | GV_EMP_ID    | -            | 8         | `ZEMS_T_EMPLOYEE-EMP_ID` | Output-only (Auto SNRO) | EDT |
| 4    | 4   | Text / Label | TXT_FNAME    | "First Name:"  | 12 | - | - | - |
| 4    | 18  | Input/Output | GV_FIRST_NAME| -            | 30        | `ZEMS_T_EMPLOYEE-FIRST_NAME` | Mandatory | EDT |
| 5    | 4   | Text / Label | TXT_LNAME    | "Last Name:"   | 11 | - | - | - |
| 5    | 18  | Input/Output | GV_LAST_NAME | -            | 30        | `ZEMS_T_EMPLOYEE-LAST_NAME` | Mandatory | EDT |
| 6    | 4   | Text / Label | TXT_GENDER   | "Gender:"     | 8  | - | - | - |
| 6    | 18  | Dropdown List| GV_GENDER    | -            | 6         | `ZEMS_T_EMPLOYEE-GENDER` | Listbox, Values: M, F, O | EDT |
| 7    | 4   | Text / Label | TXT_DOB      | "Date of Birth:"| 14 | - | - | - |
| 7    | 18  | Input/Output | GV_DOB       | -            | 10        | `ZEMS_T_EMPLOYEE-DOB` | Format: DATS (Calendar) | EDT |
| 2    | 49  | Box / Frame  | BOX_PHOTO    | "Photo Container" | 28 | - | Height: 7 lines | - |
| 3    | 51  | Custom Control| CTRL_PHOTO  | -            | 24        | - | BDS graphical container frame | - |
| 9    | 2   | Box / Frame  | BOX_JOB      | "Job & Financial Information" | 75 | - | - | - |
| 10   | 4   | Text / Label | TXT_DEP_ID   | "Department ID:"| 14 | - | - | - |
| 10   | 20  | Input/Output | GV_DEP_ID    | -            | 8         | `ZEMS_T_EMPLOYEE-DEP_ID` | Mandatory, F4: `ZEMS_SH_DEPT` | EDT |
| 11   | 4   | Text / Label | TXT_DESIG    | "Designation:" | 12 | - | - | - |
| 11   | 20  | Input/Output | GV_DESIGNATION| -           | 30        | `ZEMS_T_EMPLOYEE-DESIGNATION`| - | EDT |
| 12   | 4   | Text / Label | TXT_JOIN     | "Joining Date:"| 13 | - | - | - |
| 12   | 20  | Input/Output | GV_JOIN_DATE | -            | 10        | `ZEMS_T_EMPLOYEE-JOIN_DATE` | DATS | EDT |
| 13   | 4   | Text / Label | TXT_SAL      | "Salary:"      | 8  | - | - | - |
| 13   | 20  | Input/Output | GV_SALARY    | -            | 15        | `ZEMS_T_EMPLOYEE-SALARY` | Mandatory | EDT |
| 13   | 36  | Input/Output | GV_WAERS     | -            | 3         | `ZEMS_T_EMPLOYEE-WAERS` | Read-only, Default: 'INR' | EDT |
| 14   | 4   | Text / Label | TXT_STATUS   | "Status:"      | 8  | - | - | - |
| 14   | 20  | Dropdown List| GV_STATUS    | -            | 8         | `ZEMS_T_EMPLOYEE-STATUS` | Listbox, Values: A, I | EDT |
| 16   | 2   | Box / Frame  | BOX_CONTACT  | "Contact Details" | 75 | - | - | - |
| 17   | 4   | Text / Label | TXT_MOBILE   | "Mobile Number:"| 14 | - | - | - |
| 17   | 20  | Input/Output | GV_MOBILE    | -            | 15        | `ZEMS_T_EMPLOYEE-MOBILE` | - | EDT |
| 18   | 4   | Text / Label | TXT_EMAIL    | "Email Address:"| 14 | - | - | - |
| 18   | 20  | Input/Output | GV_EMAIL     | -            | 50        | `ZEMS_T_EMPLOYEE-EMAIL` | - | EDT |
| 19   | 4   | Text / Label | TXT_ADDR     | "Address:"     | 9  | - | - | - |
| 19   | 20  | Input/Output | GV_ADDRESS   | -            | 100       | `ZEMS_T_EMPLOYEE-ADDRESS` | - | EDT |
| 21   | 20  | Push Button  | BTN_SAVE     | "Save"       | 10        | - | FCode: `SAVE`, Icon: `@2L@` | - |
| 21   | 35  | Push Button  | BTN_CANCEL   | "Cancel"     | 10        | - | FCode: `CANCEL` | - |
