function u = abc_update_u(u, to_remove, to_add)
    u(to_remove == 1) = u(to_remove == 1) - 1;

    for col_to_add = to_add
        u(col_to_add == 1) = u(col_to_add == 1) + 1;
    end

end