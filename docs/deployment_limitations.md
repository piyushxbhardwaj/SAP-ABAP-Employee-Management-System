# Deployment Limitations & Scope Boundaries

This document defines the scope boundaries and limitations for the Employee Management System (EMS) project. It distinguishes between the assets generated in this offline repository and the configurations that must be performed in a live SAP NetWeaver AS ABAP environment.

---

## 1. Offline Artifacts vs. Online Configurations

The repository is structured to maximize the amount of code and documentation that can be built offline. However, due to SAP's closed architecture, several elements cannot be compiled locally and require manual activation inside the SAP GUI.

| Component Group | Artifacts Generated Offline (Ready) | Tasks Requiring SAP GUI/NetWeaver (Online) |
|-----------------|--------------------------------------|---------------------------------------------|
| **Data Dictionary (DDIC)** | Transparent table definitions (`ZEMS_T_*`), custom data elements, domains, message class text tables. | Table activation, technical index creation, Table Maintenance TMG compiling (`SE54`). |
| **User Interface (Screens)** | PBO/PAI flow module codes, global variables bindings, field group configurations (`EDT`). | Graphical element placement (Screen Painter `SE51`), Menu Painter function key mapping (`SE41`). |
| **Logic & Programming** | Main Module Pool includes, local controller class implementations, ALV grids layout, mock seeder report. | Compilation, syntax check execution, T-Code registration (`SE93`). |
| **Printed Forms** | Structural window specifications, interface signatures, driver logic, OTF-PDF converter code. | Visual layout templates styling (`SMARTFORMS`), Company Logo BMP import (`SE78`). |
| **System Security & Roles** | Authority-Check code statements, role permission maps. | SU21 authorization field creation, PFCG role generation, profile compiling. |

---

## 2. Infrastructure & BASIS Prerequisites

Before this application can be fully executed, the host SAP NetWeaver AS ABAP environment must satisfy the following landscape requirements:

### 2.1 SMTP Network Routing (`SCOT`)
The Business Communication Services (`CL_BCS`) emailing logic executes within the ABAP processor. However, emails will remain stuck in the queue (`SOST`) unless:
* BASIS has configured transaction **`SCOT`** with a valid SMTP mail server.
* The standard mail send job `SUBMIT RSCONN01` is scheduled to run periodically in the background (`SM36`).

### 2.2 System Log Objects (`SLG1`)
The Application Logging logic calls `BAL_LOG_CREATE` passing log object `ZEMS_LOG` and subobject `CRUD`.
* These objects **must be registered** in transaction **`SU21`** or **`SLG0`** before execution, otherwise, the logger FMs will return validation errors and suppress log writes.

### 2.3 Developer Authorizations
To deploy and configure this application, the developer user account must be granted standard workbench authorizations, specifically:
* `S_DEVELOP` (Standard Developer authorization object covering package `ZEMS`).
* PFCG and SU21 administrative privileges.

---

## 3. Key Assumptions & Constraints

1. **SAP GUI Client**: Layout coordinates defined in `screens_specification.md` assume standard font configurations and display scaling in SAP GUI (Signature/Enjoy UI Theme).
2. **Buffering Latency**: The Department Master check table is set to fully buffered. If a department is added or modified via `SM30`, it may take a few minutes to reflect across app server nodes unless the buffer is manually synchronized (`/$TAB` command).
3. **No External Database Connection Required**: All tables reside within the standard SAP database schema. Open SQL statements execute directly against the standard database driver.
