#import math

file_de = open("DE.txt", "w")
for i in xrange(0,512):
	file_de.write('{0:09b}'.format(i))
	file_de.write(' ')
	file_de.write('{0:016b}'.format(i*128))
	file_de.write("\n")
file_de.close()
	
