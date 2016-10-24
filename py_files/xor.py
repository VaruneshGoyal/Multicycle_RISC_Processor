#import math

file_de = open("xor.txt", "w")
for i in xrange(0,32):
	for j in xrange(50,80):
		file_de.write('{0:016b}'.format(i))
		file_de.write(' ')
		file_de.write('{0:016b}'.format(j))
		file_de.write(' ')
		file_de.write('{0:016b}'.format(i^j))
		file_de.write("\n")
file_de.close()
	
