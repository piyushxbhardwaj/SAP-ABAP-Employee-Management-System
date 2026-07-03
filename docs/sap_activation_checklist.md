# SAP Go-Live Activation Checklist (EMS)

This document is the official **Go-Live Activation Checklist** for importing and activating all Employee Management System (EMS) objects in a live SAP NetWeaver AS ABAP server environment. Follow the activation order strictly to prevent dependency errors during compile time.

---

## Phase 1: Package & DDIC Activation Order (`SE80` / `SE11`)

DDIC objects must be activated in a specific sequence due to primary key and check table dependencies. Activate objects in this order:

- [ ] **1. Create Package (`SE80` / `SE21`)**
  * Create package `ZEMS`. All subsequent objects must be assigned to this package.
- [ ] **2. Custom Domains (`SE11`)**
  * Define and activate domains: `ZEMS_D_EMPID`, `ZEMS_D_DEPID`, `ZEMS_D_GENDER`, `ZEMS_D_STATUS`, `ZEMS_D_AUDITID`, `ZEMS_D_LOGID`.
- [ ] **3. Custom Data Elements (`SE11`)**
  * Reference the domains created in Step 2. Create and activate data elements: `ZEMS_DE_EMPID`, `ZEMS_DE_DEPID`, `ZEMS_DE_DEPNAME`, `ZEMS_DE_FNAME`, `ZEMS_DE_LNAME`, `ZEMS_DE_GENDER`, `ZEMS_DE_DOB`, `ZEMS_DE_MOBILE`, `ZEMS_DE_EMAIL`, `ZEMS_DE_DESIG`, `ZEMS_DE_SALARY`, `ZEMS_DE_JOINDATE`, `ZEMS_DE_ADDRESS`, `ZEMS_DE_STATUS`, `ZEMS_DE_LOCATION`, `ZEMS_DE_AUDITID`, `ZEMS_DE_LOGID`, `ZEMS_DE_ACTION`.
- [ ] **4. Check Table `ZEMS_T_DEPT` (`SE11`)**
  * Create table structure `ZEMS_T_DEPT`. Maintain locations and manager ID fields. Activate.
- [ ] **5. Master Table `ZEMS_T_EMPLOYEE` (`SE11`)**
  * Create table structure `ZEMS_T_EMPLOYEE`. Create foreign key link for field `DEP_ID` checking table `ZEMS_T_DEPT-DEP_ID`. Activate.
- [ ] **6. Transactional Table `ZEMS_T_AUDIT` (`SE11`)**
  * Create table `ZEMS_T_AUDIT`. Create foreign key check on field `EMP_ID` checking table `ZEMS_T_EMPLOYEE-EMP_ID`. Activate.
- [ ] **7. Lock Objects (`SE11`)**
  * Create lock objects `EZEMS_EMPLOYEE` (Table: `ZEMS_T_EMPLOYEE`) and `EZEMS_DEPT` (Table: `ZEMS_T_DEPT`). Lock Mode: **Exclusive lock (Write Lock / E)**. Activate to generate FMs.
- [ ] **8. Search Helps (`SE11`)**
  * Create elementary search help objects `ZEMS_SH_DEPT` (Selection Method: `ZEMS_T_DEPT`) and `ZEMS_SH_EMP` (Selection Method: `ZEMS_T_EMPLOYEE`). Create Search Help Exit function module `ZEMS_SH_EXIT_DEPT` (if filtering is enabled).
- [ ] **9. Maintenance View `ZEMS_V_DEPT` (`SE11`)**
  * Create Maintenance View referencing table `ZEMS_T_DEPT` as base.
- [ ] **10. Table Maintenance Generator (`SE11` / `SE54`)**
  * Generate TMG for Maintenance View `ZEMS_V_DEPT` (Type: One-step, screen number `0001`, function group `ZEMS_FG_DEPT`).

---

## Phase 2: Message Class & System Settings

- [ ] **1. Custom Message Class (`SE91`)**
  * Create message class `ZEMS_MSG` and map message IDs `000` through `023`.
- [ ] **2. Number Range Object Configuration (`SNRO`)**
  * Register number range object `ZEMS_NR_EP` (domain `ZEMS_D_EMPID`, interval `01` bounds `00000001` to `99999999`).
  * Register number range object `ZEMS_NR_AD` (domain `ZEMS_D_AUDITID`, interval `01` bounds `0000000001` to `9999999999`).

---

## Phase 3: Screen & Menu Painters (`SE80` / `SE51` / `SE41`)

- [ ] **1. Main Dialog Includes (`SE80`)**
  * Create Dialog program shell `ZEMS_EMPLOYEE_CRUD`. Integrate includes: `zems_employee_top`, `zems_employee_lcl`, `zems_employee_o01`, `zems_employee_i01`.
- [ ] **2. Screen Painter layouts (`SE51`)**
  * Create Screen `100` and Screen `200` properties, element lists (map fields to top include variables), and write dynpro PBO/PAI flow code.
- [ ] **3. Menu Painter layouts (`SE41`)**
  * Map GUI Status definitions: `STATUS_100` (Execute key), `STATUS_200` (Save key, Cancel key), and `STATUS_ALV` for Screen `9000`.
- [ ] **4. Report Program `ZEMS_REPORTS` (`SE38`)**
  * Create program `ZEMS_REPORTS`. Add selection screen variables. Create Screen `9000` (ALV wrapper screen). Copy-paste report code and compile.
- [ ] **5. Transaction Codes (`SE93`)**
  * Create T-Code `ZEMS_CRUD` (references Program `ZEMS_EMPLOYEE_CRUD` and Screen `100`).
  * Create T-Code `ZEMS_REP` (references Program `ZEMS_REPORTS`).

---

## Phase 4: Output Design & Security (`SMARTFORMS` / `PFCG`)

- [ ] **1. Smart Forms layouts Designer (`SMARTFORMS`)**
  * Define and activate layouts `ZEMS_SF_PROFILE` and `ZEMS_SF_SALSLIP` according to graphic templates.
  * Import Company Logo BMP graphic under object name `ZEMS_LOGO` using transaction `SE78`.
- [ ] **2. Smart Forms Driver (`SE38`)**
  * Create and compile `ZEMS_SMARTFORMS_DRIVER` including BCS classes (`CL_BCS`).
- [ ] **3. Authorizations Object & Roles (`SU21` / `PFCG`)**
  * SU21: Create custom authorization object `Z_EMS_AUTH` with fields `ACTVT` and `DEP_ID`.
  * PFCG: Create roles `ZEMS_ADMIN` and `ZEMS_VIEWER` and generate profiles.

---

## Phase 5: Post-Go-Live Runtime Validations

- [ ] **1. Table Maintenance Validation (`SM30`)**
  * Open transaction `SM30` for view `ZEMS_V_DEPT` and confirm CRUD operations work for departments.
- [ ] **2. Test Data Seeding (`SE38`)**
  * Execute program `ZEMS_MOCK_DATA` to populate the master records.
- [ ] **3. Runtime Errors Check (`ST22`)**
  * Monitor `ST22` for short dumps during data saves or ALV reports drilldown.
- [ ] **4. Security Checks Verification (`SU53` / `SU01`)**
  * Assign `ZEMS_VIEWER` role to a test user and attempt to edit an employee. Check transaction `/nSU53` to verify authorization checks block the update and flag activity `02` for `Z_EMS_AUTH`.
- [ ] **5. Application Logs Verification (`SLG1`)**
  * Run searches on object `ZEMS_LOG` in transaction `SLG1` to verify validations and logs are saved.
- [ ] **6. Email Spool Queue Verification (`SOST` / `SCOT`)**
  * After executing "Email Slip" in the reports toolbar, check transaction `SOST` to verify the generated PDF salary slip is pending transmission in the email spool queue.
