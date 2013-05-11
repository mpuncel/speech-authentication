import os
import operator

file_file = file(r'/Users/michaelpuncel/Desktop/Spring2013/6.345/speech-authentication/mfcc_data/mat_files', 'r')
matlab_script = file(r'/Users/michaelpuncel/Desktop/Spring2013/6.345/speech-authentication/matlab_scripts/mat_converter.m', 'w')

for line in file_file:
    line = line.strip()
    matlab_script.write('mat_to_txt(\'mfcc_data/%s\')\n' % line)

matlab_script.close()

