Attribute VB_Name = "Module1"
'This Module does ONO_SOKKI initialisation and shutdown
Option Explicit

Global stringv As String
Global ONO_SOKKI As Integer

Sub Start_ONOSOKKI()

    ONO_SOKKI = ildev(0, 9, 0, T3s, 1, 0)
    'NB Looks like both primary and secondary addresses used.
    'Set both to 9

    If (ibsta And Err) Then
        MsgBox "ibdev error"
    End If

    ibclr (ONO_SOKKI)
    If (ibsta And Err) Then
        MsgBox "ibclr Error"""
    End If

End Sub

Sub End_ONOSOKKI()
    'Take Analyser Offline
    Call ibonl(ONO_SOKKI, 0)

    'Take the driver board off line
    Call ibonl(0, 0)

End Sub
