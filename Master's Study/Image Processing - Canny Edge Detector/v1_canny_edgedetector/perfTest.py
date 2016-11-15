import subprocess
import os

perfLog = open("perfLog", "w")
fullAvg = 0
count = 1
for root, dirs, files in os.walk("test_pics"):
  avg = 0
  for name in files:
    print "Testing '" + os.path.join(root, name) + "'..."
    avgSum = 0
    for cnt in range(0, count):
      out = subprocess.Popen(['./canny', '-i', os.path.join(root, name)], stdout=subprocess.PIPE).communicate()[0]
      print out
      try:
        avgSum += float(out)
      except ValueError:
        print "Fail during edge detection in file '" + os.path.join(root, name) + "'. Probably too big input file."
        break
    
    
    if avgSum == 0:
      continue
    avg = avgSum/count
    strAvg = str('{0:.7f}'.format(avg))
    print "AVG: " + strAvg
    perfLog.write(name + "- AVG:" + strAvg + "\n")
    fullAvg += avg
    
print "FULL AVG: " + str(fullAvg)
perfLog.write("FULL AVG: " + str(fullAvg) + "\n")
perfLog.close()    
      

