*======================================================================*
* PROJECT: Employee Management System (EMS)
* PROGRAM: ZEMS_EMPLOYEE_CRUD (Transaction: ZEMS_CRUD)
* PACKAGE: ZEMS
* TYPE:    Module Pool / Dialog Program (Type M)
* DESCRIPTION: Main program shell coordinating screens 100 & 200.
*======================================================================*

PROGRAM zems_employee_crud MESSAGE-ID zems_msg.

*----------------------------------------------------------------------*
* Global Declarations (TOP Include)
*----------------------------------------------------------------------*
INCLUDE zems_employee_top.

*----------------------------------------------------------------------*
* Local Object-Oriented ABAP Classes (Controller & Logic)
*----------------------------------------------------------------------*
INCLUDE zems_employee_lcl.

*----------------------------------------------------------------------*
* PBO Modules (Process Before Output)
*----------------------------------------------------------------------*
INCLUDE zems_employee_o01.

*----------------------------------------------------------------------*
* PAI Modules (Process After Input)
*----------------------------------------------------------------------*
INCLUDE zems_employee_i01.
