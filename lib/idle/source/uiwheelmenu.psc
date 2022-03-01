Scriptname UIWheelMenu extends UIMenuBase

string property     ROOT_MENU       = "CustomMenu" autoReadonly
string Property     MENU_ROOT       = "_root.WheelPhase.WheelBase." autoReadonly

GlobalVariable Property idlemenuBase auto hidden
GlobalVariable Property IsOpenBase auto hidden
GlobalVariable Property IdleOp00 auto hidden
GlobalVariable Property IsOpenOp00 auto hidden
GlobalVariable Property IdleOp01 auto hidden
GlobalVariable Property IsOpenOp01 auto hidden
GlobalVariable Property IdleOp02 auto hidden
GlobalVariable Property IsOpenOp02 auto hidden
GlobalVariable Property IdleOp03 auto hidden
GlobalVariable Property IsOpenOp03 auto hidden
GlobalVariable Property IdleOp04 auto hidden
GlobalVariable Property IsOpenOp04 auto hidden
GlobalVariable Property IdleOp05 auto hidden
GlobalVariable Property IsOpenOp05 auto hidden
GlobalVariable Property IdleOp06 auto hidden
GlobalVariable Property IsOpenOp06 auto hidden

GlobalVariable Property IdleGpAP auto hidden
GlobalVariable Property IsOpenGpAP auto hidden
GlobalVariable Property IdleGpBW auto hidden
GlobalVariable Property IsOpenGpBW auto hidden
GlobalVariable Property IdleGpKW auto hidden
GlobalVariable Property IsOpenGpKW auto hidden
GlobalVariable Property IdleGpPas auto hidden
GlobalVariable Property IsOpenGpPas auto hidden
GlobalVariable Property IdleGpMR auto hidden
GlobalVariable Property IsOpenGpMR auto hidden
GlobalVariable Property IdleGpPTW auto hidden
GlobalVariable Property IsOpenGpPTW auto hidden
GlobalVariable Property IdleGpDC auto hidden
GlobalVariable Property IsOpenGpDC auto hidden
GlobalVariable Property IdleGpSR auto hidden
GlobalVariable Property IsOpenGpSR auto hidden
GlobalVariable Property IdleGpGaT auto hidden
GlobalVariable Property IsOpenGpGaT auto hidden
GlobalVariable Property IdleGpPS auto hidden
GlobalVariable Property IsOpenGpPS auto hidden

bool inital = false


Form _form = None
bool _enabled = true
int _lastIndex = 0
bool _selectionLock = false
int _returnValue = 0

string[] _optionText
string[] _optionLabelText
string[] _optionIcon
int[] _optionIconColor
bool[] _optionEnabled
int[] _optionTextColor

string Function GetMenuName()
    return "UIWheelMenu"
EndFunction

Function OnInit()
    _optionText = new String[8]
    _optionLabelText = new String[8]
    _optionIcon = new String[8]
    _optionIconColor = new Int[8]
    _optionEnabled = new Bool[8]
    _optionTextColor = new Int[8]
    ResetMenu()
EndFunction

int Function OpenMenu(Form akForm = None, Form akReceiver = None)
    _form = akForm

    If !BlockUntilClosed() || !WaitForReset()
        return 255
    Endif

    RegisterForModEvent("UIWheelMenu_ChooseOption", "OnChooseOption")
    RegisterForModEvent("UIWheelMenu_SetOption", "OnSelectOption")
    RegisterForModEvent("UIWheelMenu_LoadMenu", "OnLoadMenu")
    RegisterForModEvent("UIWheelMenu_CloseMenu", "OnUnloadMenu")

    Lock()
    UI.OpenCustomMenu("wheelmenu")
    If !WaitLock()
        return 255
    Endif

    return _returnValue
EndFunction

Event OnLoadMenu(string eventName, string strArg, float numArg, Form formArg)
    UpdateWheelEnabledOptions()
    UpdateWheelForm()
    UpdateWheelOptions()
    UpdateWheelOptionLabels()
    UpdateWheelIcons()
    UpdateWheelIconColors()
    UpdateWheelSelection()
    UpdateWheelTextColors()
EndEvent

Event OnUnloadMenu(string eventName, string strArg, float numArg, Form formArg)
    UnregisterForModEvent("UIWheelMenu_ChooseOption")
    UnregisterForModEvent("UIWheelMenu_SetOption")
    UnregisterForModEvent("UIWheelMenu_LoadMenu")
    UnregisterForModEvent("UIWheelMenu_CloseMenu")
EndEvent

Event OnChooseOption(string eventName, string strArg, float numArg, Form formArg)
    _returnValue = numArg as Int
    Unlock()
EndEvent

Event OnSelectOption(string eventName, string strArg, float numArg, Form formArg)
    _lastIndex = numArg as Int
EndEvent

Function ResetMenu()
    isResetting = true
    _optionText[0] = ""
    _optionText[1] = ""
    _optionText[2] = ""
    _optionText[3] = ""
    _optionText[4] = ""
    _optionText[5] = ""
    _optionText[6] = ""
    _optionText[7] = ""

    _optionLabelText[0] = ""
    _optionLabelText[1] = ""
    _optionLabelText[2] = ""
    _optionLabelText[3] = ""
    _optionLabelText[4] = ""
    _optionLabelText[5] = ""
    _optionLabelText[6] = ""
    _optionLabelText[7] = ""

    _optionIcon[0] = ""
    _optionIcon[1] = ""
    _optionIcon[2] = ""
    _optionIcon[3] = ""
    _optionIcon[4] = ""
    _optionIcon[5] = ""
    _optionIcon[6] = ""
    _optionIcon[7] = ""

    _optionIconColor[0] = 0xFFFFFF
    _optionIconColor[1] = 0xFFFFFF
    _optionIconColor[2] = 0xFFFFFF
    _optionIconColor[3] = 0xFFFFFF
    _optionIconColor[4] = 0xFFFFFF
    _optionIconColor[5] = 0xFFFFFF
    _optionIconColor[6] = 0xFFFFFF
    _optionIconColor[7] = 0xFFFFFF

    _optionTextColor[0] = 0xFFFFFF
    _optionTextColor[1] = 0xFFFFFF
    _optionTextColor[2] = 0xFFFFFF
    _optionTextColor[3] = 0xFFFFFF
    _optionTextColor[4] = 0xFFFFFF
    _optionTextColor[5] = 0xFFFFFF
    _optionTextColor[6] = 0xFFFFFF
    _optionTextColor[7] = 0xFFFFFF

    _optionEnabled[0] = false
    _optionEnabled[1] = false
    _optionEnabled[2] = false
    _optionEnabled[3] = false
    _optionEnabled[4] = false
    _optionEnabled[5] = false
    _optionEnabled[6] = false
    _optionEnabled[7] = false
    isResetting = false
EndFunction

Function SetPropertyInt(string propertyName, int value)
    if propertyName == "lastIndex"
        _lastIndex = value
    Endif
EndFunction

Function SetPropertyIndexInt(string propertyName, int index, int value)
    If index < 0 || index > 7
        return
    Endif
    If propertyName == "optionIconColor"
        _optionIconColor[index] = value
    Elseif propertyName == "optionTextColor"
        _optionTextColor[index] = value
    Endif
EndFunction

Function SetPropertyIndexBool(string propertyName, int index, bool value)
    If index < 0 || index > 7
        return
    Endif
    If propertyName == "optionEnabled"
        _optionEnabled[index] = value
    Endif
EndFunction

Function SetPropertyIndexString(string propertyName, int index, string value)
    If index < 0 || index > 7
        return
    Endif
    If propertyName == "optionText"
        _optionText[index] = value
    Elseif propertyName == "optionLabelText"
        _optionLabelText[index] = value
    Elseif propertyName == "optionIcon"
        _optionIcon[index] = value
    Endif
EndFunction

; Functions only to be used while the menu is open
Function UpdateWheelSelection()
    
    if inital == False
        idlemenuBase = Game.GetFormFromFile(0x007498, "IdlePlayWheelMenu.esp") As GlobalVariable
        IsOpenBase = Game.GetFormFromFile(0x0094E5, "IdlePlayWheelMenu.esp") As GlobalVariable
        IdleOp00= Game.GetFormFromFile(0x00BA9E, "IdlePlayWheelMenu.esp") As GlobalVariable
        IsOpenOp00= Game.GetFormFromFile(0x00BA9F, "IdlePlayWheelMenu.esp") As GlobalVariable
        IdleOp01= Game.GetFormFromFile(0x00BAA0, "IdlePlayWheelMenu.esp") As GlobalVariable
        IsOpenOp01= Game.GetFormFromFile(0x00BAA1, "IdlePlayWheelMenu.esp") As GlobalVariable
        IdleOp02= Game.GetFormFromFile(0x00BAA2, "IdlePlayWheelMenu.esp") As GlobalVariable
        IsOpenOp02= Game.GetFormFromFile(0x00BAA3, "IdlePlayWheelMenu.esp") As GlobalVariable
        IdleOp03= Game.GetFormFromFile(0x00BAA4, "IdlePlayWheelMenu.esp") As GlobalVariable
        IsOpenOp03= Game.GetFormFromFile(0x00BAA5, "IdlePlayWheelMenu.esp") As GlobalVariable
        IdleOp04= Game.GetFormFromFile(0x00BAA6, "IdlePlayWheelMenu.esp") As GlobalVariable
        IsOpenOp04= Game.GetFormFromFile(0x00BAA7, "IdlePlayWheelMenu.esp") As GlobalVariable
        IdleOp05= Game.GetFormFromFile(0x00BAA8, "IdlePlayWheelMenu.esp") As GlobalVariable
        IsOpenOp05= Game.GetFormFromFile(0x00BAA9, "IdlePlayWheelMenu.esp") As GlobalVariable
        IdleOp06= Game.GetFormFromFile(0x00BAAA, "IdlePlayWheelMenu.esp") As GlobalVariable
        IsOpenOp06= Game.GetFormFromFile(0x00BAAB, "IdlePlayWheelMenu.esp") As GlobalVariable
        
        IdleGpAP = Game.GetFormFromFile(0x00DAFF, "IdlePlayWheelMenu.esp") As GlobalVariable
        IsOpenGpAP = Game.GetFormFromFile(0x00DB00, "IdlePlayWheelMenu.esp") As GlobalVariable
        IdleGpSR = Game.GetFormFromFile(0x00E063, "IdlePlayWheelMenu.esp") As GlobalVariable
        IsOpenGpSR = Game.GetFormFromFile(0x00E064, "IdlePlayWheelMenu.esp") As GlobalVariable
        IdleGpPTW = Game.GetFormFromFile(0x00E065, "IdlePlayWheelMenu.esp") As GlobalVariable
        IsOpenGpPTW = Game.GetFormFromFile(0x00E066, "IdlePlayWheelMenu.esp") As GlobalVariable
        IdleGpPS = Game.GetFormFromFile(0x00E067, "IdlePlayWheelMenu.esp") As GlobalVariable
        IsOpenGpPS = Game.GetFormFromFile(0x00E068, "IdlePlayWheelMenu.esp") As GlobalVariable
        IdleGpPas = Game.GetFormFromFile(0x00E069, "IdlePlayWheelMenu.esp") As GlobalVariable
        IsOpenGpPas = Game.GetFormFromFile(0x00E06A, "IdlePlayWheelMenu.esp") As GlobalVariable
        IdleGpMR = Game.GetFormFromFile(0x00E06B, "IdlePlayWheelMenu.esp") As GlobalVariable
        IsOpenGpMR = Game.GetFormFromFile(0x00E06C, "IdlePlayWheelMenu.esp") As GlobalVariable
        IdleGpKW = Game.GetFormFromFile(0x00E06D, "IdlePlayWheelMenu.esp") As GlobalVariable
        IsOpenGpKW = Game.GetFormFromFile(0x00E06E, "IdlePlayWheelMenu.esp") As GlobalVariable
        IdleGpGaT = Game.GetFormFromFile(0x00E06F, "IdlePlayWheelMenu.esp") As GlobalVariable
        IsOpenGpGaT = Game.GetFormFromFile(0x00E070, "IdlePlayWheelMenu.esp") As GlobalVariable
        IdleGpDC = Game.GetFormFromFile(0x00E071, "IdlePlayWheelMenu.esp") As GlobalVariable
        IsOpenGpDC = Game.GetFormFromFile(0x00E072, "IdlePlayWheelMenu.esp") As GlobalVariable
        IdleGpBW = Game.GetFormFromFile(0x00E073, "IdlePlayWheelMenu.esp") As GlobalVariable
        IsOpenGpBW = Game.GetFormFromFile(0x00E074, "IdlePlayWheelMenu.esp") As GlobalVariable
        
        debug.notification("WheelMenu Init")
        debug.trace("WheelMenu Init")
        
        inital = true
    endif


    If  IsOpenGpAP.getvalue() == 1.0
        float[] idleplay = new float[2]
        idleplay[0] = IdleGpAP.getvalue()
        idleplay[1] = true as float
        UI.InvokeFloatA(ROOT_MENU, MENU_ROOT + "setWheelSelection", idleplay)
        debug.trace("int is" + IdleGpAP.getvalue())
    Elseif  IsOpenGpSR.getvalue() == 1.0
        float[] idleplay = new float[2]
        idleplay[0] = IdleGpSR.getvalue()
        idleplay[1] = true as float
        UI.InvokeFloatA(ROOT_MENU, MENU_ROOT + "setWheelSelection", idleplay)
        debug.trace("int is" + IdleGpSR.getvalue())
    Elseif  IsOpenGpPTW.getvalue() == 1.0
        float[] idleplay = new float[2]
        idleplay[0] = idleGpPTW.getvalue()
        idleplay[1] = true as float
        UI.InvokeFloatA(ROOT_MENU, MENU_ROOT + "setWheelSelection", idleplay)
        debug.trace("int is" + idleGpPTW.getvalue())
    Elseif  IsOpenGpPS.getvalue() == 1.0
        float[] idleplay = new float[2]
        idleplay[0] = IdleGpPS.getvalue()
        idleplay[1] = true as float
        UI.InvokeFloatA(ROOT_MENU, MENU_ROOT + "setWheelSelection", idleplay)
        debug.trace("int is" + IdleGpPS.getvalue())
    Elseif  IsOpenGpPaS.getvalue() == 1.0
        float[] idleplay = new float[2]
        idleplay[0] = IdleGpPaS.getvalue()
        idleplay[1] = true as float
        UI.InvokeFloatA(ROOT_MENU, MENU_ROOT + "setWheelSelection", idleplay)
        debug.trace("int is" + IdleGpPaS.getvalue())
    Elseif  IsOpenGpMR.getvalue() == 1.0
        float[] idleplay = new float[2]
        idleplay[0] = IdleGpMR.getvalue()
        idleplay[1] = true as float
        UI.InvokeFloatA(ROOT_MENU, MENU_ROOT + "setWheelSelection", idleplay)
        debug.trace("int is" + IdleGpMR.getvalue())
    Elseif  IsOpenGpKW.getvalue() == 1.0
        float[] idleplay = new float[2]
        idleplay[0] = IdleGpKW.getvalue()
        idleplay[1] = true as float
        UI.InvokeFloatA(ROOT_MENU, MENU_ROOT + "setWheelSelection", idleplay)
        debug.trace("int is" + IdleGpKW.getvalue())
    Elseif  IsOpenGpDC.getvalue() == 1.0
        float[] idleplay = new float[2]
        idleplay[0] = IdleGpDC.getvalue()
        idleplay[1] = true as float
        UI.InvokeFloatA(ROOT_MENU, MENU_ROOT + "setWheelSelection", idleplay)
        debug.trace("int is" + IdleGpDC.getvalue())
    Elseif  IsOpenGpBW.getvalue() == 1.0
        float[] idleplay = new float[2]
        idleplay[0] = IdleGpBW.getvalue()
        idleplay[1] = true as float
        UI.InvokeFloatA(ROOT_MENU, MENU_ROOT + "setWheelSelection", idleplay)
        debug.trace("int is" + IdleGpBW.getvalue())     
    Elseif  IsOpenGpGaT.getvalue() == 1.0
        float[] idleplay = new float[2]
        idleplay[0] = IdleGpGaT.getvalue()
        idleplay[1] = true as float
        UI.InvokeFloatA(ROOT_MENU, MENU_ROOT + "setWheelSelection", idleplay)
        debug.trace("int is" + IdleGpGaT.getvalue())                

        
    Elseif  IsOpenBase.getvalue() == 1.0
        float[] idleplay = new float[2]
        idleplay[0] = idlemenuBase.getvalue()
        idleplay[1] = true as float
        UI.InvokeFloatA(ROOT_MENU, MENU_ROOT + "setWheelSelection", idleplay)
        debug.trace("int is" + idlemenuBase.getvalue())
    elseif  IsOpenOp00.getvalue() == 1.0
        float[] idleplay = new float[2]
        idleplay[0] = IdleOp00.getvalue()
        idleplay[1] = true as float
        UI.InvokeFloatA(ROOT_MENU, MENU_ROOT + "setWheelSelection", idleplay)
        debug.trace("int is" + IdleOp00.getvalue()) 
    elseif  IsOpenOp01.getvalue() == 1.0
        float[] idleplay = new float[2]
        idleplay[0] = IdleOp01.getvalue()
        idleplay[1] = true as float
        UI.InvokeFloatA(ROOT_MENU, MENU_ROOT + "setWheelSelection", idleplay)
        debug.trace("int is" + IdleOp01.getvalue()) 
    elseif  IsOpenOp02.getvalue() == 1.0
        float[] idleplay = new float[2]
        idleplay[0] = IdleOp02.getvalue()
        idleplay[1] = true as float
        UI.InvokeFloatA(ROOT_MENU, MENU_ROOT + "setWheelSelection", idleplay)
        debug.trace("int is" + IdleOp02.getvalue()) 
    elseif  IsOpenOp03.getvalue() == 1.0
        float[] idleplay = new float[2]
        idleplay[0] = IdleOp03.getvalue()
        idleplay[1] = true as float
        UI.InvokeFloatA(ROOT_MENU, MENU_ROOT + "setWheelSelection", idleplay)
        debug.trace("int is" + IdleOp03.getvalue()) 
    elseif  IsOpenOp04.getvalue() == 1.0
        float[] idleplay = new float[2]
        idleplay[0] = IdleOp04.getvalue()
        idleplay[1] = true as float
        UI.InvokeFloatA(ROOT_MENU, MENU_ROOT + "setWheelSelection", idleplay)
        debug.trace("int is" + IdleOp04.getvalue()) 
    elseif  IsOpenOp05.getvalue() == 1.0
        float[] idleplay = new float[2]
        idleplay[0] = IdleOp05.getvalue()
        idleplay[1] = true as float
        UI.InvokeFloatA(ROOT_MENU, MENU_ROOT + "setWheelSelection", idleplay)
        debug.trace("int is" + IdleOp05.getvalue())         
    elseif  IsOpenOp06.getvalue() == 1.0
        float[] idleplay = new float[2]
        idleplay[0] = IdleOp06.getvalue()
        idleplay[1] = true as float
        UI.InvokeFloatA(ROOT_MENU, MENU_ROOT + "setWheelSelection", idleplay)
        debug.trace("int is" + IdleOp06.getvalue())         
    else
        float[] params = new float[2]
        params[0] = _lastIndex as float
        params[1] = true as float
        UI.InvokeFloatA(ROOT_MENU, MENU_ROOT + "setWheelSelection", params) 
    endif       
EndFunction

Function UpdateWheelForm()
    UI.InvokeForm(ROOT_MENU, MENU_ROOT + "setWheelForm", _form)
EndFunction

Function UpdateWheelVisibility()
    UI.SetBool(ROOT_MENU, MENU_ROOT + "enabled", _enabled)
    UI.SetBool(ROOT_MENU, MENU_ROOT + "_visible", _enabled)
EndFunction

Function UpdateWheelEnabledOptions()
    UI.InvokeBoolA(ROOT_MENU, MENU_ROOT + "setWheelOptionsEnabled", _optionEnabled)
EndFunction

Function UpdateWheelOptions()
    UI.InvokeStringA(ROOT_MENU, MENU_ROOT + "setWheelOptions", _optionText)
EndFunction

Function UpdateWheelOptionLabels()
    UI.InvokeStringA(ROOT_MENU, MENU_ROOT + "setWheelOptionLabels", _optionLabelText)
EndFunction

Function UpdateWheelIcons()
    UI.InvokeStringA(ROOT_MENU, MENU_ROOT + "setWheelOptionIcons", _optionIcon)
EndFunction

Function UpdateWheelIconColors()
    UI.InvokeIntA(ROOT_MENU, MENU_ROOT + "setWheelOptionIconColors", _optionIconColor)
EndFunction

Function UpdateWheelTextColors()
    UI.InvokeIntA(ROOT_MENU, MENU_ROOT + "setWheelOptionTextColors", _optionTextColor)
EndFunction