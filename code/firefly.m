clear
close all

%% Beispiel aus wikipedia englisch

% A = zeros(5, 4); % 5 elements in universe, 4 subsets
% 
% % Definition subset 1: {1,2,3}
% A(:, 1) = [1;1;1;0;0];
% 
% % Definition subset 2: {2,4}
% A(:, 2) = [0;1;0;1;0];
% 
% % Definition subset 3: {3,4}
% A(:, 3) = [0;0;1;1;0];
% 
% % Definition subset 4: {4,5}
% A(:, 4) = [0;0;0;1;1];
%% Beispiel aus https://optimization.cbe.cornell.edu/index.php?title=Set_covering_problem

A = zeros(15, 8);

A(:, 1) = [1;0;1;1;0;1;1;0;0;0;0;0;0;0;0];
A(:, 2) = [0;0;0;1;0;0;1;1;0;0;0;1;0;0;0];
A(:, 3) = [0;1;0;0;1;0;0;0;1;0;1;0;1;0;0];
A(:, 4) = [1;1;0;0;0;0;0;0;0;0;0;0;0;1;1];
A(:, 5) = [0;0;1;0;0;1;0;0;0;1;0;1;0;1;0];
A(:, 6) = [0;0;0;0;0;0;0;1;0;0;0;0;0;1;1];
A(:, 7) = [1;1;0;0;0;1;0;0;0;0;1;0;0;0;0];
A(:, 8) = [1;1;0;1;0;1;0;1;0;0;0;1;0;0;0];

%%
% Definition of weights for weighted SCP
weights = zeros(size(A,2), 1);
for i = 1:length(weights)
    weights(i) = 1;%sum(A(:,i)); % Cardinality of a set is its weight
end

%%

% [A, weights] = import_scp_data();
% weights = weights';

%% Firefly Algorithm

%%%%% Parameters %%%%%
attr_0 = 1; % Attractiveness at distance = 0
light_abs = 1; % Light Absorption coefficient
pop_size = 15; % Number of fireflies
max_gen = 1000; % Maximum number of generations

%%%%% Quick Functions %%%%%

% Calculates the attractiveness between fireflies x and y
attr = @(x,y) attr_0 * exp(-light_abs*norm(x - y)^2)*(x-y); 

% Movement transfer function
T = @(x) abs(2/pi * atan(pi*x/2));

%%%%% Generation 0 %%%%%
gen_no = 0;
fireflies = randSolutions(A, pop_size);

%%%%% Iterations %%%%%
while gen_no < max_gen
    
    % Fitness for each firefly
    fit = firefly_fitness(fireflies, weights);
    
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
    fireflies;
    gen_no = gen_no + 1
    fit(best_index)
end
fireflies(:,best_index)
fit(best_index)


function fit = firefly_fitness(firefly, weights)
    fit = weights' * firefly;
end




