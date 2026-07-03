# User Manual: Employee Management System (EMS)

Welcome to the Employee Management System (EMS) user manual. This application provides HR personnel and managers with interfaces to maintain employee records, monitor department statistics, and distribute monthly pay slips.

---

## 1. System Entry & Dashboard Navigation

### 1.1 Entering the System
1. Log in to the SAP GUI.
2. Enter Transaction Code **`/nZEMS_CRUD`** in the command field.
3. You will be presented with the **Screen 100 Dashboard Panel**.

### 1.2 Understanding the Dashboard Layout
* **KPI Header Tiles**: Displays counters for Total Employees, Active Employees, Inactive Employees, and the current Average Base Salary across the company.
* **Search Filters**: Enter an Employee ID or select a Department ID (using F4 search helps) to filter your lookup focus.
* **Operation Controls (Radio Buttons)**: Select the action mode you wish to perform (Create, Edit, Display, or Delete).
* **Execute Button**: Processes your selected search filter and action mode.

---

## 2. Managing Employee Records (CRUD Operations)

### 2.1 Hiring an Employee (Create Record)
1. On the Screen 100 Dashboard, select the **Create Employee** radio button.
2. Click **Execute**. You will route to Screen 200 (Form).
3. Fill in all mandatory fields:
   * First Name, Last Name
   * Gender (Select from dropdown)
   * Date of Birth (Must be age 18 or older)
   * Joining Date (Cannot be a future date)
   * Department ID (Use F4 list to select)
   * Designation (Title)
   * Salary (Must be positive)
4. Click **Save**. The system auto-generates a new Employee ID, saves the record, writes an audit trail log, and returns to the dashboard with a success message.

### 2.2 Updating Employee Profiles (Edit Record)
1. In Screen 100, enter the target **Employee ID** in the search field.
2. Select the **Edit Employee** radio button and click **Execute**.
3. The fields on Screen 200 will be editable. (Note: The Employee ID key is locked and cannot be changed).
4. Update details (e.g. Change department, status, mobile, address, etc.) and click **Save**.

### 2.3 Terminating/Deleting Records
1. Enter the target Employee ID in the search field on Screen 100.
2. Select **Delete Employee** and click **Execute**.
3. The system will prompt a confirmation popup: **"Are you sure you want to delete this employee?"**
4. Click **Yes**. The record is locked, deleted from active storage, and logged as `DELETE` in the audit table.

---

## 3. Reporting Dashboard (ALV Reports)

To run analytical reports, enter Transaction Code **`/nZEMS_REP`**:
1. Fill in selection criteria: Employee ID range, Department range, Joining Date range, or Salary range filters.
2. Select one of the five report formats:
   * *Employee List* (Full master roster)
   * *Department Count* (Headcount summary grouped by location)
   * *Salary Report* (High earners filter)
   * *Active Employees* (Excludes resigned/inactive staff)
   * *Recent Hires* (Joined between specific date ranges)
3. Click **Execute (F8)**. The dynamic OO ALV Grid will display.

### ALV Grid Interactive Features
* **Zebra Stripes & Color Codes**: Active employees are highlighted in soft green, inactive employees in soft red.
* **Totals Line**: Displays the sum total of employee salaries at the bottom of the grid.
* **Excel Export**: Click the standard **Export to Spreadsheet** icon in the toolbar to download the grid data directly to MS Excel.
* **Double-click Hotspot**: Double-click on any Employee ID cell to instantly jump to the CRUD details screen.

---

## 4. Pay Slip Distribution & Profiles

On the ALV Report Grid, select an employee line and choose one of the custom toolbar buttons:
1. **Print Profile**: Launches standard spool dialogs to print or generate a print preview of the employee profile A4 sheet with barcode details.
2. **Email Slip**: Automatically calls the Salary Slip Smart Form, converts the OTF stream to a PDF, attaches it to an email container, and routes it directly to the employee's corporate email address using Business Communication Services (BCS).
