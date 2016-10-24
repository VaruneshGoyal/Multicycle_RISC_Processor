#import math

file_de = open("TRACEFILE_ALU.txt", "w")
control=0
for j in [45, -45, 32700, -32700, -32768, 32767]:
	for i in range(-150,150):
		file_de.write('{0:02b}'.format(control))
		file_de.write(' ')
		#file_de.write(str(i))
		#file_de.write(' ')
		#file_de.write(str(j))
		#file_de.write(' ')
		#file_de.write(str(i+j))
		#file_de.write(' ')
		file_de.write(format(i if i >= 0 else (1 << 16) + i, '016b'))
		file_de.write(' ')
		file_de.write(format(j if j >= 0 else (1 << 16) + j, '016b'))
		file_de.write(' ')
		file_de.write(format((i+j) if (i+j) >= 0 else (1 << 16) + (i+j), '016b'))
		file_de.write(' ')
		#file_de.write(str(i+j))
		#file_de.write(' ')
		file_de.write(format(1 if ((i+j) > 32767 or (i+j) < -32768) else 0, '01b'))
		file_de.write(format(1 if (i+j) == 0 else 0, '01b'))
		file_de.write("\n")
	
control=2
c=1
j=4500
for i in range(4450,4550):
	c=1-c;
	file_de.write('{0:02b}'.format(control))
	file_de.write(' ')
	file_de.write(format(i, '016b'))
	file_de.write(' ')
	file_de.write(format(j, '016b'))
	file_de.write(' ')
	file_de.write(format(~(i&j) if ~(i&j) >= 0 else (1 << 16) + ~(i&j), '016b'))
	file_de.write(' ')
	file_de.write(format(c, '01b'))
	file_de.write(format(1 if ~(i&j) == 0 else 0, '01b'))
	file_de.write("\n")
	
	
control=1
for i in range(4490,4505):
	for i in range(4450,4550):
		c=1-c;
		file_de.write('{0:02b}'.format(control))
		file_de.write(' ')
		file_de.write(format(i, '016b'))
		file_de.write(' ')
		file_de.write(format(j, '016b'))
		file_de.write(' ')
		file_de.write(format((i^j), '016b'))
		file_de.write(' ')
		file_de.write(format(c, '01b'))
		file_de.write(format(1 if (i^j) == 0 else 0, '01b'))
		file_de.write("\n")
file_de.close()
	
	
	
	
	
	
	
	
	
	
	
	
	
