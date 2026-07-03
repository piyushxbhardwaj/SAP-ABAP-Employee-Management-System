*======================================================================*
* PROJECT: Employee Management System (EMS)
* COMPONENT: SAP Dictionary (DDIC) - Domains & Data Elements
* PACKAGE: ZEMS
* DESCRIPTION: Definition of custom domains and data elements for EMS.
*              This file contains metadata and properties to replicate in SE11.
*======================================================================*

*----------------------------------------------------------------------*
* DOMAINS
*----------------------------------------------------------------------*

* 1. ZEMS_D_EMPID
* Description: Employee Identification Number
* Data Type:   NUMC (Numeric Character)
* Length:      8
* Decimals:    0
* Convers. Exit: None
* Value Range: None (Generated via Number Range ZEMS_NR_EP)

* 2. ZEMS_D_DEPID
* Description: Department Identification Code
* Data Type:   CHAR (Character)
* Length:      8
* Decimals:    0
* Value Range: None

* 3. ZEMS_D_GENDER
* Description: Employee Gender
* Data Type:   CHAR (Character)
* Length:      1
* Decimals:    0
* Value Range (Fixed Values):
*   'M' - Male
*   'F' - Female
*   'O' - Other

* 4. ZEMS_D_STATUS
* Description: Employee Employment Status
* Data Type:   CHAR (Character)
* Length:      1
* Decimals:    0
* Value Range (Fixed Values):
*   'A' - Active
*   'I' - Inactive

* 5. ZEMS_D_AUDITID
* Description: Audit Log Sequence ID
* Data Type:   NUMC (Numeric Character)
* Length:      10
* Decimals:    0

* 6. ZEMS_D_LOGID
* Description: Error/Exception Log Sequence ID
* Data Type:   NUMC (Numeric Character)
* Length:      10
* Decimals:    0


*----------------------------------------------------------------------*
* DATA ELEMENTS (SE11)
*----------------------------------------------------------------------*

* 1. ZEMS_DE_EMPID
* Domain:      ZEMS_D_EMPID
* Description: Employee ID
* Field Labels:
*   Short:     Emp ID
*   Medium:    Employee ID
*   Long:      Employee ID
*   Heading:   Employee ID

* 2. ZEMS_DE_DEPID
* Domain:      ZEMS_D_DEPID
* Description: Department ID
* Field Labels:
*   Short:     Dept ID
*   Medium:    Department ID
*   Long:      Department ID
*   Heading:   Department ID

* 3. ZEMS_DE_DEPNAME
* Domain:      CHAR30 (Standard Domain)
* Description: Department Name
* Field Labels:
*   Short:     Dept Name
*   Medium:    Department Name
*   Long:      Department Name
*   Heading:   Department Name

* 4. ZEMS_DE_FNAME
* Domain:      CHAR30 (Standard Domain)
* Description: First Name
* Field Labels:
*   Short:     First Name
*   Medium:    First Name
*   Long:      First Name
*   Heading:   First Name

* 5. ZEMS_DE_LNAME
* Domain:      CHAR30 (Standard Domain)
* Description: Last Name
* Field Labels:
*   Short:     Last Name
*   Medium:    Last Name
*   Long:      Last Name
*   Heading:   Last Name

* 6. ZEMS_DE_GENDER
* Domain:      ZEMS_D_GENDER
* Description: Gender
* Field Labels:
*   Short:     Gender
*   Medium:    Gender
*   Long:      Gender
*   Heading:   Gender

* 7. ZEMS_DE_DOB
* Domain:      DATS (Standard Date Domain)
* Description: Date of Birth
* Field Labels:
*   Short:     DOB
*   Medium:    Date of Birth
*   Long:      Date of Birth
*   Heading:   Date of Birth

* 8. ZEMS_DE_MOBILE
* Domain:      CHAR15 (Standard Domain)
* Description: Mobile Number
* Field Labels:
*   Short:     Mobile
*   Medium:    Mobile Number
*   Long:      Mobile Number
*   Heading:   Mobile Number

* 9. ZEMS_DE_EMAIL
* Domain:      CHAR50 (Standard Domain)
* Description: Email Address
* Field Labels:
*   Short:     Email
*   Medium:    Email Address
*   Long:      Email Address
*   Heading:   Email Address

* 10. ZEMS_DE_DESIG
* Domain:      CHAR30 (Standard Domain)
* Description: Designation
* Field Labels:
*   Short:     Desig
*   Medium:    Designation
*   Long:      Designation
*   Heading:   Designation

* 11. ZEMS_DE_SALARY
* Domain:      WERTV8 (Standard Value Domain: DEC 15, Decimals 2)
* Data Type:   CURR
* Description: Employee Salary
* Ref Table:   ZEMS_T_EMPLOYEE
* Ref Field:   WAERS
* Field Labels:
*   Short:     Salary
*   Medium:    Salary
*   Long:      Employee Salary
*   Heading:   Salary

* 12. ZEMS_DE_JOINDATE
* Domain:      DATS (Standard Date Domain)
* Description: Joining Date
* Field Labels:
*   Short:     Join Date
*   Medium:    Joining Date
*   Long:      Joining Date
*   Heading:   Joining Date

* 13. ZEMS_DE_ADDRESS
* Domain:      CHAR100 (Standard Domain)
* Description: Address
* Field Labels:
*   Short:     Address
*   Medium:    Address
*   Long:      Address
*   Heading:   Address

* 14. ZEMS_DE_STATUS
* Domain:      ZEMS_D_STATUS
* Description: Status
* Field Labels:
*   Short:     Status
*   Medium:    Status
*   Long:      Employee Status
*   Heading:   Status

* 15. ZEMS_DE_LOCATION
* Domain:      CHAR30 (Standard Domain)
* Description: Location
* Field Labels:
*   Short:     Location
*   Medium:    Location
*   Long:      Location
*   Heading:   Location

* 16. ZEMS_DE_AUDITID
* Domain:      ZEMS_D_AUDITID
* Description: Audit ID
* Field Labels:
*   Short:     Audit ID
*   Medium:    Audit ID
*   Long:      Audit ID
*   Heading:   Audit ID

* 17. ZEMS_DE_LOGID
* Domain:      ZEMS_D_LOGID
* Description: Log ID
* Field Labels:
*   Short:     Log ID
*   Medium:    Log ID
*   Long:      Log ID
*   Heading:   Log ID

* 18. ZEMS_DE_ACTION
* Domain:      CHAR10 (Standard Domain)
* Description: Action Type
* Field Labels:
*   Short:     Action
*   Medium:    Action Type
*   Long:      Action Type
*   Heading:   Action
