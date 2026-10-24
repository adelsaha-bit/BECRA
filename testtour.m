E = edges;   % your edge list

TOURS = orderedHamiltonianTours(E);

idx = find([TOURS.found]);
disp(idx);

if ~isempty(idx)
    it = idx(1);
    disp(TOURS(it).cycle);          % Hamiltonian tour (vertex sequence)
    disp(TOURS(it).selected_edges); % edges used (N edges)
end
    deg2(u) = deg2(u) + 1;
    deg2(v) = deg2(v) + 1;
    adj2(u,v) = 1; adj2(v,u) = 1;
    chosen2(pos) = true;

    [ok, chosen] = dfsRec(pos+1, picked+1, Er, deg2, adj2, chosen2, N, m);
    if ok
        return;
    end
%end

% ---- Option 2: SKIP edge ----
[ok, chosen] = dfsRec(pos+1, picked, Er, deg, adj, chosen, N, m);

%end

% =====================================================================
% Check Hamiltonian cycle: all degrees = 2 and connected
% =====================================================================
function tf = isSingleHamiltonianCycle(adj)

N = size(adj,1);
deg = full(sum(adj,2));

if any(deg ~= 2)
    tf = false;
    return;
end

visited = false(N,1);
stack = 1;
visited(1) = true;

while ~isempty(stack)
    a = stack(end); stack(end) = [];
    nb = find(adj(a,:));
    for b = nb
        if ~visited(b)
            visited(b) = true;
            stack(end+1) = b; %#ok<AGROW>
        end
    end
end

tf = all(visited);

end

% =====================================================================
% Premature cycle detection:
% In a deg<=2 graph, a cycle exists iff a component has all deg=2.
% =====================================================================
function tf = createsPrematureCycle(adj)

N = size(adj,1);
deg = full(sum(adj,2));
visited = false(N,1);
tf = false;

for s = 1:N
    if visited(s), continue; end

    queue = s;
    visited(s) = true;
    comp = s;

    while ~isempty(queue)
        a = queue(1); queue(1) = [];
        nb = find(adj(a,:));
        for b = nb
            if ~visited(b)
                visited(b) = true;
                queue(end+1) = b; %#ok<AGROW>
                comp(end+1) = b; %#ok<AGROW>
            end
        end
    end

    if numel(comp) >= 2 && all(deg(comp) == 2)
        tf = true;
        return;
    end
end

end

% =====================================================================
% Extract a cycle order from a cycle graph on nodes 1..N
% Returns 1 x (N+1) indices, last = first.
% =====================================================================
function cyc = extractCycleIdx(G)

A = adjacency(G);
n = numnodes(G);

deg = full(sum(A,2));
if any(deg ~= 2)
    error('extractCycleIdx:NotCycle', 'Graph is not a simple cycle (degree ~= 2).');
end

start = 1;
cyc = zeros(1, n+1);
cyc(1) = start;

prev = 0;
cur  = start;

for k = 2:n+1
    neigh = find(A(cur,:));         % exactly 2 neighbors
    cand  = neigh(neigh ~= prev);   % next step candidates

    if isempty(cand)
        error('extractCycleIdx:DeadEnd', 'Cycle walk got stuck at step %d.', k);
    end

    next = cand(1);                 % first step has 2 candidates; pick one
    prev = cur;
    cur  = next;
    cyc(k) = cur;
end

end

