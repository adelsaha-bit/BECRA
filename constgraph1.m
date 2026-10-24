%% BITSP solving using the edges_frequency_based heuristic
%  Part of this software inspired by 
%  Didier Maquin (2024). TSP2024 TSP solving using the Clark and Wright heuristic
%  (https://www.mathworks.com/matlabcentral/fileexchange/158496-tsp2024)
%  MATLAB Central File Exchange. 
function [L1_new,L2_new,pk,gen_tour]= constgraph1 (X1,X2,edges,nbr)

%clc

n = length(X1);

% Add node numbers
%for k = 1:n
 %	str = sprintf(' %d',k);
 %	text(X(k,1),X(k,2),str)
% end
hold on

% With Statistics and Machine Learning Toolbox
% center = mean(X,1);               % mean of data
% hub = knnsearch(X,center,'k',1);  % nearest record to center
for k=1:nbr              % k is the number of generated solutions
%hub = edges(k,1); 
hub = randi(n);

plot(X1(hub,1),X1(hub,2),'og','MarkerSize',12,'MarkerFaceColor','b','LineWidth',2)
% Graph creation with nodes only
G = graph;
G = addnode(G,n);


 s = edges;
minParent = 1:n;

Vh = zeros(1,n);      % Vh(i)=1 if the vertex is included in the final tour
Vh(hub) = 1;
VhCount = n-1;        % Number of vertices to examine
degrees = zeros(1,n); % Vertex degrees

edge_idx = 1;         % Number of the saving to be examined    

while VhCount>2  && (edge_idx < size(edges,1))     % Try until only two vertices remain 
    % Edge to be inserted
    i = s(edge_idx,1);
    j = s(edge_idx,2);

    if Vh(i)==0 && Vh(j)==0 && (minParent(i)~=minParent(j))

        degrees(i) = degrees(i)+1; 
        degrees(j) = degrees(j)+1;
        plot([X1(i,1) X1(j,1)],[X1(i,2) X1(j,2)],'g','LineWidth',2)
        G=addedge(G,i,j);
        pause(0.2)

        if minParent(i)<minParent(j)
            minParent(minParent==minParent(j))=minParent(i);
        else
            minParent(minParent==minParent(i))=minParent(j);            
        end

        if degrees(i)==2
            Vh(i) = 1;
            VhCount = VhCount-1;
        end

        if degrees(j)==2
            Vh(j) = 1;
            VhCount = VhCount-1;
        end
    end
    edge_idx = edge_idx+1;

end

remain = find(Vh==0); % last remaining nodes

% Add of the two last edges from the vertice hub to the 2 unvisited
% vertices
G=addedge(G,hub,remain(1));
G=addedge(G,hub,remain(2));
plot([X1(hub,1) X1(remain(1),1)],[X1(hub,2) X1(remain(1),2)],'g','LineWidth',2)
plot([X1(hub,1) X1(remain(2),1)],[X1(hub,2) X1(remain(2),2)],'g','LineWidth',2)

tour=dfsearch(G,hub);

% Closing of the polygon for length calculus
p = [tour ; tour(1)];
pk(k,:)=p;
gen_tour{k} = p;
% Add title

end
 m = size(pk,1);
 %%%%%%

L1_new = zeros(m,1);
L2_new = zeros(m,1);

for i = 1:m
    
    L1_new(i) = tour_length(X1, pk(i,:));
    L2_new(i) = tour_length(X2, pk(i,:));
end
end
