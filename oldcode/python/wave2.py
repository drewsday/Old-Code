from visual import *
i=1
#for i in range(1000):
while 1:
	wave = curve(x=arange(0,20,0.1), z = .1)
	wave.y = sin( 2.0*wave.x - 6.28*i )
	i = i + 1
