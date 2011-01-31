# timer.py v 1.1
# Original program written by Timothy M. Brauch <tbrauch@mindless.com>
# Written November 20, 2000
# First Beta version finished December 3, 2000
# Version 1.0 completed December 6, 2000
# Version 1.1 completed February 22, 2001
# Version 1.1 adds a visual display of countdown.

from visual import cone, cylinder, curve, display, sphere, label
import time

scene=display(title='Hourlgass', background=(0,0,.5))

class Hourglass:

    # This program will generate a visual hourglass useful
    # for timing simple things.

    def __init__(self,timer_length,markings=0):
        self.start_time=time.time()
        self.time=timer_length

        # if markings is enabled calibration labels will be displayed

        if markings !=0:
            self.marks()

        self.sand()
        self.frame(1)
        self.frame(-1)
        self.phase_1()
        self.phase_2()
        self.phase_3()
        self.end_time=time.time()

    def sand(self):
        self.top=cone(pos=(0,self.time*1.1,0),
                      axis=(0,-1,0),
                      color=(1,1,0))
        self.bottom=cone(pos=(0,-self.time*1.1,0),
                         axis=(0,1,0),
                         color=(.5,.5,0))
        self.falling=cylinder(pos=(0,self.time*0.125,0),
                              axis=(0,-1,0),
                              color=(.5,.5,0),
                              radius=self.time*0.035)
        self.countdown=sphere(pos=(0,self.time*1.5,0),
                              radius=0)

    def frame(self,sign):
        self.glass=curve(pos=[(sign*self.time,-self.time*1.1,0),
                              (sign*self.time*0.05,-self.time*0.1,0),
                              (sign*self.time*0.05,self.time*0.1,0),
                              (sign*self.time,self.time*1.1,0),
                              (sign*self.time,self.time*1.15,0)],
                         radius=self.time*.025)
        self.base=cylinder(pos=(0,sign*self.time*1.15,0),
                           axis=(0,1,0),
                           length=self.time*0.1,
                           radius=self.time*1.2,
                           color=(.66,.46,.13))
        self.pole=cylinder(pos=(sign*self.time,-self.time*1.1,0),
                           axis=(0,1,0),
                           length=self.time*2.3,
                           radius=self.time*0.06,
                           color=(.66,.46,.13))

    def phase_1(self):
        while (time.time()-self.start_time<self.time*.1):
            self.falling.length=time.time()*11.5-self.start_time*11.5
            self.top.radius=self.time-(time.time()-self.start_time)
            self.top.length=self.top.radius
            self.top.pos=(0,self.top.length+1,0)
            self.countdown.label=(str(self.start_time+self.time-time.time())+' seconds left')

    def phase_2(self):
        while (time.time()-self.start_time<=self.time*.9):
            self.top.radius=self.time-(time.time()-self.start_time)
            self.top.length=self.top.radius
            self.top.pos=(0,self.top.length+1,0)
            self.bottom.radius=time.time()-self.start_time
            self.bottom.length=self.bottom.radius
            self.countdown.label=(str(self.start_time+self.time-time.time())+' seconds left')
        self.top.visible=0

    def phase_3(self):
        while (time.time()-self.start_time<=self.time):
            self.falling.pos=(0,-self.time*1.1,0)
            self.falling.axis=(0,1,0)
            self.falling.length=((self.time-time.time()+self.start_time)*12.5)
            self.countdown.label=(str(self.start_time+self.time-time.time())+' seconds left')
        self.falling.visible=0
        self.countdown.visible=0
        end=label(pos=(0,self.time*1.5,0),
                  text='End')

    def marks(self):
        marks_list=[]
        new_time=self.time
        while (new_time>=5):
            marks_list.append(int(new_time))
            new_time=new_time-5.0
        marks_list.append(int(0))
        for marks in marks_list:
            sphere(pos=(marks,marks*1.1,0),
                   radius=0,
                   label=str(marks)+' seconds')

Hourglass(15,1)
