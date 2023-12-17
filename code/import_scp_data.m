function [A, cost_per_col] = import_scp_data()

    data = readmatrix("../scp-data/scpd5.txt", "Delimiter", [" ", " \n "]);

    data(1) = [];
    data(end) = [];

    rows_no = data(1);
    cols_no = data(2);

    cost_per_col = data(3:3+cols_no-1);

    A = zeros(rows_no, cols_no);

    i_start = 3+cols_no+1;
    current_row = 1;
    till_new_row = data(i_start - 1);

    for i = 3+cols_no+1:length(data)

        if till_new_row ~= 0
           till_new_row = till_new_row - 1;

           A(current_row, data(i)) = 1;

        else
           current_row = current_row + 1;
           till_new_row = data(i);
        end

    end
end