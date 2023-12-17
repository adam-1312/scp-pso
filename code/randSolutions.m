function x = randSolutions(A, n)
    no_of_subsets = size(A, 2);
    x = round(rand(no_of_subsets, n));
    
%%%% Should the randomly generated solutions at the
%%%% beginning be valid solutions or just any random
%%%% solution vector would work??? How would the fitness
%%%% function react to this in that case???
for i = 1:n
    ff_i = x(:,i);
    coverage = A * ff_i;
    while min(coverage) == 0
        rand_zero_index = randsample(find(~ff_i),1);
        ff_i(rand_zero_index) = 1;
        coverage = A * ff_i;
    end
    x(:,i) = ff_i;
end

%     for k = 1:n
%        k
%        coverage = A * x(:,k) % coverage of elements per solution
%        while (size(coverage) ~= size(coverage(coverage >= 1)))
%           x(:,k) = round(rand(no_of_subsets,1)); 
%           coverage = A * x(:,k)
%        end
%     end
end