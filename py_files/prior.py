#import math

file_de = open("Prior.txt", "w")
for i in range(0,256):
	file_de.write('{0:08b}'.format(i))
	file_de.write(' ')
	if i%2!=0:
		file_de.write('{0:03b}'.format(0))
	elif (i/2)%2!=0:
		file_de.write('{0:03b}'.format(1))
	elif (i/4)%2!=0:
		file_de.write('{0:03b}'.format(2))
	elif (i/8)%2!=0:
		file_de.write('{0:03b}'.format(3))
	elif (i/16)%2!=0:
		file_de.write('{0:03b}'.format(4))
	elif (i/32)%2!=0:
		file_de.write('{0:03b}'.format(5))
	elif (i/64)%2!=0:
		file_de.write('{0:03b}'.format(6))
	elif (i/128)%2!=0:
		file_de.write('{0:03b}'.format(7))
	file_de.write("\n")
file_de.close()
	
