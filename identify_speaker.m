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
        end
        probability_array(i) = probability;
        speaker_names{i} = speaker_name;
    end
    outputfile = fopen('classifications.txt', 'a');
    
    fprintf(outputfile, '%s\t%s\n', this_speaker, max_prob_speaker);
    fclose(outputfile);
end