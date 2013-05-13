function [ probability_array, speaker_names ] = identify_speaker( path_to_data, directory_file )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    [path, filename ext] = fileparts(path_to_data);
    parts = regexp(path, '/', 'split');
    this_speaker = parts{3};
    
    directories = textread(directory_file, '%s');
    num_models = size(directories, 1);
    
    probability_array = zeros(num_models,1);
    speaker_names = cell(num_models, 1);
    
    max_prob = -Inf;
    max_prob_speaker = '';
    
    for i=1:num_models
        [path, filename, ext] = fileparts(directories{i});
        parts = regexp(path, '/', 'split');
        speaker_name = parts{3};
        probability = speaker_model_probability(path_to_data, directories{i});
      
        if probability > max_prob
            max_prob = probability;
            max_prob_speaker = speaker_name;
        probability_array(i) = probability;
        speaker_names{i} = speaker_name;
        end
    end
    
    true_probability = speaker_model_probability(path_to_data, strcat('mfcc_data/train_data/', this_speaker, '/gmm8.mat'));
    
    sorted_probability = sort(probability_array, 'ascend');
    sorted_probability
    rank = find(sorted_probability==true_probability);
    rank = rank(1);
    rank
    outputfile = fopen('classifications.txt', 'a');

    fprintf(outputfile, '%s\t%s\t%u\n', this_speaker, max_prob_speaker, rank);
    fclose(outputfile);
end