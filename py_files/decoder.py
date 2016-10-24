#import math

file_de = open("decoder.txt", "w")
for i in xrange(0,8):
	file_de.write('{0:03b}'.format(i))
	file_de.write(' ')
	file_de.write('{0:08b}'.format(2**i))
	file_de.write("\n")
file_de.close()
	
