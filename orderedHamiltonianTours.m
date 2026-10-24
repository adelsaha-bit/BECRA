function TOURS = orderedHamiltonianTours_R2022b(E)
% orderedHamiltonianTours_R2022b
% R2022b compatible Hamiltonian cycle (tour) solver using ordered edge stream.
%
% INPUT:
%   E : m x 2 list of undirected edges (u,v), in a fixed order.
%
% OUTPUT:
%   TOURS(it) struct for each cyclic start it:
%     .it              : starting index in the stream
%     .found           : true if a Hamiltonian cycle was found
%     .N               : number of vertices
%     .vertices        : sorted list of vertex labels in the instance
%     .order_idx       : rotated indices into E (stream order used)
%     .selected_stream : positions (1..m) in rotated stream that were selected
%     .selected_edges  : selected edges in original labels (N x 2)
%     .cycle           : vertex cycle in original labels (1 x (N+1)), last = first

% ----- checks -----
if size(E,2) ~= 2
    error('E must be m x 2.');
end

m = size(E,1);
Vall = unique(E(:));
N = numel(Vall);

% Map original vertex labels -> 1..N
maxV = max(Vall);
map = zeros(maxV,1);
map(Vall) = 1:N;

% Preallocate output
TOURS = repmat(struct( ...
    'it', [], ...
    'found', false, ...
    'N', N, ...
    'vertices', Vall, ...
    'order_idx', [], ...
    'selected_stream', [], ...
    'selected_edges', [], ...
    'cycle', [] ), m, 1);

% ===== iterate over all cyclic starts =====
for it = 1:m

    % Rotate stream starting at it
    order_idx = [it:m, 1:it-1];
    Er0 = E(order_idx,:);           % rotated edges in original labels

    % Convert rotated edges to mapped indices 1..N (canonical undirected form)
    Er = zeros(m,2);
    availDeg = zeros(N,1);
    for k = 1:m
        u = Er0(k,1); v = Er0(k,2);
        if u == v
            Er(k,:) = [0 0];       % unusable self-loop
            continue;
        end
        a = map(u); b = map(v);
        if a < b
            Er(k,:) = [a b];
        else
            Er(k,:) = [b a];
        end
        availDeg(Er(k,1)) = availDeg(Er(k,1)) + 1;
        availDeg(Er(k,2)) = availDeg(Er(k,2)) + 1;
    end

    % Necessary condition: every vertex must appear in >=2 edges overall
    if any(availDeg < 2)
        TOURS(it).it = it;
        TOURS(it).order_idx = order_idx;
        continue;
    end

    % Run ordered DFS/backtracking to pick exactly N edges
    [ok, chosen] = dfsHamiltonOrdered(Er, N);

    TOURS(it).it = it;
    TOURS(it).order_idx = order_idx;
    TOURS(it).found = ok;

    if ok
        selStream = find(chosen);      % positions in rotated stream
        selEdges  = Er0(selStream,:);  % edges in original labels, in stream order

        % Build cycle graph on indices 1..N (R2022b safe)
        s = map(selEdges(:,1));
        t = map(selEdges(:,2));
        G = graph(s, t, [], N);

        cyc_idx = extractCycleIdx(G);  % indices in 1..N
        cyc = Vall(cyc_idx);           % convert back to original labels

        TOURS(it).selected_stream = selStream;
        TOURS(it).selected_edges  = selEdges;
        TOURS(it).cycle = cyc(:).';
    end
end

end

% =====================================================================
% Ordered DFS: select a subsequence of edges Er (in order) forming a
% Hamiltonian cycle: N edges, deg=2 all vertices, one component.
% =====================================================================
function [ok, chosen] = dfsHamiltonOrdered(Er, N)

m = size(Er,1);
deg = zeros(N,1);
adj = sparse(N,N);       % adjacency of selected edges
chosen = false(m,1);

[ok, chosen] = dfsRec(1, 0, Er, deg, adj, chosen, N, m);

end

function [ok, chosen] = dfsRec(pos, picked, Er, deg, adj, chosen, N, m)

% success: picked exactly N edges
if picked == N
    ok = isSingleHamiltonianCycle(adj);
    return;
end

% failure: stream ended
if pos > m
    ok = false;
    return;
end

% prune: cannot reach N even if take all remaining
if picked + (m - pos + 1) < N
    ok = false;
    return;
end

% prune: degree must never exceed 2
if any(deg > 2)
    ok = false;
    return;
end

% prune: do not close a smaller cycle before selecting N edges
if picked < N && createsPrematureCycle(adj)
    ok = false;
    return;
end

u = Er(pos,1);
v = Er(pos,2);

% ---- Option 1: TAKE edge if legal ----
if u > 0 && u ~= v && deg(u) < 2 && deg(v) < 2 && adj(u,v) == 0

    deg2 = deg;
    adj2 = adj;
    chosen2 = chosen;

    deg2(u) = deg2(u) + 1;
    deg2(v) = deg2(v) + 1;
    adj2(u,v) = 1; adj2(v,u) = 1;
    chosen2(pos) = true;

    [ok, chosen] = dfsRec(pos+1, picked+1, Er, deg2, adj2, chosen2, N, m);
    if ok
        return;
    end
end

% ---- Option 2: SKIP edge ----
[ok, chosen] = dfsRec(pos+1, picked, Er, deg, adj, chosen, N, m);

end

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
