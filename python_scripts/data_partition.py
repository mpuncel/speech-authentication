import random
import os
import operator
root_root = r'/Users/michaelpuncel/Desktop/Spring2013/6.345/speech-authentication/mfcc_data'
data_root = root_root + '/mat/'

print data_root
for root, dirs, files in os.walk(data_root):
    print root
    for dir in dirs:
        for root2, dirs2, files2 in os.walk(os.path.join(root, dir)):
            train_set = set(random.sample(files2, len(files2)/2))
            test_set = set(files2).difference(train_set)
            join_file = open(root_root + '/trainData/' + dir + '/' + 'joined.mat', 'w')
            for filename in train_set:
                oldpath = root + dir + '/' + filename
                newpath = root_root + '/trainData/' + dir + '/' + filename
                stdIn, stdOut, stdErr = os.popen3('cp %s %s' % (oldpath, newpath))

                lines = stdErr.readlines() 
                if len(lines) > 0:
                    print lines

                source_file = file(oldpath, 'r')
                join_file.write(source_file.read())
            join_file.close()

            for filename in test_set:
                oldpath = root + dir + '/' + filename
                newpath = root_root + '/testData/' + dir + '/' + filename
                stdIn, stdOut, stdErr = os.popen3('cp %s %s' % (oldpath, newpath))

                lines = stdErr.readlines() 
                if len(lines) > 0:
                    print lines

