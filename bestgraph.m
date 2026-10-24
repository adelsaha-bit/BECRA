function [L, pk, becrasol, becra_sol_length] = bestgraph(X, D, cred_sort)
% BESTGRAPH - version rapide pour grandes instances (n > 5000)
% Pour chaque depart 'it' :
%   1. on construit des chemins avec les aretes de cred_sort (degre<=2, sans cycle)
%   2. on extrait les chemins
%   3. on les relie par un chainage glouton sur les distances euclidiennes

n = size(X, 1);
nStarts = min(100, size(cred_sort,1));      % reduire/augmenter selon le temps voulu
becrasol         = cell(1, nStarts);
becra_sol_length = inf(1, nStarts);
nValid = 0;

for it = 1:nStarts

    %% ===== 1. Construction des chemins (sans objet graph) =====
    nb     = zeros(n,2);                   % voisins de chaque sommet
    deg    = zeros(1,n);
    parent = 1:n;                          % union-find
    nEdges = 0;

    for e = it:size(cred_sort,1)
        i = cred_sort(e,1);  j = cred_sort(e,2);
        if deg(i) < 2 && deg(j) < 2
            ri = i; while parent(ri) ~= ri, parent(ri) = parent(parent(ri)); ri = parent(ri); end
            rj = j; while parent(rj) ~= rj, parent(rj) = parent(parent(rj)); rj = parent(rj); end
            if ri ~= rj
                deg(i) = deg(i)+1;  nb(i,deg(i)) = j;
                deg(j) = deg(j)+1;  nb(j,deg(j)) = i;
                parent(rj) = ri;
                nEdges = nEdges + 1;
                if nEdges == n-1, break; end   % un chemin hamiltonien est complet
            end
        end
    end

    %% ===== 2. Extraction des chemins (tampon reutilise) =====
    visited = false(1,n);
    paths   = {};
    buf     = zeros(1,n);
    for s = find(deg <= 1)
        if visited(s), continue; end
        len = 1;  buf(1) = s;  visited(s) = true;
        prev = 0; curr = s;
        while true
            nx = nb(curr,1);
            if nx == prev || nx == 0, nx = nb(curr,2); end
            if nx == 0 || nx == prev || visited(nx), break; end
            prev = curr;  curr = nx;
            len = len+1;  buf(len) = curr;  visited(curr) = true;
        end
        paths{end+1} = buf(1:len); %#ok<AGROW>
    end
    if isempty(paths), continue; end

    %% ===== 3. Chainage glouton des chemins =====
    nP   = numel(paths);
    ends = zeros(nP,2);
    for k = 1:nP
        ends(k,1) = paths{k}(1);
        ends(k,2) = paths{k}(end);
    end
    used = false(1,nP);
    used(1) = true;
    tour = zeros(1,n);
    pos  = numel(paths{1});
    tour(1:pos) = paths{1};
    cur = ends(1,2);

    for step = 2:nP
        idxU = find(~used);
        xc = X(cur,1);  yc = X(cur,2);
        d1 = hypot(xc - X(ends(idxU,1),1), yc - X(ends(idxU,1),2));
        d2 = hypot(xc - X(ends(idxU,2),1), yc - X(ends(idxU,2),2));
        [m1,k1] = min(d1);  [m2,k2] = min(d2);
        if m1 <= m2
            kk = idxU(k1);  p = paths{kk};
        else
            kk = idxU(k2);  p = paths{kk}(end:-1:1);
        end
        tour(pos+1:pos+numel(p)) = p;
        pos = pos + numel(p);
        used(kk) = true;
        cur = p(end);
    end

    %% Fermeture et longueur
    p   = [tour(1:pos), tour(1)];
    len = sum(sqrt(diff(X(p,1)).^2 + diff(X(p,2)).^2));

    nValid = nValid + 1;
    becrasol{nValid}         = p;
    becra_sol_length(nValid) = len;
end

becrasol         = becrasol(1:nValid);
becra_sol_length = becra_sol_length(1:nValid);

%% ===== Resultat =====
if nValid == 0
    L  = Inf;
    pk = [];
    fprintf('Aucun tour valide construit.\n');
else
    [L, idx] = min(becra_sol_length);
    pk = becrasol{idx};
    fprintf('Nombre de tours valides : %d\n', nValid);
    fprintf('Meilleure longueur : %.4f\n', L);

    figure;
    plot(X(:,1), X(:,2), 'kx', 'MarkerSize', 4); hold on;
    plot(X(pk,1), X(pk,2), 'b-', 'LineWidth', 1.2);
    plot(X(pk(1),1), X(pk(1),2), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
    title(sprintf('Meilleur tour | L = %.4f  (%d tours)', L, nValid));
    axis equal; hold off;
end
end
