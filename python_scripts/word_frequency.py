import os
import operator
root = r'/Users/michaelpuncel/Desktop/Spring2013/6.345/speech-authentication/by_speaker/'

words = {}
sentences = {}
matlab_script = file(r'/Users/michaelpuncel/Desktop/Spring2013/6.345/speech-authentication/wav_converter.m', 'w')

for root, dirs, files in os.walk(root):
    for filename in files:
        if filename[len(filename) - 4:] == '.txt':
            fp = file(os.path.join(root, filename), 'r')
            for line in fp:
                line_words = line.split(' ')
                for word in line_words:
                    words[word] = words.get(word, 0) + 1
                sentence = ' '.join(line_words[2:])
                sentences[sentence] = sentences.get(sentence, 0) + 1
        if filename[len(filename) - 4:] == '.wav':
            filepath = os.path.join(root, filename)
            matlab_script.write('wavReadTimit(\'%s\')\n' % filepath)

matlab_script.close()
fp.close()



sorted_sentences = sorted(sentences.iteritems(), key=operator.itemgetter(1))
sorted_words = sorted(words.iteritems(), key=operator.itemgetter(1))
import ipdb; ipdb.set_trace()

