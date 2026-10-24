%% impsol function draw the improved solution graph

function [G]= impsol(X,L,pk)

clc
% load('X.mat');
% load('L.mat');
% load('pk.mat');
%% trouver l'indice du min sol
mini=L(1);
    best_idx=1;

for i=2:length(L)
    if L(i)<mini
        mini=L(i);
        best_idx=(i);
    end
end

%% construir le min tour
%p=pk(best_idx,:);
p = pk;          % au lieu de pk(best_idx,:) ou pk{best_idx}
%% graph drawing using p vertex (best tour)
n=length(p);
G = graph;
G = addnode(G,n);
plot(X(:,1),X(:,2),'kx','MarkerSize',8,'LineWidth',2)

% Add node numbers
for k = 1:n-1
 	str = sprintf(' %d',k);
 	text(X(k,1),X(k,2),str)
end
hold on

for i=1:n-2
plot([X(p(i),1) X(p(i+1),1)],[X(p(i),2) X(p(i+1),2)],'b','LineWidth',2)
        G=addedge(G,p(i),p(i+1));
        i=i+1;
        pause(0.2)
title("BECRA's Best Solution");
end


end

