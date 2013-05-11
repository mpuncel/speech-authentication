import os
import operator
root = r'/Users/michaelpuncel/Desktop/Spring2013/6.345/speech-authentication/by_speaker/'

matlab_script = file(r'/Users/michaelpuncel/Desktop/Spring2013/6.345/speech-authentication/matlab_scripts/mfcc_saver.m', 'w')

for root, dirs, files in os.walk(root):
    for dir in dirs:
        for root2, dirs2, files2 in os.walk(os.path.join(root, dir)):
            for filename in files2:
                if filename[len(filename) - 4:] == '.wav':
                    try:
                        opa_file = file(root + dir + '/' + filename[0:-4] + '.opa')
                    except IOError:
                        continue
                    lines = opa_file.readlines()
                    first_line = lines[0]
                    last_line = lines[-1]
                    foo = 1
                    while last_line == '\n':
                        last_line = lines[-1 - foo]
                        foo += 1

                    start_index = first_line.split(' ')[0]
                    end_index = last_line.split(' ')[1]

                    filepath = os.path.join(root, filename)
                    matlab_script.write('compute_mfcc(\'%s\', \'%s\', \'%s\', %s, %s)' % (dir, filename[0: -4] + '.mat', filename, start_index, end_index))
                    matlab_script.write('\n')

matlab_script.close()
