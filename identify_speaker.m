function identify_speaker( path_to_data, directory_file )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    [path, speech_filename ext] = fileparts(path_to_data);
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
      
        if probability == 0
            probability
        end
        if probability > max_prob
            max_prob = probability;
            max_prob_speaker = speaker_name;
        end
        
        probability_array(i) = probability;
        speaker_names{i} = speaker_name;
    end
    %probability_array
    
    true_probability = speaker_model_probability(path_to_data, strcat('mfcc_data/train_data/', this_speaker, '/gmm8.mat'));
    
    sorted_probability = sort(probability_array, 'descend');
    %sorted_probability
    rank = find(sorted_probability==true_probability);
    rank = rank(1);
    %rank
    outputfile = fopen('classifications.txt', 'a');

    %SPEAKER_TESTED SPEAKER_IDENTIFIED RANK_OF_TRUE_SPEAKER
    %PROBABILITY_OF_TRUE_SPEAKER PROBABILITY_OF_IDENTIFIED_SPEAKER
    %PROBABILITY_OF_SECOND_CHOICE_SPEAKER AVERAGE_PROBABILITY
    %PROBABILITY_VARIANCE
    fprintf(outputfile, '%s\t%s\t%s\t%u\t%f\t%f\t%f\t%f\t%f\n', speech_filename, this_speaker, max_prob_speaker, rank, true_probability, max_prob, sorted_probability(2), mean(sorted_probability), var(sorted_probability));
    fclose(outputfile);
end