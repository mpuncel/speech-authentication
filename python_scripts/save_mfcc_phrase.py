import os
import operator
root = r'/Users/michaelpuncel/Desktop/Spring2013/6.345/speech-authentication/by_speaker/'

words = {}
sentences = {}
file_file = file(r'/Users/michaelpuncel/Desktop/Spring2013/6.345/speech-authentication/phrase_files.txt', 'r')
matlab_script = file(r'/Users/michaelpuncel/Desktop/Spring2013/6.345/speech-authentication/phrase_mfcc_saver.m', 'w')

for line in file_file:
    chunks = line.split('/')
    matlab_script.write('compute_mfcc(\'%s\', \'%s\', \'%s\')\n' % (chunks[1] + '/', chunks[2].split('.')[0], chunks[2].split(':')[0][0:-4] + '.wav'))

matlab_script.close()

