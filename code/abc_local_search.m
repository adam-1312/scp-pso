function new_food = abc_local_search(food, A, c)
    new_food = food;

    food_cols = find(food);
    % filtered_A = A(:,food_cols); % A only with cols in food

    improve = 1;

    while improve

        improve = 0;

        for j = food_cols(end:-1:1)' % Cols ordered in decreasing cost

            u = A*new_food; % Number of cols in food covering each row

            col_j = A(:,j);
            P_j = zeros(1, length(u));
            for i = find(col_j)' % Each row index covered by col j
                if u(i) == 1
                    P_j(i) = 1;
                end
            end

            cardinality = sum(P_j); % Cardinality of P_j

            if cardinality == 0
                new_food(j) = 0;
                % u(col_j==1) = u(col_j==1) - 1;
                improve = 1;
            elseif cardinality == 1

                % Assumes A's columns ordered ascendingly by cost
                least_cost_col_indx = find(A(P_j==1,:),1); % least cost col covering row i
                least_cost_col = A(:,least_cost_col_indx);
                
                if all(col_j ~= least_cost_col)
                    % Replace col j with least cost
                    new_food(j) = 0;
                    new_food(least_cost_col_indx) = 1;
                    % u(col_j==1) = u(col_j==1) - 1;
                    % u(least_cost_col==1) = u(least_cost_col==1) + 1;
                    improve = 1;
                end

            else

                i = find(P_j);
                least_cost_col_indx = zeros(1,length(i));

                for k = 1:length(i)
                    % Assumes A's columns ordered ascendingly by cost
                    least_cost_col_indx(k) = find(A(i(k),:),1); % least cost col covering row i
                end

                least_cost_col = A(:, least_cost_col_indx);

                if cardinality == 2
                    if all(least_cost_col(:,1) ~= least_cost_col(:,2)) && sum(c(least_cost_col_indx)) < c(j)
                        % Replace col j with both least cost columns
                        new_food(j) = 0;
                        new_food(least_cost_col_indx) = 1;
                        improve = 1;
                    elseif all(least_cost_col(:,1) == least_cost_col(:,2)) && all(least_cost_col(:,2) ~= col_j)
                        % Replace col j with one of the least cost cols
                        new_food(j) = 0;
                        new_food(least_cost_col_indx(1)) = 1;
                        improve = 1;
                    end
                elseif cardinality == 3
                    if all(least_cost_col(:,1) ~= least_cost_col(:,2)) &&...
                       all(least_cost_col(:,1) ~= least_cost_col(:,3)) &&...
                       all(least_cost_col(:,2) ~= least_cost_col(:,3)) &&...
                       sum(c(least_cost_col_indx)) < c(j)

                        % Replace col j with the 3 least cost columns
                        new_food(j) = 0;
                        new_food(least_cost_col_indx) = 1;
                        improve = 1;

                    elseif all(least_cost_col(:,1) == least_cost_col(:,2)) &&...
                           all(least_cost_col(:,2) == least_cost_col(:,3)) &&...
                           all(least_cost_col(:,3) ~= col_j)

                        % Replace col j with the one least cost column
                        new_food(j) = 0;
                        new_food(least_cost_col_indx(1)) = 1;
                        improve = 1;
                    
                    elseif all(least_cost_col(:,1) == least_cost_col(:,2)) &&...
                           all(least_cost_col(:,1) ~= least_cost_col(:,3)) &&...
                           sum(c(least_cost_col_indx([1 3]))) < c(j)
                        
                        % Replace col j with the least cost columns 1 and 3
                        new_food(j) = 0;
                        new_food(least_cost_col_indx([1 3])) = 1;
                        improve = 1;

                    elseif all(least_cost_col(:,1) == least_cost_col(:,3)) &&...
                           all(least_cost_col(:,1) ~= least_cost_col(:,2)) &&...
                           sum(c(least_cost_col_indx([1 2]))) < c(j)
                        
                        % Replace col j with the least cost columns 1 and 2
                        new_food(j) = 0;
                        new_food(least_cost_col_indx([1 2])) = 1;
                        improve = 1;

                    elseif all(least_cost_col(:,2) == least_cost_col(:,3)) &&...
                           all(least_cost_col(:,1) ~= least_cost_col(:,2)) &&...
                           sum(c(least_cost_col_indx([1 2]))) < c(j)
                    
                        % Replace col j with the least cost columns 1 and 2
                        new_food(j) = 0;
                        new_food(least_cost_col_indx([1 2])) = 1;
                        improve = 1;

                    end
                end
            end
        end
    end
end