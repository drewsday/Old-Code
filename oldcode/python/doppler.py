from visual import *

scene = display(width=500, height=500, range=5)
scene.autoscale = 0

wavefront = ring(pos=(0,0,0), axis=(0,0,1),radius=0.5, thickness=0.01)
source = sphere(pos=(0,0,0),radius=.35)
wavefront2 = ring(pos=source.pos, axis=(0,0,1), radius=0.5, thickness=0.01, visible=0)
wavefront3 = ring(pos=source.pos, axis=(0,0,1), radius=0.5, thickness=0.01, visible=0)
wavefront4 = ring(pos=source.pos, axis=(0,0,1), radius=0.5, thickness=0.01, visible=0)
wavefront5 = ring(pos=source.pos, axis=(0,0,1), radius=0.5, thickness=0.01, visible=0)
wavefront6 = ring(pos=(0,0,0), axis=(0,0,1), radius=0.5, thickness=0.01, visible=0)
wavefront7 = ring(pos=(0,0,0), axis=(0,0,1), radius=0.5, thickness=0.01, visible=0)
wavefront8 = ring(pos=(0,0,0), axis=(0,0,1), radius=0.5, thickness=0.01, visible=0)
wavefront9 = ring(pos=(0,0,0), axis=(0,0,1), radius=0.5, thickness=0.01, visible=0)

source.p = vector(.0005,0,0)
dt=.0005
t = 0.0

def move(x):
	x.pos = x.pos + t*x.p
	return x.pos

def emit(wave, nextwave):
	wave.visible=1
	wave.radius = wave.radius + 0.001*t
	nextwave.pos = source.pos
	return wave.radius

while 1:
	rate(10000)
#        t = t + dt 
	x = 10000
	todo_list = (move(source), emit(wavefront,wavefront2), emit(wavefront2,wavefront3), emit(wavefront3,wavefront4))
	for i in range(2, len(todo_list) + 1):
	    	for j in range(x):
        		for k in range(i):
            			t = t+dt
				todo_list[k]
