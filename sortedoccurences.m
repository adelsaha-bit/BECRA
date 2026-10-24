function [occur,idx]= sortedoccurences(tau_cum,D,n_ants,C)

n=length(D); % longueur du tour càd le nmbr de sommet de graphe
occur=zeros(n,n);% le nbr de possibilité de laisons n(n-1)
z = n*n_ants; %% z is the size of C vector "all vertices in all solutions"
% convert matrix to vector
%A = tour;
%B= A';
C = reshape(tau_cum',1,[]);
vector = C;
%n=length (D);
%occur=zeros(n,n);
% Initialize a map to store pairs and their counts
pairCounts = containers.Map('KeyType', 'char', 'ValueType', 'int32');

% Loop through the vector
for i = 1:length(vector) - 1
    % Create a pair string
    pair = sprintf('%d,%d', vector(i), vector(i+1));
    
    % Check if the pair is already in the map
    if isKey(pairCounts, pair)
        % Increment the count
        pairCounts(pair) = pairCounts(pair) + 1;
        occur(vector(i), vector(i+1))= occur(vector(i), vector(i+1))+1;
    else
        % Add the pair to the map with a count of 1
        pairCounts(pair) = 1;
        occur(vector(i), vector(i+1))=1;
    end
end

% Display the pairs and their counts
%keys(pairCounts)
%values(pairCounts)

%%%%%%%%%%%%%%%%%% Sort occur with indexes 
n=length(occur);
k=0;
for i=1:n 
    for j=1:n 
        k=k+1;
        idx(k,:)= [i j occur(i,j)];
    end
end

%% delete LOOPS
for i=1:length(idx)
    a=idx(i,1);
    b=idx(i,2);
    if a==b
        idx(i,3)=0;
    end
end
%% keep only non zero occurencies for idx matrix
A=idx(1,:);
for i=2:n*n
    if idx(i,3)~=0
        A=[A ;idx(i,:)];
       end
end
idx=A;

%% Sort occur descend
[~,order] = sort(idx(:,3),'descend');
idx = idx(order,:);


end