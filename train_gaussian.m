function train_gaussian( datapath, centroidpath )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

clc
close all

centroids = dlmread(centroidpath);
data = dlmread(datapath, '\t');

NUM_ITERS = 75;
NUM_GAUSSIANS = size(centroids, 1);
[NUM_FRAMES, DIMENSIONS] = size(data);

weights = zeros(1,NUM_GAUSSIANS) + 1/NUM_GAUSSIANS;
variances = cell(1, NUM_GAUSSIANS);
likelihood = zeros(NUM_FRAMES,NUM_ITERS);

for i=1:NUM_GAUSSIANS
    variances{i} = 1750*eye(DIMENSIONS);
end

% figure;
% col=hsv(10);
for iter = 1:NUM_ITERS
    
    denominator = zeros(NUM_FRAMES, 1);
    prob_gaussian = zeros(NUM_GAUSSIANS, NUM_FRAMES);
    for i=1:NUM_GAUSSIANS
        denominator = denominator + weights(i) * mvnpdf(data, centroids(i,:), variances{i});
    end
    
    for i=1:NUM_GAUSSIANS
        prob_gaussian(i, :) = weights(i) * mvnpdf(data, centroids(i,:), variances{i}) ./ denominator;
    end
    
    weights = sum(prob_gaussian,2)/NUM_FRAMES;
    centroids = prob_gaussian * data ./ (sum(prob_gaussian, 2) * ones(1, DIMENSIONS));
    
    for i=1:NUM_GAUSSIANS
        data_minus_centroid = (data - (ones(NUM_FRAMES, 1) * centroids(i,:)));
        data_minus_centroid = repmat(prob_gaussian(i, :),DIMENSIONS,1)*data_minus_centroid'*data_minus_centroid;
        variances{i} = sum(prob_gaussian(i, :)*data_minus_centroid, 1) ./ sum(prob_gaussian(i,:));
        size(variances{i})
    end
%     subplot(221);plot(1:100,prob_gaussian(1,1:100), 'color', col(iter,:),'marker','o');
%     hold on;
%     subplot(222);plot(1:100,prob_gaussian(2,1:100), 'color', col(iter,:),'marker','o');
%     hold on;
%     subplot(223);plot(1:100,prob_gaussian(3,1:100), 'color', col(iter,:),'marker','o');
%     hold on;
%     subplot(224);plot(1:100,prob_gaussian(4,1:100), 'color', col(iter,:),'marker','o');
%     hold on;
%     for i=1:NUM_GAUSSIANS
%         likelihood(:,iter)=likelihood(:,iter)+mvnpdf(data,centroids(i,:), variances{i})*weights(i);
%     end
%     likelihood(:,iter)= log(likelihood(:,iter));
end
% legend('Iter1','Iter2','Iter3','Iter4','Iter5','Iter6','Iter7','Iter8','Iter9','Iter10')


[path filename ext] = fileparts(datapath);
gmm_params.weights = weights;
gmm_params.means = centroids;
gmm_params.variances = variances;
save(strcat(path, '/gmm8.mat'), '-struct', 'gmm_params');

% h = figure;
% plot(1:NUM_ITERS,sum(likelihood,1),'marker','o')
% xlabel('Iterations')
% ylabel('Log Likelihood')
% title('Log Likelihood of Data Set')
% saveas(h, strcat(path,'/likelihood_plot.jpeg'))
