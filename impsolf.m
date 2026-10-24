%% impsol function draw the improved solution graph

function [G1]= impsol(X,Lf,pkf)

clc
% load('X.mat');
% load('L.mat');
% load('pk.mat');
%% trouver l'indice du min sol
mini=Lf(1);
    best_idx=1;

for i=2:length(Lf)
    if Lf(i)<mini
        mini=Lf(i);
        best_idx=(i);
    end
end

%% construir le min tour
pkf=pkf(best_idx,:);

%% graph drawing using p vertex (best tour)
n=length(pkf);
G1 = graph;
G1 = addnode(G1,n);
plot(X(:,1),X(:,2),'kx','MarkerSize',8,'LineWidth',2)

% Add node numbers
for k = 1:n-1
 	str = sprintf(' %d',k);
 	text(X(k,1),X(k,2),str)
end
hold on

for i=1:n-2
plot([X(pkf(i),1) X(pkf(i+1),1)],[X(pkf(i),2) X(pkf(i+1),2)],'b','LineWidth',2)
        G1=addedge(G1,pkf(i),pkf(i+1));
        i=i+1;
        pause(0.2)
end
plot([X(pkf(i),1) X(pkf(i+1),1)],[X(pkf(i),2) X(pkf(i+1),2)],'b','LineWidth',2);


end


%save ('L','L');