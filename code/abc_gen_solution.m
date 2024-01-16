function sol = abc_gen_solution(A, c, size_r_c)
    % Assumption: Passed A is ordered in ascending order of cost
    %             and if cost of two columns are equal then most
    %             amount of rows covered comes first
    % A = zeros(15, 8);
    % c = [23;1;4;7;7;1;1;3];%ones(8,1);
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
    % sort_scp(A, c);
    % size_r_c = 3;

    % % Sort col indices according to cost
    % [~,sorted_indices] = sort(c);
    % 
    % % Sort same cost columns according to amount of rows in column
    % uniq_c = unique(c);
    % if length(uniq_c) ~= size(A, 2)
    %     i = 1;
    %     for u = 1:length(uniq_c)
    %         cost = uniq_c(u);
    %         no_with_cost = length(c(c == cost));
    %         if no_with_cost > 1
    %             no_rows_in_cols = sum(A(:, c == cost));
    %             i_end = i+no_with_cost-1;
    %             [~, sorted_cost_indices] = sort(no_rows_in_cols, 'descend');
    %             tmp = sorted_indices(i:i_end);
    %             sorted_indices(i:i_end) = tmp(sorted_cost_indices);
    %             i = i_end + 1;
    %         else
    %             i = i + 1;
    %         end
    %     end
    % end
    % 
    % % Sort A and c
    % c = c(sorted_indices, :);
    % A = A(:, sorted_indices);

    %% Initialisation
    no_rows = size(A, 1);
    no_cols = size(A, 2);

    sol = zeros(no_cols, 1);
    %u = zeros(no_rows, 1);

    for i = 1:no_rows

        % Select random column that contains row i
        cols_in_row = find(A(i, :));
        if size_r_c < length(cols_in_row)
            cols_in_row = cols_in_row(1:size_r_c);
        end        
        if length(cols_in_row) == 1
            j = cols_in_row;
        else
            j = randsample(cols_in_row, 1);
        end

        % Add column to solution
        sol(j) = 1;
        %u(A(:,j)==1) = u(A(:,j)==1) + 1;
    end

    % Remove some redundant columns
    t = sum(sol);
    while t > 0
        % Select random column from first t cols in sol
        cols_in_sol = find(sol);
        if t < length(cols_in_sol)
            cols_in_sol = cols_in_sol(1:t);
        end
        if length(cols_in_sol) == 1
            j = cols_in_sol;
        else
            j = randsample(cols_in_sol, 1);
        end

        % Check if column could be reduced
        u = A*sol;
        filtered_u = u(A(:,j)==1);
        reducible = length(filtered_u(filtered_u>=2)) == length(filtered_u);

        if reducible
            % Remove column from solution
            sol(j) = 0;
            %u(A(:,j)==1) = u(A(:,j)==1) - 1;
        end

        t = t - 1;
    end

    %A*sol
end