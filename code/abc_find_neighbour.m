function new_food = abc_find_neighbour(A, c, food, i, col_add, col_drop, p_a, size_r_c)
    % This function determines a new food source in the neighbourhood
    % of a food source with column index i in the 'food' matrix that
    % includes all food sources associated with employed bees
    
    new_food = food;
    no_of_srcs = size(food, 2);
    
    % Randomly select food source j different from i
    j = i;
    while j == i
        j = randsample(1:no_of_srcs, 1);
    end

    food_i = food(:, i);
    food_j = food(:, j);

    % Select columns to add to food source i
    cols_to_check = find(food_j ~= food_i);
    cols_to_add = cols_to_check(food_j(cols_to_check) == 1);
    if col_add < length(cols_to_add)
        cols_to_add = cols_to_add(1:col_add);
    end
    
    if isempty(cols_to_add)
        % That must mean food_i == food_j
        % COLLISION
        new_food = -1;
    else
        % Add columns
        new_food(cols_to_add, i) = 1;

        % Drop columns
        cols_to_drop = randsample(find(new_food(:,i)), col_drop, false);
        new_food(cols_to_drop, i) = 0;

        u = A*new_food(:, i);
        while (~isempty(find(u == 0, 1)))
            % Repair solution
            rows_to_cover = find(u == 0);
            
            for r = rows_to_cover'
                if rand < 0
                    % Select minimal column cost to # of uncovered of
                    % rows covered by column ration
                    [~, selected_col] = min(c ./ sum(A(rows_to_cover,:))');
                else
                    % Select random column that contains row r
                    cols_in_row = find(A(r, :));
                    if size_r_c < length(cols_in_row)
                        cols_in_row = cols_in_row(1:size_r_c);
                    end        
                    if length(cols_in_row) == 1
                        selected_col = cols_in_row;
                    else
                        selected_col = randsample(cols_in_row, 1);
                    end 
                end

                % Add selected column to food source i
                new_food(selected_col, i) = 1;
            end

            u = A*new_food(:, i);
        end
    end



end