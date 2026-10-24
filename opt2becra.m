%% OPT2BECRA - 2-opt rapide (script, utilise pk, D, X du workspace)
%  - plus de plot/pause dans la boucle
%  - un echange applique des qu'il est trouve (first improvement par ligne i)
%  - evaluation vectorisee sur j
%  - le sommet de depart repete a la fin de pk est retire avant optimisation

p = pk(:)';                               % tour en ligne
if p(1) == p(end), p(end) = []; end       % retirer le sommet repete (tour ferme)
n = numel(p);
N = size(D,1);

% Longueur initiale
L0 = sum(D(sub2ind([N N], p, p([2:n 1]))));
fprintf('Longueur avant 2-opt : %g\n', L0);

improved = true;
nPass = 0;
tStart = tic;
while improved
    improved = false;
    nPass = nPass + 1;
    for i = 1:n-2
        a = p(i);  b = p(i+1);
        if i == 1
            jj = 3:n-1;                   % eviter l'arete adjacente (n,1)
        else
            jj = i+2:n;
        end
        if isempty(jj), continue; end
        c = p(jj);
        d = p(mod(jj,n)+1);               % successeur de c (cyclique)
        delta = D(a,c) + D(b,d) - D(a,b) - D(sub2ind([N N], c, d));
        [m, k] = min(delta);
        if m < -1e-10
            j = jj(k);
            p(i+1:j) = p(j:-1:i+1);       % inversion du segment b..c
            improved = true;
        end
    end
    fprintf('Passe %d, %.1f s\n', nPass, toc(tStart));
end

% Fermer le tour et calculer la longueur finale
p = [p p(1)];
L = sum(D(sub2ind([N N], p(1:end-1), p(2:end))));
best_BECRA_2opt = L;
fprintf('Longueur apres 2-opt : %g\n', L);

% Un seul trace a la fin
figure;
plot(X(:,1), X(:,2), 'kx', 'MarkerSize', 4); hold on;
plot(X(p,1), X(p,2), 'r-', 'LineWidth', 1);
axis equal; hold off;
title(sprintf('Tour Length of BECRA\\_2opt: %g', L));
