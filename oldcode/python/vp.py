from visual import *

ball = sphere(color=color.green, radius = 0.1)

t=0.0
dt=0.000005
scene.autoscale=0

while 1:
	rate(10000)
	t = t + dt
	ball.radius = (ball.radius + 0.00001*(sin(65*(t))))		
