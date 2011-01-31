from visual import *
from visual.controls import *
from Tkinter import *
import tkFileDialog
import string
from time import clock

# Save this file before running, in order to create orbit files.

print """
Press to choose initial position for green star.
Then drag to choose its initial velocity.
During an orbit, click to stop, then click
  again to define new initial conditions.
The files x=-2.76.orb and x=-2.765.orb differ
  only very slightly in the initial value of x.
The intent of the program is to demonstrate the
  great complexity of motion with just 3 objects,
  despite simple rules (Newtonian mechanics), and
  the high sensitivity to initial conditions in
  such a system.
If you first rotate the scene before dragging,
  you can make a nonplanar orbit.
Bruce Sherwood, January 2003.
"""

root = None
scene.width = sw = 600
scene.height = sh = 600
scene.x = scene.y = 0
xmax = 2.8
G = 1. # gravitational constant in arbitrary units
M_to_R = 0.07 # convert mass to radius by M_to_R*mass**(1./3.)
vstar = 2 # The star whose velocity we'll choose by dragging
save = zeros(3*7, 'float') # to save pos, vel, mass at start of each orbit
filetypes = [('Orbit files', '.orb')]

def buildfiles(): # If a standard *.orb file doesn't exist, create it
    orbitdata = [
            ('commute.orb', [-0.5, 0, 0, -0.0465, 0.663, 0, 2, 0.5, 0, 0, 0, -1.2, 0, 1, -0.65, 1.82, 0, 0.93, -1.26, 0, 0.1]),
            ('moon1.orb', [-0.5, 0, 0, 0, 0.68, 0, 2, 0.5, 0, 0, 0, -1.2, 0, 1, 0.12, 0.86, 0, 0, -1.6, 0, 0.1]),
            ('moon2.orb', [-0.5, 0, 0, 0.0525, 0.643, 0, 2, 0.5, 0, 0, 0, -1.2, 0, 1, 0.54, 0.49, 0, -1.05, -0.86, 0, 0.1]),
            ('moon3.orb', [-0.5, 0, 0, -0.0475, 0.6755, 0, 2, 0.5, 0, 0, 0, -1.2, 0, 1, -0.32, 1.01, 0, 0.95, -1.51, 0, 0.1]),
            ('moon4.orb', [-0.5, 0, 0, 0.0195, 0.7135, 0, 2, 0.5, 0, 0, 0, -1.2, 0, 1, 1.22, 0.05, 0, -0.39, -2.27, 0, 0.1]),
            ('rosette.orb', [-0.5, 0, 0, 0.0325, 0.63, 0, 2, 0.5, 0, 0, 0, -1.2, 0, 1, 0.91, 0.77, 0, -0.65, -0.6, 0, 0.1]),
            ('sevenloops.orb', [-0.5, 0, 0, -0.000450452, 0.516665, -2.96059e-017, 2, 0.5, 0, 0, -0.000450452, -1.28333, -2.96059e-017, 1, -0.108108, 0.0168919, -4.44089e-016, 0.0135136, 2.5, 8.88178e-016, 0.1]),
            ('shuttle1.orb', [-0.5, 0, 0, 0.0395, 0.6585, 0, 2, 0.5, 0, 0, 0, -1.2, 0, 1, 0.71, 0.8, 0, -0.79, -1.17, 0, 0.1]),
            ('shuttle2.orb', [-0.5, 0, 0, 0.0375, 0.654, 0, 2, 0.5, 0, 0, 0, -1.2, 0, 1, 0.7, 0.83, 0, -0.75, -1.08, 0, 0.1]),
            ('trefoil.orb', [-0.214352881110285, -0.368303127453297, 0, -0.477702690351465, -0.0690629362757092, 0, 2, -0.195743825051338, 0.735857211504369, 0, 1.13140538070293, 0.0241258725514185, 0, 1, 0.22, 0.04, 0, -1.76, 1.14, 0, 0.1]),
            ('weave.orb', [-0.5, 0, 0, 0, 0.5305, 0, 2, 0.5, 0, 0, 0, -1.2, 0, 1, 0.13, -0.81, 0, 0, 1.39, 0, 0.1]),
            ('weave2.orb', [-0.5, 0, 0, -0.038, 0.5775, 0, 2, 0.5, 0, 0, 0, -1.2, 0, 1, -1.92, -1.4, 0, 0.76, 0.45, 0, 0.1]),
            ('wild1.orb', [-0.5, 0, 0, -0.0275, 0.6005, 0, 2, 0.5, 0, 0, 0, -1.2, 0, 1, -2.79, -0.22, 0, 0.55, -0.01, 0, 0.1]),
            ('wildnonplanar.orb', [-0.5, 0, 0, -0.0324781, 0.577146, -0.0510757, 2, 0.5, 0, 0, -0.0324781, -1.22285, -0.0510757, 1, -0.490672, 0.438966, 0.647793, 0.974342, 0.685622, 1.53227, 0.1]),
            ('x=-2.76.orb', [-0.5, 0, 0, -0.023, 0.5995, 0, 2, 0.5, 0, 0, 0, -1.2, 0, 1, -2.76, -0.14, 0, 0.46, 0.01, 0, 0.1]),
            ('x=-2.765.orb', [-0.5, 0, 0, -0.023, 0.5995, 0, 2, 0.5, 0, 0, 0, -1.2, 0, 1, -2.765, -0.14, 0, 0.46, 0.01, 0, 0.1]),
        ]
    error = 0
    for item in orbitdata:
        file, data = item
        
        try:
            fd = open(file, 'r')
        except:
            pass # file does not exist
        else:
            continue # file does exist
        
        try:
            fd = open(file, 'w')
        except:
            error = 1
            continue
        
        for nn in range(3*7):
            try:
                fd.write('%g' % data[nn])
            except:
                error = 1
                print 'Cannot write to file '+file
            if ((nn+1) % 7) == 0:
                c = '\n'
            else:
                c = '\t'
            try:
                fd.write('\n')
            except:
                error = 1
                print 'Cannot write to file '+file
    if error:
        print """
If you want to create data files for some interesting orbits,
first save the program in your own folder, then run it again.
"""

def mass_to_radius(mass):
    return M_to_R*mass**(1./3.)

def restoreview():
    scene.range = (sw/sh)*xmax
    scene.up = (0,1,0)
    scene.forward = (0,0,-1)

def restore():
    global save
    for nn in range(3):
        stars[nn].pos = vector(save[7*nn+0],save[7*nn+1],save[7*nn+2])
        stars[nn].vel = vector(save[7*nn+3],save[7*nn+4],save[7*nn+5])
        stars[nn].mass = save[7*nn+6]
    stars[0].color = color.red
    stars[1].color = color.blue
    stars[2].color = color.green
    for s in stars:
        s.radius = mass_to_radius(s.mass)
        s.p = s.mass*s.vel
        s.trail.pos = []
        s.trail.color = s.color
        if s.mass > 0:
            s.visible = 1
    pause(state=1)

def showvarrs():
    for nn in range(3):
        varr[nn].pos = stars[nn].pos
        varr[nn].axis = vscale*stars[nn].vel
        varr[nn].visible = 1

def setdefaultsituation():
    global save
    save = [-0.5,0,0,0,0.6,0,2, # star 0: x,y,z,px,py,pz,m
            0.5,0,0,0,-1.2,0,1, # star 1: x,y,z,px,py,pz,m
            -2,0,0,0,1,0,0.1]   # star 2: x,y,z,px,py,pz,m
    restore()

def getsituation():
    global root
    if not root:
        # The following arcane sequence ensures that the file dialog box
        #   will appear in front of all other windows.
        root = Tk() # invoke Tk (graphics toolkit)
        root.wm_geometry(newGeometry='+0+0')
    else:
        root.deiconify()
    root.wait_visibility() # wait for root window to be displayed
    root.focus_force() # force it to be in focus (in front of all other windows)
    fd = tkFileDialog.askopenfile(filetypes=filetypes)
    root.withdraw() # make root window invisible
    if not fd:
        return
    data = fd.read()
    words = string.split(data)
    # File format: three sets of 7 numbers;
    # x, y, z, vx, vy, vz, mass
    for nn in range(3):
        base = 7*nn
        stars[nn].pos = vector(float(words[base+0]),float(words[base+1]),float(words[base+2]))
        stars[nn].vel = vector(float(words[base+3]),float(words[base+4]),float(words[base+5]))
        stars[nn].mass = float(words[base+6])
    for s in stars:
        s.trail.pos = []
        s.p = s.mass*s.vel
    showvarrs()
    bget.state = 1
    restoreview()

def savesituation():
    global root
    if not root:
        # The following arcane sequence ensures that the file dialog box
        #   will appear in front of all other windows.
        root = Tk() # invoke Tk (graphics toolkit)
        root.wm_geometry(newGeometry='+0+0')
    else:
        root.deiconify()
    root.wait_visibility() # wait for root window to be displayed
    root.focus_force() # force it to be in focus (in front of all other windows)
    fname = tkFileDialog.asksaveasfilename(filetypes=filetypes)
    root.withdraw() # make root window invisible
    if not fname:
        return
    if fname[-4:] != '.orb':
        fname = fname+'.orb'
    fd = open(fname, 'w')
    # File format: three sets of 7 numbers;
    # x, y, z, vx, vy, vz, mass
    for nn in range(3*7):
        fd.write('%g' % save[nn])
        if ((nn+1) % 7) == 0:
            fd.write('\n')
        else:
            fd.write('\t')

def pause(state=None):
    if state != None:
        bpause.state = state
    else:
        bpause.state = not bpause.state
    if bpause.state:
        bpause.text = 'Run'
    else:
        bpause.text = 'Pause'
        
def energy(state=None):
    if state != None:
        benergy.state = state
    else:
        benergy.state = not benergy.state
    if benergy.state:
        benergy.text = 'Hide Energy'
        Kbar.height = 0
        Ubar.height = 0
        Ebar.height = 0
        Kbar.visible = 1
        Ubar.visible = 1
        Ebar.visible = 1
        Klabel.visible = 1
        Ulabel.visible = 1
        Elabel.visible = 1
    else:
        benergy.text = 'Show Energy'
        Kbar.visible = 0
        Ubar.visible = 0
        Ebar.visible = 0
        Klabel.visible = 0
        Ulabel.visible = 0
        Elabel.visible = 0

def reset():
    setdefaultsituation()
    pause(state=1)
    breset.state = 1
    restoreview()

def repeat():
    restore()
    brepeat.state = 1
        
def click():
    # return 1 if click in orbit window
    if scene.mouse.events:
        m = scene.mouse.getevent()
        return m.click
    else:
        return 0

def saveinitialconditions():
    global save
    for nn in range(3):
        save[7*nn] = stars[nn].pos.x
        save[7*nn+1] = stars[nn].pos.y
        save[7*nn+2] = stars[nn].pos.z
        save[7*nn+3] = stars[nn].vel.x
        save[7*nn+4] = stars[nn].vel.y
        save[7*nn+5] = stars[nn].vel.z
        save[7*nn+6] = stars[nn].mass
    
def showenergy():
    K = 0
    U = 0
    for s in stars:
        if s.mass > 0:
            K = K+0.5*(mag(s.p)**2)/s.mass
    for pair in [(0,1), (0,2), (1,2)]:
        i = pair[0]
        j = pair[1]
        if stars[i].mass > 0 and stars[j].mass > 0:
            U = U-G*stars[i].mass*stars[j].mass/mag(stars[i].pos-stars[j].pos)
    Kbar.height = Escale*K
    Kbar.y = Kbar.height/2
    Ubar.height = Escale*U
    Ubar.y = Ubar.height/2
    Ebar.height = Escale*(K+U)
    Ebar.y = Ebar.height/2
                
def orbit():
    dt = 0.01
    for s in stars:
        s.p = s.mass*s.vel
        if s.mass > 0:
            s.visible = 1
    pause(state=0)
    brepeat.state = 0
    saveinitialconditions()
    tclock = clock()
    while 1:
        rate(300)
        ctrl.interact()
        if click() or breset.state or brepeat.state or bget.state:
            pause(state=1)
            return
        if not bpause.state:
            for s1 in stars:  # Find force acting on star s1
                if s1.visible == 0: continue # s1 merged with another star
                F = vector(0,0,0) # We will add up all the forces on s1 
                for s2 in stars:
                    if s2 == s1: continue # All stars but s1 itself
                    if s2.visible == 0: continue # s2 merged with another star
                    r12 = s2.pos-s1.pos
                    if r12.mag <= s1.radius+s2.radius:
                        if s2.mass > s1.mass:
                            s2.color = s1.color
                        s1.mass = s1.mass+s2.mass
                        s1.radius = mass_to_radius(s1.mass)
                        s1.p = s1.p+s2.p
                        s2.visible = 0
                        s2.mass = 0
                        continue
                    else:
                        # Add up all vector forces acting on star s1
                        F = F + (G*s1.mass*s2.mass/mag(r12)**2)*norm(r12)
                s1.p = s1.p+F*dt  # Apply net force to star s1
                
            for s in stars: # After updating momenta, update positions
                if s.visible == 0: continue
                s.pos = s.pos+(s.p/s.mass)*dt
                s.trail.append(pos=s.pos)

            if benergy.state:
                showenergy()

            if clock() > tclock+3:
                instruct.text = ''

#########################################################################

restoreview()
buildfiles()
ctrl = controls(x=scene.x+sw, y=scene.y, width=400, height=200)
bpause = button(pos=(-65,20), width=60, height=30,
             action=lambda: pause())
brepeat = button(pos=(0,20), width=60, height=30, text='Repeat',
             action=lambda: repeat())
benergy = button(pos=(65,20), width=60, height=30,
             action=lambda: energy())
bget = button(pos=(-65,-20), width=60, height=30, text='Get File',
              action=lambda: getsituation())
bsave = button(pos=(0,-20), width=60, height=30, text='Save File',
              action=lambda: savesituation())
breset = button(pos=(65,-20), width=60, height=30, text='Reset',
             action=lambda: reset())
pause(state=1)
bget.state = 0
breset.state = 0
brepeat.state = 0

xi = 0.7*xmax
spacing = 0.1*xmax
w = 0.8*spacing
offset = w/2
Kbar = box(pos=(xi,0,0), size=(w,0,0.01), color=color.magenta, visible=0)
Ubar = box(pos=(xi+spacing,0,0), size=(w,0,0.01), color=color.cyan, visible=0)
Ebar = box(pos=(xi+2*spacing,0,0), size=(w,0,0.01), color=color.yellow, visible=0)
Klabel = label(pos=Kbar.pos+vector(0,-offset,0), text='K', opacity=0, box=0, line=0, visible=0)
Ulabel = label(pos=Ubar.pos+vector(0,offset,0), text='U', opacity=0, box=0, line=0, visible=0)
Elabel = label(pos=Ebar.pos+vector(0,offset,0), text='K+U', opacity=0, box=0, line=0, visible=0)
Escale = 0.7
energy(state=0)

stars = []
stars.append(sphere(visible=0))
stars.append(sphere(visible=0))
stars.append(sphere(visible=0))
for s in stars:
    s.trail = curve()
setdefaultsituation()
ipress = "Press to position green star, then drag to choose initial velocity"
idrag = "Drag to choose initial velocity"
iorbiting = "Click to stop"
inext = "Click to choose new initial conditions"
irun = "Click to run"
instruct = label(pos=(0,0.94*xmax,0), text=ipress, opacity=0, box=0, line=0)

vscale = 0.5 # Scale velocity vectors to graphics window
varr = []
for s in stars:
    varr.append(arrow(pos=s.pos, axis=vscale*s.vel,
                      shaftwidth=0.03, color=s.color, visible=(s.mass > 0)))
vchoose = arrow(pos=(0,0,0), axis=(0,0,0), shaftwidth=0.05, color=color.yellow)
startorbit = 0
pos = None
while 1: # drag to define initial velocity of vstar
    ctrl.interact()
    if not bpause.state:
        pause(state=0)
        startorbit = 1
    if bget.state:
        bget.state = 0
        startorbit = 1
        instruct.text = irun
        while 1:
            if click():
                break
    if brepeat.state:
        brepeat.state = 0
        startorbit = 1
    if startorbit:
        startorbit = 0
        pos = None
        for a in varr:
            a.visible = 0
        vchoose.visible = 0
        instruct.text = iorbiting
        for s in stars:
            s.trail.pos = []
        orbit()
        instruct.text = inext
        while 1:
            ctrl.interact()
            if brepeat.state:
                restore()
                brepeat.state = 0
                startorbit = 1
                break
            if bget.state:
                break
            if click() or breset.state:
                instruct.text = ipress
                if not breset.state:
                    restore()
                showvarrs()
                breset.state = 0
                break
    if pos:
        vchoose.axis = scene.mouse.pos-pos
        # Adjust other stars' momenta so that total p = 0
        pother = vector(0,0,0)
        mother = 0
        for n in range(3):
            if n == vstar:
                p = stars[n].mass*vchoose.axis/vscale
                m = stars[n].mass
            else:
                pother = pother+stars[n].mass*stars[n].vel
                mother = mother+stars[n].mass
        if p.mag > 0:
            votherold = pother/mother
            vothernew = -p/mother # make total momentum be 0
            for n in range(3):
                if n == vstar: continue
                stars[n].vel = (stars[n].vel-votherold)+vothernew
                varr[n].axis = vscale*stars[n].vel
    if scene.mouse.events:
        ev = scene.mouse.getevent()
        if ev.drag:
            if not pos:
                instruct.text = idrag
            pos = ev.pos
            stars[vstar].pos = pos
        elif ev.press == 'left':
            instruct.text = idrag
            vchoose.pos = ev.pos
            vchoose.axis = (0,0,0)
            vchoose.visible = 1
        elif ev.drop or ev.click:
            if ev.drop:
                stars[vstar].vel = vchoose.axis/vscale
            else:
                stars[vstar].pos = ev.pos
                stars[vstar].vel = vector(0,0,0)
                stars[1].vel = -stars[0].mass*stars[0].vel/stars[1].mass
            startorbit = 1




