VERSION 4.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   4185
   ClientLeft      =   3300
   ClientTop       =   1770
   ClientWidth     =   7275
   Height          =   4590
   Left            =   3240
   LinkTopic       =   "Form1"
   ScaleHeight     =   4185
   ScaleWidth      =   7275
   Top             =   1425
   Width           =   7395
   Begin VB.CommandButton CmdGraph 
      Caption         =   "Graph"
      Height          =   495
      Left            =   120
      TabIndex        =   13
      Top             =   2400
      Width           =   1215
   End
   Begin VB.TextBox StepText 
      Height          =   285
      Left            =   600
      TabIndex        =   12
      Text            =   "0.5"
      Top             =   1920
      Width           =   735
   End
   Begin VB.TextBox XmaxText 
      Height          =   285
      Left            =   600
      TabIndex        =   10
      Text            =   "10"
      Top             =   1560
      Width           =   735
   End
   Begin VB.TextBox XminText 
      Height          =   285
      Left            =   600
      TabIndex        =   8
      Text            =   "0"
      Top             =   1200
      Width           =   735
   End
   Begin VB.TextBox bText 
      Height          =   285
      Left            =   600
      TabIndex        =   6
      Text            =   "30"
      Top             =   840
      Width           =   735
   End
   Begin VB.TextBox NText 
      Height          =   285
      Left            =   600
      TabIndex        =   4
      Text            =   "5"
      Top             =   480
      Width           =   735
   End
   Begin VB.TextBox MText 
      Height          =   285
      Left            =   600
      TabIndex        =   2
      Text            =   "20"
      Top             =   120
      Width           =   735
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Step"
      Height          =   195
      Index           =   5
      Left            =   120
      TabIndex        =   11
      Top             =   1920
      Width           =   330
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Xmax"
      Height          =   195
      Index           =   4
      Left            =   120
      TabIndex        =   9
      Top             =   1560
      Width           =   390
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Xmin"
      Height          =   195
      Index           =   3
      Left            =   120
      TabIndex        =   7
      Top             =   1200
      Width           =   345
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "b"
      Height          =   195
      Index           =   2
      Left            =   360
      TabIndex        =   5
      Top             =   840
      Width           =   90
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "N"
      Height          =   195
      Index           =   1
      Left            =   360
      TabIndex        =   3
      Top             =   480
      Width           =   120
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "M"
      Height          =   195
      Index           =   0
      Left            =   360
      TabIndex        =   1
      Top             =   120
      Width           =   135
   End
   Begin MSChartLib.MSChart Chart1 
      Height          =   4215
      Left            =   1440
      OleObjectBlob   =   "Form1.frx":0000
      TabIndex        =   0
      Top             =   0
      Width           =   5895
   End
End
Attribute VB_Name = "Form1"
Attribute VB_Creatable = False
Attribute VB_Exposed = False
Option Explicit

Private Sub CmdGraph_Click()
Dim M As Single
Dim N As Single
Dim b As Single
Dim xmin As Single
Dim xmax As Single
Dim xstep As Single
Dim X As Single
Dim values() As Single
Dim i As Integer
Dim num_x As Integer

    M = CSng(MText.Text)
    N = CSng(NText.Text)
    b = CSng(bText.Text)
    xmin = CSng(XminText.Text)
    xmax = CSng(XmaxText.Text)
    xstep = CSng(StepText.Text)
    num_x = (xmax - xmin) / xstep
    ReDim values(1 To num_x, 1 To 2)
        
    ' Compute the data values.
    X = xmin
    For i = 1 To num_x
        values(i, 1) = M * X + b
        values(i, 2) = N * X ^ 2 - M * X + b
        X = X + xstep
    Next i

    ' Send the data to the chart.
    Chart1.RowCount = 2
    Chart1.ColumnCount = num_x
    Chart1.ChartData = values
    Chart1.ChartType = VtChChartType2dLine

    ' Create the legend.
    With Chart1.Legend
        .Location.Visible = True
        .Location.LocationType = VtChLocationTypeRight
        .TextLayout.HorzAlignment = _
            VtHorizontalAlignmentRight
    End With
    
    ' Set the legend text for the series.
    Chart1.Plot.SeriesCollection(1).LegendText = "Straight Line"
    Chart1.Plot.SeriesCollection(2).LegendText = "Quadratic"
End Sub

Private Sub Form_Load()
    CmdGraph_Click
End Sub


