%% Elimine les doublons (i,j)/(j,i) : on garde (i,j) (1re orientation rencontree)
%% et on lui ajoute la frequence de (j,i). Resultat trie par frequence decroissante.
%% Complexite O(m log m) au lieu de O(m^2).
function edges = undoubles(edges)
    if isempty(edges), return; end

    N   = max(max(edges(:,1:2)));
    lo  = min(edges(:,1), edges(:,2));
    hi  = max(edges(:,1), edges(:,2));
    key = (lo-1)*N + hi;                      % cle unique par arete non orientee

    [~, ia, ic] = unique(key, 'stable');      % ia : 1re occurrence de chaque arete
    freq = accumarray(ic, edges(:,3));        % somme des frequences (i,j) + (j,i)

    edges = [edges(ia,1:2), freq];
    edges = sortrows(edges, -3);              % tri par frequence decroissante
end
