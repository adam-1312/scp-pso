function [sol, fit, gen] = abc(A, c)
     
    no_rows = size(A, 1);
    no_cols = size(A, 2);

    % Sort scp problem
    [A, c] = sort_scp(A, c);

    % Parameters
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

    

end