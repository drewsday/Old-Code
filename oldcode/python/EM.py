### EMWave.py
### Electromagnetic Plane Wave visualization (requires VPython)
### Rob Salgado
### salgado@physics.syr.edu     http://physics.syr.edu/~salgado/
### v0.5  2001-11-07 tested on Windows 2000
### v0.51 2003-02-16 tested on Windows 2000
###         with Python-2.1.1.exe and VPython-2001-10-31.exe

from visual import *

print"""
Electromagnetic Plane Wave visualization (v0.51)
Rob Salgado (salgado@physics.syr.edu)

dE/dt ("change-in-the-magnitude-of-the-electric-field") is determined 
the
spatial arrangement of the magnetic field according to
Ampere's Law (as evaluated on the green loop).

dB/dt ("change-in-the-magnitude-of-the-magnetic-field") is determined 
the
spatial arrangement of the electric field according to
Faraday's Law (as evaluated on the yellow loop).

Intuitively, the sign of dE/dt (in this example)
tells the current value of E at that point to look like
the value of E at the point to its left.
In other words, the pattern of the electric field moves to the RIGHT.

Similarly, the sign of dB/dt (in this example)
tells the current value of B at that point to look like
the value of B at the point to its left.
In other words, the pattern of the magnetic field moves to the RIGHT.

Thus, this electromagnetic plane wave moves to RIGHT.

(This shows that the right-hand-rule to determine the
Poynting vector comes from the right-hand-rules associated with Faraday 
and Ampere.)
"""

scene = display(title="EM Wave (Rob Salgado)")
scene.autoscale=0
scene.range=(8,8,8)
scene.forward=(-1.0, -1.250, -4)
scene.newzoom=1

EField=[]
Ecolor=[color.blue,color.cyan]
BField=[]
Bcolor=[color.red,color.magenta]
ddtcolor=[color.green,color.yellow]
Emax=4.
separation=5.

S=20

for i in arange(-S,S):
    Ev=arrow(pos=(i,0,0),axis=(0,Emax*cos(2.*pi*i/S),0),color=Ecolor[0],shaftwidth=0.2)
    EField.append(Ev)

for i in arange(-S,S):
    Bv=arrow(pos=(i,0,0),axis=(0,0,Emax*cos(2.*pi*i/S)),color=Bcolor[0],shaftwidth=0.2)
    BField.append(Bv)


#for fi in arange(-5,5):
fi=-6

height=separation
k=0.5

FaradayLoop=curve(pos=[(-1,-height,0),(-1,height,0),(1,height,0),(1,-height,0),(-1,-height,0)],color=ddtcolor[1])
AmpereLoop=curve(pos=[(-1,0,-height),(-1,0,height),(1,0,height),(1,0,-height),(-1,0,-height)],color=ddtcolor[0])

#box(pos=(fi,0,0),axis=(0,0,1),height=2.*Emax,width=2.,length=.01,color=color.yellow)
dBdt=arrow(pos=(fi,0,0),axis=(0,0,-Emax*sin(2.*pi*fi/S)/S),color=ddtcolor[1],shaftwidth=0.2,headwidth=1)
dEdt=arrow(pos=(fi,0,0),axis=(0,-Emax*sin(2.*pi*fi/S)/S,0),color=ddtcolor[0],shaftwidth=0.2,headwidth=1)
dBdtlabel = label(pos=(fi,0,-Emax*sin(2.*pi*fi/S)/S), text='dB/dt',color=ddtcolor[1], xoffset=20, yoffset=12, height=10, border=6)
dEdtlabel = label(pos=(fi,-Emax*sin(2.*pi*fi/S)/S,0), text='dE/dt',color=ddtcolor[0], xoffset=20, yoffset=12, height=10, border=6)

while 1:

    newfi=int(scene.mouse.pos.x)
    newfi=max(min(newfi,S-2),-(S-2))
    if fi<>newfi:
        EField[S+fi-1].color=Ecolor[0]
        EField[S+fi+1].color=Ecolor[0]
        BField[S+fi-1].color=Bcolor[0]
        BField[S+fi+1].color=Bcolor[0]
        fi=newfi        
        EField[S+fi-1].color=Ecolor[1]
        EField[S+fi+1].color=Ecolor[1]
        BField[S+fi-1].color=Bcolor[1]
        BField[S+fi+1].color=Bcolor[1]
        #FaradayLoop.pos=(fi,0,0)
        FaradayLoop.x[0]=fi-1
        FaradayLoop.x[1]=fi-1
        FaradayLoop.x[2]=fi+1
        FaradayLoop.x[3]=fi+1
        FaradayLoop.x[4]=fi-1
        AmpereLoop.x[0]=fi-1
        AmpereLoop.x[1]=fi-1
        AmpereLoop.x[2]=fi+1
        AmpereLoop.x[3]=fi+1
        AmpereLoop.x[4]=fi-1


        dBdt.axis.z=k*Emax*abs(sin(2.*pi*fi/S))*-sign(dot(EField[S+fi+1].axis-EField[S+fi-1].axis,vector(0,1,0)) )
        dBdt.shaftwidth=0.1
        dBdt.headwidth=1
        if dot(dBdt.axis,BField[S+fi].axis)>0:
            dBdtlabel.text='dB/dt>0'
            dBdt.pos=(fi,0,BField[S+fi].axis.z)
        elif dot(dBdt.axis,BField[S+fi].axis)<0:
            dBdtlabel.text='dB/dt<0'
            dBdt.pos=(fi,0,BField[S+fi].axis.z-dBdt.axis.z)
        else:
            dBdtlabel.text='dB/dt=0'
            dBdt.pos=(fi,0,BField[S+fi].axis.z)
        dBdtlabel.pos=dBdt.pos+vector(0,0,dBdt.axis.z/2.)


        dEdt.axis.y=k*Emax*abs(sin(2.*pi*fi/S))*sign( dot(BField[S+fi+1].axis-BField[S+fi-1].axis,vector(0,0,-1)) )
        dEdt.shaftwidth=0.1
        dEdt.headwidth=1
        if dot(dEdt.axis,EField[S+fi].axis)>0:
            dEdtlabel.text='dE/dt>0'
            dEdt.pos=(fi,EField[S+fi].axis.y,0)
        elif dot(dEdt.axis,EField[S+fi].axis)<0:
            dEdtlabel.text='dE/dt<0'
            dEdt.pos=(fi,EField[S+fi].axis.y-dEdt.axis.y,0)
        else:
            dEdtlabel.text='dE/dt=0'
            dEdt.pos=(fi,EField[S+fi].axis.y,0)
        dEdtlabel.pos=dEdt.pos+vector(0,dEdt.axis.y/2.,0)
    else:
        rate(60) #v0.51 suggested by Jonathan Brandmeyer to reduce mousing polling when idle
        

