*======================================================================*
* PROJECT: Employee Management System (EMS)
* COMPONENT: SAP GUI - Menu Painter (SE41)
* PACKAGE: ZEMS
* STATUS METADATA: ZEMS_GUI_STATUS
* DESCRIPTION: Specifications for PF-STATUS and Function Keys.
*======================================================================*

*----------------------------------------------------------------------*
* 1. PF-STATUS: STATUS_100 (Screen 100 Dashboard)
*----------------------------------------------------------------------*
* Menu Bar:
*   - Program:  Exit (FCode: EXIT)
*   - Edit:     Execute (FCode: EXECUTE)
*
* Application Toolbar:
*   - Item 1:   Text: "Execute"
*               FCode: EXECUTE
*               Icon:  @15@ (ICON_EXECUTE_OBJECT)
*               Info:  Process action (F8)
*
* Function Keys (Standard Mapping):
*   - F3:       FCode: BACK     (Green Arrow Back)
*   - F12:      FCode: CANCEL   (Red Circle Cancel)
*   - Shift+F3: FCode: EXIT     (Yellow Arrow Up Exit)
*   - F8:       FCode: EXECUTE


*----------------------------------------------------------------------*
* 2. PF-STATUS: STATUS_200 (Screen 200 Employee Form)
*----------------------------------------------------------------------*
* Menu Bar:
*   - Program:  Save (FCode: SAVE), Back (FCode: BACK)
*
* Application Toolbar:
*   - Item 1:   Text: "Save"
*               FCode: SAVE
*               Icon:  @2L@ (ICON_SYSTEM_SAVE)
*               Info:  Save Employee Record (Ctrl+S)
*   - Item 2:   Text: "Cancel"
*               FCode: CANCEL
*               Icon:  @0W@ (ICON_CANCEL)
*               Info:  Cancel changes and go back
*
* Function Keys (Standard Mapping):
*   - F3:       FCode: BACK
*   - F11:      FCode: SAVE     (Save Key)
*   - F12:      FCode: CANCEL
*   - Ctrl+S:   FCode: SAVE


*----------------------------------------------------------------------*
* 3. PF-STATUS: STATUS_ALV (Screen 9000 ALV Grid Wrapper)
*----------------------------------------------------------------------*
* Menu Bar:
*   - Program:  Back (FCode: BACK)
*
* Application Toolbar:
*   (Standard ALV grid toolbar is added dynamically in CL_GUI_ALV_GRID,
*    so only standard navigation is needed on the screen level)
*
* Function Keys (Standard Mapping):
*   - F3:       FCode: BACK
*   - F12:      FCode: CANCEL
*   - Shift+F3: FCode: EXIT
