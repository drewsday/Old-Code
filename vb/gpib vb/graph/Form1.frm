VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   4470
   ClientLeft      =   1980
   ClientTop       =   1875
   ClientWidth     =   4470
   LinkTopic       =   "Form1"
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   4470
   ScaleWidth      =   4470
   Begin VB.PictureBox Picture1 
      AutoRedraw      =   -1  'True
      Height          =   4455
      Left            =   0
      ScaleHeight     =   4395
      ScaleWidth      =   4395
      TabIndex        =   0
      Top             =   0
      Width           =   4455
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
Dim i As Integer
Dim x As Single
Dim y As Single

    Picture1.Scale (-10, 10)-(10, -10)
    
    ' Draw X axis.
    Picture1.Line (-10, 0)-(10, 0)
    For i = -9 To 9
        Picture1.Line (i, -0.4)-(i, 0.4)
        Picture1.CurrentX = i - Picture1.TextWidth(Format$(i)) / 2
        Picture1.CurrentY = -0.5
        Picture1.Print Format$(i)
    Next i

    ' Draw Y axis.
    Picture1.Line (0, -10)-(0, 10)
    For i = -9 To 9
        Picture1.Line (-0.4, i)-(0.4, i)
        Picture1.CurrentX = -0.5 - Picture1.TextWidth(Format$(i))
        Picture1.CurrentY = i - Picture1.TextHeight(Format$(i)) / 2
        Picture1.Print Format$(i)
    Next i
    
    ' Draw y = 4 * sin(x).
    Picture1.ForeColor = vbRed
    x = -10
    y = 4 * Sin(x)
    Picture1.CurrentX = x
    Picture1.CurrentY = y
    For x = -10 To 10 Step 0.25
        y = 4 * Sin(x)
        Picture1.Line -(x, y)
    Next x
    
    ' Draw y = x ^ 3 / 5 - 3 * x + 1.
    Picture1.ForeColor = vbBlue
    x = -10
    y = x ^ 3 / 5 - 3 * x + 1
    Picture1.CurrentX = x
    Picture1.CurrentY = y
    For x = -10 To 10 Step 0.25
        y = x ^ 3 / 5 - 3 * x + 1
        Picture1.Line -(x, y)
    Next x
End Sub


