function Exercise3_kmeans(k)
%EXERCISE3_KMEANS Summary of this function goes here
%   Detailed explanation goes here
[dataset_all,cluster_init_all] = load_data();
threshold = 1e-6;
for i=1:3
    distortion = inf;
    delta_distortion = inf;
    %%
    clusters = cluster_init_all(:,:,i);
    dataset = dataset_all(:,:,i);
    [~,prediction] = E_step(k,clusters,dataset);
    while delta_distortion >= threshold
        clusters = M_step(k,prediction,dataset);
        [square_err, prediction] = E_step(k,clusters,dataset);
        distortion_old = distortion;
        distortion = sum(square_err); 
        delta_distortion = distortion_old - distortion;
    end
    plot_clusters(k, prediction, dataset);
end
end


%%
function [dataset_all,cluster_init_all] = load_data()
load ('gesture_dataset.mat');
size_temp = [size(gesture_l,1)*size(gesture_l,2), size(gesture_l,3)];
dataset_all = zeros([size_temp, 3]);
dataset_all(:,:,1) = reshape(gesture_l,size_temp);
dataset_all(:,:,2) = reshape(gesture_o,size_temp);
dataset_all(:,:,3) = reshape(gesture_x,size_temp);
cluster_init_all = zeros([size(init_cluster_l),3]);
cluster_init_all(:,:,1) = init_cluster_l;
cluster_init_all(:,:,2) = init_cluster_o;
cluster_init_all(:,:,3) = init_cluster_x;
end


%%
function [square_err, prediction] = E_step(k,clusters,dataset)
distance = zeros(size(dataset,1),k);
for j=1:k
    cluster = clusters(j,:);
    clusters_replica = repmat(cluster,size(dataset,1),1);
    distance(:,j) = sum((clusters_replica-dataset).^2,2).^0.5;
end
[square_err, prediction] = min(distance,[],2);
square_err = square_err.^2;
end


%% 
function clusters = M_step(k,prediction,dataset)
clusters = zeros(size(prediction,1),size(dataset,2));
for j=1:k
    index_cluster = find(prediction==j);
    dataset_cluster = dataset(index_cluster,:);
    clusters(j,:) = mean(dataset_cluster);
end
end


%%
function plot_clusters(k, prediction, dataset)
color = ['b','k','r','g','m','y','c'];
figure
hold on
for j=1:k
    index_cluster = find(prediction==j);
    dataset_cluster = dataset(index_cluster,:);
    scatter(dataset_cluster(:,1),dataset_cluster(:,2),strcat(color(j),'*'));
end
hold off
end

