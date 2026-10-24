%% Based Edge Credebility ranking Algorithm
clc;
clear all;

%% Load results file
if exist('mes_resultats.mat', 'file')
    load('mes_resultats.mat', 'results');
end

%% compute the frequency of each edge
[tour,D,n_ants,X,best_length,tau_cum]=TSPcum; % you can use also TSPaco
[occur,idx]=sortedoccurences(tour,D,n_ants); %% find the occurences of each edge in all solutions
[edgesf]= edges_occur(idx); %% edges vector contains edges sorted by decreasing order of occurences 
[edgesf]= undoubles(edgesf);%% if we retain edge(i,j), we eleminate edge(j,i) but its frequeny is added to edge(i,j)
%% compute the pourcentage of edgesf 
 n = size(edgesf, 1);
edgesf = [edgesf, edgesf(:,3)/n];

%% calculte edges(quality) and edgesf (frequency) 
 n =length(X);
[edges]=testsort(tau_cum,D,n); %% find the quality of each edge based on tau_cum 

%% 
% Initialization
cred = zeros(size(edgesf));  

% Compute the credebility of each edge
for k = 1:size(edgesf,1)
    i = edgesf(k,1);
    j = edgesf(k,2);
    freq = edgesf(k,4);
    
    if freq > 0
       cred(i,j) = tau_cum(i,j) / (1-freq);
        
    end
end

%% credsort contain edges sorted by decreasin credebility
[i, j, val] = find(cred);         
cred_list = [i, j, val];
[~, idx] = sort(cred_list(:,3), 'descend');
cred_sort = cred_list(idx, :);

%% create solutions using BECRA based on cred_sort
[L,pk]=bestgraph(X,D,cred_sort);%% edges_credebility_based heuristic

if min(L)< best_length
   % best_tour=p;
     str=sprintf('The improved solution by BEQRA algorithm is: %g', min(L))

else
     str=sprintf('There is NO impovement by BEQRA algorithm Tour Length: %g',best_length)
end
best_BECRA=min(L);
close all;
[G]=impsol(X,L,pk);
opt2becra;


%% Creation of new result lign   
nouvelle_ligne = [best_length, best_BECRA, best_BECRA_2opt];

% If the variable results does not exist yet → create it
if ~exist('results', 'var')
    results = nouvelle_ligne;
else
% Otherwise, add the new line at the bottom
end
%% Save results
save('mes_resultats.mat', 'results');