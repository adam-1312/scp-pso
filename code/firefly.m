function [sol, fit, gen] = firefly(A, c)

%% Firefly Algorithm

%%%%% Parameters %%%%%
attr_0 = 7; % Attractiveness at distance = 0
light_abs = 3; % Light Absorption coefficient
pop_size = 100; % Number of fireflies
max_gen = 1000; % Maximum number of generations

%%%%% Quick Functions %%%%%

% Calculates the attractiveness between fireflies x and y
attr = @(x,y) attr_0 * exp(-light_abs*norm(x - y)^2)*(x-y); 

% Movement transfer function
T = @(x) abs(2/pi * atan(pi*x/2));

% Calculates fitness of a firefly
firefly_fitness = @(firefly, weights) weights' * firefly;

%%%%% Generation 0 %%%%%
gen_no = 0;
fireflies = randSolutions(A, pop_size);

%%%%% Iterations %%%%%
while gen_no < max_gen
    
    % Fitness for each firefly
    fit = firefly_fitness(fireflies, c);
    
    [~, best_index] = min(fit);
    % Choose best firefly randomly from all fireflies with min fit
    %best_index = randsample(find(fit==min(fit)), 1);
    
    
    % Modification of firefly position
    for i = 1:pop_size
        for j = i+1:pop_size
            if (fit(j) < fit(i)) % firefly j more attractive
                ff_i = fireflies(:,i);
                ff_j = fireflies(:,j);
                
                % Calculate movement of ff i to ff j
                movement = ff_i + attr(ff_i, ff_j) + rand - 0.5;
                
                % Move compontent-wise
                for k = 1:length(movement)
                    if (rand < T(movement(k)))
                        ff_i(k) = fireflies(k, best_index);
                    else
                        ff_i(k) = 0;
                    end
                end
                
                % Repair solution (firefly i) to SCP solution
                coverage = A * ff_i;
                while min(coverage) == 0
                    rand_zero_index = randsample(find(~ff_i),1);
                    ff_i(rand_zero_index) = 1;
                    coverage = A * ff_i;
                end
                
                fireflies(:, i) = ff_i;
                
            end
        end
    end
    gen_no = gen_no + 1;
    %fit(best_index)
end

gen = gen_no;
sol = fireflies(:,best_index);
fit = fit(best_index);

end



