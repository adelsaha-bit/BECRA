%% =====================================================

%% This code is the implementation of Face to face comaprison between ACO2OPT and BECRA2OPT
%% First we apply the ACO metaheuristic then EXCHANGE2 (apply 2opt on ACO's Solution).
%% BECRA2OPT apply BECRA procedure on tour constructed by ACO then apply 2opt heuristique (opt2becra code);
%% and return and save the 4 values of ACO,ACO2OPT,BECRA and BECRA2OPT in 
%% results_ACO.mat file
%% =====================================================
clear; 
[tour,D,n_ants,X,best_length,tau_cum,tau,best_tour] = TSPcum ();
EXCHANGE2;
BECRA2OPT;
%% Save results
%% =====================================================
%% Save the 4 results of each run
%% =====================================================

ACO        = best_length;          % result of ACO
ACO2OPT    = L1;     % result of EXCHANGE2 (2-opt sur ACO)
BECRA      = best_BECRA;            % result of BECRA
BECRA2OPT  = best_BECRA_2opt;        % result ofBECRA + 2-opt

nouvelle_ligne = [ACO, ACO2OPT, BECRA, BECRA2OPT];

%% Results are saved in this File
fichier = 'results_ACO.mat';

if exist(fichier, 'file')
   
    load(fichier, 'results');
    results = [results; nouvelle_ligne];   
else
       results = nouvelle_ligne;
end
%% save the file
save(fichier, 'results');

%% Display new results
disp('Nouvelle ligne ajoutée :');
disp(nouvelle_ligne);
disp(['Nombre total d''exécutions : ' num2str(size(results,1))]);
disp(results);