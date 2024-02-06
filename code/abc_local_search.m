function new_food = abc_local_search(food, A, c)
    new_food = food;

    food_cols = find(food);
    % filtered_A = A(:,food_cols); % A only with cols in food

    % Initialize u outside loop for performance
    u = A*new_food; % Number of cols in food covering each row

    improve = 1;

    while improve

        improve = 0;
        
        for j = food_cols(end:-1:1)' % Cols ordered in decreasing cost

            %u = sum(A(:,new_food==1)')';
            u = A*new_food;

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
                % Update u
                %u(col_j==1) = u(col_j==1) - 1;
                improve = 1;
            elseif cardinality == 1

                % Assumes A's columns ordered ascendingly by cost
                least_cost_col_indx = find(A(P_j==1,:),1); % least cost col covering row i
                least_cost_col = A(:,least_cost_col_indx);
                
                if any(col_j ~= least_cost_col)
                    % Replace col j with least cost
                    new_food(j) = 0;
                    tmp = new_food;
                    new_food(least_cost_col_indx) = 1;
                    % Update u
                    % to_update = (((col_j==1) - P_j')) == 1; % Update rows covered by j but not in P_j
                    % %to_update = col_j == 1;
                    % u(to_update) = u(to_update) - 1;
                    % if ~tmp(least_cost_col_indx)
                    %     to_update = ((least_cost_col==1) - P_j') == 1; % Update rows covered by least cost col but not in P_j
                    %     u(to_update) = u(to_update) + 1;
                    % end
                    u = abc_update_u(u, col_j, least_cost_col);
                    improve = 1;
                end

            else

                %u = A*new_food; % Number of cols in food covering each row

                i = find(P_j);
                least_cost_col_indx = zeros(1,length(i));

                for k = 1:length(i)
                    % Assumes A's columns ordered ascendingly by cost
                    least_cost_col_indx(k) = find(A(i(k),:),1); % least cost col covering row i
                end

                least_cost_col = A(:, least_cost_col_indx);

                if cardinality == 2
                    if any(least_cost_col(:,1) ~= least_cost_col(:,2)) && sum(c(least_cost_col_indx)) < c(j)
                        % Replace col j with both least cost columns
                        new_food(j) = 0;
                        tmp = new_food;
                        new_food(least_cost_col_indx) = 1;
                        % Update u 
                        % to_update = ((col_j==1) - P_j') == 1; % Update rows covered by j but not in P_j
                        % %to_update = col_j == 1;
                        % u(to_update) = u(to_update) - 1;
                        % for k = 1:length(least_cost_col_indx)
                        %     if ~tmp(least_cost_col_indx(k))
                        %         to_update = ((least_cost_col(:, k)==1) - P_j') == 1; % Update rows covered by least cost col but not in P_j
                        %         u(to_update) = u(to_update) + 1;
                        %     end
                        % end
                        u = abc_update_u(u, col_j, least_cost_col);
                        improve = 1;
                    elseif all(least_cost_col(:,1) == least_cost_col(:,2)) && any(least_cost_col(:,2) ~= col_j)
                        % Replace col j with one of the least cost cols
                        new_food(j) = 0;
                        tmp = new_food;
                        new_food(least_cost_col_indx(1)) = 1;
                        % Update u
                        % to_update = ((col_j==1) - P_j') == 1; % Update rows covered by j but not in P_j
                        % %to_update = col_j == 1;
                        % u(to_update) = u(to_update) - 1;
                        % if ~tmp(least_cost_col_indx(1))
                        %     to_update = ((least_cost_col(:,1)==1) - P_j') == 1; % Update rows covered by least cost col but not in P_j
                        %     u(to_update) = u(to_update) + 1;
                        % end
                        u = abc_update_u(u, col_j, least_cost_col(:,1));
                        improve = 1;
                    end

                elseif cardinality == 3
                    if any(least_cost_col(:,1) ~= least_cost_col(:,2)) &&...
                       any(least_cost_col(:,1) ~= least_cost_col(:,3)) &&...
                       any(least_cost_col(:,2) ~= least_cost_col(:,3)) &&...
                       sum(c(least_cost_col_indx)) < c(j)

                        % Replace col j with the 3 least cost columns
                        new_food(j) = 0;
                        tmp = new_food;
                        new_food(least_cost_col_indx) = 1;
                        % Update u
                        % to_update = ((col_j==1) - P_j') == 1; % Update rows covered by j but not in P_j
                        % %to_update = col_j == 1;
                        % u(to_update) = u(to_update) - 1;
                        % for k = 1:length(least_cost_col_indx)
                        %     if ~tmp(least_cost_col_indx(k))
                        %         to_update = ((least_cost_col(:,k)==1) - P_j') == 1; % Update rows covered by least cost col but not in P_j
                        %         u(to_update) = u(to_update) + 1;
                        %     end
                        % end
                        u = abc_update_u(u, col_j, least_cost_col);
                        improve = 1;

                    elseif all(least_cost_col(:,1) == least_cost_col(:,2)) &&...
                           all(least_cost_col(:,2) == least_cost_col(:,3)) &&...
                           any(least_cost_col(:,3) ~= col_j)

                        % Replace col j with the one least cost column
                        new_food(j) = 0;
                        tmp = new_food;
                        new_food(least_cost_col_indx(1)) = 1;
                        % Update u
                        % to_update = ((col_j==1) - P_j') == 1; % Update rows covered by j but not in P_j
                        % %to_update = col_j == 1;
                        % u(to_update) = u(to_update) - 1;
                        % if ~tmp(least_cost_col_indx(1))
                        %     to_update = ((least_cost_col(:,1)==1) - P_j') == 1; % Update rows covered by least cost col but not in P_j
                        %     u(to_update) = u(to_update) + 1;
                        % end
                        u = abc_update_u(u, col_j, least_cost_col(:,1));
                        improve = 1;
                    
                    elseif all(least_cost_col(:,1) == least_cost_col(:,2)) &&...
                           any(least_cost_col(:,1) ~= least_cost_col(:,3)) &&...
                           sum(c(least_cost_col_indx([1 3]))) < c(j)
                        
                        % Replace col j with the least cost columns 1 and 3
                        new_food(j) = 0;
                        tmp = new_food;
                        new_food(least_cost_col_indx([1 3])) = 1;
                        % Update u
                        % to_update = ((col_j==1) - P_j') == 1; % Update rows covered by j but not in P_j
                        % %to_update = col_j == 1;
                        % u(to_update) = u(to_update) - 1;
                        % for k = [1 3]
                        %     if ~tmp(least_cost_col_indx(k))
                        %         to_update = ((least_cost_col(:,k)==1) - P_j') == 1; % Update rows covered by least cost col but not in P_j
                        %         u(to_update) = u(to_update) + 1;
                        %     end
                        % end
                        u = abc_update_u(u, col_j, least_cost_col([1 3]));
                        improve = 1;

                    elseif all(least_cost_col(:,1) == least_cost_col(:,3)) &&...
                           any(least_cost_col(:,1) ~= least_cost_col(:,2)) &&...
                           sum(c(least_cost_col_indx([1 2]))) < c(j)
                        
                        % Replace col j with the least cost columns 1 and 2
                        new_food(j) = 0;
                        tmp = new_food;
                        new_food(least_cost_col_indx([1 2])) = 1;
                        % Update u
                        % to_update = ((col_j==1) - P_j') == 1; % Update rows covered by j but not in P_j
                        % %to_update = col_j == 1;
                        % u(to_update) = u(to_update) - 1;
                        % for k = [1 2]
                        %     if ~tmp(least_cost_col_indx(k))
                        %         to_update = ((least_cost_col(:,k)==1) - P_j') == 1; % Update rows covered by least cost col but not in P_j
                        %         u(to_update) = u(to_update) + 1;
                        %     end
                        % end
                        u = abc_update_u(u, col_j, least_cost_col([1 2]));
                        improve = 1;

                    elseif all(least_cost_col(:,2) == least_cost_col(:,3)) &&...
                           any(least_cost_col(:,1) ~= least_cost_col(:,2)) &&...
                           sum(c(least_cost_col_indx([1 2]))) < c(j)
                    
                        % Replace col j with the least cost columns 1 and 2
                        new_food(j) = 0;
                        tmp = new_food;
                        new_food(least_cost_col_indx([1 2])) = 1;
                        % Update u
                        % to_update = ((col_j==1) - P_j') == 1; % Update rows covered by j but not in P_j
                        % %to_update = col_j == 1;
                        % u(to_update) = u(to_update) - 1;
                        % for k = [1 2]
                        %     if ~tmp(least_cost_col_indx(k))
                        %         to_update = ((least_cost_col(:,k)==1) - P_j') == 1; % Update rows covered by least cost col but not in P_j
                        %         u(to_update) = u(to_update) + 1;
                        %     end
                        % end
                        u = abc_update_u(u, col_j, least_cost_col([1]));
                        improve = 1;

                    end
                end
            end
        end
    end
end