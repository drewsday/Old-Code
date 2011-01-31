from visual import *

c = curve( x = arange(0,20,0.1), radius=0.5 ) # Draw a helix

c.y = sin( 2.0*c.x )

c.z = cos( 2.0*c.x )

