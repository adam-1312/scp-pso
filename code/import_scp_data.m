function [A, cost_per_col] = import_scp_data(dataset_name)
    
    % Get dataset path
    PATH_PRE = "../scp-data/";
    PATH_POST = ".txt";
    input_path = strcat(PATH_PRE, dataset_name, PATH_POST);

    % Get output paths
    output_name_matrix = strcat(dataset_name, "-MATRIX");
    output_name_costs = strcat(dataset_name, "-COSTS");
    output_path_matrix = strcat(PATH_PRE, output_name_matrix, PATH_POST);
    output_path_costs = strcat(PATH_PRE, output_name_costs, PATH_POST);

    if isfile(output_path_matrix) && isfile(output_path_costs)

        A = readmatrix(output_path_matrix);
        cost_per_col = readmatrix(output_path_costs);

        disp('Data was already converted. Imported data.')

    else

        % Transform txt data to matrix
        data = readmatrix(input_path, "Delimiter", [" ", " \n "]);
        
        % Get rid of negligible elements at start and end
        data(1) = [];
        data(end) = [];
    
        % Extract scp size
        rows_no = data(1);
        cols_no = data(2);
        
        % Extract costs
        cost_per_col = data(3:3+cols_no-1);
    
        % Initialize scp incidence matrix
        A = zeros(rows_no, cols_no);
    
        % Initialize indices used in extraction
        i_start = 3+cols_no+1;
        current_row = 1;
        till_new_row = data(i_start - 1);
    
        % Extract incidence matrix values
        for i = 3+cols_no+1:length(data)
    
            if till_new_row ~= 0 % New row not reached?
               till_new_row = till_new_row - 1;
    
               % Place current_row in current col seen in data 
               A(current_row, data(i)) = 1;
    
            else
               % Go to next row
               current_row = current_row + 1;
    
               % Extract number of cols with 1 in that row
               till_new_row = data(i);
            end
    
        end
    
        % Write to output paths
        writematrix(A, output_path_matrix);
        writematrix(cost_per_col, output_path_costs);

        disp('Data needed to be converted. Data is ready.')
    end

end