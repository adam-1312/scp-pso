%function [sol, fit, gen] = abc(A, c)
    A = zeros(15, 8);

    A(:, 1) = [1;0;1;1;0;1;1;0;0;0;0;0;0;0;0];
    A(:, 2) = [0;0;0;1;0;0;1;1;0;0;0;1;0;0;0];
    A(:, 3) = [0;1;0;0;1;0;0;0;1;0;1;0;1;0;0];
    A(:, 4) = [1;1;0;0;0;0;0;0;0;0;0;0;0;1;1];
    A(:, 5) = [0;0;1;0;0;1;0;0;0;1;0;1;0;1;0];
    A(:, 6) = [0;0;0;0;0;0;0;1;0;0;0;0;0;1;1];
    A(:, 7) = [1;1;0;0;0;1;0;0;0;0;1;0;0;0;0];
    A(:, 8) = [1;1;0;1;0;1;0;1;0;0;0;1;0;0;0];

    c = ones(size(A, 2), 1);
    

    no_rows = size(A, 1);
    no_cols = size(A, 2);

    % Sort scp problem
    [A, c] = sort_scp(A, c);

    % Parameters
    POP_SIZE = 20;
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

    % Generate food source
    food = zeros(no_cols, EMPLOYED_SIZE);
    for i = 1:EMPLOYED_SIZE
        food(:,i) = abc_gen_solution(A, c, SIZE_R_C);
    end

%end