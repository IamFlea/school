# UKOL 2 - podukol 2 
# Autori: Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
# Datum: 8. listopad
# Soubor: ukol2b.py  

from pymol import cmd
from pymol.cgo import *

# Hmm tak jo:
coords = cmd.centerofmass()
spherelist = [COLOR, 0.700, 0.300, 1.000, 
              SPHERE, coords[0], coords[1], coords[2], 1]
cmd.load_cgo(spherelist, 'CENTER_BALL',   0)
print coords
