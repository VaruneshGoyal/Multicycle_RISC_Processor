#import math

file_de = open("SE6-16.txt", "w")
for i in xrange(0,64):
	file_de.write('{0:06b}'.format(i))
	file_de.write(' ')
	if i/32==0:
		file_de.write('{0:016b}'.format(i))
	else:
		file_de.write('{0:016b}'.format(i+ 65472))
	file_de.write("\n")
file_de.close()
	
