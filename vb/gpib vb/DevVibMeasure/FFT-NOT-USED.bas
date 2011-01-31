Attribute VB_Name = "FFTNOTUSED"
Option Explicit

' Tracking Dialog Items - Setting Constants
' On & Off
Public Const SET_OFF = 0
Public Const SET_ON = 1
' Tracking Slope
Public Const SET_UP = 0
Public Const SET_DOWN = 1
Public Const SET_UP_N_DOWN = 2
' Octave Tracking
Public Const SET_FULL_OCT = 1
Public Const SET_THIRD_OCT = 2
' Constaant Band Tracking
Public Const SET_HZ = 0
Public Const SET_ORD = 1
' Up & Down Auto Storage/Display at End of Tracking Measurement
Public Const SET_CHA = 0
Public Const SET_CHB = 1
Public Const SET_CHA_N_CHB = 2
' External Sample Input
Public Const SET_BNC = 0
Public Const SET_LG_MP = 1
' External Sample Coupling
Public Const SET_AC = 0
Public Const SET_DC = 1
' External Sampling Input Voltage Range
Public Const SET_TTL = 0
Public Const SET_10_VOLT = 1
' Line Colors
Public Const SET_WHITE = 1
Public Const SET_RED = 7
Public Const SET_GREEN = 12
Public Const SET_YELLOW = 8
Public Const SET_BLUE = 15
' Line Types
Public Const SET_SOLID = 1
Public Const SET_DASH = 2
Public Const SET_LG_DOT = 3
Public Const SET_SM_DOT = 4
Public Const SET_DASH_DOT = 5
Public Const SET_DASH_DOT_DOT = 6
Public Const SET_FINE_DOT = 7

' Tracking Dialogs
Public Const TRACK_COND_DLG = 1
Public Const TRACK_DISP_DLG = 2
Public Const ORDER_SET_DLG = 3
Public Const FREQ_SET_DLG = 4
Public Const ANALOG_EXT_DLG = 5
Public Const COLOR_DLG = 6
Public Const LINE_DLG = 7

' Tracking Dialog Items:
' Tracking Condition Set Dialog
Public Const LOW_RPM = 1
Public Const HIGH_RPM = 2
Public Const DELTA_RPM = 3
Public Const NOISE_RPM = 4
Public Const SLOPE = 5
Public Const TRACK_LINE = 6
Public Const PULSE_PER_REV = 7
Public Const RPM_DIVIDE = 8
Public Const MAX_ORDER = 9
Public Const PWR_MODE = 10
Public Const OCTAVE_TRACK = 11
Public Const MAX_ORD_TRACK = 12
Public Const ORDER_PEAK = 13
Public Const CONST_BAND = 14
Public Const BAND_WIDTH = 15
Public Const HI_SPEED_TRACK = 16
Public Const UP_DN_MEMORY = 17

' Analog Control Set Dialog
Public Const TRACK_FILTER = 1
Public Const SAMPLE_INPUT = 2
Public Const SAMPLE_SLOPE = 3
Public Const SAMPLE_COUPLE = 4
Public Const SAMPLE_LEVEL = 5
Public Const SLICE_LEVEL = 6

' Window Types
Public Const RECT = 1
Public Const HANN = 2
Public Const FLAT = 3
Public Const USER = 4
Public Const FORCE = 5
Public Const EXPO = 6

' Display Formats
Public Const ONE_FRAME = 1
Public Const TWO_FRAME = 2
Public Const THREE_FRAME = 3
Public Const FOUR_FRAME = 4
Public Const QUAD_FAME = 5

' Misc
Public Const RPM_ON As Byte = 4
Public Const SET_LINEAR = 0
Public Const SET_LOG = 1

'****************************************
'The functions in this module are NOT called in the
'VibMeasure program.  However, if any problems arise with the
'program, try including this file to see if it is trying to call
'one of these functions.
'*****************************************


'Not used in VibMeasure program! (I think)
Function FFTCurrentRPM(intFFT As Integer, sngRPM As Single) As Boolean
' Read the currently displayed rpm from the CF-5200
' Note: rpm display must be on or this func will return zero (see FFTSetRPMDisplay function)
' Args:
'       intFFT:     GPIB device descriptior
'       sngRPM:     single variable where current rpm will be stored
' Return:
'       Boolean     True if successful, False if funtion fails

  Dim strMesg As String
  Dim resp As Integer
  Dim strRPM As String

  strRPM = Space$(11)
     
  If Not FFTSendCmd(intFFT, "RRC") Then
    GoTo Err_FFTCurrentRPM
  End If

  If Not FFTReceiveString(intFFT, strRPM) Then
    GoTo Err_FFTCurrentRPM
  End If
   
  sngRPM = CSng(strRPM)
  FFTCurrentRPM = True

Exit_FFTCurrentRPM:
  Exit Function
 
Err_FFTCurrentRPM:
  strMesg = "GPIB ERROR !!" & Chr$(13) & Chr$(13) & "Function: FFTCurrentRPM" & Chr$(13) & "Error #" & iberr & ": " & GPIBErrorString(iberr)
  resp = MsgBox(strMesg, vbCritical + vbOKOnly, "CF-5200 GPIB")
  FFTCurrentRPM = False
  GoTo Exit_FFTCurrentRPM

End Function

'Not used in VibMeasure program! (I think)
Function SpectralLinesToTimePoints(intLines As Integer) As Integer

  SpectralLinesToTimePoints = intLines * 2.56

End Function
'Not used in VibMeasure program! (I think)
Function FFTSetWindow(intFFT As Integer, bytChannel As Byte, bytWinType As Byte) As Boolean
  Dim strCmd As String

  strCmd = "WIS" & Trim(Str(bytChannel)) & "," & Trim(Str(bytWinType))
 
  If FFTSendCmd(intFFT, strCmd) Then
     FFTSetWindow = True
   Else
     FFTSetWindow = False
  End If

End Function
'Not used in VibMeasure program! (I think)
Function WindowTextToByte(strWinType As String) As Byte

  Select Case strWinType
   Case "RECT"
      WindowTextToByte = RECT
   Case "HANN"
      WindowTextToByte = HANN
   Case "USER"
      WindowTextToByte = USER
   Case "FLAT"
      WindowTextToByte = FLAT
   Case "EXP"
      WindowTextToByte = EXPO
   Case "FORCE"
      WindowTextToByte = FORCE
   Case Else
      WindowTextToByte = HANN
  End Select

End Function
'Not used in VibMeasure program! (I think)
Function SlopeTextToByte(strSlope As String) As Byte

  Select Case strSlope
   Case "UP"
     SlopeTextToByte = SET_UP
   Case "DOWN"
     SlopeTextToByte = SET_DOWN
  End Select
  
End Function
'Not used in VibMeasure program! (I think)
Function FFTSetBlockLength(intFFT As Integer, intPoints As Integer) As Boolean
' Use this function to set the FFT block size.
' Valid sizes are: 64, 128, 256, 512, 1024, 2048, and 4096
' If you set intPoints to something other then one of the values above
' the CF-5200 will select the first valid block size greater then the
' value specified (e.g. if intPoints = 1098 then the block size will
' be set to 2048).  If you set intPoints > 4096 then 4096 is set.

  Dim strCmd As String

  strCmd = "FLS" & Trim(Str(intPoints))
 
  If FFTSendCmd(intFFT, strCmd) Then
     FFTSetBlockLength = True
   Else
     FFTSetBlockLength = False
  End If

End Function
'Not used in VibMeasure program! (I think)
Function FFTSetYScale(intFFT As Integer, bytScale As Byte) As Boolean

  Select Case bytScale
  
   Case SET_LINEAR
     If FFTSendCmd(intFFT, "YLI") Then
        FFTSetYScale = True
      Else
        FFTSetYScale = False
     End If
  
   Case SET_LOG
     If FFTSendCmd(intFFT, "YLO") Then
        FFTSetYScale = True
      Else
        FFTSetYScale = False
     End If
     
  End Select
 
End Function
'Not used in VibMeasure program! (I think)
Function FFTSetRPMDisplay(intFFT As Integer) As Boolean
' Set the rpm display function ON
 
  If Not FFTSendCmd(intFFT, "SKY8,3,1,3") Then
     FFTSetRPMDisplay = False
   Else
     FFTSetRPMDisplay = True
  End If

End Function

'Not used in VibMeasure program! (I think)
Function FFTSetOrderAnalysis(intFFT As Integer) As Boolean
' Set order analysis mode ON

  If Not FFTSendCmd(intFFT, "SKY8,3,1,4") Then
     FFTSetOrderAnalysis = False
   Else
     FFTSetOrderAnalysis = True
  End If

End Function

'Not used in VibMeasure program! (I think)
Function FFTSetAutoMemory(intFFT As Integer) As Boolean
' Set order tracking option auto memory function ON

  If Not FFTSendCmd(intFFT, "SKY8,3,1,6") Then
     FFTSetAutoMemory = False
   Else
     FFTSetAutoMemory = True
  End If

End Function

'Not used in VibMeasure program! (I think)
Function FFTSetDisplayFormat(intFFT As Integer, intFormat As Integer) As Boolean
' Set analyzer display format (num of display frames)
' Args:
'       intFFT:     GPIB device descriptior
'       intFormat:  display format:
'                       1: single frame
'                       2: dual frame
'                       3: three frame
'                       4: four frame
'                       5: four frame (QUAD)
' Return:
'       Boolean     True if successful, False if function fails
  
  Dim strCmd As String

  strCmd = "DFM" & Trim(Str(intFormat))
 
  If FFTSendCmd(intFFT, strCmd) Then
     FFTSetDisplayFormat = True
   Else
     FFTSetDisplayFormat = False
  End If

End Function


'Not used in VibMeasure program! (I think)
Function FFTSetActiveDisplayFrame(intFFT As Integer, intFrame As Integer) As Boolean
' specifies which frame will be active for next display command
' (similar to pressing the NEXT key on front panel)
  
  Dim strCmd As String

  strCmd = "ACT" & Trim(Str(intFrame))
 
  If FFTSendCmd(intFFT, strCmd) Then
     FFTSetActiveDisplayFrame = True
   Else
     FFTSetActiveDisplayFrame = False
  End If

End Function


'Not used in VibMeasure program! (I think)
Function FFTSetTrackingParameter(intFFT As Integer, intDialog As Integer, intItem As Integer, varSetting As Variant) As Boolean
' Generic function used to set any of the parameters for the order
' tracking option dialogs (this func is called by several other
' functions in this lib)
'
'Arguments:
'   intFFT:     GPIB device descriptor
'   intDialog:  Tracking dialog box
'   intItem:    Item in dialog to be set (numbered from top down)
'   varSetting: New setting value for specified item

  Dim strCmd As String
 
  strCmd = "TKS" & Trim(Str$(intDialog)) & ", " & Trim(Str$(intItem)) & ", " & Trim(varSetting)
 
  If FFTSendCmd(intFFT, strCmd) Then
     FFTSetTrackingParameter = True
   Else
     FFTSetTrackingParameter = False
  End If

End Function

'Not used in VibMeasure program! (I think)
Function FFTSetMaxOrder(intFFT As Integer, varMaxOrd As Variant) As Boolean
' This function will set maximum analyzed order range.  If the parameter varMaxOrd
' is less then 400 the CF-5200 will select the nearest valid order range and no error
' will occur.  If varMaxOrd is > 400 then 400 is set.
 
  If varMaxOrd > 400 Then
     varMaxOrd = 400
  End If
  
  If FFTSetTrackingParameter(intFFT, TRACK_COND_DLG, MAX_ORDER, varMaxOrd) Then
     FFTSetMaxOrder = True
   Else
     FFTSetMaxOrder = False
  End If

End Function

'Not used in VibMeasure program! (I think)
Function FFTSetLowRPM(intFFT As Integer, varLowRPM As Variant) As Boolean
 
  If FFTSetTrackingParameter(intFFT, TRACK_COND_DLG, LOW_RPM, varLowRPM) Then
     FFTSetLowRPM = True
   Else
     FFTSetLowRPM = False
  End If

End Function

'Not used in VibMeasure program! (I think)
Function FFTSetHighRPM(intFFT As Integer, varHighRPM As Variant) As Boolean
 
  If FFTSetTrackingParameter(intFFT, TRACK_COND_DLG, HIGH_RPM, varHighRPM) Then
     FFTSetHighRPM = True
   Else
     FFTSetHighRPM = False
  End If

End Function

'Not used in VibMeasure program! (I think)
Function FFTSetDeltaRPM(intFFT As Integer, varDeltaRPM As Variant) As Boolean
 
  If FFTSetTrackingParameter(intFFT, TRACK_COND_DLG, DELTA_RPM, varDeltaRPM) Then
     FFTSetDeltaRPM = True
   Else
     FFTSetDeltaRPM = False
  End If

End Function

'Not used in VibMeasure program! (I think)
Function FFTSetTrackingSlope(intFFT As Integer, varSlope As Variant) As Boolean
 
  If FFTSetTrackingParameter(intFFT, TRACK_COND_DLG, SLOPE, varSlope) Then
     FFTSetTrackingSlope = True
   Else
     FFTSetTrackingSlope = False
  End If

End Function

'Not used in VibMeasure program! (I think)
Function FFTSetPulsePerRev(intFFT As Integer, varPulse As Variant) As Boolean
 
  If FFTSetTrackingParameter(intFFT, TRACK_COND_DLG, PULSE_PER_REV, varPulse) Then
     FFTSetPulsePerRev = True
   Else
     FFTSetPulsePerRev = False
  End If

End Function

'Not used in VibMeasure program! (I think)
Function FFTSetExtSampleInput(intFFT As Integer, varInput As Variant) As Boolean
 
  If FFTSetTrackingParameter(intFFT, ANALOG_EXT_DLG, SAMPLE_INPUT, varInput) Then
     FFTSetExtSampleInput = True
   Else
     FFTSetExtSampleInput = False
  End If

End Function

'Not used in VibMeasure program! (I think)
Function FFTSetExtSampleSlope(intFFT As Integer, varSlope As Variant) As Boolean
 
  If FFTSetTrackingParameter(intFFT, ANALOG_EXT_DLG, SAMPLE_SLOPE, varSlope) Then
     FFTSetExtSampleSlope = True
   Else
     FFTSetExtSampleSlope = False
  End If

End Function

'Not used in VibMeasure program! (I think)
Function FFTSetExtSampleCouple(intFFT As Integer, varCouple As Variant) As Boolean
 
  If FFTSetTrackingParameter(intFFT, ANALOG_EXT_DLG, SAMPLE_COUPLE, varCouple) Then
     FFTSetExtSampleCouple = True
   Else
     FFTSetExtSampleCouple = False
  End If

End Function

'Not used in VibMeasure program! (I think)
Function FFTSetExtSampleInputRange(intFFT As Integer, varRange As Variant) As Boolean
 
  If FFTSetTrackingParameter(intFFT, ANALOG_EXT_DLG, SAMPLE_LEVEL, varRange) Then
     FFTSetExtSampleInputRange = True
   Else
     FFTSetExtSampleInputRange = False
  End If

End Function

'Not used in VibMeasure program! (I think)
Function FFTSetExtSampleSliceLevel(intFFT As Integer, varLevel As Variant) As Boolean
 
  If FFTSetTrackingParameter(intFFT, ANALOG_EXT_DLG, SLICE_LEVEL, varLevel) Then
     FFTSetExtSampleSliceLevel = True
   Else
     FFTSetExtSampleSliceLevel = False
  End If

End Function

'Not used in VibMeasure program! (I think)
Function FFTClearAllBlockMemory(intFFT As Integer) As Boolean
' Clears all block memory

  If Not FFTSendCmd(intFFT, "CMC") Then
     FFTClearAllBlockMemory = False
   Else
     FFTClearAllBlockMemory = True
  End If

End Function

'Not used in VibMeasure program! (I think)
Function FFTSetBlockMemoryAddress(intFFT As Integer, intAddr As Integer) As Boolean
  Dim strCmd As String

  strCmd = "MBS" & Trim(Str$(intAddr))
  If Not FFTSendCmd(intFFT, strCmd) Then
     FFTSetBlockMemoryAddress = False
   Else
     FFTSetBlockMemoryAddress = True
  End If

End Function

'Not used in VibMeasure program! (I think)
Function FFTReadMemoryBlock(sngData() As Single, intFFT As Integer, intBlock As Integer)
  Dim intLines As Integer
  Dim i As Integer

  'Dim strRtn As String
  ' LOOPS TWICE DUE TO INTERFACE PROBLEM WITH CF-5200
  ' Determine number of points on analyzer display (single frame display)
  If Not FFTDisplayDataPoints(intFFT, intLines) Then
   GoTo Err_FFTReadMemoryBlock
  End If
    
  For i = 0 To (intLines - 1)   ' intLines indicates num of data points in spectrum display
   sngData(i) = 0               ' starting at 1 and going to num of points (sngData() is zero based)
  Next i
   
  Call Send(GPIB_BOARD, ONO_FFT_ADR, "DMS4", NLend)
  Call Send(GPIB_BOARD, ONO_FFT_ADR, "WDR1", NLend)
  Call Receive32(GPIB_BOARD, ONO_FFT_ADR, sngData(0), (intLines * 4 + 2), STOPend)

  If ibcntl = 0 Then
   ' Determine number of points on analyzer display (single frame display)
   If Not FFTDisplayDataPoints(intFFT, intLines) Then
    GoTo Err_FFTReadMemoryBlock
   End If
   For i = 0 To (intLines - 1)   ' intLines indicates num of data points in spectrum display
    sngData(i) = 0               ' starting at 1 and going to num of points (sngData() is zero based)
   Next i
 
   Call Send(GPIB_BOARD, ONO_FFT_ADR, "DMS4", NLend)
   Call Send(GPIB_BOARD, ONO_FFT_ADR, "WDR1", NLend)
   Call Receive32(GPIB_BOARD, ONO_FFT_ADR, sngData(0), (intLines * 4 + 2), STOPend)
  End If

  FFTReadMemoryBlock = True
  
Exit_FFTReadMemoryBlock:
  Exit Function
 
Err_FFTReadMemoryBlock:
  FFTReadMemoryBlock = False
  GoTo Exit_FFTReadMemoryBlock
  
End Function

'Not used in VibMeasure program! (I think)
Function ConvertToSingle(strData As String) As Single
  Dim A As Byte
  Dim B As Byte
  Dim c As Byte
  Dim D As Byte
  Dim S As Byte
  Dim E As Byte
  Dim Elsb As Byte
  Dim Ex As Integer
  Dim F As Double
  Dim X As Long

  A = AscB(Mid$(strData, 1, 1))
  B = AscB(Mid$(strData, 2, 1))
  c = AscB(Mid$(strData, 3, 1))
  D = AscB(Mid$(strData, 4, 1))
  
  S = A \ 128

  E = A And 127  ' lower 7 bits of byte A are part of the exponent
  E = E * 2      ' shift all bits left one bit (leaving LSB open)
  Elsb = B \ 128 ' the MSB of byte B is LSB of the exponent
  E = E + Elsb   ' add the LSB to exponent

  If (E = 0) Then       ' Mantissa is between 0 and 1
     Ex = -126              ' if the exponent byte is set to zero
                            ' then the exponent is fixed at -126
   Else                 ' Mantiss is between 1 and 2
     Ex = CInt(E) - 127           ' otherwise subtract the 127 bias from
  End If                   ' the exponent byte

  B = B And 127 ' remove Elsb from B
  If (E <> 0) Then
    B = B + 128 ' add hidden bit to B (Mantiss is between 1 and 2)
  End If

  F = (B * (2 ^ -7)) + (c * (2 ^ -15)) + (D * (2 ^ -23))

  F = (2 ^ Ex) * F

  If (S = 1) Then
     ConvertToSingle = -F  ' Value is negative number
   Else
     ConvertToSingle = F   ' Value is positive number
  End If

End Function
'Not used in VibMeasure program! (I think)
Function FFTDataTypeInCurrentBlock(intFFT As Integer, intType As Integer) As Boolean
  Dim strReturn As String
  Dim strMesg As String      ' message box text
  Dim resp As Integer        ' user response from MesgBox

  strReturn = Space$(10)
     
  If Not FFTSendCmd(intFFT, "MSC") Then
    GoTo Err_FFTDataTypeInCurrentBlock
  End If

  If Not FFTReceiveString(intFFT, strReturn) Then
    GoTo Err_FFTDataTypeInCurrentBlock
  End If
   
  ' This will return zero if mem block is empty
  ' or the data type (as integer) if valid data exists
  intType = Val(Mid$(strReturn, 2, 3))
  FFTDataTypeInCurrentBlock = True

Exit_FFTDataTypeInCurrentBlock:
  Exit Function
 
Err_FFTDataTypeInCurrentBlock:
  strMesg = "GPIB ERROR !!" & Chr$(13) & Chr$(13) & "Function: FFTDataTypeInCurrentBlock = True" & Chr$(13) & "Error #" & iberr & ": " & GPIBErrorString(iberr)
  resp = MsgBox(strMesg, vbCritical + vbOKOnly, "CF-5200 GPIB")
  FFTDataTypeInCurrentBlock = True
  GoTo Exit_FFTDataTypeInCurrentBlock

End Function
'Not used in VibMeasure program! (I think)
Function BlockNumToChannel(intBlk As Integer) As Byte
' When auto-storing two channels of data to block memory the channels
' will be interleaved (ch1, ch2, ch1, ch2, etc..) in block memory
' This function will determine which channel is stored in a particular
' memory block (assuming storage started at block number one)
  
  Dim IsEven As Integer

  IsEven = intBlk Mod 2
  If (IsEven = 0) Then
     BlockNumToChannel = 2
   Else
     BlockNumToChannel = 1
  End If

End Function
'Not used in VibMeasure program! (I think)
Function FFTRecallCurrentMemoryBlock(intFFT As Integer) As Boolean
' Recalls current memory block to the display (same as pressing
' the RECALL key on the front panel)

  If Not FFTSendCmd(intFFT, "MRC") Then
     FFTRecallCurrentMemoryBlock = False
   Else
     FFTRecallCurrentMemoryBlock = True
  End If

End Function
'Not used in VibMeasure program! (I think)
Function FFTDisplayDataPoints(intFFT As Integer, intPoints As Integer) As Boolean
' Returns the number of data points in the currently displayed data

  Dim strReturn As String
  Dim strMesg As String      ' message box text
  Dim resp As Integer        ' user response from MesgBox

  strReturn = Space$(10)
     
  If Not FFTSendCmd(intFFT, "WLC1") Then
    GoTo Err_FFTDisplayDataPoints
  End If

  If Not FFTReceiveString(intFFT, strReturn) Then
    GoTo Err_FFTDisplayDataPoints
  End If
   
  intPoints = Val(strReturn)
  FFTDisplayDataPoints = True

Exit_FFTDisplayDataPoints:
  Exit Function
 
Err_FFTDisplayDataPoints:
  strMesg = "GPIB ERROR !!" & Chr$(13) & Chr$(13) & "Function: FFTDisplayDataPoints" & Chr$(13) & "Error #" & iberr & ": " & GPIBErrorString(iberr)
  resp = MsgBox(strMesg, vbCritical + vbOKOnly, "CF-5200 GPIB")
  FFTDisplayDataPoints = False
  GoTo Exit_FFTDisplayDataPoints

End Function
'Not used in VibMeasure program! (I think)
Function FFTReadMemoryRPM(intFFT As Integer, sngRPM As Single) As Boolean
' Reads the rpm value that was stored with data stored in block memory

  Dim strData As String
  Dim strHeader As String

  strData = Space$(4096)
  strHeader = Space$(512)
  
  ' Read data currently on analyzer display
  If Not FFTSendCmd(intFFT, "CRD") Then
    GoTo Err_FFTReadMemoryRPM
  End If

  If Not FFTReceiveString(intFFT, strData) Then
    GoTo Err_FFTReadMemoryRPM
  End If
     
  If Not FFTReceiveString(intFFT, strHeader) Then
    GoTo Err_FFTReadMemoryRPM
  End If
     
  sngRPM = ConvertToSingle(Mid$(strHeader, 261, 4))
  
  FFTReadMemoryRPM = True
  
Exit_FFTReadMemoryRPM:
  Exit Function
 
Err_FFTReadMemoryRPM:
  FFTReadMemoryRPM = False
  GoTo Exit_FFTReadMemoryRPM
 
End Function

