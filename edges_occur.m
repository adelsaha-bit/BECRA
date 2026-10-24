%% this function elemine duplication of symetric edges

function  [edges]= edges_occur (idx)

edges=idx;
for i=1:length(idx)
    a=idx(i,1);
    b=idx(i,2);
   for j=i+1:length(idx)-1
     c=idx(j,1);
    d=idx(j,2);
    
       if ((a==d)&&(b==c))
        edges(i,3)=idx(i,3)+idx(j,3);
       %edges(j,:) = [];
    end
   end
end
%% Sort occur descend
[~,order] = sort(edges(:,3),'descend');
edges = edges(order,:);