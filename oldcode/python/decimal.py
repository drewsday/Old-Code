
from visual import *
from time import sleep

pause=.1

c=[]
def init():
        for i in range(10):
                c.append((0,0,0))

        c[0]=[255,255,255]
        c[1]=[255,153,51]
        c[2]=[102,102,153]
        c[3]=[255,0,102]
        c[4]=[102,102,153]
        c[5]=[255,102,0]
        c[6]=[128,0,128]
        c[7]=[255,255,0]
        c[8]=[51,51,153]
        c[9]=[255,0,102]
        for each in c:
                for i in (0,1,2):
                        each[i]=each[i]/255.
        #scene.forward=[0.5,-0.5,-1]
        #scene.forward=[0,10,0]

init()

def tenblocks(firstblock=0):
        global pause
        for i in range(10):
                box(color=c[i],pos=(0,0,-firstblock + 10 -i))
                if pause>0.05:
                        pause= pause * 0.99
                        sleep(pause)

def trailingzeros(n):
        s=str(n)
        lnth=len(s)
        for i in range(1,1+lnth):
                if not s[-i] == '0':
                        break
        return i-1

def CarryN(number=1):
        if number>0: #we're getting every ending in 0
                for position in range(trailingzeros(number)):
                        width=10**(position + 1)
                        xpos=0
                        ypos= - (position + 1)
                        zpos=10 + 0.5  -(number + (width / 2))
                        size=(width,1,width)
                        colorindex=(number / width) % 10
                        print number, colorindex
                        b=box(pos=(xpos,ypos,zpos), size=size, width=width, color=c[colorindex])


def Carry10(number=1):
        #assume < 100
        width=10

        print '>>>10s', number
        xpos=0
        ypos=-1
        zpos=10 + 0.5  -(number + (width / 2))
        size=(10,1,10)
        if number > 0:
                b=box(pos=(xpos,ypos,zpos), size=size, width=width, color=c[((number / 10) % 10)])


def ShowUpTo(Number=50):
        Tens=Number/10
        for i in range(Tens):
                CarryN(number=i*10)
                tenblocks(firstblock=i*10)

ShowUpTo(Number=11010)


