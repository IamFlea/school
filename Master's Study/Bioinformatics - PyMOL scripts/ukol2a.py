# UKOL 2 - podukol 1 
# Autori: Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
# Datum: 8. listopad
# Soubor: ukol2a.py  

from pymol import cmd
MAX_DIST=2.15 # Lepsi 2.05

#cmd.delete("all")
#cmd.load("2bem.pdb")

#cmd.color("white") # Pro jistotu
#cmd.show("lines")

cmd.select("cis", "resn CYS")  
cmd.color("yellow", "cis")

list_of_bonds = []

# Projdi atom po atomu 
for a_mol in cmd.index("CYS/SG", "cis"):
  for b_mol in cmd.index("CYS/SG", "cis"):  
    if a_mol[1] < b_mol[1]: # Neprchazej molekuly ktere uz mam 
      if cmd.dist("tmp", a_mol, b_mol) < MAX_DIST: # Seber Vzdalenost
        print "dist(" + str(b_mol[1]) + ", " + str(a_mol[1])+") = "+ str(cmd.dist("result", a_mol, b_mol))
        list_of_bonds.append(a_mol[1])
        list_of_bonds.append(b_mol[1])
        cmd.select("sulfidy", "?sulfidy | (" + a_mol[0]+ "`" + str(a_mol[1])+")")
        cmd.select("sulfidy", "?sulfidy | (" + b_mol[0]+ "`" + str(b_mol[1])+")")
      cmd.delete("tmp")
if len(list_of_bonds) > 0:
  cmd.color("orange", "sulfidy")
  # Jsem prase and i know it
  def fun(resi, resn, name, index):
    global list_of_bonds
    for i in list_of_bonds:
      if i == index:
        cmd.select("resultino", "?resultino | (resi "+resi+" & resn CYS) ")
  cmd.iterate("cis", "fun(resi, resn, name, index)")       
  cmd.select("cis", "resn CYS")  
  cmd.color("orange", "resultino")
  cmd.label("sulfidy", "resi")

else:
  print "Nebyly nalezeny zadne cysteinove mosty, protoze je jeste stavari nepostavili."
    