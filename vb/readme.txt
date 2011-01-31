http://www.vb-helper.com/HowTo/graph4.zip

	Purpose
Draw a simple graph with labeled axes

	Method
Use the Line method to graph equations. Step along each axes drawing tick marks and unit labels like this:

    ' Draw X axis.
    Picture1.Line (-10, 0)-(10, 0)
    For i = -9 To 9
        Picture1.Line (i, -0.4)-(i, 0.4)
        Picture1.CurrentX = i - Picture1.TextWidth(Format$(i)) / 2
        Picture1.CurrentY = -0.5
        Picture1.Print Format$(i)
    Next i

The book "Custom Controls Library" implements 101 custom controls including a simple graph control. It provides many more features than this example but you can still modify it. For more information go to

		http://www.vb-helper.com/ccl.htm

The book "Visual Basic Graphics Programming" has lots more to say about graphics.

		http://www.vb-helper.com/vbgp.htm

	Disclaimer
This example program is provided "as is" with no warranty of any kind. It is
intended for demonstration purposes only. In particular, it does not error
handling. You can use the example in any form, but please mention
www.vb-helper.com.
