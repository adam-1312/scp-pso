function [sol, best_fit, gen] = abc(A, c)
    % A = zeros(15, 8);
    % 
    % A(:, 1) = [1;0;1;1;0;1;1;0;0;0;0;0;0;0;0];
    % A(:, 2) = [0;0;0;1;0;0;1;1;0;0;0;1;0;0;0];
    % A(:, 3) = [0;1;0;0;1;0;0;0;1;0;1;0;1;0;0];
    % A(:, 4) = [1;1;0;0;0;0;0;0;0;0;0;0;0;1;1];
    % A(:, 5) = [0;0;1;0;0;1;0;0;0;1;0;1;0;1;0];
    % A(:, 6) = [0;0;0;0;0;0;0;1;0;0;0;0;0;1;1];
    % A(:, 7) = [1;1;0;0;0;1;0;0;0;0;1;0;0;0;0];
    % A(:, 8) = [1;1;0;1;0;1;0;1;0;0;0;1;0;0;0];
    % 
    % c = ones(size(A, 2), 1);
    

    %no_rows = size(A, 1);
    no_cols = size(A, 2);

    % Sort scp problem
    [A, c] = sort_scp(A, c);

    %% Parameters
    MAX_ITER = 500;
    POP_SIZE = 200;
    EMPLOYED_RATE = 0.25;
    EMPLOYED_SIZE = EMPLOYED_RATE*POP_SIZE;
    ONLOOKERS_SIZE = POP_SIZE - EMPLOYED_SIZE;
    LIMIT = 50;
    SIZE_R_C = 6;
    p_a = 0.9;
    if no_cols > 35
        col_add = 5;
        col_drop = 12;
    else
        col_add = 3;
        col_drop = 5;
    end

    %% Generate food source
    food = zeros(no_cols, EMPLOYED_SIZE);
    food_limits = zeros(1, EMPLOYED_SIZE) + LIMIT;
    for i = 1:EMPLOYED_SIZE
        food(:,i) = abc_gen_solution(A, c, SIZE_R_C);
    end
    fit = abc_fitness(food, A, c);

    iterations = 0;
    while iterations < MAX_ITER
    %iterations
    %min(fit(1,:))

    food_change = zeros(1, EMPLOYED_SIZE);

    % Handle Limit
    if any(food_limits == 0)
        for f = find(food_limits == 0)
            food(:, f) = abc_gen_solution(A, c, SIZE_R_C);
            food_limits(f) = LIMIT;
        end
        fit = abc_fitness(food, A, c);
    end

    %% Employed bees look for better new food source in neighbourhood
    for i = 1:EMPLOYED_SIZE
        new_food = abc_find_neighbour(A, c, food, i, col_add, col_drop, p_a, SIZE_R_C);
        
        if new_food == -1 % Handle collision
            % Employed bee abandons old food source and becomes scout
            % and gets a new random food source
            food(:,i) = abc_gen_solution(A, c, SIZE_R_C);
            food_change(i) = 1;
        else

            new_fit = abc_fitness(new_food, A, c);

            if new_fit(1) < fit(1, i) ||... 
               new_fit(1) == fit(1, i) && new_fit(2) < fit(2, i)
                
                % Replace food source with new one
                food(:, i) = new_food;
                food_change(i) = 1;
            
            end
            
        end
    end
    fit = abc_fitness(food, A, c);

    %% Onlooker bees select food source
    % Roullete-Wheel-Selection based on 1/fit as fitness, to switch
    % minimization problem to maximization problem
    wheel_prob = (1 ./ fit(1, :)) ./ sum(1 ./ fit(1, :));
    onlooked_food_indx = randsample(1:EMPLOYED_SIZE, ONLOOKERS_SIZE, true, wheel_prob);

    % Onlooker bees look for new food source in neighbourhood
    new_food_candidates = zeros(no_cols, ONLOOKERS_SIZE);
    for onlooker = 1:ONLOOKERS_SIZE
        while 1
            i = onlooked_food_indx(onlooker);
            new_food_candidates(:, onlooker) = abc_find_neighbour(A, c, food, i, col_add, col_drop, p_a, SIZE_R_C);
            if new_food_candidates(:, onlooker) == -1
                onlooked_food_indx(onlooker) = randsample(1:EMPLOYED_SIZE, 1, true, wheel_prob);
            else
                break;
            end
        end
    end
    candidates_fit = abc_fitness(new_food_candidates, A, c);

    %% Check if employed food source is best in neighbourhood
    for i = 1:EMPLOYED_SIZE
        neighbours_indx = find(onlooked_food_indx == i);
        neighbours_fit = candidates_fit(:, neighbours_indx);

        % Find best fitness in neighbourhood without employed food source
        [best_neighbour_fit, best_neighbour_indx]  = min(neighbours_fit(1, :));

        if best_neighbour_fit <= fit(1, i)
            if sum(neighbours_fit(1, :) == best_neighbour_fit) > 1
                % More than one neighbour with best primary fitness
                % So select best neighbour based on secondary fitness

                neighbours_indx = neighbours_indx(neighbours_fit(1,:) == best_neighbour_fit);
                neighbours_fit = neighbours_fit(neighbours_fit == best_neighbour_fit);
                [best_neighbour_fit2, best_neighbour_indx]  = min(neighbours_fit(2, :));
                best_neighbour_indx = neighbours_indx(best_neighbour_indx);

                if (best_neighbour_fit == fit(1, i)  &&...
                    best_neighbour_fit2 < fit(2, i)) ||...
                   best_neighbour_fit < fit(1, i)

                    % Best primary fitness is same as src and
                    % So replace if best secondary fitness is less than src
                    % OR
                    % Best primary fitness is less than src
                    
                    food(:, i) = new_food_candidates(:, best_neighbour_indx);
                    food_change(i) = 1;

                end
                
            elseif best_neighbour_fit == fit(1, i) &&...
                   neighbours_fit(2, best_neighbour_indx) < fit(2, i)
                % Best fitness is unique in neighbourhood and same as src
                % So replace if best neighbour has better secondary fitness
                
                best_neighbour_indx = neighbours_indx(best_neighbour_indx);
                food(:, i) = new_food_candidates(:, best_neighbour_indx);
                food_change(i) = 1;

            else
                % Best fitness is unique and different than source
                % So replace source with best neighbour

                best_neighbour_indx = neighbours_indx(best_neighbour_indx);
                food(:, i) = new_food_candidates(:, best_neighbour_indx);
                food_change(i) = 1;

            end
        end

    end
    fit = abc_fitness(food, A, c);

    unchanged_food_indx = find(~food_change);
    food_limits(unchanged_food_indx) = food_limits(unchanged_food_indx) - 1;

    iterations = iterations + 1;

    end

    [best_fit, sol_index] = min(fit(1,:));
    sol_candidates = find(fit == best_fit);
    if length(sol_candidates) > 1
        [~, sol_index] = min(fit(2, :));     
    end
    sol = food(sol_index);
    gen = MAX_ITER;
    

end










