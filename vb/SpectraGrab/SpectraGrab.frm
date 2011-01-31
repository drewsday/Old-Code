VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{65E121D4-0C60-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCHRT20.OCX"
Begin VB.Form Form1 
   Caption         =   "SpectraGrab"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin MSChart20Lib.MSChart MSChart1 
      Height          =   1695
      Left            =   120
      OleObjectBlob   =   "SpectraGrab.frx":0000
      TabIndex        =   3
      Top             =   840
      Width           =   4335
   End
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   3480
      Top             =   2760
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Save To File"
      Height          =   495
      Left            =   1560
      TabIndex        =   2
      Top             =   2640
      Width           =   1215
   End
   Begin VB.TextBox Text2 
      Height          =   375
      Left            =   120
      ScrollBars      =   3  'Both
      TabIndex        =   1
      Top             =   240
      Width           =   4215
   End
   Begin VB.CommandButton cmdGetData 
      Caption         =   "Get Data"
      Height          =   495
      Left            =   120
      TabIndex        =   0
      Top             =   2640
      Width           =   1215
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmdGetData_Click()

'Declare Strings
Dim send_str As Variant
Dim reading As String      'Single string response storage
Dim Units(14) As String
Dim memstr As String

'Declare Other Parameters
Dim noblks As Integer       'Number of Blocks
Dim startmem As Integer     'Start mass memory no.
Dim endmem As Integer       'end mass memory no.
Dim memcount As Integer
Dim nounits As Integer


'Define All Possible Unit Strings
Units(1) = "W/m2"
Units(2) = "Pa"
Units(3) = "m/s"
Units(4) = "dBRIL"
Units(5) = "dBSPL"
Units(6) = "dBPVL"
Units(7) = "dBV"
Units(8) = "dB"         'List last as is a substring of dBRIL, dBPVL
Units(9) = "mV"
Units(10) = "V"
Units(11) = "kHz"
Units(12) = "Hz"
Units(13) = "mSEC"
Units(14) = "SEC"

nounits = 14

' Change mouse pointer to hourglass.
Screen.MousePointer = vbHourglass

Text2.SetFocus
Text2.Text = "Acquiring "

'Find out what type of data is stored. read unit on X axis
Call ibwrt(ONO_SOKKI, "LDD1,0,0")
If (ibsta And EERR) Then
    MsgBox "Error Writing LDD Command"
    GoTo errhandler
End If

reading = Space(30)             'Initialise read buffer
Call ibrd(ONO_SOKKI, reading)
If (ibsta And EERR) Then
    MsgBox "Error in ibsta Sending Read Command"
    GoTo errhandler
End If
If (ibsta And TIMO) Then
    MsgBox "GPIB Timeout on read Command"
    GoTo errhandler
End If
    
If Replace(reading, "Hz", "") <> reading Then
    noblks = 401
Else
    noblks = 1024
End If


'Initialise reading string buffer to accomodate max expected response
Call ibwrt(ONO_SOKKI, "LDD3,0," & Trim(Str(noblks)))
If (ibsta And EERR) Then
    MsgBox "Error Writing LDD Command"
    GoTo errhandler
End If
    
For i = 0 To noblks - 1
    reading = Space(30)
    Call ibrd(ONO_SOKKI, reading)
    If (ibsta And EERR) Then
        MsgBox "Error in ibsta Sending Read Command"
        GoTo errhandler
    End If
    If (ibsta And TIMO) Then
        MsgBox "GPIB Timeout on read Command"
        GoTo errhandler
    End If
'Take out unit references
    send_str = Split(reading, ",")
    send_str(1) = Replace(reading, send_str(0), "")
    reading = send_str(0)
    kx = 0
    ky = 0
'Find which unit is used and extract it. Unit may be placed in Header
    While send_str(0) = reading
        kx = kx + 1
        If kx > nounits Then           'No units found??!!
            MsgBox "Warning! Unknown Unit type Received or none specified"
        End If
        send_str(0) = Replace(reading, Units(kx), "")
    Wend
        
    reading = send_str(1)
        
    While send_str(1) = reading
        ky = ky + 1
        If ky > nounits Then           'No units found??!!
            MsgBox "Warning! Unknown Unit type Received or none specified"
        End If
        send_str(1) = Replace(reading, Units(ky), "")
    Wend
    
 'Replace Ono Sokki's -infinity reference (......) with 0
    For istr = 0 To 1
        send_str(istr) = Replace(send_str(istr), "......", "NaN")
        send_str(istr) = Replace(send_str(istr), ",", "")
        send_str(istr) = Replace(send_str(istr), vbCrLf, "")   'AND take out CRLF
        send_str(istr) = Trim(send_str(istr))                   'remove extra spaces
    Next
    
    If i < noblks - 1 Then
    stringv = stringv & send_str(0) & "," & send_str(1) & vbNewLine
    Else
    stringv = stringv & send_str(0) & "," & send_str(1)
    End If
    
Next     'Next noblks

'Output to Screen
Text2.Text = "Data Acquired(" & Units(ky) & "," & Units(kx) & "):" & vbNewLine _
& stringv

Screen.MousePointer = vbDefault

errhandler:
'All GPIB errors
Screen.MousePointer = vbDefault
Exit Sub


End Sub


'CLICK2: SAVE BUTTON
Private Sub Command2_Click()
  Dim F As Integer
  
  'Did user cancel?
  CommonDialog1.CancelError = True
  On Error GoTo errhandler
  
  ' Set CommonDialog flags
  CommonDialog1.Flags = cdlOFNOverwritePrompt
 
  ' Set filters
  CommonDialog1.Filter = "All Files (*.*)|*.*|Text Files" & _
  "(*.csv)|*.csv|Text Files (*.txt)|*.txt"
  ' Specify default filter
  CommonDialog1.FilterIndex = 2
  
  ' Display the Save dialog box
  CommonDialog1.ShowSave
  
  ' Get name of selected file
  File_name_str = CommonDialog1.filename
   'Open specified file
  
  F = FreeFile                  'Get next available record no
  Open File_name_str For Output As #F
  Print #F, stringv
  Close #F   ' Close file.

  Exit Sub
  
errhandler:
  'User pressed the Cancel button
  Exit Sub


End Sub


Private Sub Form_Load()

'Inititialise the system
Call Start_ONOSOKKI


End Sub

Private Sub Form_Unload(Cancel As Integer)
'END_ONOSOKKI declared in genereal module

Call End_ONOSOKKI

End Sub


