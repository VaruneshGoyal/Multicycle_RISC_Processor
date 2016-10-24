#import math

file_de = open("tracefile_dataregister.txt", "w")
k=0
d = 0
for i in xrange(0,2**10):
	k = 1-k
	file_de.write('{0:01b}'.format(k))
	file_de.write(' ')
	file_de.write('{0:016b}'.format(i))
	file_de.write(' ')
	file_de.write('{0:016b}'.format(d))
	file_de.write("\n")
	if k==1 :
		d = i
file_de.close()
	
