# Technical Specification: Employee Management System (EMS)

## 1. DDIC Tables & Fields Architecture
This project is assigned to transport requests under package **`ZEMS`**. The custom database design consists of:
* **`ZEMS_T_EMPLOYEE`**: Employee Master Data.
* **`ZEMS_T_DEPT`**: Department Master Data (Fully buffered check table).
* **`ZEMS_T_AUDIT`**: Change log tracker for employee actions.
* **`ZEMS_V_DEPT`**: Maintenance View enabling SM30 configurations.

---

## 2. Dialog Programming (Module Pool)
* **Program Name**: `ZEMS_EMPLOYEE_CRUD`
* **Transaction Code**: `ZEMS_CRUD`
* **Screens**:
  * **Screen 100**: Coordinates search inputs, execution controls, and display variables for statistics. Calculates total, active, inactive, and average salary using aggregate Open SQL selects:
    ```abap
    SELECT COUNT(*), AVG( salary ) FROM zems_t_employee INTO (gv_kpi_total, gv_kpi_avg_salary).
    ```
  * **Screen 200**: Coordinates detail fields grouped under screen group `EDT`. PBO module loops through screen attributes to enforce field locks (input = 0) based on modes:
    * `gc_mode_display`: Locks all input fields.
    * `gc_mode_edit`: Locks only primary key `GV_EMP_ID`.
    * `gc_mode_create`: Locks primary key field as it is auto-populated via number range.

---

## 3. Local Class Controller (`LCL_EMPLOYEE_CONTROLLER`)
All transactional logic, validations, locks, and logs are encapsulated within local class `lcl_employee_controller` inside include `zems_employee_lcl`.

### Key Methods & Interfaces

#### A. Number Range API (`NUMBER_GET_NEXT`)
Retrieves sequence numbers dynamically using standard range intervals:
* **Object Name**: `ZEMS_NR_EP` (Employee ID interval 00000001 - 99999999)
* **Object Name**: `ZEMS_NR_AD` (Audit sequence ID)
```abap
CALL FUNCTION 'NUMBER_GET_NEXT'
  EXPORTING
    nr_range_nr = '01'
    object      = 'ZEMS_NR_EP'
  IMPORTING
    number      = lv_number.
```

#### B. Concurrent Record Locks (Enqueue/Dequeue)
Prevents double-maintenance of records by acquiring exclusive write locks:
* Enqueue: Call FM `ENQUEUE_EZEMS_EMPLOYEE` on PAI execution logic in Edit mode.
* Dequeue: Call FM `DEQUEUE_EZEMS_EMPLOYEE` on Screen exit/save completion.

#### C. Role-Based Authorization Checks (`Z_EMS_AUTH`)
Enforces field authorizations by matching user activities (`ACTVT`) and department scopes (`DEP_ID`):
* Admin permissions (ACTVT: `01` - Create, `02` - Update, `06` - Delete).
* Viewer permissions (ACTVT: `03` - Display).
```abap
AUTHORITY-CHECK OBJECT 'Z_EMS_AUTH'
  ID 'ACTVT'  FIELD iv_actvt
  ID 'DEP_ID' FIELD iv_dep_id.
```

#### D. Standard Application Logging (BAL / SLG1)
Writes exceptions and runtime anomalies to the system log database instead of simple messaging:
* **Log Object**: `ZEMS_LOG`, **Subobject**: `CRUD`
* Calls FMs:
  1. `BAL_LOG_CREATE` (Instantiate log context)
  2. `BAL_LOG_MSG_ADD` (Write message structure to buffer)
  3. `BAL_DB_SAVE` (Persist buffers to tables `BALHDR`/`BALDAT`)
* Log viewer: Transaction `SLG1`.

---

## 4. Smart Forms & BCS Emailing API
Driver program `ZEMS_SMARTFORMS_DRIVER` (T-Code: `ZEMS_SF`) fetches record structures and maps spool generations.

### OTF to PDF Conversion
Fetches OTF (Output Text Format) lines from the Smart Form call output buffer and converts them into binary format:
```abap
CALL FUNCTION 'CONVERT_OTF'
  EXPORTING
    format    = 'PDF'
  IMPORTING
    bin_file  = lv_pdf_xstring
  TABLES
    otf       = lt_otf_data
    lines     = lt_pdf_tab.
```

### BCS Transmission (`CL_BCS`)
Encapsulates emailing attachments:
1. Create send request: `lo_send_request = cl_bcs=>create_persistent( )`.
2. Attach PDF content: convert xstring to solix table via `cl_bcs_convert=>xstring_to_solix( lv_pdf_xstring )` and call `lo_document->add_attachment( )`.
3. Add sender/recipient mapping: `cl_sapuser_bcs=>create( sy-uname )` and `cl_cam_address_bcs=>create_internet_address( iv_recipient )`.
4. Trigger sending: `lo_send_request->send( )`.

---

## 5. Performance Optimization Guidelines

* **Avoid `SELECT *`**: Explicitly query required fields into structured tables.
* **Join optimization**: Fetch employee details and department names using a single `LEFT OUTER JOIN` statement instead of selecting employees and querying department text inside a loop.
* **Internal Table Processing**: Use `ASSIGNING FIELD-SYMBOL(<fs_out>)` in table loops instead of copying rows into work areas (`INTO gs_out`) to bypass memory overhead during updates.
* **Master Table Buffering**: Table `ZEMS_T_DEPT` is set to "Fully Buffered" since it is read frequently in search help and validation logic but modified rarely.
