%% this function use an ACO algorithm with cummulated pheromone BEQRA ALGO

function [tour,D,n_ants,X,best_length,tau_cum,tau,best_tour,BestTour] = TSPcum()
  clear;
close all;

%X = rand(50,2);
% % %% Problem Definition mod1 (obj1)
 model1=CreateD_Set('1889.txt');
 CostFunction=@(tour) TourLength(tour,model1);
 nVar=model1.n;
 D=model1.D;
 X(:,1)=(model1.x);
 X(:,2)=(model1.y);
% X= load("X.mat");
% X=X.X;
n = length(X);
% Computation of the distance matrix
% D = squareform(pdist(X,'euclidean'));
plot(X(:,1),X(:,2),'kx','MarkerSize',12,'LineWidth',2)
hold on

% ACO Parameters
maxiter = 5;   % Maximum number of iterations
n_ants = 200;     % Number of ants
Q = 1;           % Pheromone quantity per tour
tau0 = 10*Q/(n_ants*mean(D(:)));	% Initial pheromone
tau_cum=tau0;    % Cumulated pheromone initialization
alpha = 1;       % Pheromone exponential weight
beta = 1;        % Heuristic exponential weight
rho = 0.04;      % Evaporation rate
e = 8;           % Number of elitist ants

% Initialization
eta = 1./D;             % Heuristic information matrix
tau = tau0*ones(n,n);   % Pheromone matrix
tau_cum = tau;
tour = zeros(n_ants,n);
tlength = zeros(n_ants,1);
best_length = inf;
best_tour = [];          % will store the best tour (1 x n vector)

% Ant System Main Loop
for iter=1:maxiter
    % Move Ants
    for k=1:n_ants   
        new_tour = randi(n);  
        for l=2:n 
            i = new_tour(end);
            P = tau(i,:).^alpha .* eta(i,:).^beta;
            P(new_tour) = 0;
            P = P / sum(P);
            j = roulette(P);
            new_tour = [new_tour j];     
        end
        tour(k,:) = new_tour;
        tlength(k) = tour_length(X, tour(k,:));
        
        if tlength(k) < best_length
            best_tour   = tour(k,:);   % <-- only the best tour vector
            best_length = tlength(k);
        end
    end
    
    % Update pheromone
    for k=1:n_ants
        ptour = tour(k,:);
        ptour = [ptour tour(k,1)];
        for l=1:n    
            i = ptour(l);
            j = ptour(l+1);
            tau(i,j)     = tau(i,j)     + Q / tlength(k);
            tau_cum(i,j) = tau_cum(i,j) + Q / tlength(k);
        end
    end
    
    % Elitist update
    ptour = [best_tour best_tour(1)];
    for l=1:n    
    	i = ptour(l);
        j = ptour(l+1);
        tau(i,j)     = tau(i,j)     + e * Q / best_length;
        tau_cum(i,j) = tau_cum(i,j) + Q / best_length;
    end
    
    % Evaporation
    tau = (1-rho)*tau;
   
    % Polygon plot
    cla
	for i=2:n
        plot([X(best_tour(i-1),1) X(best_tour(i),1)], ...
             [X(best_tour(i-1),2) X(best_tour(i),2)], 'r', 'LineWidth', 2)
    end
    plot([X(best_tour(end),1) X(best_tour(1),1)], ...
         [X(best_tour(end),2) X(best_tour(1),2)], 'r', 'LineWidth', 2)
    plot(X(:,1), X(:,2), 'kx', 'MarkerSize', 12, 'LineWidth', 2)
    pause(0)
    title(['Itération numéro : ' num2str(iter)])
end

% Final title
str = sprintf('Tour length: %g', best_length);
title(str)

% =====================================================
% BestTour = ONLY the best tour (1 x n vector)
% =====================================================
BestTour = best_tour;   % row vector of city indices that give best_length

    function TL = tour_length(X,tour)
        tour = [tour tour(1)];
        TL = sum(sqrt(diff(X(tour,1)).^2 + diff(X(tour,2)).^2));
    end

    function node_j = roulette(P)
        r = rand;
        C = cumsum(P);
        node_j = find(r <= C, 1);
    end

end