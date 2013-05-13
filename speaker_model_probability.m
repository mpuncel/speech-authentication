function [output] = speaker_model_probability( path_to_data, path_to_model)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
data = dlmread(path_to_data, '\t');
%data = data(1:300, :);

%now have weights, means, variances
load(path_to_model);
NUM_GAUSSIANS = size(weights,1);
num_frames = size(data, 1);

prob_matrix = zeros(num_frames, 1);

for i=1:NUM_GAUSSIANS
    prob_matrix = prob_matrix + weights(i)*mvnpdf(data, means(i, :), variances{i});
end

output = sum(log(prob_matrix), 1);
end