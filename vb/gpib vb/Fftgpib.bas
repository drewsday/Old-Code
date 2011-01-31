Attribute VB_Name = "FFTGPIB"
Option Explicit

' variable for fft gpib device descriptor
Public fft%
'Dim fft% As Integer

' GPIB Board Descriptor & Instrument Addresse
Public Const GPIB_BOARD = 0
Public Const ONO_FFT_ADR = 9
 
' Channels
Public Const CH1 = 1
Public Const CH2 = 2


Function FFTSendCmd(intFFT As Integer, strCmd As String) As Boolean

Dim resp As Integer
  Dim strMesg As String
   
  Call Send(GPIB_BOARD, ONO_FFT_ADR, strCmd, NLend)
  If (ibsta% And EERR) Then    ' error sending command
   GoTo Err_FFTSendCmd
  End If
  
  FFTSendCmd = True
  
Exit_FFTSendCmd:
 Exit Function
  
Err_FFTSendCmd:
 strMesg = "GPIB ERROR !!" & Chr$(13) & Chr$(13) & "Function: FFTSendCmd" & Chr$(13) & "Error #" & iberr & ": " & GPIBErrorString(iberr)
 resp = MsgBox(strMesg, vbCritical + vbOKOnly, "FFT-5100 GPIB")
 FFTSendCmd = False
 GoTo Exit_FFTSendCmd
 
End Function

Function FFTOpenComm(intFFT As Integer) As Boolean

Dim strMesg As String
Dim resp As Integer

  Call SendIFC(GPIB_BOARD)
  If (ibsta% And EERR) Then
    GoTo Err_FFTOpenComms
  End If
  
  Call DevClear(GPIB_BOARD, ONO_FFT_ADR)
  If (ibsta% And EERR) Then
    GoTo Err_FFTOpenComms
  End If
  
  FFTOpenComm = True
  
Exit_FFTOpenComms:
 Exit Function
 
Err_FFTOpenComms:
 strMesg = "GPIB ERROR !!" & Chr$(13) & Chr$(13) & "Function: FFTOpenComms" & Chr$(13) & "Error #" & iberr & ": " & GPIBErrorString(iberr)
 resp = MsgBox(strMesg, vbCritical + vbOKOnly, "FFT-5100 GPIB")
 FFTOpenComm = False
 GoTo Exit_FFTOpenComms
  
End Function

Function FFTReadDisplayData(reading As String) As Boolean
 Dim datas(2048) As Single
 'Dim reading As String
 Dim value As String
 Dim num As Integer
 Dim i As Integer
 Dim resp As Integer
 Dim strMesg As String
 Dim j As Integer
  
 On Error GoTo Err_FFTReadDisplayData
 
 '***** CODE FROM ONO SOKKI JAPAN ********************************
 Call Send(GPIB_BOARD, ONO_FFT_ADR, "AMOWAS001ZTS", NLend)
  If (ibsta% And EERR) Then    ' error sending command
    GoTo GPIBErr_FFTReadDisplayData
  End If
 reading = Space(2048)
 Call Receive(GPIB_BOARD, ONO_FFT_ADR, reading, STOPend)
  If (ibsta% And EERR) Then    ' error sending command
   GoTo GPIBErr_FFTReadDisplayData
  End If
 num = Val(Trim(reading))
For i = 0 To num
 datas(i) = 0
Next i
 'Call Send(GPIB_BOARD, ONO_FFT_ADR, "DMS4", NLend)
 ' If (ibsta% And EERR) Then    ' error sending command
 '  GoTo GPIBErr_FFTReadDisplayData
 ' End If
' Call Send(GPIB_BOARD, ONO_FFT_ADR, "ZTD", NLend)
 '  If (ibsta% And EERR) Then    ' error sending command
 '  GoTo GPIBErr_FFTReadDisplayData
 ' End If
'  value = num * 4 + 2
' Call Receive32(GPIB_BOARD, ONO_FFT_ADR, datas(0), 11, STOPend)
'  If (ibsta% And EERR) Then    ' error sending command
'   GoTo GPIBErr_FFTReadDisplayData
'  End If
 
 ' ***************************************************************

 'For i = 0 To (num - 1)
 ' sngSpectrum(i) = datas(i)
 'Next i
  
 FFTReadDisplayData = True
 
Exit_FFTReadDisplayData:
 Exit Function
 
GPIBErr_FFTReadDisplayData:
 strMesg = "GPIB ERROR !!" & Chr$(13) & Chr$(13) & "Function: FFTReadDisplayData" & Chr$(13) & "Error #" & iberr & ": " & GPIBErrorString(iberr)
 resp = MsgBox(strMesg, vbCritical + vbOKOnly, "CF-5200 GPIB")
 FFTReadDisplayData = False
 GoTo Exit_FFTReadDisplayData
 
Err_FFTReadDisplayData:
 FFTReadDisplayData = False
 Resume Exit_FFTReadDisplayData

End Function


Function FFTReadDisplayDataB(sngSpectrum() As Single) As Boolean
 Dim datas(2048) As Single
 Dim reading As String
 Dim value As String
 Dim num As Integer
 Dim i As Integer
 Dim resp As Integer
 Dim strMesg As String
 Dim j As Integer
  
 On Error GoTo Err_FFTReadDisplayData
 
 '***** CODE FROM ONO SOKKI JAPAN ********************************
 Call Send(GPIB_BOARD, ONO_FFT_ADR, "WLC1", NLend)
  If (ibsta% And EERR) Then    ' error sending command
    GoTo GPIBErr_FFTReadDisplayData
  End If
 reading = Space(20)
 Call Receive(GPIB_BOARD, ONO_FFT_ADR, reading, STOPend)
  If (ibsta% And EERR) Then    ' error sending command
   GoTo GPIBErr_FFTReadDisplayData
  End If
 num = Val(Trim(reading))
 For i = 0 To num
  datas(i) = 0
 Next i
 Call Send(GPIB_BOARD, ONO_FFT_ADR, "DMS4", NLend)
  If (ibsta% And EERR) Then    ' error sending command
   GoTo GPIBErr_FFTReadDisplayData
  End If
 Call Send(GPIB_BOARD, ONO_FFT_ADR, "WDR2", NLend)
   If (ibsta% And EERR) Then    ' error sending command
   GoTo GPIBErr_FFTReadDisplayData
  End If
  value = num * 4 + 2
 Call Receive32(GPIB_BOARD, ONO_FFT_ADR, datas(0), value, STOPend)
  If (ibsta% And EERR) Then    ' error sending command
   GoTo GPIBErr_FFTReadDisplayData
  End If
 
 ' ***************************************************************

 For i = 0 To (num - 1)
  sngSpectrum(i) = datas(i)
 Next i
 
 FFTReadDisplayDataB = True
 
Exit_FFTReadDisplayData:
 Exit Function
 
GPIBErr_FFTReadDisplayData:
 strMesg = "GPIB ERROR !!" & Chr$(13) & Chr$(13) & "Function: FFTReadDisplayData" & Chr$(13) & "Error #" & iberr & ": " & GPIBErrorString(iberr)
 resp = MsgBox(strMesg, vbCritical + vbOKOnly, "CF-5200 GPIB")
 FFTReadDisplayDataB = False
 GoTo Exit_FFTReadDisplayData
 
Err_FFTReadDisplayData:
 FFTReadDisplayDataB = False
 Resume Exit_FFTReadDisplayData

End Function


Function FFTReadDisplayDataX(sngSpectrum() As Single) As Boolean
 Dim datas(2048) As Single
 Dim reading As String
 Dim value As String
 Dim num As Integer
 Dim i As Integer
 Dim resp As Integer
 Dim strMesg As String
 Dim j As Integer
  
 On Error GoTo Err_FFTReadDisplayDataX
 
 '***** CODE FROM ONO SOKKI JAPAN ********************************
 Call Send(GPIB_BOARD, ONO_FFT_ADR, "WLC1", NLend)
  If (ibsta% And EERR) Then    ' error sending command
    GoTo GPIBErr_FFTReadDisplayDataX
  End If
 reading = Space(20)
 Call Receive(GPIB_BOARD, ONO_FFT_ADR, reading, STOPend)
  If (ibsta% And EERR) Then    ' error sending command
   GoTo GPIBErr_FFTReadDisplayDataX
  End If
 num = Val(Trim(reading))
 For i = 0 To num
  datas(i) = 0
 Next i
 Call Send(GPIB_BOARD, ONO_FFT_ADR, "DMS4", NLend)
  If (ibsta% And EERR) Then    ' error sending command
   GoTo GPIBErr_FFTReadDisplayDataX
  End If
 Call Send(GPIB_BOARD, ONO_FFT_ADR, "UDD,1,0,800", NLend)
   If (ibsta% And EERR) Then    ' error sending command
   GoTo GPIBErr_FFTReadDisplayDataX
  End If
  value = num * 4 + 2
 Call Receive32(GPIB_BOARD, ONO_FFT_ADR, datas(0), value, STOPend)
  If (ibsta% And EERR) Then    ' error sending command
   GoTo GPIBErr_FFTReadDisplayDataX
  End If
 
 ' ***************************************************************

 For i = 0 To (num - 1)
  sngSpectrum(i) = datas(i)
 Next i
  
 FFTReadDisplayDataX = True
 
Exit_FFTReadDisplayDataX:
 Exit Function
 
GPIBErr_FFTReadDisplayDataX:
 strMesg = "GPIB ERROR !!" & Chr$(13) & Chr$(13) & "Function: FFTReadDisplayData" & Chr$(13) & "Error #" & iberr & ": " & GPIBErrorString(iberr)
 resp = MsgBox(strMesg, vbCritical + vbOKOnly, "CF-5200 GPIB")
 FFTReadDisplayDataX = False
 GoTo Exit_FFTReadDisplayDataX
 
Err_FFTReadDisplayDataX:
 FFTReadDisplayDataX = False
 Resume Exit_FFTReadDisplayDataX

End Function

Function FFTSystemReset(intFFT As Integer) As Boolean
' Sends system reset command to the CF-5200
' Note: you should delay sending commands to the analyzer for a
' few seconds after using this func to reset the analyzer
' Args:
'       intFFT:     GPIB device descriptior
' Return:
'       Boolean     True if successful, False if function fails

  If FFTSendCmd(intFFT, "SRE") Then
    FFTSystemReset = True
   Else
    FFTSystemReset = False
  End If
 
  Call ibclr(intFFT)
 
End Function

Function FFTReceiveString(intFFT As Integer, strReturn As String) As Boolean
' Receive ASCII string data from the CF-5200 analyzer in response to
' previously sent command.
' Args:
'       intFFT:     GPIB device descriptior
'       strReturn:  text string returned by analyzer is placed into this string variable
' Return:
'       Boolean     True if successful, False if read fails

  Dim resp As Integer
  Dim strMesg As String

  Call ibrd(intFFT, strReturn)
  If (ibsta% And EERR) Then    ' error reading cmd confirmation
    GoTo Err_FFTReceiveString
  End If
  
  FFTReceiveString = True
  
Exit_FFTReceiveString:
  Exit Function
  
Err_FFTReceiveString:
  strMesg = "GPIB ERROR !!" & Chr$(13) & Chr$(13) & "Function: FFTReceiveString" & Chr$(13) & "Error #" & iberr & ": " & GPIBErrorString(iberr)
  resp = MsgBox(strMesg, vbCritical + vbOKOnly, "CF-5200 GPIB")
  FFTReceiveString = False
  GoTo Exit_FFTReceiveString

End Function

Function FFTSetEUValue(intFFT As Integer, bytChannel As Byte, sngEUVal As Single) As Boolean
  Dim strCmd As String

  ' The CF-5200 expects the value sent with the 'EAN' command to have
  ' units of EU/Volt.  So, we will take inverse of V/EU passed to this
  ' function before transmitting to the anallyzer.
  sngEUVal = 1 / sngEUVal
 
  Select Case bytChannel
   Case CH1
     strCmd = "EAN" & Trim(Str(sngEUVal))
   Case CH2
     strCmd = "EBN" & Trim(Str(sngEUVal))
  End Select
 
  If FFTSendCmd(intFFT, strCmd) Then
     FFTSetEUValue = True
   Else
     FFTSetEUValue = False
  End If

End Function

Function FFTSetEUName(intFFT As Integer, bytChannel As Byte, strName As String) As Boolean
  Dim strCmd As String
 
  Select Case bytChannel
   Case CH1
     strCmd = "EA=" & Trim(strName)
   Case CH2
     strCmd = "EB=" & Trim(strName)
  End Select
 
  If FFTSendCmd(intFFT, strCmd) Then
     FFTSetEUName = True
   Else
     FFTSetEUName = False
  End If

End Function

Function FFTEUOn(intFFT As Integer) As Boolean

  If FFTSendCmd(intFFT, "YUO") Then
     FFTEUOn = True
   Else
     FFTEUOn = False
  End If

End Function

Function FFTSetInputRange(intFFT As Integer, bytChannel As Byte, strRange As String) As Boolean

  Dim strCmd As String

  strCmd = "VLT" & Trim(Str(bytChannel)) & "," & strRange
 
  If FFTSendCmd(intFFT, strCmd) Then
     FFTSetInputRange = True
   Else
     FFTSetInputRange = False
  End If

End Function


'Not used in VibMeasure program! (I think)
'However, this would be a useful function.
Function FFTStart(intFFT As Integer) As Boolean
' Start analysis (same as pressing the START switch on front panel)

  If FFTSendCmd(intFFT, "CST") Then
     FFTStart = True
   Else
     FFTStart = False
  End If

End Function


'Not used in VibMeasure program! (I think)
'However, this would be a useful function.
Function FFTPause(intFFT As Integer) As Boolean
' Pause analysis (same as pressing the PAUSE switch on front panel)

  If FFTSendCmd(intFFT, "CPS") Then
     FFTPause = True
   Else
     FFTPause = False
  End If

End Function


'Not used in VibMeasure program! (I think)
'However, this would be a useful function.
Function FFTAverageOn(intFFT As Integer) As Boolean
' Set average mode ON (same as pressing the AVG switch on front
' so that LED is ON)

  If FFTSendCmd(intFFT, "AVO") Then
    FFTAverageOn = True
   Else
    FFTAverageOn = False
  End If

End Function


'Not used in VibMeasure program! (I think)
'However, this would be a useful function.
Function FFTAverageOff(intFFT As Integer) As Boolean
' Set average mode OFF (same as pressing the AVG switch on front
' so that LED is OFF)

  If FFTSendCmd(intFFT, "AVF") Then
     FFTAverageOff = True
   Else
     FFTAverageOff = False
  End If

End Function


'Not used in VibMeasure program! (I think)
'Might be worth implementing in the future
Function FFTDisplaySpectrum(intFFT As Integer, intChannel As Integer) As Boolean

  Select Case intChannel
   
   Case CH1
     If FFTSendCmd(intFFT, "WAV21,3") Then
        FFTDisplaySpectrum = True
      Else
        FFTDisplaySpectrum = False
     End If
  
   Case CH2
     If FFTSendCmd(intFFT, "WAV22,3") Then
        FFTDisplaySpectrum = True
      Else
        FFTDisplaySpectrum = False
     End If
  
  End Select

End Function


'Not used in VibMeasure program! (I think)
'Might be worth implementing in the future
Function FFTDisplayTime(intFFT As Integer, intChannel As Integer) As Boolean

  Select Case intChannel
  
   Case CH1
     If FFTSendCmd(intFFT, "WAV1,1") Then
        FFTDisplayTime = True
      Else
        FFTDisplayTime = False
     End If
  
   Case CH2
     If FFTSendCmd(intFFT, "WAV2,1") Then
        FFTDisplayTime = True
      Else
        FFTDisplayTime = False
     End If
 
  End Select

End Function

Function FFTCloseComm(intFFT As Integer) As Boolean
' Close comms with CF-5200 analyzer

  Dim strMesg As String
  Dim resp As Integer

  Call ibonl(intFFT, 0)
  
  If (ibsta% And EERR) Then
    GoTo Err_FFTCloseComm
  End If
  
  FFTCloseComm = True
  
Exit_FFTCloseComm:
  Exit Function
 
Err_FFTCloseComm:
  strMesg = "GPIB ERROR !!" & Chr$(13) & Chr$(13) & "Function: FFTCloseComm" & Chr$(13) & "Error #" & iberr & ": " & GPIBErrorString(iberr)
  resp = MsgBox(strMesg, vbCritical + vbOKOnly, "CF-5200 GPIB")
  FFTCloseComm = False
  GoTo Exit_FFTCloseComm
  
End Function
'IMPLEMENT THIS FUNCTION!
Function FFTSetLabel(intFFT As Integer, strLabel As String) As Boolean
' Set current label text for CF-5200.

  Dim strCmd As String
 
  strCmd = "LAS" & strLabel
  If FFTSendCmd(intFFT, strCmd) Then
     FFTSetLabel = True
   Else
     FFTSetLabel = False
  End If

End Function

Function GPIBErrorString(intError As Integer) As String
' Accepts an int GPIB error code and returns the string
' description of that error.
  Select Case intError
   Case EDVR
    GPIBErrorString = "System error"
   Case ECIC
    GPIBErrorString = "Function requires GPIB board to be CIC"
   Case ENOL
    GPIBErrorString = "Write function detected no listeners"
   Case EADR
    GPIBErrorString = "Interface board not addressed correctly"
   Case EARG
    GPIBErrorString = "Invalid argument to function call"
   Case ESAC
    GPIBErrorString = "Function requires GPIB board to be SAC"
   Case EABO
    GPIBErrorString = "I/O operation aborted"
   Case ENEB
    GPIBErrorString = "Non-existent interface board"
   Case EDMA
    GPIBErrorString = "DMA Error"
   Case EOIP
    GPIBErrorString = "I/O operation started before previous operation completed"
   Case ECAP
    GPIBErrorString = "No capability for intended operation"
   Case EFSO
    GPIBErrorString = "File system operation error"
   Case EBUS
    GPIBErrorString = "Command error during device call"
   Case ESTB
    GPIBErrorString = "Serial poll status byte lost"
   Case ESRQ
    GPIBErrorString = "SRQ remains asserted"
   Case ETAB
    GPIBErrorString = "The return buffer is full"
   Case ELCK
    GPIBErrorString = "Address or board is locked"
   Case Else
    GPIBErrorString = "Unidentified GPIB error"
  End Select

End Function

Sub ReportError(errmsg$)
  Dim resp As Integer

  resp = MsgBox("Error: " & errmsg$, vbOKOnly)
  
End Sub

'Not used in VibMeasure program! (I think)
Function FFTReadInput(intFFT As Integer, intRange As Integer, intChannel As Integer) As Boolean
' Reads the rpm value that was stored with data stored in block memory

  Dim strData As String
  Dim strCmd As String
  
  Select Case intChannel
  Case 1
  strCmd = "AAR"
  Case 2
  strCmd = "BAR"
  End Select
  
  strData = Space$(6)
    
  ' Read data currently on analyzer display
  If Not FFTSendCmd(intFFT, strCmd) Then
    GoTo Err_FFTReadInput
  End If

  If Not FFTReceiveString(intFFT, strData) Then
    GoTo Err_FFTReadInput
  End If
  
intRange = Val(strData)
FFTReadInput = True
  
Exit_FFTReadInput:
  Exit Function
 
Err_FFTReadInput:
  FFTReadInput = False
  GoTo Exit_FFTReadInput
 
End Function

'USE THIS FUNCTION?!?!
Function FFTReadFreqRange(intFFT As Integer, sngFreqRange As Single) As Boolean
' Reads the frequency range value that was stored with data stored in block memory

  Dim strData As String
  
  strData = Space$(12)
    
  ' Read data currently on analyzer display
  If Not FFTSendCmd(intFFT, "FQC") Then
    GoTo Err_FFTReadFreqRange
  End If

  If Not FFTReceiveString(intFFT, strData) Then
    GoTo Err_FFTReadFreqRange
  End If
  
sngFreqRange = Val(strData)
FFTReadFreqRange = True
  
Exit_FFTReadFreqRange:
  Exit Function
 
Err_FFTReadFreqRange:
  FFTReadFreqRange = False
  GoTo Exit_FFTReadFreqRange
 
End Function

'USE THIS FUNCTION!!
Function FFTReadResolution(intFFT As Integer, sngRes As Single) As Boolean
' Reads the frequency range value that was stored with data stored in block memory

  Dim strData As String
  
  strData = Space$(12)
    
  ' Read data currently on analyzer display
  If Not FFTSendCmd(intFFT, "FLC1") Then
    GoTo Err_FFTReadResolution
  End If

  If Not FFTReceiveString(intFFT, strData) Then
    GoTo Err_FFTReadResolution
  End If
  
sngRes = (Val(strData) / 2.56)
FFTReadResolution = True
  
Exit_FFTReadResolution:
  Exit Function
 
Err_FFTReadResolution:
  FFTReadResolution = False
  GoTo Exit_FFTReadResolution
 
End Function

