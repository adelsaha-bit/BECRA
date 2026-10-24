

clc;
clear all;
%% Seconf bloc for BEFRA Algorithm
[tour,D,n_ants,X,best_length,tau_cum]=TSPcum; % you can use also TSPaco

[occur,idx]=sortedoccurences(tour,D,n_ants); %% find the occurences of each edge in all solutions
[edgesf]= edges_occur(idx); %% edges vector contains edges sorted by decreasing order of occurences 
[edgesf]= undoubles(edgesf);
[Lf,pkf]=bestgraph(X,D,edgesf);%% edges_frequency_based heuristic
if min(Lf)< best_length
   % best_tour=p;
     str1=sprintf('The improved solution by BEFRA algorithm is: %g', min(Lf))
     
else
     str1=sprintf('There is NO impovement by BEFRA algorithm Tour Length: %g',best_length)
end
best_BEFRA=min(Lf);
%impnum;
%str
%str1
  
close all;
% [G1]=impsolf(X,Lf,pkf); %% plot BEFRA's best_solution
opt2f;
%% BEQRA_BEFRA in the same code
%% calculte edges(quality) and edgesf (frequency) 
%[tour,D,n_ants,X,best_length,tau_cum]=TSPcum;
 n =length(X);
[edges]=testsort(tau_cum,D,n); %% find the quality ofeach edge based on tau_cum 

%%  apply BEQRA and BEFRA alglorithms
%% first bloc for BEQRA
[L,pk]=bestgraph(X,D,edges);%% edges_frequency_based heuristic

if min(L)< best_length
   % best_tour=p;
     str=sprintf('The improved solution by BEQRA algorithm is: %g', min(L))

else
     str=sprintf('There is NO impovement by BEQRA algorithm Tour Length: %g',best_length)
end
best_BEQRA=min(L);
%impnum;
%str1 
close all;
% [G]=impsol(X,L,pk); %% %% plot BEQRA's best_solution
opt2;
% %% Seconf bloc for BEFRA Algorithm
% [occur,idx]=sortedoccurences(tour,D,n_ants); %% find the occurences of each edge in all solutions
% [edgesf]= edges_occur(idx); %% edges vector contains edges sorted by decreasing order of occurences 
% [edgesf]= undoubles(edgesf);
% [Lf,pkf]=bestgraph(X,D,edgesf);%% edges_frequency_based heuristic
% if min(Lf)< best_length
%    % best_tour=p;
%      str1=sprintf('The improved solution by BEFRA algorithm is: %g', min(Lf))
%      
% else
%      str1=sprintf('There is NO impovement by BEFRA algorithm Tour Length: %g',best_length)
% end
% best_BEFRA=min(Lf);
% %impnum;
% str
% str1
%   
% close all;
% [G1]=impsolf(X,Lf,pkf);
% opt2f;