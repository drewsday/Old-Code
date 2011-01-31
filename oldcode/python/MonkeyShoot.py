# The classic Shoot-the-Monkey Demo
# John W. Keck, February 2003
# American University
#
# camera direction still jerky:
# should monkey be the center?

from visual import *

# define exx marker
newframe = frame
class exx(object):
    def __init__(self, frame=None, pos=(0,0,0), axis=(1,0,0), color=(1.0,0.5,0)):
        self.frame = newframe(pos=pos, axis=axis, frame=frame)
        self.__pos = vector(pos)
        self.__axis = vector(axis)
        self.__color = color
#        self.parts = 
        box(frame=self.frame,axis=(1,1,0),size=(2,0.2,1),color=self.__color)
        box(frame=self.frame,axis=(1,-1,0),size=(2,0.2,1),color=self.__color)

    def getpos(self):
        return self.__pos

    def setpos(self, pos):
        self.frame.pos = self.__pos = vector(pos)

    pos = property(getpos, setpos)

    def getaxis(self):
        return self.__axis

    def setaxis(self, axis): # scale all points in front face
        self.frame.axis = self.__axis = vector(axis)
        length = mag(self.__axis)
        
    axis = property(getaxis, setaxis)

    def getcolor(self):
        return self.__color
    
    def setcolor(self, color):
        self.__color = color
        self.faces.color = color

    color = property(getcolor, setcolor)

#-----------------------------------------------------------------------
# set defaults and initial parameters
color.orange = (1,0.5,0)
color.brown = (0.46,0.28,0.10)

v0 = 30.0  # default ball speed
mkht = 135  # default monkey height
ballpos = vector(-45,10,0) # default ball position
dt = 0.01  # time increment for action calculation

#-------------------------------
mkpos = (47,mkht,0)  
scene = display(title="Shoot the Monkey", center=mkpos, ambient = 0.4, x=0, y=0, width=500,height=500)
rt = int(1/dt) # limiting rate of action loop
first = 1  # first run flag

while 1:
#----------------------------------------------------------------------
#SET THE STAGE
    mkpos = vector(47,mkht,0)
    scene.center = mkpos

    #set up the environment
    floor = box (pos=(10,0,0), size=(110,0.5,6), color=color.green, opacity=0.5)  #length=110, height=0.5, width=6, color=color.green)
    tree = cylinder(pos=(60,0,0), axis=(0,mkht,0), radius=3, color=(0.7,0.7,0.3))
    branch = cylinder(pos=(60,mkht-17,0), axis=(-12,30,0), radius=2, color=(0.7,0.7,0.3))
    
    # power bar for selecting velocity
#    pinstr = frame()
    i = 0
    while i < 5:
        pwr0 = box(pos=(-55,i*20+5,-10), size=(4.9,10,4.9), color=(0.8,0.8,0.5))
##        label(frame=pinstr,text=str(i*20), pos=(i*20,0,10), height=8)
        pwr1 = box(pos=(-55,i*20+15,-10), size=(4.9,10,4.9), color=color.yellow)
        i += 1
##    label(frame=pinstr,text=str(i*20), pos=(i*20,0,10), height=8)
##    pinstr.pos = (-62,0,0)
##    pinstr.axis = (0,1,0)
##    pinstr.visible = 0
    power1 = box(pos=(-55,v0/2,-10), size=(5,v0,5), color=color.red)
    pwr = label(pos=(-62,v0,0), height=12, visible=1)
    pwr.text = '%0.1f' % (v0)


    #the monkey
#   mkcolor = (1,0.7,0.2)
    mkcolor = color.brown
    monkey = frame()
    sphere(frame=monkey, pos=(1,0,0),radius=2,color=mkcolor) #head
    sphere(frame=monkey, pos=(0.6,0,-1.9),radius=1.2,color=(1,0.8,0.5)) #snout
    sphere(frame=monkey, pos=(1.5,0.12,-2.3),radius=0.2,color=color.black) #nostrils
    sphere(frame=monkey, pos=(1.5,-0.12,-2.3),radius=0.2,color=color.black)
    ring(frame=monkey, pos=(0.7,0,-2.2),axis=(2,0,-1),radius=0.9,thickness=0.2,color=color.black) # mouth
    eang0 = 65*pi/180
    eang1 = 20*pi/180
    sphere(frame=monkey, pos=(1+1.5*cos(eang0),1.5*sin(eang0)*sin(eang1),-1.5*sin(eang0)*cos(eang1)),radius=0.6,color=(0.9,0.9,0.9)) #eyes
    sphere(frame=monkey, pos=(1+1.5*cos(eang0),-1.5*sin(eang0)*sin(eang1),-1.5*sin(eang0)*cos(eang1)),radius=0.6,color=(0.9,0.9,0.9)) #eyes
    eang0 = 67*pi/180
    eang1 = 19*pi/180
    sphere(frame=monkey, pos=(1+2.02*cos(eang0),2.02*sin(eang0)*sin(eang1),-2.02*sin(eang0)*cos(eang1)),radius=0.2,color=color.black) #eyes
    sphere(frame=monkey, pos=(1+2.02*cos(eang0),-2.02*sin(eang0)*sin(eang1),-2.02*sin(eang0)*cos(eang1)),radius=0.2,color=color.black) #eyes
##    eang0 = 70*pi/180
##    eang1 = 90*pi/180
##    cone(frame=monkey, pos=(1+2.3*cos(eang0),2.3*sin(eang0)*sin(eang1),-2.3*sin(eang0)*cos(eang1)),axis=(-0.5*cos(eang0),-0.5*sin(eang0)*sin(eang1),0.5*sin(eang0)*cos(eang1)),radius=0.3,color=mkcolor)
##    cone(frame=monkey, pos=(1+2.3*cos(eang0),-2.3*sin(eang0)*sin(eang1),-2.3*sin(eang0)*cos(eang1)),axis=(-0.5*cos(eang0),0.5*sin(eang0)*sin(eang1),0.5*sin(eang0)*cos(eang1)),radius=0.3,color=mkcolor)
    cylinder(frame=monkey, pos=(-6,0,0), axis=(5,0,0), radius=2, color=mkcolor) #body
    
    monkey.pos = mkpos
    monkey.axis = (0,1,0)
    monkey.velocity = vector(0,0,0)
    monkey.trail = curve(color=mkcolor)
    monkey.mass = 5

    #the ball
    ball = sphere (pos=ballpos, radius=1, color=(0.4,0.9,1))
    ball.mass = 1
    ball.trail = curve(color=ball.color)
    bpos = label(pos=ballpos, visible=0)
    bpos.text = '%0.1f, %0.1f' %(ball.pos.x, ball.pos.y)

    # take aim
    aim = curve(pos=[ball.pos,monkey.pos+monkey.axis], color=(0.9,0.7,0.7))
    dist = mag(ball.pos-monkey.pos)
    cx = (monkey.x - ball.x)/dist
    cy = (monkey.y - ball.y)/dist
    ball.velocity = vector(v0*cx,v0*cy,0)
    vel = arrow(pos=ball.pos, axis=ball.velocity/4, shaftwidth=1, fixedwidth=1, color=color.yellow)

    masstot = ball.mass + monkey.mass

# TEXT INSTRUCTIONS
    print
    print "======================================"
    print "Shoot-the-Monkey Physics Demonstration"
    print "Written by John W. Keck 2003"
    if first:
        instr = label(text='Answer question in text\nwindow to continue.', pos=scene.center+vector(0,scene.range.y,0), height=12)
        print
        print "Consider the situation depicted here. A gun is accurately aimed at a monkey"
        print "hanging from a tree. The target is well within the gun's range, but the"
        print "instant the gun is fired and the bullet moves with a speed v0, the monkey"
        print "lets go and drops to the ground. What happens? The bullet" 
        print
        print "1. hits the monkey regardless of the value of v0, as long as he doesn't"
        print "   hit the ground first."
        print "2. hits the monkey only if v0 is large enough for the bullet to reach"
        print "   him before he falls much more than the length of his body."
        print "3. misses the monkey entirely." 
        print
# comment out the following line if it gets annoying
        answer = input("Which (1-3)?")
        print
        print "Try shooting the ball at difference speeds from various places"
        print "to discover the answer."
        print
        print "At 1-second intervals, the computer will plot measures showing"
        print "how far each body has fallen."
        first = 0
        instr.visible = 0
        while scene.mouse.events: xx = scene.mouse.getevent() # clear mouse buffer

    print
    print "=== INSTRUCTIONS ==="
    print "Drag Ball to position Ball"
    print "Drag power bar at left to change initial velocity"
    print "Drag tree to position Monkey"
    print "Click background to FIRE"
    print


#----------------------------------------------------------------------
# AIMING STAGE
    pick = None
    go = 1
    while go:
        if scene.mouse.events:
            m1 = scene.mouse.getevent() # obtain drag or drop event
            if m1.drag and m1.pick == ball: 
                drag_pos = m1.pickpos
                pick = m1.pick
                scene.cursor.visible = 0 # make cursor invisible 
            elif m1.drop: 
                pick = None # end dragging
                scene.cursor.visible = 1 # cursor visible
            if m1.drag and m1.pick == power1: 
                drag_pos = m1.pickpos
                pick = m1.pick
                scene.cursor.visible = 0 # make cursor invisible 
            elif m1.drop: 
                pick = None # end dragging
                scene.cursor.visible = 1 # cursor visible
            if m1.drag and m1.pick == tree: 
                drag_pos = m1.pickpos
                pick = m1.pick
                scene.cursor.visible = 0 # make cursor invisible 
            elif m1.drop: 
                scene.center = monkey.pos # jerky, but workable
                pick = None # end dragging
                scene.cursor.visible = 1 # cursor visible
        if scene.mouse.clicked:
            m = scene.mouse.getclick()
            print "FIRE!"
            go = 0
        if pick==ball: 
            new_pos = scene.mouse.project(normal=(0,0,1))
            if new_pos != drag_pos: 
                pick.pos += new_pos - drag_pos
                drag_pos = new_pos
                dist = mag(ball.pos-monkey.pos)
                cx = (monkey.x - ball.x)/dist
                cy = (monkey.y - ball.y)/dist
                ball.velocity = vector(v0*cx,v0*cy,0)
                vel.axis = ball.velocity/4
                vel.pos = ball.pos
                aim.pos = [ball.pos,monkey.pos+monkey.axis]
        if pick==power1: 
            new_pos = scene.mouse.project(normal=(0,0,1))
            if new_pos != drag_pos: 
                pick.height += new_pos.y - drag_pos.y
                v0 = pick.height
                if v0 > 100:
                    v0 = 100
                if v0 < 0:
                    v0 = 0
                pick.height = v0
                ball.velocity = vector(v0*cx,v0*cy,0)
                vel.axis = ball.velocity/4
                vel.pos = ball.pos
                power1.y = v0/2
                pwr.pos=(-62,v0,0)
                pwr.text = '%0.1f' % (v0)
                drag_pos = new_pos
        if pick==tree: 
            new_pos = scene.mouse.project(normal=(0,0,1))
            if new_pos != drag_pos: 
                pick.axis.y += new_pos.y - drag_pos.y
                h = pick.axis.y
                if h > 300:
                    h = 300
                if h < 17:
                    h = 17
                pick.axis.y = h
#                pick.y = 0
                monkey.pos.y = h
#                scene.center = monkey.pos # makes it hard to control
                branch.pos.y = h - 17
                dist = mag(ball.pos-monkey.pos)
                cx = (monkey.x - ball.x)/dist
                cy = (monkey.y - ball.y)/dist
                ball.velocity = vector(v0*cx,v0*cy,0)
                vel.axis = ball.velocity/4
                vel.pos = ball.pos
                aim.pos = [ball.pos,monkey.pos+monkey.axis]
                drag_pos = new_pos 

    print "Initial velocity = %0.2f m/s at %0.2f degrees" %(v0,atan(cy/cx)*180/pi)
    print "Initial position = (%0.2f, %0.2f)" % (ball.x,ball.y)
    ballpos.x = ball.pos.x #save for next time round
    ballpos.y = ball.pos.y
    mkpos.y = monkey.pos.y
#    mkpos0.y = mkpos.y
    # find params of line that ball would have travelled without gravity
    slope = (ball.pos.y-monkey.pos.y)/(ball.pos.x-monkey.pos.x)
    yint = ball.pos.y - slope*ball.pos.x
    sphere(pos=monkey.pos,color=color.orange,radius=1.0)
#    pwr.visible = 0

    # clear mouse event buffer
    while scene.mouse.events:
        xx = scene.mouse.getevent()

#----------------------------------------------------------------------
# ACTION STAGE
    #aim.visible = 0
    g = 9.8
    t = 0
    relvel0 = vector(0,0,0)
    bpos0 = ball.pos
    go = 1
    nohit = 1
    b1 = 0
    d0 = 0.5*g # standard distance (same for both Monkey and Ball)    
    while go or nohit:
        rate (rt)
        # change ball and monkey positions and velocities for free fall
        ball.velocity.y -= g*dt
        ball.pos += ball.velocity*dt
        monkey.velocity.y -= g*dt
        monkey.pos += monkey.velocity*dt
        scene.center = monkey.pos
        if monkey.x > tree.x-tree.radius-1:
            ball.velocity.x = -0.8*ball.velocity.x
        if ball.x > monkey.x + 10:
            go = 0
            nohit = 0
        if monkey.y <= 6 :
            go = 0
        # leave trails and show ball's velocity vector
        vel.pos = ball.pos
        vel.axis = ball.velocity/4
        ball.trail.append(pos=ball.pos)
        if not nohit: monkey.trail.append(pos=monkey.pos+monkey.axis/2)
#        print t,fmod(t,1)
        # plot measurement bars to show how fall objects have fallen
        # (The distances don't exactly fall on perfect squares because
        # of the limited precision of the calculation;
        # as dt -> 0, results improve.) 
        t += dt
        if t>(1.0-dt) and nohit:
            projy = slope*ball.x + yint
            projpos = vector(ball.x, projy, 0)
            sphere(pos=mkpos,color=color.orange,radius=1.0)
            sphere(pos=projpos,color=color.orange,radius=1.0)         
            exx(pos=ball.pos)        
            d = (projy - ball.pos.y)
            xx = d/d0/2
            i = 0
            while i<xx:
                b = projpos-vector(0,2*i*d0,0)
                b2 = mkpos-vector(0,2*i*d0,0)
                curve(pos=[b,b-vector(0,d0,0)],color=color.orange)
                curve(pos=[b2,b2-vector(0,d0,0)],color=color.orange)
                if (2*i+1)*d0<d:
                    curve(pos=[b-vector(0,d0,0),b-vector(0,2*d0,0)],color=(0.5,0,0.5))
                    curve(pos=[b2-vector(0,d0,0),b2-vector(0,2*d0,0)],color=(0.5,0,0.5))
                i += 1
#            curve(pos=[projpos,ballpos],color=color.orange)
##            sphere(pos=monkey.pos,color=color.orange,radius=1.0)
            exx(pos=monkey.pos)
            t = 0
            b1 += 1
        # monkey-ball collision
        if nohit and (ball.x > monkey.x-2 and ball.x < monkey.x+2) and (ball.y > monkey.y-5 and ball.y < monkey.y+2):
            relvel = mag(monkey.velocity - ball.velocity)
            print "BLAM! Ball hits Monkey at %0.2f m/s" % (relvel)
            print
            print "Notice how the Monkey and the Ball"
            print "fell equal distances in equal time intervals."
            # perfectly inelastic collision
            ball.velocity.x = (ball.mass*ball.velocity.x + monkey.mass*monkey.velocity.x)/masstot
            ball.velocity.y = (ball.mass*ball.velocity.y + monkey.mass*monkey.velocity.y)/masstot
            monkey.velocity = ball.velocity
            nohit = 0
        # pause option
        if scene.mouse.clicked:
            m = scene.mouse.getclick()
            instr = label(text='  --PAUSED--\nClick to continue', pos=scene.center, height=12)
            m = scene.mouse.getclick()
            instr.visible = 0
    # wait for user before going back to beginning        
    while scene.mouse.events: xx = scene.mouse.getevent() # clear mouse buffer
    instr = label(text='   ---DONE---\nClick to re-run', pos=scene.center, height=12)
    m = scene.mouse.getclick()
    for obj in scene.objects:
        obj.visible = 0
