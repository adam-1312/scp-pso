function [A, c] = sort_scp(A, c)
    % Sort col indices according to cost
    [~,sorted_indices] = sort(c);

    % Sort same cost columns according to amount of rows in column
    uniq_c = unique(c);
    if length(uniq_c) ~= size(A, 2)
        i = 1;
        for u = 1:length(uniq_c)
            cost = uniq_c(u);
            no_with_cost = length(c(c == cost));
            if no_with_cost > 1
                no_rows_in_cols = sum(A(:, c == cost));
                i_end = i+no_with_cost-1;
                [~, sorted_cost_indices] = sort(no_rows_in_cols, 'descend');
                tmp = sorted_indices(i:i_end);
                sorted_indices(i:i_end) = tmp(sorted_cost_indices);
                i = i_end + 1;
            else
                i = i + 1;
            end
        end
    end
    
    % Sort A and c
    c = c(sorted_indices, :);
    A = A(:, sorted_indices);
end