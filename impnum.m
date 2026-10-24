imp=0; %% number of improvement
for i=1:length(L)
if L(i)< best_length
    imp=imp+1;
end
end
str1=sprintf('The ACO best solution is impoved %d times of %d',imp,i);