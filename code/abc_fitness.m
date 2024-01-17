function fit = abc_fitness(food_src, A, c)
    % This is the fitness function for the ant bee colony algorithm

    fit1 = c' * food_src;

    fit2 = sum(A*food_src == 1);

    fit = [fit1; fit2];

end