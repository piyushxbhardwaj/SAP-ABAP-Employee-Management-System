# Screen Specifications: ZEMS_EMPLOYEE_CRUD

This document specifies the layout, controls, attributes, and flow logic for screens painter (`SE51`) in the Employee Management System Dialog application.

---

## Screen 100: Dashboard & Search Panel

* **Screen Type**: Normal
* **Next Screen**: 100
* **Title Bar**: `TITLE_100` ("Employee Management System - Dashboard")
* **Status**: `STATUS_100` (Back/Exit/Cancel enabled)

### Screen Flow Logic

```abap
PROCESS BEFORE OUTPUT.
  MODULE status_0100.

PROCESS AFTER INPUT.
  MODULE user_command_0100.
```

### Visual Layout Architecture

```
+----------------------------------------------------------------------------------+
| Employee Management System - Dashboard                                            |
+----------------------------------------------------------------------------------+
|  [KPI Dashboard Summary]                                                         |
|  +----------------------------------------------------------------------------+  |
|  | Total Employees: [ 142 ]          Active Employees:   [ 135 ]              |  |
|  | Inactive Employees: [   7 ]          Average Salary:     [ 85,250.00 INR ]    |  |
|  +----------------------------------------------------------------------------+  |
|                                                                                  |
|  [Search Criteria]                                                               |
|  +----------------------------------------------------------------------------+  |
|  | Employee ID: [ 00000105 ] (F4 enabled - ZEMS_SH_EMP)                        |  |
|  | Department:  [ HR01     ] (F4 enabled - ZEMS_SH_DEPT)                       |  |
|  +----------------------------------------------------------------------------+  |
|                                                                                  |
|  [Operations Control]                                                            |
|  +----------------------------------------------------------------------------+  |
|  | ( ) Create Employee   (*) Edit Employee   ( ) Display Employee  ( ) Delete  |  |
|  +----------------------------------------------------------------------------+  |
|                                                                                  |
|                       [  Execute  ]   [  Clear Selection  ]                      |
+----------------------------------------------------------------------------------+
```

### Screen Elements Catalog

| Element Name | Type | Description | Technical Properties | Screen Group |
|--------------|------|-------------|----------------------|--------------|
| `GV_KPI_TOTAL` | Input/Output | Display total count | Type: `INT4`, Read-Only | KPI |
| `GV_KPI_ACTIVE` | Input/Output | Display active count | Type: `INT4`, Read-Only | KPI |
| `GV_KPI_INACTIVE`| Input/Output | Display inactive count | Type: `INT4`, Read-Only | KPI |
| `GV_KPI_AVG_SAL` | Input/Output | Display avg salary | Type: `CURR`, Read-Only | KPI |
| `GV_SEARCH_EMP` | Input/Output | Emp ID filter | Data Element: `ZEMS_DE_EMPID`, Search Help: `ZEMS_SH_EMP` | SCH |
| `GV_SEARCH_DEPT`| Input/Output | Dept ID filter | Data Element: `ZEMS_DE_DEPID`, Search Help: `ZEMS_SH_DEPT` | SCH |
| `GV_ACTION_MODE`| Radio Button | Select operation | Radiogroup: `MOD`, Codes: 'C', 'E', 'V', 'D' | MOD |

---

## Screen 200: Employee CRUD Form

* **Screen Type**: Normal
* **Next Screen**: 100
* **Title Bar**: `TITLE_200` (Dynamic title)
* **Status**: `STATUS_200` (Save/Back/Cancel enabled)

### Screen Flow Logic

```abap
PROCESS BEFORE OUTPUT.
  MODULE status_0200.

PROCESS AFTER INPUT.
  FIELD gv_dept_id MODULE val_dept ON INPUT.
  MODULE user_command_0200.
```

### Visual Layout Architecture

```
+----------------------------------------------------------------------------------+
| Create/Edit/Display Employee                                                     |
+----------------------------------------------------------------------------------+
|  +-----------------------------+   +------------------------------------------+  |
|  | Employee ID: [ 00000105 ]   |   | [ Photo Container ]                      |  |
|  | First Name:  [ Piyush    ]   |   |                                          |  |
|  | Last Name:   [ Bhardwaj  ]   |   |                                          |  |
|  | Gender:      [ Male    v ]   |   | Image Source: BDS / Database             |  |
|  | Date of Birth: [15.08.1998]  |   |                                          |  |
|  +-----------------------------+   +------------------------------------------+  |
|                                                                                  |
|  [Job & Financial Information]                                                   |
|  +----------------------------------------------------------------------------+  |
|  | Department ID: [ HR01     ] (F4 Search Help)                                |  |
|  | Designation:   [ Developer]                                                 |  |
|  | Joining Date:  [01.07.2023]                                                 |  |
|  | Salary:        [ 95000.00 ]   Currency: [ INR ]                             |  |
|  | Status:        [ Active v ]                                                 |  |
|  +----------------------------------------------------------------------------+  |
|                                                                                  |
|  [Contact Details]                                                               |
|  +----------------------------------------------------------------------------+  |
|  | Mobile Number: [ +919876543210 ]                                            |  |
|  | Email Address: [ piyush@example.com           ]                             |  |
|  | Address:       [ 123 SAP Lane, Bangalore, India                           ] |  |
|  +----------------------------------------------------------------------------+  |
|                                                                                  |
|                        [  Save  ]        [  Cancel  ]                            |
+----------------------------------------------------------------------------------+
```

### Screen Elements Catalog

| Element Name | Type | Description | Technical Properties | Screen Group |
|--------------|------|-------------|----------------------|--------------|
| `GV_EMP_ID` | Input/Output | Employee ID key | Data Element: `ZEMS_DE_EMPID`, Read-only in Create/Edit | EDT |
| `GV_FIRST_NAME` | Input/Output | First Name | Data Element: `ZEMS_DE_FNAME`, Required field | EDT |
| `GV_LAST_NAME` | Input/Output | Last Name | Data Element: `ZEMS_DE_LNAME`, Required field | EDT |
| `GV_GENDER` | Dropdown | Employee Gender | Dropdown, Type: `CHAR1`, Values: M, F, O | EDT |
| `GV_DOB` | Input/Output | Date of Birth | DATS, Date picker control | EDT |
| `GV_DEPT_ID` | Input/Output | Dept ID reference | Data Element: `ZEMS_DE_DEPID`, Search Help: `ZEMS_SH_DEPT` | EDT |
| `GV_DESIGNATION`| Input/Output | Job Title | Data Element: `ZEMS_DE_DESIG` | EDT |
| `GV_JOIN_DATE` | Input/Output | Date of Joining | DATS, Date picker control | EDT |
| `GV_SALARY` | Input/Output | Salary | Data Element: `ZEMS_DE_SALARY`, Format: Currency | EDT |
| `GV_WAERS` | Input/Output | Currency Key | Data Element: `WAERS`, Read-only | EDT |
| `GV_STATUS` | Dropdown | Active Status | Dropdown, Type: `CHAR1`, Values: A, I | EDT |
| `GV_MOBILE` | Input/Output | Mobile phone | Data Element: `ZEMS_DE_MOBILE` | EDT |
| `GV_EMAIL` | Input/Output | Email address | Data Element: `ZEMS_DE_EMAIL` | EDT |
| `GV_ADDRESS` | Input/Output | Home Address | Data Element: `ZEMS_DE_ADDRESS` | EDT |
