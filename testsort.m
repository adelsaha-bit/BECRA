function [edges]= testsort(tau_cum,D,n)

% clc;
% clear all 
% %[tour,D,n_ants,X,best_length]=TSPaco; %% create solutions applying ACO Algorithm
% [tour,D,n_ants,X,best_length,tau_cum]=TSPcum;
% n=length(D); % longueur du tour càd le nmbr de sommet de graphe
% occur=zeros(n,n);% le nbr de possibilité de laisons n(n-1)
% z = n*n_ants; %% z is the size of C vector "all vertices in all solutions"

%A =tau_cum;
for i=1:n
    for j=1:n
      tau_cum(i,i)=0;
    end
end
C = reshape(tau_cum',1,[]);
vector = C;
%%%%%%%%%%%%%%%%%%



% Convert matrix to vector and sort
[vals, linresult] = sort(tau_cum(:),'descend');

% Convert linear indices to row & column indices
[row, col] = ind2sub(size(tau_cum), linresult);

 %% result contain cumulated pheromone by descending order  with edges index

%result = table(row, col,vals);
result=[row,col];
edges=result;
% edges(:,3)=[];
end