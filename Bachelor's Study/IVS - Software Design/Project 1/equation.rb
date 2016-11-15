# Projekt č. 1
# Jméno: Petr Dvořáček
# E-mail: xdvora0n@stud.fit.vutbr.cz
# 
def solve(a, b, c)
  x = []
  if a == 0
    if b == 0 
      x = nil
    else
      x << (-c)/(b*1.0)
    end
  else
    d = b*b-4*a*c
    if d > 0
      d = Math.sqrt(d)
      x << ((-b+d)/(2*a))
      x << ((-b-d)/(2*a))
    elsif d == 0
      x << (-b)/(2*a)
    else
      x = nil	
    end	
  end
  return x
end
