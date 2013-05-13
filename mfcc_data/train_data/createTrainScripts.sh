JOBFILE=train_gaussian_saver.m

for DIR in ./*
do
    echo train_gaussian\'mfcc_data/train_data/"$DIR"/joined.txt\', \'mfcc_data/train_data/"$DIR"/"$DIR"_k_means_centers_8.txt\' >> "$JOBFILE"

done
