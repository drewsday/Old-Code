VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form frmMain 
   BackColor       =   &H0000C000&
   Caption         =   "Vibration Measurements"
   ClientHeight    =   6675
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9975
   LinkTopic       =   "Form1"
   ScaleHeight     =   6675
   ScaleWidth      =   9975
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtNotes 
      Height          =   1215
      Left            =   360
      TabIndex        =   32
      Top             =   5160
      Width           =   4695
   End
   Begin VB.Frame Frame1 
      BackColor       =   &H0000C000&
      Caption         =   "Set Label"
      Height          =   1095
      Left            =   5400
      TabIndex        =   29
      Top             =   1440
      Width           =   4335
      Begin VB.TextBox txtLabel 
         Height          =   285
         Left            =   240
         TabIndex        =   31
         Text            =   " "
         Top             =   480
         Width           =   3255
      End
      Begin VB.CommandButton cmdSetLabel 
         Caption         =   "Set "
         Height          =   495
         Left            =   3600
         TabIndex        =   30
         Top             =   360
         Width           =   495
      End
   End
   Begin VB.PictureBox Picture1 
      BackColor       =   &H0000C000&
      BorderStyle     =   0  'None
      Height          =   495
      Left            =   3120
      Picture         =   "main.frx":0000
      ScaleHeight     =   495
      ScaleWidth      =   495
      TabIndex        =   5
      Top             =   1800
      Width           =   495
      Begin VB.PictureBox Picture2 
         Height          =   135
         Left            =   600
         ScaleHeight     =   135
         ScaleWidth      =   15
         TabIndex        =   6
         Top             =   240
         Width           =   15
      End
   End
   Begin VB.CommandButton cmdOpen 
      Caption         =   "Save"
      Height          =   615
      Left            =   5640
      TabIndex        =   23
      Top             =   3840
      Width           =   1215
   End
   Begin VB.Frame frameEUSetting 
      BackColor       =   &H0000C000&
      Caption         =   "EU Setting:"
      Height          =   1935
      Left            =   240
      TabIndex        =   14
      Top             =   2760
      Width           =   4935
      Begin VB.TextBox txtEUValue 
         Height          =   285
         Left            =   2400
         TabIndex        =   20
         Top             =   480
         Width           =   1095
      End
      Begin VB.TextBox txtEUName 
         Height          =   285
         Left            =   2400
         TabIndex        =   19
         Top             =   960
         Width           =   1095
      End
      Begin VB.Frame frameChannel 
         Caption         =   "Channel:"
         Height          =   1335
         Left            =   240
         TabIndex        =   16
         Top             =   360
         Width           =   1095
         Begin VB.OptionButton optChannel 
            Caption         =   "CH1"
            Height          =   255
            Index           =   0
            Left            =   240
            TabIndex        =   18
            Top             =   360
            Width           =   735
         End
         Begin VB.OptionButton optChannel 
            Caption         =   "CH2"
            Height          =   255
            Index           =   1
            Left            =   240
            TabIndex        =   17
            Top             =   840
            Width           =   735
         End
      End
      Begin VB.CommandButton cmdSet 
         Caption         =   "SET"
         Height          =   495
         Left            =   3720
         TabIndex        =   15
         Top             =   600
         Width           =   1095
      End
      Begin VB.Label lblEUValue 
         BackColor       =   &H0000C000&
         Caption         =   "V/EU Value:"
         Height          =   255
         Left            =   1440
         TabIndex        =   22
         Top             =   480
         Width           =   975
      End
      Begin VB.Label lblEUName 
         BackColor       =   &H0000C000&
         Caption         =   "EU Name:"
         Height          =   255
         Left            =   1560
         TabIndex        =   21
         Top             =   960
         Width           =   735
      End
   End
   Begin VB.CommandButton cmdPause 
      Caption         =   "Pause "
      Height          =   615
      Left            =   6960
      TabIndex        =   13
      Top             =   3120
      Width           =   1215
   End
   Begin VB.CommandButton cmdStart 
      Caption         =   "Start "
      Height          =   615
      Left            =   5640
      TabIndex        =   12
      Top             =   3120
      Width           =   1215
   End
   Begin VB.Frame Frame3 
      BackColor       =   &H0000C000&
      Caption         =   "Enter the number of data points per sample."
      Height          =   1095
      Left            =   240
      TabIndex        =   3
      Top             =   240
      Width           =   4935
      Begin VB.ComboBox cmboPoints 
         Height          =   315
         Left            =   360
         TabIndex        =   25
         Top             =   480
         Width           =   2055
      End
      Begin VB.CommandButton cmdPoints 
         Caption         =   "Set # points"
         Height          =   495
         Left            =   2760
         TabIndex        =   4
         Top             =   360
         Width           =   1815
      End
   End
   Begin VB.Frame Frame2 
      BackColor       =   &H0000C000&
      Caption         =   "Enter the maximum frequency of desired range."
      Height          =   1095
      Left            =   5400
      TabIndex        =   1
      Top             =   240
      Width           =   4335
      Begin VB.ComboBox cmboFreq 
         Height          =   315
         Left            =   120
         TabIndex        =   26
         Top             =   480
         Width           =   2055
      End
      Begin VB.CommandButton cmdFreq 
         Caption         =   "Set Max Freq"
         Height          =   495
         Left            =   2280
         TabIndex        =   2
         Top             =   360
         Width           =   1815
      End
   End
   Begin VB.CommandButton Close 
      Caption         =   "Exit"
      Height          =   615
      Left            =   8280
      TabIndex        =   0
      Top             =   3840
      Width           =   1215
   End
   Begin VB.Frame Frame4 
      BackColor       =   &H0000C000&
      Caption         =   "Adjust Input Voltage Ranges"
      Height          =   1095
      Left            =   240
      TabIndex        =   7
      Top             =   1440
      Width           =   4935
      Begin VB.PictureBox Picture3 
         BackColor       =   &H0000C000&
         BorderStyle     =   0  'None
         Height          =   495
         Left            =   3480
         Picture         =   "main.frx":0442
         ScaleHeight     =   495
         ScaleWidth      =   495
         TabIndex        =   10
         Top             =   360
         Width           =   495
         Begin VB.PictureBox Picture4 
            Height          =   135
            Left            =   600
            ScaleHeight     =   135
            ScaleWidth      =   15
            TabIndex        =   11
            Top             =   240
            Width           =   15
         End
      End
      Begin VB.OptionButton optChan 
         BackColor       =   &H0000C000&
         Caption         =   "Channel B"
         Height          =   255
         Index           =   1
         Left            =   120
         TabIndex        =   9
         Top             =   720
         Width           =   1335
      End
      Begin VB.OptionButton optChan 
         BackColor       =   &H0000C000&
         Caption         =   "Channel A"
         Height          =   255
         Index           =   0
         Left            =   120
         TabIndex        =   8
         Top             =   360
         Width           =   1335
      End
   End
   Begin VB.Frame Frame5 
      BackColor       =   &H0000C000&
      Height          =   1935
      Left            =   5400
      TabIndex        =   24
      Top             =   2760
      Width           =   4335
      Begin VB.CommandButton cmdReset 
         Caption         =   "Reset Analyzer"
         Height          =   615
         Left            =   1560
         TabIndex        =   28
         Top             =   1080
         Width           =   1215
      End
      Begin VB.CommandButton cmdAverage 
         Caption         =   "Average"
         Height          =   615
         Left            =   2880
         TabIndex        =   27
         Top             =   360
         Width           =   1215
      End
   End
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   6480
      Top             =   3960
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Frame Frame6 
      BackColor       =   &H0000C000&
      Caption         =   "Notes"
      Height          =   1575
      Left            =   240
      TabIndex        =   33
      Top             =   4920
      Width           =   4935
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit



Private Sub Form_Load()
  
  FillComboBoxes
  ' establish comms with CF-5200 analyzer
  If Not FFTOpenComm(fft%) Then
    Call ReportError("Could not open device FFT")
  End If

'Set to peak hold average mode

If Not FFTSendCmd(fft%, "AMS3") Then
    ReportError ("Error sending GPIB command string.")
  End If
  If Not FFTSendCmd(fft%, "AVO") Then
    ReportError ("Error sending GPIB command string.")
  End If
  
  'Set to dual display mode.
  
  If Not FFTSendCmd(fft%, "DFM2") Then
    ReportError ("Error sending GPIB command string.")
  End If
  
  If Not FFTSendCmd(fft%, "ACT1") Then
    ReportError ("Error sending GPIB command string.")
  End If
  
  'Set display 1 to Channel A spectrum (Real).
  
  If Not FFTSendCmd(fft%, "WAV21,1") Then
    ReportError ("Error setting display one to Channel A spectrum.")
  End If
  
  
  'Set display 2 to power spectrum, channel B
  If Not FFTSendCmd(fft%, "ACT2") Then
    ReportError ("Error sending GPIB command string.")
  End If
  
  If Not FFTSendCmd(fft%, "WAV22,1") Then
    ReportError ("Error setting display 2.")
  End If
  
End Sub

Private Sub cmdAverage_Click()  'Check to make sure this works!!

If Not FFTSendCmd(fft%, "AND50") Then
    ReportError ("Error sending GPIB command string.")
  End If

If Not FFTSendCmd(fft%, "AVO") Then
    ReportError ("Error sending GPIB command string.")
  End If

End Sub

Private Sub cmdFreq_Click()

If Not FFTSendCmd(fft%, "FRQ" + Trim(cmboFreq.Text)) Then
    ReportError ("Error sending GPIB command string.")
  End If

End Sub

Private Sub cmdPause_Click()
If Not FFTSendCmd(fft%, "CPS") Then
    ReportError ("Error sending GPIB command string.")
  End If
End Sub

Private Sub cmdPoints_Click()
If Not FFTSendCmd(fft%, "FLS" + Trim(cmboPoints.Text)) Then
    ReportError ("Error sending GPIB command string.")
  End If
End Sub

Private Sub cmdOpen_Click()

Dim sngData(2048) As Single
Dim i As Integer
Dim j As Integer
Dim k As Single
Dim F As Integer
Dim DataFile As String
Dim sngFrange As Single
'Dim sngRes As Single
Dim deltaF As Single
Dim arrArray(1 To 3, 1 To 802)
Dim strRecord As String

F = FreeFile
 
' call to a common dialog box to prompt for file name
CommonDialog1.ShowOpen
DataFile = CommonDialog1.filename
Open DataFile For Output As #F
  
'Read Channel A info and write to file
   If Not FFTReadDisplayData(sngData()) Then
    MsgBox "Error reading data."
   End If
   
   For i = 1 To 802 'should be 802 for one channel
     'Write #F, sngData(i)
     arrArray(1, i) = sngData(i - 1)
   Next i
   
'Read Channel B info and write to file
   If Not FFTReadDisplayDataB(sngData()) Then
    MsgBox "Error reading data."
   End If
   
   For i = 1 To 802 'should be 802 for one channel
     'Write #F, sngData(i)
     arrArray(2, i) = sngData(i - 1)
   Next i

'Read X axis info does not work properly, routine below will work for 800 line spectrum only!
   'If Not FFTReadDisplayDataX(sngData()) Then
   ' MsgBox "Error reading X axis."
   'End If
   
   'For i = 1 To 802
   '  arrArray(3, i) = sngData(i - 1)
   'Next i
       
   deltaF = Trim(Text1.Text) / 800

   For k = 0 To 800
    arrArray(1, k + 1) = k * deltaF
   Next k
       
   For j = 1 To 802
        Print #F, arrArray(3, j) & ","; arrArray(1, j) & ","; arrArray(2, j)
   Next j
   
   Close #F
  
  
End Sub

Private Sub cmdSet_Click()
 Dim i As Integer
  Dim bytChannel As Byte

  For i = 0 To 1
   If optChannel(i).value Then
    bytChannel = CByte(i + 1)
    Exit For
   End If
  Next i
 
  If Not FFTSetEUValue(fft%, bytChannel, CSng(txtEUValue.Text)) Then
    ReportError ("Error setting EU value.")
  End If
  If Not FFTSetEUName(fft%, bytChannel, txtEUName.Text) Then
    ReportError ("Error setting EU name.")
  End If
  If Not FFTEUOn(fft%) Then
    ReportError ("Error setting EU function on.")
  End If
End Sub

Private Sub cmdStart_Click()

If Not FFTSendCmd(fft%, "CST") Then
    ReportError ("Error sending GPIB command string.")
  End If
  
End Sub



Private Sub Picture1_Click()

Dim intRng As Integer
Dim intCh As Integer
Dim strCmd As String
Dim i As Integer
  

  For i = 0 To 1
   If optChan(i).value Then
    intCh = i + 1
    Exit For
   End If
  Next i

If Not FFTReadInput(fft%, intRng, intCh) Then
    ReportError ("Error sending GPIB command string.")
    End If
If intRng < 46 Then
    intRng = intRng + 1
    Else
    ReportError ("Input Range Limit")
    Exit Sub
    End If

Select Case intCh
Case 1
strCmd = "AAS" & Trim(Str(intRng))
Case 2
strCmd = "BAS" & Trim(Str(intRng))
End Select

If Not FFTSendCmd(fft%, strCmd) Then
  ReportError ("Error sending GPIB command string.")
  End If
  
End Sub

Private Sub Picture1_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Picture1.Top = Picture1.Top + 10
    Picture1.Left = Picture1.Left + 10
End Sub

Private Sub Picture1_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Picture1.Top = Picture1.Top - 10
    Picture1.Left = Picture1.Left - 10
End Sub

Private Sub Picture3_Click()
Dim intRng As Integer
Dim intCh As Integer
Dim strCmd As String
Dim i As Integer
  

  For i = 0 To 1
   If optChan(i).value Then
    intCh = i + 1
    Exit For
   End If
  Next i

If Not FFTReadInput(fft%, intRng, intCh) Then
    ReportError ("Error sending GPIB command string.")
    End If
If intRng > 1 Then
    intRng = intRng - 1
    Else
    ReportError ("Input Range Limit")
    Exit Sub
    End If

Select Case intCh
Case 1
strCmd = "AAS" & Trim(Str(intRng))
Case 2
strCmd = "BAS" & Trim(Str(intRng))
End Select

If Not FFTSendCmd(fft%, strCmd) Then
  ReportError ("Error sending GPIB command string.")
  End If
End Sub

Private Sub Picture3_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Picture3.Top = Picture3.Top + 10
    Picture3.Left = Picture3.Left + 10
End Sub

Private Sub Picture3_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Picture3.Top = Picture3.Top - 10
    Picture3.Left = Picture3.Left - 10
End Sub
Sub FillComboBoxes()

 cmboPoints.AddItem "4096"
 cmboPoints.AddItem "2048"
 cmboPoints.AddItem "1024"
 cmboPoints.AddItem "512"
 cmboPoints.AddItem "256"
 cmboPoints.AddItem "128"
 cmboPoints.ListIndex = 1   ' default to 2048

 cmboFreq.AddItem "100000"
 cmboFreq.AddItem "10000"
 cmboFreq.AddItem "1000"
 cmboFreq.AddItem "100"
 cmboFreq.ListIndex = 1   ' default to 10000 lines
 
 cmboDisplays.AddItem "1"
 cmboDisplays.AddItem "2"
 cmboDisplays.AddItem "3"
 cmboDisplays.ListIndex = 1       ' default to 2 Displays
 
End Sub

Private Sub cmdReset_Click()

If Not FFTSystemReset(fft%) Then
    ReportError ("Error sending GPIB command string.")
  End If

End Sub

Private Sub Close_Click()

FFTCloseComm (fft%)
Unload Me

End Sub

