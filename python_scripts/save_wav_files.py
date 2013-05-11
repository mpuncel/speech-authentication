import os

for root, folders, files in os.walk('Documents/timit_new'):
    for f in files:
        dir = f[f.rfind('-')+1:f.find('.wav')]

        cmd = "mv Documents/timit_new/%s Documents/MIT/MENG/6.345/Project/by_speaker/%s/%s" %(f,dir,f)
        stdIn, stdOut, stdErr = os.popen3(cmd)
        
        lines = stdErr.readlines()
        if len(lines)>0:
            print(lines)
            break
            break
