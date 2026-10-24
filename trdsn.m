%s = s(idx,:);
long=zeros(1,n*n-n+1);
for i=1:(n*n-n+1)
hub=idx(i,1);
plot(X(hub,1),X(hub,2),'g','MarkerSize',12,'MarkerFaceColor','g','LineWidth',2)
% Graph creation with nodes only
G = graph;
G = addnode(G,n);

minParent = 1:n;

Vh = zeros(1,n);      % Vh(i)=1 if the vertex is included in the final tour
Vh(hub) = 1;
VhCount = n-1;        % Number of vertices to examine
degrees = zeros(1,n); % Vertex degrees

edge_idx = 1;         % Number of the saving to be examined    
%%%%%%%% edge_idx=i;
while VhCount>2       % Try until only two vertices remain 
    % Edge to be inserted
    i = idx(edge_idx,1);
    j = idx(edge_idx,2);

    if Vh(i)==0 && Vh(j)==0 && (minParent(i)~=minParent(j))

        degrees(i) = degrees(i)+1;
        degrees(j) = degrees(j)+1;
        plot([X(i,1) X(j,1)],[X(i,2) X(j,2)],'g','LineWidth',2)
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
plot([X(hub,1) X(remain(1),1)],[X(hub,2) X(remain(1),2)],'g','LineWidth',2)
plot([X(hub,1) X(remain(2),1)],[X(hub,2) X(remain(2),2)],'g','LineWidth',2)

%tour=dfsearch(G,hub);

% Closing of the polygon for length calculus
p = [tour ; tour(1)];
% Add title
L = sum(sqrt(diff(X(p,1)).^2 + diff(X(p,2)).^2));
long(i)=L;
str = sprintf('Tour Length: %g',L);
title(str)
end
long;