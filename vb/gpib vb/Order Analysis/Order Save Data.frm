VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form Form1 
   Caption         =   "Order Based Analysis"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox Text1 
      Enabled         =   0   'False
      Height          =   1095
      Left            =   2640
      MultiLine       =   -1  'True
      TabIndex        =   6
      Text            =   "Order Save Data.frx":0000
      Top             =   120
      Width           =   1815
   End
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   3120
      Top             =   840
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CommandButton cmdSaveData 
      Caption         =   "Save Data"
      Height          =   615
      Left            =   2880
      TabIndex        =   3
      Top             =   1440
      Width           =   1455
   End
   Begin VB.TextBox txtNotes 
      Height          =   1095
      Left            =   240
      MultiLine       =   -1  'True
      TabIndex        =   2
      Top             =   1200
      Width           =   2055
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Exit Program"
      Height          =   615
      Left            =   2880
      TabIndex        =   1
      Top             =   2160
      Width           =   1455
   End
   Begin VB.TextBox txtMaxValue 
      Height          =   285
      Left            =   240
      TabIndex        =   0
      Top             =   360
      Width           =   2055
   End
   Begin VB.Frame Frame2 
      Caption         =   "Notes"
      Height          =   1455
      Left            =   120
      TabIndex        =   5
      ToolTipText     =   "Anything entered in this box will be stored with the data as a header."
      Top             =   960
      Width           =   2295
   End
   Begin VB.Frame Frame1 
      Caption         =   "Max order"
      Height          =   615
      Left            =   120
      TabIndex        =   4
      ToolTipText     =   "Enter the largest value for the x-axis.  The x-axis data saved to a file is dependent on this value."
      Top             =   120
      Width           =   2295
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False


Private Sub Form_Load()

If Not FFTOpenComm(fft%) Then
    Call ReportError("Could not open device FFT")
  End If

End Sub


Private Sub cmdSaveData_Click()

Dim sngData(2048) As Single
Dim i As Integer
Dim j As Integer
Dim k As Single
Dim l As Single
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
'Open DataFile For Output As #F
Open DataFile For Append As #F
  
'Read Channel A info and write to file
   If Not FFTReadDisplayData(sngData()) Then
    MsgBox "Error reading data."
   End If
   
   For i = 1 To 802 'should be 802 for one channel
     'Write #F, sngData(i)
     arrArray(1, i) = sngData(i - 1)
   Next i
   
'Read Channel B info and write to file
'   If Not FFTReadDisplayDataB(sngData()) Then
 '   MsgBox "Error reading data."
 '  End If
   
'   For i = 1 To 802 'should be 802 for one channel
     'Write #F, sngData(i)
 '    arrArray(2, i) = sngData(i - 1)
  ' Next i

'Read X axis info does not work properly, routine below will work for 800 line spectrum only!
   'If Not FFTReadDisplayDataX(sngData()) Then
   ' MsgBox "Error reading X axis."
   'End If
   
   'For i = 1 To 802
   '  arrArray(3, i) = sngData(i - 1)
   'Next i
       
   deltaF = Trim(txtMaxValue.Text) / 800

   For k = 0 To 800
    arrArray(3, k + 1) = k * deltaF
   Next k
       
   Print #F, txtNotes.Text   'this includes the notes section in the saved file.  (hopefully)
   Print #F, ""
       
   For j = 1 To 802
    '    Print #F, arrArray(3, j) & ","; arrArray(1, j) & ","; arrArray(2, j)
'        Print #F, arrArray(3, j) & ","; arrArray(1, j)
   Next j
   
   Print #F, ""

'This writes the half order info...

   For k = 1 To 20
        l = (k * 32) + 1
        Print #F, arrArray(3, l) & ","; arrArray(1, l)
          
   Next k
   
   Close #F

End Sub

Private Sub Command1_Click()

   Unload Me

End Sub

