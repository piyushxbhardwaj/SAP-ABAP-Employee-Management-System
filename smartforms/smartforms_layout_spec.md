# SAP Smart Forms Layout Specifications

This document outlines the layout structure, window nodes, form interfaces, and style attributes for the three custom Smart Forms in the Employee Management System (EMS).

---

## 1. Form: `ZEMS_SF_PROFILE` (Employee Profile Form)

* **Description**: Detailed A4-sized comprehensive record of an employee.
* **Style**: `ZEMS_SF_STYLE` (Fonts: Arial 10pt/12pt Bold, Margins: 1cm)

### Form Interface (SE37 Signature)
* **Importing**:
  * `IS_EMPLOYEE` type `ZEMS_T_EMPLOYEE`
  * `IS_DEPT` type `ZEMS_T_DEPT`

### Form Layout Tree
```
Form ZEMS_SF_PROFILE
└── Global Definitions
    └── Global Data: GV_BARCODE_VAL type CHAR20
└── Pages and Windows
    └── PAGE1 (A4, Portrait, Next Page: PAGE1)
        ├── LOGO_WINDOW (Secondary Window, Top Left)
        │   └── Graphic Node: ZEMS_LOGO (Object: GRAPHICS, ID: BMAP, Btype: BCOL)
        ├── HEADER_WINDOW (Secondary Window, Top Right)
        │   ├── Text: "EMPLOYEE SYSTEM PROFILE" (Arial 16pt Bold)
        │   └── Text: "Date: &SY-DATUM& | Page &SFSY-PAGE& of &SFSY-FORMPAGES&"
        └── MAIN_WINDOW (Main Window, Center Page)
            ├── Template: TEMP_PERSONAL (2 columns, border enabled)
            │   ├── Cell 1_1: Text: "Employee ID:"
            │   ├── Cell 1_2: Text: "&IS_EMPLOYEE-EMP_ID&" (Character Format: BARC -> Code 128 Font)
            │   ├── Cell 2_1: Text: "Full Name:"
            │   ├── Cell 2_2: Text: "&IS_EMPLOYEE-FIRST_NAME& &IS_EMPLOYEE-LAST_NAME&"
            │   ├── Cell 3_1: Text: "Gender:"
            │   └── Cell 3_2: Text: "&IS_EMPLOYEE-GENDER&"
            ├── Spacer (10mm)
            ├── Template: TEMP_JOB (2 columns)
            │   ├── Cell 1_1: Text: "Department:"
            │   ├── Cell 1_2: Text: "&IS_DEPT-DEP_NAME& (Code: &IS_EMPLOYEE-DEP_ID&)"
            │   ├── Cell 2_1: Text: "Designation:"
            │   ├── Cell 2_2: Text: "&IS_EMPLOYEE-DESIGNATION&"
            │   ├── Cell 3_1: Text: "Joining Date:"
            │   ├── Cell 3_2: Text: "&IS_EMPLOYEE-JOIN_DATE&"
            │   ├── Cell 4_1: Text: "Base Salary:"
            │   └── Cell 4_2: Text: "&IS_EMPLOYEE-SALARY& &IS_EMPLOYEE-WAERS&"
            └── Text: "Residential Address: &IS_EMPLOYEE-ADDRESS&"
```

---

## 2. Form: `ZEMS_SF_IDCARD` (Employee ID Card Form)

* **Description**: Wallet-sized (85mm x 54mm) printable company ID Badge.
* **Style**: `ZEMS_SF_ID_STYLE`

### Form Interface
* **Importing**:
  * `IS_EMPLOYEE` type `ZEMS_T_EMPLOYEE`
  * `IV_DEPT_NAME` type `ZEMS_DE_DEPNAME`

### Form Layout Tree
```
Form ZEMS_SF_IDCARD
└── Pages and Windows
    └── ID_PAGE (85mm x 54mm Portrait)
        └── CARD_WINDOW (Main Window, Full Page border)
            ├── Text: "ANTIGRAVITY CORP" (Center, Arial 12pt Bold, Reverse video banner)
            ├── Spacer (2mm)
            ├── Graphic: PHOTO_FRAME (Placeholder boundary for BDS image reference)
            ├── Spacer (2mm)
            ├── Text: "&IS_EMPLOYEE-FIRST_NAME& &IS_EMPLOYEE-LAST_NAME&" (Center, 10pt Bold)
            ├── Text: "&IS_EMPLOYEE-DESIGNATION&" (Center, 8pt Italic)
            ├── Text: "ID: &IS_EMPLOYEE-EMP_ID&" (Center, 9pt Bold)
            ├── Text: "Dept: &IV_DEPT_NAME&" (Center, 8pt)
            ├── Spacer (3mm)
            └── Text: "&IS_EMPLOYEE-EMP_ID&" (Mapped to character format: QRCODE)
```

---

## 3. Form: `ZEMS_SF_SALSLIP` (Monthly Salary Slip Form)

* **Description**: Monthly earnings and deductions statements.
* **Style**: `ZEMS_SF_PAY_STYLE`

### Form Interface
* **Importing**:
  * `IS_EMPLOYEE` type `ZEMS_T_EMPLOYEE`
  * `IS_DEPT` type `ZEMS_T_DEPT`
  * `IV_MONTH` type `CHAR10`
  * `IV_YEAR` type `CHAR4`

### Form Layout Tree
```
Form ZEMS_SF_SALSLIP
└── Pages and Windows
    └── PAY_PAGE (A4 Landscape, Next Page: PAY_PAGE)
        ├── HEADER (Company details, Title: "SALARY STATEMENT FOR &IV_MONTH& &IV_YEAR&")
        ├── EMP_DETAILS_WINDOW (Metadata table: Name, Dept, Joining Date, Bank Acc, PF No)
        └── MAIN_WINDOW (Salary Calculations Grid)
            ├── Table: TAB_SALARY (2 Main Columns: Earnings vs Deductions)
            │   ├── Header Row:
            │   │   ├── Col 1: Text: "Earnings Description" | "Amount"
            │   │   └── Col 2: Text: "Deductions Description" | "Amount"
            │   ├── Table Line (Data loop - program lines calculate components):
            │   │   ├── Left (Earnings): Basic, HRA (40%), TA, Special Allowance
            │   │   └── Right (Deductions): Provident Fund (12%), Professional Tax, Income Tax
            │   └── Footer Row:
            │       ├── Text: "Total Earnings: &GV_TOT_EARN&"
            │       └── Text: "Total Deductions: &GV_TOT_DED&"
            ├── Spacer (10mm)
            ├── Text: "NET TAKE HOME PAY: &GV_NET_PAY& &IS_EMPLOYEE-WAERS&" (Arial 14pt Bold, double underline)
            ├── Text: "In Words: &GV_NET_PAY_WORDS& Only."
            └── Signatures: "Manager Signatory" | "Employee Signature"
```
