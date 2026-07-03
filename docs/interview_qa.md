# Developer Interview Preparation: SAP ABAP Employee Management System (EMS)

This guide contains the top 20 technical interview questions and detailed answers based on the architecture, DDIC objects, and code structure of this Employee Management System (EMS) project.

---

## 1. SAP Data Dictionary (DDIC) Questions

### Q1: What is the difference between a Domain and a Data Element?
* **Answer**: A **Domain** defines the technical characteristics of a table field, such as data type (e.g., `CHAR`, `NUMC`), field length, decimal places, and value range constraints (fixed values). A **Data Element** defines the semantic description of the field, providing field labels (Short, Medium, Long, Heading) and documentation texts. Multiple data elements can reference the same domain.

### Q2: Why did you use Buffering for the Department Master Table (`ZEMS_T_DEPT`)?
* **Answer**: Buffering table data in the application server's main memory significantly improves performance by reducing database hits. Since the Department Master is a small table (~10-50 rows) that is frequently queried for validations and search help options but updated very rarely, it is a prime candidate for **Full Buffering** (loading the entire table into server cache on the first read).

### Q3: What is a Lock Object, and how did you implement concurrency checks in this project?
* **Answer**: A **Lock Object** (`SE11` prefix `E`) prevents multiple users from editing the same database record simultaneously. In this project, I created the lock object `EZEMS_EMPLOYEE` on `ZEMS_T_EMPLOYEE`. When activated, SAP automatically generates two function modules:
  * `ENQUEUE_EZEMS_EMPLOYEE`: Called during PAI before loading Screen 200 in Edit Mode. It locks the employee ID. If the record is already locked, it raises the exception `FOREIGN_LOCK` and retrieves the locking username from `SY-MSGV1`.
  * `DEQUEUE_EZEMS_EMPLOYEE`: Called in PAI after saving the record or exiting Screen 200 to release the lock.

### Q4: Why did you use Table Maintenance Generator (TMG) for the Department Master?
* **Answer**: For master data tables like departments where custom, complex business logic is not required for creation, creating a CRUD UI from scratch is a waste of development time. Standard practice is to generate a Maintenance View (`ZEMS_V_DEPT`) and attach a TMG to it. This allows business admins to securely maintain department lists using standard transaction **`SM30`** (using generated dynpro modules) with built-in logging and transport requests integrations.

### Q5: What is a Search Help Exit, and why did you use it?
* **Answer**: A **Search Help Exit** is a custom function module associated with an elementary search help in `SE11`. It allows developers to intercept the standard F4 search cycle (e.g. before data selection `SELECT` step or before record display `DISP` step) to alter search parameters dynamically. I specified `ZEMS_SH_EXIT_DEPT` to filter out records based on location attributes or active status before display, showcasing standard SAP values manipulation.

---

## 2. Dialog Programming (Module Pool) Questions

### Q6: What is the difference between PBO (Process Before Output) and PAI (Process After Input)?
* **Answer**:
  * **PBO**: Triggers before the screen is displayed to the user. It is used to set GUI statuses (menus, toolbars), dynamic titlebars, and modify screen fields dynamically (e.g., hiding or locking fields).
  * **PAI**: Triggers after the user performs an action (e.g., button click, menu selection). It is used to capture input variables, validate fields, perform database operations, and control screen flow navigation.

### Q7: How did you implement dynamic field read-only controls in Screen 200?
* **Answer**: In the PBO module `status_0200`, I looped through the system screen table elements (`LOOP AT SCREEN`). I assigned the edit group attribute `Group1 = 'EDT'` to all input fields in Screen Painter. If the operation mode variable `gv_action_mode` equals display mode `gc_mode_display` ('V'), I set `screen-input = 0` (making the field read-only) and modified the element properties using `MODIFY SCREEN`.

### Q8: How did you calculate and display real-time KPI metrics on Screen 100?
* **Answer**: During the PBO cycle of Screen 100, the program calls the controller method `go_controller->calculate_kpis( )`. This method runs optimized SQL aggregate functions (`COUNT(*)`, `AVG(salary)`) directly on table `ZEMS_T_EMPLOYEE` and stores the values in global variables bound to output-only screen elements.

---

## 3. Object-Oriented ALV Grid Questions

### Q9: Why did you choose OO ALV (`CL_GUI_ALV_GRID`) over standard function module `REUSE_ALV_GRID_DISPLAY`?
* **Answer**: Standard procedural ALV functions are outdated and do not conform to modern ABAP OO standards. The class `CL_GUI_ALV_GRID` offers extensive layout configuration control, object-oriented event handling (e.g., catching double-clicks, custom toolbar additions), and easily fits inside custom screen containers (like `cl_gui_container=>screen0` or custom control regions).

### Q10: How did you color rows in the ALV report based on employee status?
* **Answer**:
  1. I added a 4-character field named `ROW_COLOR` to the report output structure.
  2. During data selection, I looped through records. If `status` was 'A' (Active), I set `row_color = 'C500'` (soft green). If 'I' (Inactive), I set `row_color = 'C100'` (soft red).
  3. In the ALV layout configuration structure (`lvc_s_layo`), I mapped `gs_layout-info_fname = 'ROW_COLOR'`. The ALV engine automatically reads this field to color matching rows during grid rendering.

### Q11: How did you handle drilldown navigation (hotspots) in the ALV?
* **Answer**: In the field catalog of the ALV grid, I set the `hotspot = 'X'` attribute for field `EMP_ID`. I created a local event handler class and registered a listener method for the event `double_click` of `CL_GUI_ALV_GRID`. When double-clicked, the method catches the clicked row index, sets SPA/GPA parameters (`SET PARAMETER ID 'ZEMS_EMP' FIELD ls_row-emp_id`), and calls transaction `ZEMS_CRUD` bypassing the initial input screen using `CALL TRANSACTION ... AND SKIP FIRST SCREEN`.

---

## 4. Smart Forms, BCS Emailing & Logger Questions

### Q12: How does a driver program call a Smart Form dynamically?
* **Answer**: In SAP, a Smart Form compiles into a dynamically named function module (e.g. `/1BCDWB/SF00000101`). Hardcoding this name is prohibited as it changes across DEV, QA, and PROD landscapes. I used function module `SSF_FUNCTION_MODULE_NAME` passing the form name `ZEMS_SF_PROFILE` to retrieve the active runtime FM name, then called that FM dynamically.

### Q13: How did you convert the Smart Form to a PDF attachment and send it via email?
* **Answer**:
  1. I set control parameter `ls_ctrl_param-getotf = 'X'` to return raw OTF spool data from the Smart Form call.
  2. I called function module `CONVERT_OTF` with format `'PDF'` to convert the OTF spool to a binary `xstring` stream.
  3. I used standard BCS classes:
     * `CL_BCS` to initialize a send request.
     * `CL_DOCUMENT_BCS` to create the email body text and attach the PDF binary table (converted from `xstring` using `cl_bcs_convert=>xstring_to_solix`).
     * `CL_SAPUSER_BCS` & `CL_CAM_ADDRESS_BCS` to map sender and recipient email addresses.
     * Called method `send( )` and committed.

### Q14: How did you implement standard SAP Application Logging (`SLG1`)?
* **Answer**: Instead of basic message popups, enterprise applications write exception logs to standard SAP Application Log databases using the `BAL_*` API. In my local controller class, I implemented the `write_app_log` method which calls `BAL_LOG_CREATE` to initialize a log context (assigned to object `ZEMS_LOG` and subobject `CRUD`), `BAL_LOG_MSG_ADD` to write warnings/errors, and `BAL_DB_SAVE` to persist the buffers. These logs can be searched by date, user, or object code in transaction **`SLG1`**.

---

## 5. Coding Standards, Security & Best Practices

### Q15: How did you implement Role-Based Access Controls (RBAC)?
* **Answer**: I defined a custom Authorization Object `Z_EMS_AUTH` in `SU21` containing fields `ACTVT` (Activity) and `DEP_ID` (Department). Inside the ABAP controllers, before executing `SAVE` (Create/Update) or `DELETE` methods, I call standard **`AUTHORITY-CHECK`** statements mapping the transaction actions and target department. This prevents users assigned to the display-only role `ZEMS_VIEWER` (who only have display activity `03` authorizations) from modifying database records.

### Q16: How did you generate Employee IDs automatically?
* **Answer**: Hardcoding an incrementing select (`MAX(emp_id) + 1`) is a major anti-pattern in SAP as it leads to duplicate keys under concurrent hirings. Instead, I created a standard Number Range object `ZEMS_NR_EP` in transaction `SNRO` and used standard function module **`NUMBER_GET_NEXT`** to obtain thread-safe sequential employee keys.
