%% EXCHANGE2 - 2-opt rapide (script, utilise best_tour, D, X du workspace)
%  Ameliore best_tour par echanges d'aretes (ab,cd) -> (ac,bd).
%  Par rapport a l'ancienne version :
%   - plus de plot/pause dans la boucle (2 x 0.2 s par echange = des heures)
%   - un echange applique des qu'il est trouve (au lieu du seul meilleur par passe)
%   - evaluation vectorisee sur j (plus de boucle while imbriquee)
%  Sortie : best_tour (meme format qu'en entree), L1 (longueur finale)

best_tour = best_tour(:)';                       % tour en ligne
closed = (best_tour(1) == best_tour(end));       % tour deja ferme ?
if closed, best_tour(end) = []; end
p = best_tour;
n = numel(p);
N = size(D,1);

% Longueur initiale
L1 = sum(D(sub2ind([N N], p, p([2:n 1]))));
fprintf('Longueur avant 2-opt (ACO) : %g\n', L1);

improved = true;
nPass = 0;
tStart = tic;
while improved
    improved = false;
    nPass = nPass + 1;
    for i = 1:n-2
        a = p(i);  b = p(i+1);
        if i == 1
            jj = 3:n-1;                          % eviter l'arete adjacente (n,1)
        else
            jj = i+2:n;
        end
        if isempty(jj), continue; end
        c = p(jj);
        d = p(mod(jj,n)+1);                      % successeur cyclique de c
        delta = D(a,c) + D(b,d) - D(a,b) - D(sub2ind([N N], c, d));
        [m, k] = min(delta);
        if m < -1e-10
            j = jj(k);
            p(i+1:j) = p(j:-1:i+1);              % inversion du segment b..c
            improved = true;
        end
    end
    fprintf('Passe %d, %.1f s\n', nPass, toc(tStart));
end

best_tour = p;
L1 = sum(D(sub2ind([N N], p, p([2:n 1]))));
if closed, best_tour = [best_tour best_tour(1)]; end
fprintf('Longueur apres 2-opt (ACO) : %g\n', L1);

% Un seul trace a la fin
figure;
plot(X(:,1), X(:,2), 'kx', 'MarkerSize', 4); hold on;
q = [p p(1)];
plot(X(q,1), X(q,2), 'r-', 'LineWidth', 1);
axis equal; hold off;
title(sprintf('Tour Length of ACO\\_2opt: %g', L1));
