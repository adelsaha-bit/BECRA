
%% Extraction des données
% Fig 1 : gen_sol (10x2)
x1 = gen_sol(:,1);      % première colonne
y1 = gen_sol(:,2);      % deuxième colonne

% Fig 2 : nd_Solutions (struct 1x23)
L1 = [nd_Solutions.L1];   % vecteur 1x23
L2 = [nd_Solutions.L2];   % vecteur 1x23

%% Tracé sur la même figure
figure;
hold on;

% Fig1 en VERT
plot(x1, y1, 'g.', 'MarkerSize', 15, 'DisplayName', 'gen_sol');

% Fig2 en ROUGE (L1 et L2)
plot(L1, L2, 'r.', 'MarkerSize', 12, 'DisplayName', 'nd_Solutions (L1,L2)');

% Améliorations
grid on;
xlabel('Objectif1');
ylabel('Objectif 2');
title('Comparaison gen\_sol (vert) vs nd\_Solutions (rouge)');
legend('Location', 'best');

hold off;