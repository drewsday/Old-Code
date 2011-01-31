from visual import *
#qeikktweak.py
#This works OK.  Why does tweaking w sort of shift origin?
xaxis=cylinder(axis=(1,0,0),radius=0.01)
yaxis=cylinder(axis=(0,1,0),radius=0.01)
wlabel=label(pos=(0,0,0), text='plane wave', xoffset=0, yoffset=-12,
         height=15, border=10,box=0)
caption=label(pos=(0,-2.0,0),
        text='Press keys k or m to change k, w or s to change k,w in exp(i(kx-wt))',
         height=10, border=10,box=0)
k=2.0
w=0.4
t=0
wre=curve(x=arange(-3.0,3.0,0.05),color=(1,0,0),radius=.05)
wim=curve(x=arange(-3.0,3.0,0.05),color=(0.6,0,0),radius=0.05)
f=exp(1j * (k*wre.x - w*t))
wre.y=f.real
wim.y=f.imag
#use scene.kb.getkey() to tweak parameters

while 1:
    t=t+0.0001
    if scene.kb.keys:
        s=scene.kb.getkey()
        if s=="k":
            k=k+0.2
        if s=="m":
            k=k-0.2
        if s=="w":
            w=w+0.2
        if s=="s":
            w=w-0.2
        wlabel.text="exp(i ("+str(k)+"x - "+str(w)+"t))"

    f=exp(1j * (k*wre.x - w*t))
    wre.y=f.real
    wim.y=f.imag
    
#This can be rewritten to set a switch (lam vs. a, say) and then use
#up down left right keys.
        
#This will be a good way to recenter the view on other programs.
