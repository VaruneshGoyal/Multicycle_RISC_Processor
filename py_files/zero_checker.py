#import math

file_de = open("zerocheck.txt", "w")
for i in xrange(0,65535):
	file_de.write('{0:016b}'.format(i))
	file_de.write(' ')
	if i%256==0:
		file_de.write('{0:01b}'.format(1))
	else:
		file_de.write('{0:01b}'.format(0))
	file_de.write("\n")
file_de.close()
	
