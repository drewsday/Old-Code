Attribute VB_Name = "VBIB32"
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' 32-bit Visual Basic Language Interface
' Version 1.7
' Copyright 1997 National Instruments Corporation.
' All Rights Reserved.
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'   This module contains the subroutine declarations,
'   function declarations and constants required to use
'   the National Instruments GPIB Dynamic Link Library
'   (DLL) for controlling IEEE-488 instrumentation.  This
'   file must be 'added' to your Visual Basic project
'   (by choosing Add File from the File menu or pressing
'   CTRL+F12) so that you can access the NI-488.2
'   subroutines and functions.
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Option Explicit

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'   NI-488 DLL entry function declarations

Declare Function ibask32 Lib "Gpib-32.dll" Alias "ibask" (ByVal ud As Long, ByVal opt As Long, value As Long) As Long
Declare Function ibbna32 Lib "Gpib-32.dll" Alias "ibbnaA" (ByVal ud As Long, sstr As Any) As Long
Declare Function ibcac32 Lib "Gpib-32.dll" Alias "ibcac" (ByVal ud As Long, ByVal v As Long) As Long
Declare Function ibclr32 Lib "Gpib-32.dll" Alias "ibclr" (ByVal ud As Long) As Long
Declare Function ibcmd32 Lib "Gpib-32.dll" Alias "ibcmd" (ByVal ud As Long, sstr As Any, ByVal cnt As Long) As Long
Declare Function ibcmda32 Lib "Gpib-32.dll" Alias "ibcmda" (ByVal ud As Long, sstr As Any, ByVal cnt As Long) As Long
Declare Function ibconfig32 Lib "Gpib-32.dll" Alias "ibconfig" (ByVal ud As Long, ByVal opt As Long, ByVal v As Long) As Long
Declare Function ibdev32 Lib "Gpib-32.dll" Alias "ibdev" (ByVal bdid As Long, ByVal pad As Long, ByVal sad As Long, ByVal tmo As Long, ByVal eot As Long, ByVal eos As Long) As Long
Declare Function ibdma32 Lib "Gpib-32.dll" Alias "ibdma" (ByVal ud As Long, ByVal v As Long) As Long
Declare Function ibeos32 Lib "Gpib-32.dll" Alias "ibeos" (ByVal ud As Long, ByVal v As Long) As Long
Declare Function ibeot32 Lib "Gpib-32.dll" Alias "ibeot" (ByVal ud As Long, ByVal v As Long) As Long
Declare Function ibfind32 Lib "Gpib-32.dll" Alias "ibfindA" (sstr As Any) As Long
Declare Function ibgts32 Lib "Gpib-32.dll" Alias "ibgts" (ByVal ud As Long, ByVal v As Long) As Long
Declare Function ibist32 Lib "Gpib-32.dll" Alias "ibist" (ByVal ud As Long, ByVal v As Long) As Long
Declare Function iblines32 Lib "Gpib-32.dll" Alias "iblines" (ByVal ud As Long, v As Long) As Long
Declare Function ibln32 Lib "Gpib-32.dll" Alias "ibln" (ByVal ud As Long, ByVal pad As Long, ByVal sad As Long, ln As Long) As Long
Declare Function ibloc32 Lib "Gpib-32.dll" Alias "ibloc" (ByVal ud As Long) As Long
Declare Function iblock32 Lib "Gpib-32.dll" Alias "iblock" (ByVal ud As Long) As Long
Declare Function ibonl32 Lib "Gpib-32.dll" Alias "ibonl" (ByVal ud As Long, ByVal v As Long) As Long
Declare Function ibpad32 Lib "Gpib-32.dll" Alias "ibpad" (ByVal ud As Long, ByVal v As Long) As Long
Declare Function ibpct32 Lib "Gpib-32.dll" Alias "ibpct" (ByVal ud As Long) As Long
Declare Function ibppc32 Lib "Gpib-32.dll" Alias "ibppc" (ByVal ud As Long, ByVal v As Long) As Long
Declare Function ibrd32 Lib "Gpib-32.dll" Alias "ibrd" (ByVal ud As Long, sstr As Any, ByVal cnt As Long) As Long
Declare Function ibrda32 Lib "Gpib-32.dll" Alias "ibrda" (ByVal ud As Long, sstr As Any, ByVal cnt As Long) As Long
Declare Function ibrdf32 Lib "Gpib-32.dll" Alias "ibrdfA" (ByVal ud As Long, sstr As Any) As Long
Declare Function ibrpp32 Lib "Gpib-32.dll" Alias "ibrpp" (ByVal ud As Long, sstr As Any) As Long
Declare Function ibrsc32 Lib "Gpib-32.dll" Alias "ibrsc" (ByVal ud As Long, ByVal v As Long) As Long
Declare Function ibrsp32 Lib "Gpib-32.dll" Alias "ibrsp" (ByVal ud As Long, sstr As Any) As Long
Declare Function ibrsv32 Lib "Gpib-32.dll" Alias "ibrsv" (ByVal ud As Long, ByVal v As Long) As Long
Declare Function ibsad32 Lib "Gpib-32.dll" Alias "ibsad" (ByVal ud As Long, ByVal v As Long) As Long
Declare Function ibsic32 Lib "Gpib-32.dll" Alias "ibsic" (ByVal ud As Long) As Long
Declare Function ibsre32 Lib "Gpib-32.dll" Alias "ibsre" (ByVal ud As Long, ByVal v As Long) As Long
Declare Function ibstop32 Lib "Gpib-32.dll" Alias "ibstop" (ByVal ud As Long) As Long
Declare Function ibtmo32 Lib "Gpib-32.dll" Alias "ibtmo" (ByVal ud As Long, ByVal v As Long) As Long
Declare Function ibtrg32 Lib "Gpib-32.dll" Alias "ibtrg" (ByVal ud As Long) As Long
Declare Function ibunlock32 Lib "Gpib-32.dll" Alias "ibunlock" (ByVal ud As Long) As Long
Declare Function ibwait32 Lib "Gpib-32.dll" Alias "ibwait" (ByVal ud As Long, ByVal mask As Long) As Long
Declare Function ibwrt32 Lib "Gpib-32.dll" Alias "ibwrt" (ByVal ud As Long, sstr As Any, ByVal cnt As Long) As Long
Declare Function ibwrta32 Lib "Gpib-32.dll" Alias "ibwrta" (ByVal ud As Long, sstr As Any, ByVal cnt As Long) As Long
Declare Function ibwrtf32 Lib "Gpib-32.dll" Alias "ibwrtfA" (ByVal ud As Long, sstr As Any) As Long

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'   NI-488.2 DLL entry function declarations

Declare Sub AllSpoll32 Lib "Gpib-32.dll" Alias "AllSpoll" (ByVal ud As Long, arg1 As Any, arg2 As Any)
Declare Sub DevClear32 Lib "Gpib-32.dll" Alias "DevClear" (ByVal ud As Long, ByVal v As Long)
Declare Sub DevClearList32 Lib "Gpib-32.dll" Alias "DevClearList" (ByVal ud As Long, arg1 As Any)
Declare Sub EnableLocal32 Lib "Gpib-32.dll" Alias "EnableLocal" (ByVal ud As Long, arg1 As Any)
Declare Sub EnableRemote32 Lib "Gpib-32.dll" Alias "EnableRemote" (ByVal ud As Long, arg1 As Any)
Declare Sub FindLstn32 Lib "Gpib-32.dll" Alias "FindLstn" (ByVal ud As Long, arg1 As Any, arg2 As Any, ByVal limit As Long)
Declare Sub FindRQS32 Lib "Gpib-32.dll" Alias "FindRQS" (ByVal ud As Long, arg1 As Any, result As Long)
Declare Sub PassControl32 Lib "Gpib-32.dll" Alias "PassControl" (ByVal ud As Long, ByVal addr As Long)
Declare Sub PPoll32 Lib "Gpib-32.dll" Alias "PPoll" (ByVal ud As Long, result As Long)
Declare Sub PPollConfig32 Lib "Gpib-32.dll" Alias "PPollConfig" (ByVal ud As Long, ByVal addr As Long, ByVal line As Long, ByVal sense As Long)
Declare Sub PPollUnconfig32 Lib "Gpib-32.dll" Alias "PPollUnconfig" (ByVal ud As Long, arg1 As Any)
Declare Sub RcvRespMsg32 Lib "Gpib-32.dll" Alias "RcvRespMsg" (ByVal ud As Long, arg1 As Any, ByVal cnt As Long, ByVal term As Long)
Declare Sub ReadStatusByte32 Lib "Gpib-32.dll" Alias "ReadStatusByte" (ByVal ud As Long, ByVal addr As Long, result As Long)
Declare Sub Receive32 Lib "Gpib-32.dll" Alias "Receive" (ByVal ud As Long, ByVal addr As Long, arg1 As Any, ByVal cnt As Long, ByVal term As Long)
Declare Sub ReceiveSetup32 Lib "Gpib-32.dll" Alias "ReceiveSetup" (ByVal ud As Long, ByVal addr As Long)
Declare Sub ResetSys32 Lib "Gpib-32.dll" Alias "ResetSys" (ByVal ud As Long, arg1 As Any)
Declare Sub Send32 Lib "Gpib-32.dll" Alias "Send" (ByVal ud As Long, ByVal addr As Long, sstr As Any, ByVal cnt As Long, ByVal term As Long)
Declare Sub SendCmds32 Lib "Gpib-32.dll" Alias "SendCmds" (ByVal ud As Long, sstr As Any, ByVal cnt As Long)
Declare Sub SendDataBytes32 Lib "Gpib-32.dll" Alias "SendDataBytes" (ByVal ud As Long, sstr As Any, ByVal cnt As Long, ByVal term As Long)
Declare Sub SendIFC32 Lib "Gpib-32.dll" Alias "SendIFC" (ByVal ud As Long)
Declare Sub SendList32 Lib "Gpib-32.dll" Alias "SendList" (ByVal ud As Long, arg1 As Any, arg2 As Any, ByVal cnt As Long, ByVal term As Long)
Declare Sub SendLLO32 Lib "Gpib-32.dll" Alias "SendLLO" (ByVal ud As Long)
Declare Sub SendSetup32 Lib "Gpib-32.dll" Alias "SendSetup" (ByVal ud As Long, arg1 As Any)
Declare Sub SetRWLS32 Lib "Gpib-32.dll" Alias "SetRWLS" (ByVal ud As Long, arg1 As Any)
Declare Sub TestSys32 Lib "Gpib-32.dll" Alias "TestSys" (ByVal ud As Long, arg1 As Any, arg2 As Any)
Declare Sub Trigger32 Lib "Gpib-32.dll" Alias "Trigger" (ByVal ud As Long, ByVal addr As Long)
Declare Sub TriggerList32 Lib "Gpib-32.dll" Alias "TriggerList" (ByVal ud As Long, arg1 As Any)

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'   DLL entry function declarations needed for GPIB global variables

Declare Function RegisterGpibGlobalsForThread Lib "Gpib-32.dll" (Longibsta As Long, Longiberr As Long, Longibcnt As Long, ibcntl As Long) As Long
Declare Function UnregisterGpibGlobalsForThread Lib "Gpib-32.dll" () As Long
Declare Function ThreadIbsta32 Lib "Gpib-32.dll" Alias "ThreadIbsta" () As Long
Declare Function ThreadIbcnt32 Lib "Gpib-32.dll" Alias "ThreadIbcnt" () As Long
Declare Function ThreadIbcntl32 Lib "Gpib-32.dll" Alias "ThreadIbcntl" () As Long
Declare Function ThreadIberr32 Lib "Gpib-32.dll" Alias "ThreadIberr" () As Long

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'   DLL entry function declarations needed for GPIBnotify OLE control

Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'   DLL entry function declarations needed for GPIB-ENET functions

Declare Function iblockx32 Lib "Gpib-32.dll" Alias "iblockxA" (ByVal ud As Long, ByVal LockWaitTime As Long, arg1 As Any) As Long
Declare Function ibunlockx32 Lib "Gpib-32.dll" Alias "ibunlockx" (ByVal ud As Long) As Long


Sub AllSpoll(ByVal ud As Integer, addrs() As Integer, results() As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If
 
' Call the 32-bit DLL.
    Call AllSpoll32(ud, addrs(0), results(0))
    
    Call copy_ibvars
End Sub

Sub copy_ibvars()
    ibsta = ConvertLongToInt(Longibsta)
    iberr = CInt(Longiberr)
    ibcnt = ConvertLongToInt(ibcntl)
End Sub

Sub DevClear(ByVal ud As Integer, ByVal addr As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If
    
' Call the 32-bit DLL.
    Call DevClear32(ud, addr)
    
    Call copy_ibvars
End Sub

Sub DevClearList(ByVal ud As Integer, addrs() As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call DevClearList32(ud, addrs(0))

    Call copy_ibvars
End Sub

Sub EnableLocal(ByVal ud As Integer, addrs() As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call EnableLocal32(ud, addrs(0))

    Call copy_ibvars
End Sub

Sub EnableRemote(ByVal ud As Integer, addrs() As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call EnableRemote32(ud, addrs(0))

    Call copy_ibvars
End Sub

Sub FindLstn(ByVal ud As Integer, addrs() As Integer, results() As Integer, ByVal limit As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If
  
' Call the 32-bit DLL.
    Call FindLstn32(ud, addrs(0), results(0), limit)
    
    Call copy_ibvars
End Sub

Sub FindRQS(ByVal ud As Integer, addrs() As Integer, result As Integer)
   Dim tmpresult As Long
   
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call FindRQS32(ud, addrs(0), tmpresult)

    result = ConvertLongToInt(tmpresult)
    
    Call copy_ibvars
End Sub

Sub ibask(ByVal ud As Integer, ByVal opt As Integer, rval As Integer)
  Dim tmprval As Long
  
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibask32(ud, opt, tmprval)
    
    rval = ConvertLongToInt(tmprval)

    Call copy_ibvars
End Sub

Sub ibbna(ByVal ud As Integer, ByVal udname As String)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibbna32(ud, ByVal udname)

    Call copy_ibvars
End Sub

Sub ibcac(ByVal ud As Integer, ByVal v As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibcac32(ud, v)

    Call copy_ibvars
End Sub

Sub ibclr(ByVal ud As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibclr32(ud)
    
    Call copy_ibvars
End Sub

Sub ibcmd(ByVal ud As Integer, ByVal buf As String)
   Dim cnt As Long
   
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

    cnt = CLng(Len(buf))
    
' Call the 32-bit DLL.
    Call ibcmd32(ud, ByVal buf, cnt)

    Call copy_ibvars
End Sub

Sub ibcmda(ByVal ud As Integer, ByVal buf As String)
    Dim cnt As Long
    
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

    cnt = CLng(Len(buf))
    
' Call the 32-bit DLL.
    Call ibcmd32(ud, ByVal buf, cnt)

' When Visual Basic remapping buffer problem solved, then use:
'    call ibcmda32(ud, ByVal buf, cnt)

    Call copy_ibvars
End Sub

Sub ibconfig(ByVal bdid As Integer, ByVal opt As Integer, ByVal v As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibconfig32(bdid, opt, v)
    
    Call copy_ibvars
End Sub

Sub ibdev(ByVal bdid As Integer, ByVal pad As Integer, ByVal sad As Integer, ByVal tmo As Integer, ByVal eot As Integer, ByVal eos As Integer, ud As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    ud = ConvertLongToInt(ibdev32(bdid, pad, sad, tmo, eot, eos))
    
    Call copy_ibvars
End Sub


Sub ibdma(ByVal ud As Integer, ByVal v As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibdma32(ud, v)
    
    Call copy_ibvars
End Sub

Sub ibeos(ByVal ud As Integer, ByVal v As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibeos32(ud, v)
    
    Call copy_ibvars
End Sub

Sub ibeot(ByVal ud As Integer, ByVal v As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibeot32(ud, v)
    
    Call copy_ibvars
End Sub



Sub ibfind(ByVal udname As String, ud As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    ud = ConvertLongToInt(ibfind32(ByVal udname))

    Call copy_ibvars
End Sub

Sub ibgts(ByVal ud As Integer, ByVal v As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibgts32(ud, v)

    Call copy_ibvars
End Sub

Sub ibist(ByVal ud As Integer, ByVal v As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibist32(ud, v)

    Call copy_ibvars
End Sub

Sub iblines(ByVal ud As Integer, lines As Integer)
   Dim tmplines As Long
   
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call iblines32(ud, tmplines)

    lines = ConvertLongToInt(tmplines)

    Call copy_ibvars
End Sub

Sub ibln(ByVal ud As Integer, ByVal pad As Integer, ByVal sad As Integer, ln As Integer)
    Dim tmpln As Long
    
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibln32(ud, pad, sad, tmpln)

    ln = ConvertLongToInt(tmpln)

    Call copy_ibvars
End Sub

Sub ibloc(ByVal ud As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibloc32(ud)

    Call copy_ibvars
End Sub

Sub ibonl(ByVal ud As Integer, ByVal v As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibonl32(ud, v)
    
    Call copy_ibvars
End Sub

Sub ibpad(ByVal ud As Integer, ByVal v As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibpad32(ud, v)
    
    Call copy_ibvars
End Sub

Sub ibpct(ByVal ud As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibpct32(ud)
    
    Call copy_ibvars
End Sub



Sub ibppc(ByVal ud As Integer, ByVal v As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibppc32(ud, v)

    Call copy_ibvars
End Sub

Sub ibrd(ByVal ud As Integer, buf As String)
    Dim cnt As Long
    
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

    cnt = CLng(Len(buf))
    
' Call the 32-bit DLL.
    Call ibrd32(ud, ByVal buf, cnt)
    
    Call copy_ibvars
End Sub

Sub ibrda(ByVal ud As Integer, buf As String)
    Dim cnt As Long
    
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

    cnt = CLng(Len(buf))
    
' Call the 32-bit DLL.
    Call ibrd32(ud, ByVal buf, cnt)
   
' When Visual Basic remapping buffer problem solved, use this:
'    Call ibrda32(ud, ByVal buf, cnt)
    
    Call copy_ibvars
End Sub

Sub ibrdf(ByVal ud As Integer, ByVal filename As String)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibrdf32(ud, ByVal filename)
    
    Call copy_ibvars
End Sub

Sub ibrdi(ByVal ud As Integer, ibuf() As Integer, ByVal cnt As Long)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibrd32(ud, ibuf(0), cnt)
    
    Call copy_ibvars
End Sub

Sub ibrdia(ByVal ud As Integer, ibuf() As Integer, ByVal cnt As Long)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibrd32(ud, ibuf(0), cnt)

' When Visual Basic remapping buffer problem is solved, then use:
'    Call ibrda32(u, ibuf(0), cnt)
    
    Call copy_ibvars
End Sub



Sub ibrpp(ByVal ud As Integer, ppr As Integer)
    Static tmp_str As String * 2
   
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If
    
' Call the 32-bit DLL.
    Call ibrpp32(ud, ByVal tmp_str)

    ppr = Asc(tmp_str)
    
    Call copy_ibvars
End Sub

Sub ibrsc(ByVal ud As Integer, ByVal v As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibrsc32(ud, v)
    
    Call copy_ibvars
End Sub

Sub ibrsp(ByVal ud As Integer, spr As Integer)
    Static tmp_str As String * 2
    
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If
    
' Call the 32-bit DLL
    Call ibrsp32(ud, ByVal tmp_str)
    
    spr = Asc(tmp_str)
    
    Call copy_ibvars
End Sub

Sub ibrsv(ByVal ud As Integer, ByVal v As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibrsv32(ud, v)

    Call copy_ibvars
End Sub

Sub ibsad(ByVal ud As Integer, ByVal v As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibsad32(ud, v)
    
    Call copy_ibvars
End Sub

Sub ibsic(ByVal ud As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibsic32(ud)
    
    Call copy_ibvars
End Sub

Sub ibsre(ByVal ud As Integer, ByVal v As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibsre32(ud, v)
    
    Call copy_ibvars
End Sub

Sub ibstop(ByVal ud As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibstop32(ud)
    
    Call copy_ibvars
End Sub

Sub ibtmo(ByVal ud As Integer, ByVal v As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibtmo32(ud, v)
    
    Call copy_ibvars
End Sub

Sub ibtrg(ByVal ud As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call 32-bit DLL.
    Call ibtrg32(ud)
    
    Call copy_ibvars
End Sub

Sub ibwait(ByVal ud As Integer, ByVal mask As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibwait32(ud, mask)

    Call copy_ibvars
End Sub

Sub ibwrt(ByVal ud As Integer, ByVal buf As String)
    Dim cnt As Long
    
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

    cnt = CLng(Len(buf))
    
' Call the 32-bit DLL.
    Call ibwrt32(ud, ByVal buf, cnt)
    
    Call copy_ibvars
End Sub

Sub ibwrta(ByVal ud As Integer, ByVal buf As String)
    Dim cnt As Long
    
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

    cnt = CLng(Len(buf))
    
' Call the 32-bit DLL.
    Call ibwrt32(ud, ByVal buf, cnt)

' When Visual Basic remapping buffer problem is solved, use this:
'    Call ibwrta32(ud, ByVal buf, cnt)

    Call copy_ibvars
End Sub

Sub ibwrtf(ByVal ud As Integer, ByVal filename As String)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibwrtf32(ud, ByVal filename)

    Call copy_ibvars
End Sub

Sub ibwrti(ByVal ud As Integer, ByRef ibuf() As Integer, ByVal cnt As Long)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibwrt32(ud, ibuf(0), cnt)

    Call copy_ibvars
End Sub

Sub ibwrtia(ByVal ud As Integer, ByRef ibuf() As Integer, ByVal cnt As Long)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibwrt32(ud, ibuf(0), cnt)

' When Visual Basic remapping buffer problem is solved, use this:
'    Call ibwrta32(ud, ibuf(0), cnt)

    Call copy_ibvars
End Sub



Function ilask(ByVal ud As Integer, ByVal opt As Integer, rval As Integer) As Integer
    Dim tmprval As Long
    
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    ilask = ConvertLongToInt(ibask32(ud, opt, tmprval))
    
    rval = ConvertLongToInt(tmprval)
    
    Call copy_ibvars
End Function

Function ilbna(ByVal ud As Integer, ByVal udname As String) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If
    
' Call the 32-bit DLL.
    ilbna = ConvertLongToInt(ibbna32(ud, ByVal udname))

    Call copy_ibvars
End Function

Function ilcac(ByVal ud As Integer, ByVal v As Integer) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    ilcac = ConvertLongToInt(ibcac32(ud, v))
    
    Call copy_ibvars
End Function

Function ilclr(ByVal ud As Integer) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    ilclr = ConvertLongToInt(ibclr32(ud))
 
    Call copy_ibvars
End Function

Function ilcmd(ByVal ud As Integer, ByVal buf As String, ByVal cnt As Long) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    ilcmd = ConvertLongToInt(ibcmd32(ud, ByVal buf, cnt))

    Call copy_ibvars
End Function

Function ilcmda(ByVal ud As Integer, ByVal buf As String, ByVal cnt As Long) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If
    
' Call the 32-bit DLL.
    ilcmda = ConvertLongToInt(ibcmd32(ud, ByVal buf, cnt))
  
' When Visual Basic remapping buffer problem is solved, use this:
'    ilcmda = ConvertLongToInt(ibcmda32(ud, ByVal buf, cnt))

    Call copy_ibvars
End Function

Function ilconfig(ByVal bdid As Integer, ByVal opt As Integer, ByVal v As Integer) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    ilconfig = ConvertLongToInt(ibconfig32(bdid, opt, v))

    Call copy_ibvars
End Function

Function ildev(ByVal bdid As Integer, ByVal pad As Integer, ByVal sad As Integer, ByVal tmo As Integer, ByVal eot As Integer, ByVal eos As Integer) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If
    
' Call the 32-bit DLL.
    ildev = ConvertLongToInt(ibdev32(bdid, pad, sad, tmo, eot, eos))
    
    Call copy_ibvars
End Function


Function ildma(ByVal ud As Integer, ByVal v As Integer) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    ildma = ConvertLongToInt(ibdma32(ud, v))

    Call copy_ibvars
End Function

Function ileos(ByVal ud As Integer, ByVal v As Integer) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    ileos = ConvertLongToInt(ibeos32(ud, v))

    Call copy_ibvars
End Function

Function ileot(ByVal ud As Integer, ByVal v As Integer) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    ileot = ConvertLongToInt(ibeot32(ud, v))

    Call copy_ibvars
End Function


Function ilfind(ByVal udname As String) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    ilfind = ConvertLongToInt(ibfind32(ByVal udname))
    
    Call copy_ibvars
End Function

Function ilgts(ByVal ud As Integer, ByVal v As Integer) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If
    
' Call the 32-bit DLL.
    ilgts = ConvertLongToInt(ibgts32(ud, v))
    
    Call copy_ibvars
End Function

Function ilist(ByVal ud As Integer, ByVal v As Integer) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    ilist = ConvertLongToInt(ibist32(ud, v))

    Call copy_ibvars
End Function


Function illines(ByVal ud As Integer, lines As Integer) As Integer
    Dim tmplines As Long
    
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    illines = ConvertLongToInt(iblines32(ud, tmplines))
    
    lines = ConvertLongToInt(tmplines)
    
    Call copy_ibvars
End Function

Function illn(ByVal ud As Integer, ByVal pad As Integer, ByVal sad As Integer, ln As Integer) As Integer
    Dim tmpln As Long
    
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    illn = ConvertLongToInt(ibln32(ud, pad, sad, tmpln))
    
    ln = ConvertLongToInt(tmpln)

    Call copy_ibvars
End Function

Function illoc(ByVal ud As Integer) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    illoc = ConvertLongToInt(ibloc32(ud))
    
    Call copy_ibvars
End Function

Function ilonl(ByVal ud As Integer, ByVal v As Integer) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    ilonl = ConvertLongToInt(ibonl32(ud, v))
    
    Call copy_ibvars
End Function

Function ilpad(ByVal ud As Integer, ByVal v As Integer) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    ilpad = ConvertLongToInt(ibpad32(ud, v))
    
    Call copy_ibvars
End Function

Function ilpct(ByVal ud As Integer) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    ilpct = ConvertLongToInt(ibpct32(ud))
    
    Call copy_ibvars
End Function



Function ilppc(ByVal ud As Integer, ByVal v As Integer) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    ilppc = ConvertLongToInt(ibppc32(ud, v))
    
    Call copy_ibvars
End Function

Function ilrd(ByVal ud As Integer, buf As String, ByVal cnt As Long) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If
    
' Call the 32-bit DLL.
    ilrd = ConvertLongToInt(ibrd32(ud, ByVal buf, cnt))
    
    Call copy_ibvars
End Function

Function ilrda(ByVal ud As Integer, buf As String, ByVal cnt As Long) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If
    
' Call the 32-bit DLL.
    ilrda = ConvertLongToInt(ibrd32(ud, ByVal buf, cnt))
    
' When Visual Basic remapping buffer problem solved, use this:
'    ilrda = ConvertLongToInt(ibrda32(ud, ByVal buf, cnt))

    Call copy_ibvars
End Function

Function ilrdf(ByVal ud As Integer, ByVal filename As String) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    ilrdf = ConvertLongToInt(ibrdf32(ud, ByVal filename))
    
    Call copy_ibvars
End Function

Function ilrdi(ByVal ud As Integer, ibuf() As Integer, ByVal cnt As Long) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    ilrdi = ConvertLongToInt(ibrd32(ud, ibuf(0), cnt))

    Call copy_ibvars
End Function

Function ilrdia(ByVal ud As Integer, ibuf() As Integer, ByVal cnt As Long) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    ilrdia = ConvertLongToInt(ibrd32(ud, ibuf(0), cnt))

' When Visual Basic remapping buffer problem solved, use this:
'    ilrdia = ConvertLongToInt(ibrda32(ud, ibuf(0), cnt))

    Call copy_ibvars
End Function



Function ilrpp(ByVal ud As Integer, ppr As Integer) As Integer
    Static tmp_str As String * 2
    
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If
    
' Call the 32-bit DLL.
    ilrpp = ConvertLongToInt(ibrpp32(ud, ByVal tmp_str))
    
    ppr = Asc(tmp_str)
    
    Call copy_ibvars
End Function

Function ilrsc(ByVal ud As Integer, ByVal v As Integer) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

'  Call the 32-bit DLL.
    ilrsc = ConvertLongToInt(ibrsc32(ud, v))
    
    Call copy_ibvars
End Function

Function ilrsp(ByVal ud As Integer, spr As Integer) As Integer
    Static tmp_str As String * 2
    
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If
    
' Call the 32-bit DLL
    ilrsp = ConvertLongToInt(ibrsp32(ud, ByVal tmp_str))
    
    spr = Asc(tmp_str)
    
    Call copy_ibvars
End Function

Function ilrsv(ByVal ud As Integer, ByVal v As Integer) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    ilrsv = ConvertLongToInt(ibrsv32(ud, v))

    Call copy_ibvars
End Function

Function ilsad(ByVal ud As Integer, ByVal v As Integer) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

'  Call the 32-bit DLL.
    ilsad = ConvertLongToInt(ibsad32(ud, v))

    Call copy_ibvars
End Function

Function ilsic(ByVal ud As Integer) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

'  Call the 32-bit DLL.
    ilsic = ConvertLongToInt(ibsic32(ud))

    Call copy_ibvars
End Function

Function ilsre(ByVal ud As Integer, ByVal v As Integer) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

'  Call the 32-bit DLL.
    ilsre = ConvertLongToInt(ibsre32(ud, v))

    Call copy_ibvars
End Function

Function ilstop(ByVal ud As Integer) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

'  Call the 32-bit DLL.
    ilstop = ConvertLongToInt(ibstop32(ud))

    Call copy_ibvars
End Function

Function iltmo(ByVal ud As Integer, ByVal v As Integer) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

'  Call the 32-bit DLL.
    iltmo = ConvertLongToInt(ibtmo32(ud, v))
    
    Call copy_ibvars
End Function

Function iltrg(ByVal ud As Integer) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If
    
' Call 32-bit DLL.
    iltrg = ConvertLongToInt(ibtrg32(ud))
    
    Call copy_ibvars
End Function

Function ilwait(ByVal ud As Integer, ByVal mask As Integer) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If
    
' Call the 32-bit DLL.
    ilwait = ConvertLongToInt(ibwait32(ud, mask))
    
    Call copy_ibvars
End Function

Function ilwrt(ByVal ud As Integer, ByVal buf As String, ByVal cnt As Long) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If
    
' Call the 32-bit DLL.
    ilwrt = ConvertLongToInt(ibwrt32(ud, ByVal buf, cnt))
    
    Call copy_ibvars
End Function

Function ilwrta(ByVal ud As Integer, ByVal buf As String, ByVal cnt As Long) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If
    
' Call the 32-bit DLL.
    ilwrta = ConvertLongToInt(ibwrt32(ud, ByVal buf, cnt))
    
' When the Visual Basic remapping solved, use this:
'    ilwrta = ConvertLongToInt(ibwrta32(ud, ByVal buf, cnt))
    
    Call copy_ibvars
   
End Function

Function ilwrtf(ByVal ud As Integer, ByVal filename As String) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    ilwrtf = ConvertLongToInt(ibwrtf32(ud, ByVal filename))

    Call copy_ibvars
End Function

Function ilwrti(ByVal ud As Integer, ByRef ibuf() As Integer, ByVal cnt As Long) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    ilwrti = ConvertLongToInt(ibwrt32(ud, ibuf(0), cnt))

    Call copy_ibvars
End Function

Function ilwrtia(ByVal ud As Integer, ByRef ibuf() As Integer, ByVal cnt As Long) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    ilwrtia = ConvertLongToInt(ibwrt32(ud, ibuf(0), cnt))

' When Visual Basic remapping buffer problem solved, use this:
'    ilwrtia = ConvertLongToInt(ibwrta32(ud, ibuf(0), cnt))

    Call copy_ibvars
End Function



Sub PassControl(ByVal ud As Integer, ByVal addr As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call PassControl32(ud, addr)

    Call copy_ibvars
End Sub

Sub Ppoll(ByVal ud As Integer, result As Integer)
    Dim tmpresult As Long
    
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call PPoll32(ud, tmpresult)

    result = ConvertLongToInt(tmpresult)
    
    Call copy_ibvars
End Sub

Sub PpollConfig(ByVal ud As Integer, ByVal addr As Integer, ByVal lline As Integer, ByVal sense As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If
    
' Call the 32-bit DLL.
    Call PPollConfig32(ud, addr, lline, sense)

    Call copy_ibvars
End Sub

Sub PpollUnconfig(ByVal ud As Integer, addrs() As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call PPollUnconfig32(ud, addrs(0))

    Call copy_ibvars
End Sub

Sub RcvRespMsg(ByVal ud As Integer, buf As String, ByVal term As Integer)
    Dim cnt As Long
    
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If
    
    cnt = CLng(Len(buf))
    
' Call the 32-bit DLL.
    Call RcvRespMsg32(ud, ByVal buf, cnt, term)
    
    Call copy_ibvars
End Sub

Sub ReadStatusByte(ByVal ud As Integer, ByVal addr As Integer, result As Integer)
    Dim tmpresult As Long
    
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If
    
' Call the 32-bit DLL.
    Call ReadStatusByte32(ud, addr, tmpresult)

    result = ConvertLongToInt(tmpresult)
    
    Call copy_ibvars
End Sub

Sub Receive(ByVal ud As Integer, ByVal addr As Integer, buf As String, ByVal term As Integer)
    Dim cnt As Long
    
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If
    
    cnt = CLng(Len(buf))
    
' Call the 32-bit DLL.
    Call Receive32(ud, addr, ByVal buf, cnt, term)
'   Call Receive32(ud, addr, buf, cnt, term)
    Call copy_ibvars
End Sub

Sub ReceiveSetup(ByVal ud As Integer, ByVal addr As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If
    
' Call the 32-bit DLL.
    Call ReceiveSetup32(ud, addr)

    Call copy_ibvars
End Sub

Sub ResetSys(ByVal ud As Integer, addrs() As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ResetSys32(ud, addrs(0))
    
    Call copy_ibvars
End Sub

Sub Send(ByVal ud As Integer, ByVal addr As Integer, ByVal buf As String, ByVal term As Integer)
    Dim cnt As Long
    
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If
    
    cnt = CLng(Len(buf))
    
' Call the 32-bit DLL.
    Call Send32(ud, addr, ByVal buf, cnt, term)
    
    Call copy_ibvars
End Sub

Sub SendCmds(ByVal ud As Integer, ByVal cmdbuf As String)
    Dim cnt As Long
    
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If
    
    cnt = CLng(Len(cmdbuf))

' Call the 32-bit DLL.
    Call SendCmds32(ud, ByVal cmdbuf, cnt)

    Call copy_ibvars
End Sub

Sub SendDataBytes(ByVal ud As Integer, ByVal buf As String, ByVal term As Integer)
    Dim cnt As Long
    
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If
    
    cnt = CLng(Len(buf))
    
' Call the 32-bit DLL.
    Call SendDataBytes32(ud, ByVal buf, cnt, term)

    Call copy_ibvars
End Sub

Sub SendIFC(ByVal ud As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call SendIFC32(ud)

    Call copy_ibvars
End Sub

Sub SendList(ByVal ud As Integer, addr() As Integer, ByVal buf As String, ByVal term As Integer)
    Dim cnt As Long
    
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If
    
    cnt = CLng(Len(buf))
    
' Call the 32-bit DLL.
    Call SendList32(ud, addr(0), ByVal buf, cnt, term)

    Call copy_ibvars
End Sub

Sub SendLLO(ByVal ud As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call SendLLO32(ud)

    Call copy_ibvars
End Sub

Sub SendSetup(ByVal ud As Integer, addrs() As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call SendSetup32(ud, addrs(0))

    Call copy_ibvars
End Sub

Sub SetRWLS(ByVal ud As Integer, addrs() As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call SetRWLS32(ud, addrs(0))

    Call copy_ibvars
End Sub

Sub TestSRQ(ByVal ud As Integer, result As Integer)
    Call ibwait(ud, 0)
   
    If ibsta And &H1000 Then
        result = 1
    Else
        result = 0
    End If
    
End Sub

Sub TestSys(ByVal ud As Integer, addrs() As Integer, results() As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If
 
' Call the 32-bit DLL.
    Call TestSys32(ud, addrs(0), results(0))
    
    Call copy_ibvars
End Sub

Sub Trigger(ByVal ud As Integer, ByVal addr As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If
    
' Call the 32-bit DLL.
    Call Trigger32(ud, addr)

    Call copy_ibvars
End Sub

Sub TriggerList(ByVal ud As Integer, addrs() As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call TriggerList32(ud, addrs(0))

    Call copy_ibvars
End Sub

Sub WaitSRQ(ByVal ud As Integer, result As Integer)
    Call ibwait(ud, &H5000)

    If ibsta And &H1000 Then
        result = 1
    Else
        result = 0
    End If
End Sub

Private Function ConvertLongToInt(LongNumb As Long) As Integer
  
  If (LongNumb And &H8000&) = 0 Then
      ConvertLongToInt = LongNumb And &HFFFF&
  Else
    ConvertLongToInt = &H8000 Or (LongNumb And &H7FFF&)
  End If
    
End Function

Public Sub RegisterGPIBGlobals()
    Dim rc As Long
    
    rc = RegisterGpibGlobalsForThread(Longibsta, Longiberr, Longibcnt, ibcntl)
    If (rc = 0) Then
      GPIBglobalsRegistered = 1
    ElseIf (rc = 1) Then
      rc = UnregisterGpibGlobalsForThread
      rc = RegisterGpibGlobalsForThread(Longibsta, Longiberr, Longibcnt, ibcntl)
      GPIBglobalsRegistered = 1
    ElseIf (rc = 2) Then
      rc = UnregisterGpibGlobalsForThread
      ibsta = &H8000
      iberr = EDVR
      ibcntl = &HDEAD37F0
    ElseIf (rc = 3) Then
      rc = UnregisterGpibGlobalsForThread
      ibsta = &H8000
      iberr = EDVR
      ibcntl = &HDEAD37F0
    Else
      ibsta = &H8000
      iberr = EDVR
      ibcntl = &HDEAD37F0
    End If
End Sub

Public Sub UnregisterGPIBGlobals()
    Dim rc As Long
    
    rc = UnregisterGpibGlobalsForThread
    GPIBglobalsRegistered = 0
    
End Sub



Public Function ThreadIbsta() As Integer
' Call the 32-bit DLL.
    ThreadIbsta = ConvertLongToInt(ThreadIbsta32())
End Function

Public Function ThreadIberr() As Integer
' Call the 32-bit DLL.
    ThreadIberr = ConvertLongToInt(ThreadIberr32())
End Function

Public Function ThreadIbcnt() As Integer
' Call the 32-bit DLL.
    ThreadIbcnt = ConvertLongToInt(ThreadIbcnt32())
End Function

Public Function ThreadIbcntl() As Long
' Call the 32-bit DLL.
    ThreadIbcntl = ThreadIbcntl32()
End Function

Public Function illock(ByVal ud As Integer) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    illock = ConvertLongToInt(iblock32(ud))
    
    Call copy_ibvars
End Function

Public Function ilunlock(ByVal ud As Integer) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    ilunlock = ConvertLongToInt(ibunlock32(ud))
    
    Call copy_ibvars
End Function

Public Sub iblock(ByVal ud As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call iblock32(ud)
    
    Call copy_ibvars
End Sub

Public Sub ibunlock(ByVal ud As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibunlock32(ud)
    
    Call copy_ibvars
End Sub

Public Function illockx(ByVal ud As Integer, ByVal LockWaitTime As Integer, ByVal buf As String) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    illockx = ConvertLongToInt(iblockx32(ud, LockWaitTime, buf))
    
    Call copy_ibvars
End Function

Public Function ilunlockx(ByVal ud As Integer) As Integer
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    ilunlockx = ConvertLongToInt(ibunlockx32(ud))
    
    Call copy_ibvars
End Function

Public Sub iblockx(ByVal ud As Integer, ByVal LockWaitTime As Integer, ByVal buf As String)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call iblockx32(ud, LockWaitTime, buf)
    
    Call copy_ibvars
End Sub

Public Sub ibunlockx(ByVal ud As Integer)
' Check to see if GPIB Global variables are registered
    If (GPIBglobalsRegistered = 0) Then
      Call RegisterGPIBGlobals
    End If

' Call the 32-bit DLL.
    Call ibunlockx32(ud)
    
    Call copy_ibvars
End Sub
