function train_gaussian( datapath, centroidpath )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

clc
close all

centroids = dlmread(centroidpath);
data = dlmread(datapath, '\t');
numIters = 50;
centroids = [1; -1];
data = [2; 1; -1; -2];
NUM_GAUSSIANS = size(centroids, 1);

[num_frames, DIMENSIONS] = size(data);

weights = zeros(1,NUM_GAUSSIANS) + 1/NUM_GAUSSIANS;
variances = cell(1, NUM_GAUSSIANS);

for i=1:NUM_GAUSSIANS
    variances{i} = eye(DIMENSIONS);
end

for iter = 1:1
    
    denominator = zeros(num_frames, 1);
    prob_gaussian = zeros(NUM_GAUSSIANS, num_frames);
    for i=1:NUM_GAUSSIANS
        denominator = denominator + weights(i) * mvnpdf(data, centroids(i), variances{i});
%         denominator
    end
    
    for i=1:NUM_GAUSSIANS
        prob_gaussian(i, :) = weights(i) * mvnpdf(data, centroids(i), variances{i}) ./ denominator;
    end
    
    weights = sum(prob_gaussian,2)/num_frames;
%     size(prob_gaussian * data)
%     size(sum(prob_gaussian, 2))
%     size(prob_gaussian)
%     prob_gaussian
%     foo = sum(prob_gaussian, 2) * ones(1, 28)
%    size(foo)
     
    centroids = prob_gaussian * data ./ (sum(prob_gaussian, 2) * ones(1, DIMENSIONS));
    
    for i=1:NUM_GAUSSIANS
        data_minus_centroid = (data - (ones(num_frames, 1) * centroids(i,:))).^2;
        variances{i} = sum(prob_gaussian(i, :)*data_minus_centroid, 1) ./ sum(prob_gaussian(i,:));
    end
end

[path filename ext] = fileparts(datapath);
gmm_params.weights = weights;
gmm_params.means = centroids;
gmm_params.variances = variances;
save(strcat(path, '/gmm8.mat'), '-struct', 'gmm_params');
path
