# UKOL 2 - podukol 3 
# Autor: Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
# Datum: 8. listopad
# Soubor: ukol2c.py  

from pymol import cmd
from math import sqrt
#Vytvorte skript, ktory najde v proteine par atomov s minimalnou 
# (okrem susedov v primarnej strukture) a maximalnou vzdialenostou a vyznaci 
#  ich v zobrazeni farbou a vzdialenostou.
#cmd.load("1a06.pdb")

minimal = float("inf")
maximal = 0.0
max_atom_a = None
max_atom_b = None
min_atom_a = None
min_atom_b = None

atoms = cmd.get_model("all")
for atom_a in atoms.atom:
  for atom_b in atoms.atom:
    # PRESKOC TO CO UZ MAME 
    if (int(atom_a.resi)) <= (int(atom_b.resi)+1): # +1  PRESKOC SUSEDA
      continue
     
    dist = sqrt((atom_a.coord[0]-atom_b.coord[0])**2+ (atom_a.coord[1]-atom_b.coord[1])**2+(atom_a.coord[2]-atom_b.coord[2])**2)
    if maximal < dist:
      maximal = dist 
      max_atom_a = atom_a
      max_atom_b = atom_b
    if dist < minimal:
      minimal = dist 
      min_atom_a = atom_a
      min_atom_b = atom_b


print "MAX distance: " + str(maximal) + " " + "[" +str(max_atom_a.index) + ", "+ str(max_atom_b.index) +"]"
print "MIN distance: " + str(minimal) + " " + "[" +str(min_atom_a.index) + ", "+ str(min_atom_b.index) +"]"
cmd.dist("MAX_DISTANCE", cmd.index("index "+ str(max_atom_a.index))[0], cmd.index("index "+ str(max_atom_b.index))[0])
cmd.dist("MIN_DISTANCE", cmd.index("index "+ str(min_atom_a.index))[0], cmd.index("index "+ str(min_atom_b.index))[0])
cmd.color("orange", "MIN_DISTANCE")
cmd.color("white", "MAX_DISTANCE")
      
      
    
#"""
      