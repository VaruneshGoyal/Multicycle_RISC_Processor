#import math

file_de = open("SE9-16.txt", "w")
for i in xrange(0,512):
	file_de.write('{0:09b}'.format(i))
	file_de.write(' ')
	if i/256==0:
		file_de.write('{0:016b}'.format(i))
	else:
		file_de.write('{0:016b}'.format(i+ 65024))
	file_de.write("\n")
file_de.close()
	
