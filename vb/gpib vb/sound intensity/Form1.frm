VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form Form1 
   BackColor       =   &H00C0E0FF&
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Oskiread"
   ClientHeight    =   4815
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   7455
   FillColor       =   &H00C0E0FF&
   ForeColor       =   &H00C0E0FF&
   LinkMode        =   1  'Source
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   4815
   ScaleWidth      =   7455
   StartUpPosition =   2  'CenterScreen
   Begin VB.TextBox Text3 
      Height          =   375
      Left            =   5760
      TabIndex        =   4
      Text            =   "1"
      Top             =   120
      Width           =   735
   End
   Begin VB.CommandButton Command2 
      Caption         =   "SAVE"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   1440
      TabIndex        =   3
      ToolTipText     =   "Click to Save to File After DAta collected"
      Top             =   120
      Width           =   975
   End
   Begin VB.TextBox Text2 
      BackColor       =   &H00004000&
      BeginProperty Font 
         Name            =   "Courier"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0080FF80&
      Height          =   3015
      Left            =   240
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   1
      Text            =   "Form1.frx":0000
      Top             =   1200
      Width           =   6855
   End
   Begin VB.CommandButton Command1 
      Caption         =   "START"
      Default         =   -1  'True
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   240
      TabIndex        =   0
      Top             =   120
      Width           =   975
   End
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   2760
      Top             =   120
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      BackColor       =   &H00C0E0FF&
      Caption         =   "MM Location"
      Height          =   375
      Left            =   4920
      TabIndex        =   5
      Top             =   120
      Width           =   735
   End
   Begin VB.Label Label2 
      Alignment       =   2  'Center
      BackColor       =   &H00C0E0FF&
      Caption         =   "DATA/INSTRUCTION DISPLAY"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   2040
      TabIndex        =   2
      Top             =   4320
      Width           =   3135
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'CLICK1: START BUTTON
Private Sub Command1_Click()
'Pads data string form ONO_Sokki FFT into variable stringv (declared in
'separate general module). Stringv is stored as a CSV user specified file.
'This module uses the LDD command (AMF mode) to acquire a range o fMAss Memory
'Blocks at one time.


' Sept 29 2001
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

'Get user inputs
startmem = Text3.Text

' Change mouse pointer to hourglass.
Screen.MousePointer = vbHourglass

'parse the user entries
If startmem < 1 Then
    MsgBox "All user entries must be integers >0. Restarting"
    GoTo errhandler
ElseIf startmem > 60 Then
    MsgBox "memory addresss must be  < 60. Restarting"
    GoTo errhandler
End If

Text2.SetFocus
Text2.Text = "Acquiring " & noblks & " blocks of display data"

'Set up Ono Sokki for SI readings using NI488 calls

'SI Mode prelim commands
Call ibwrt(ONO_SOKKI, "AMO")            'SI On
'Standard Mode GPIB Prelim
Call ibwrt(ONO_SOKKI, "AMF")

'Use LDD to read all points at once
stringv = ""
    
If startmem < 10 Then
    memstr = "MBS00" & startmem
Else
    memstr = "MBS0" & startmem
End If
   
Call ibwrt(ONO_SOKKI, memstr)       'Specify memory location
If (ibsta And EERR) Then
    MsgBox "Error Sending  MM Block No"
    GoTo errhandler
End If
    
Call ibwrt(ONO_SOKKI, "MRC")         'Recall memory
If (ibsta And EERR) Then
    MsgBox "Error Recalling  MM Block"
    GoTo errhandler
End If
  
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
        send_str(istr) = Replace(send_str(istr), "......", "0.0")
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

Exit Sub

errhandler:
'All GPIB errors
Screen.MousePointer = vbDefault
Exit Sub

errhandler1:
MsgBox "Unknown Unit Type Received. Exiting"
Screen.MousePointer = vbDefault
Exit Sub

errhandler2:
MsgBox "Invalid counts entered"
Screen.MousePointer = vbDefault
Exit Sub


End Sub
'Unresolved Issues/possible upgrade paths:
'[] Real Time Display Update and/or synchronization with data Rx
'[] Automation of Trace setup and transfer for mutli-trace records

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


'Output Instructions
Text2.Text = _
"This program uses the Analyser GPIB interface to read CRT memory data " _
& vbCrLf & "The program uses the more reliable ASCII transfer. It reads" _
& vbCrLf & "SPectra and Time graphs: " _
& vbCrLf & "[] Spectra take approx 6 secs (401 points)." _
& vbCrLf & "[] Time displays take about 11 sec (1024 points)" _
& vbCrLf & "" _
& vbCrLf & "Please ensure that the FFT Analyser:" _
& vbCrLf & "[] Is connected to the GPIB port of the PC" _
& vbCrLf & "[] Has the required display data stored in a CRT memory block" _
& vbCrLf & "[] Has the GPIB Mode set to Address (Menu C/Others/GPIB/Address)" _
& vbCrLf _
& vbCrLf & "Data Read Operation..." _
& vbCrLf & "[] To start readings enter the CRT Memory Number (any of 1 to 60) in the box above" _
& vbCrLf & "[] Press the START button when ready" _
& vbCrLf & "[] Use the SAVE button to file the acquird data" _
& vbCrLf & "The data is stored in a CSV formatted text file,with x data in column 1, y data in col. 2" _
& vbCrLf & "Note OnoSokki's ......dBXXX reference is changed to 0.0dBXXX"

'Inititialise the system
Call Start_ONOSOKKI


End Sub

Private Sub Form_Unload(Cancel As Integer)
'END_ONOSOKKI declared in genereal module

Call End_ONOSOKKI

End Sub

