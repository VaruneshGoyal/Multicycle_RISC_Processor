#import math

file_de = open("tracefile_datamux.txt", "w")
c = 0
for i in xrange(0,1024):
	c = c+1
	c = c%4
	file_de.write('{0:02b}'.format(c))
	file_de.write(' ')
	file_de.write('{0:016b}'.format(i))
	file_de.write(' ')
	file_de.write('{0:016b}'.format(i+1))
	file_de.write(' ')
	file_de.write('{0:016b}'.format(i+2))
	file_de.write(' ')
	file_de.write('{0:016b}'.format(i+3))
	file_de.write(' ')
	file_de.write('{0:016b}'.format(i+c))
	file_de.write("\n")
file_de.close()
